function [V, Vref, conv ] = ee(med_file, sis_file, tol_max, int_max, S_PESO, out_file, med_opt, DBG)
% Estimação de estado - Newton-Raphson
% global Barra Ramo MVA_BASE Ybus Yd Yp H medidores
% med_file    => Arquivo com a estrutura de medidores e respectivas medidas
% sis_file    => Arquivo com os dados da rede, no formato IEEE CDF
% tol_max     => Diferença máxima entre as tensões em iterações sucessivas
% int_max     => Número máximo de iterações para convergência
% S_PESO = 1  => Matriz de pesos formada pela covariâncias das medidas
% S_PESO = 0  => Matriz de pesos formada por valores ajustados
% out_file    => Arquivo de saída
% med_opt = 0 => Tensões de referencia do arquivo sis_file
%                Variâncias das telemedidas calculadas internamente
% med_opt = 1 => Não utiliza tensõesE de referência
%                Desvio-padrão das telemedidas informado no arquivo med_file
% DBG         => Exterioriza alguns resultados parciais para debug
%% Configura o caminho para as subfunções
path('.\sub', path);
path('.\Criticality Analisys', path);
path('.\Criticality Analisys\src', path);
%% Analisa os parâmetros de entrada
if nargin < 8; DBG = 0; end
if nargin < 7; med_opt = 0; end
if nargin < 6
    titulo(1);
    out_file = input('Arquivo de saída: ', 's');
    if isempty(out_file); out_file = 'ee.out'; end
end
fout = fopen(out_file, 'w');
if nargin < 5, S_PESO = 1; end
if nargin < 4
    int_max = input('Numero maximo de iteraçoes?: ');
end
if nargin < 3
    tol_max = input('Tolerancia maxima entre iteraçoes?: ');
end
if nargin < 2
    sis_file = input('Arquivo de dados do sistema no formato IEEE CDF: ', 's');
end
if nargin < 1
    med_file = input('Arquivo de dados dos medidores: ', 's');
end
%% Define o tipo de busca para as criticalidades
fprintf('============================\n');
type_search = input('Escolha o tipo de busca de criticalidade\nModelo completo da rede - COMPLETE\nModelo DC da rede - DC\nMedidas em pares real+imag - PAIR\n', 's');
type_search = upper(type_search);
if ( type_search ~= "COMPLETE" && type_search ~= "DC" && type_search ~= "PAIR")
    fprintf('Comando não reconhecido... fazendo a busca completa\n');
    type_search = "COMPLETE";
end
%% Exterioriza titulo e dados do caso na tela e no arquivo de saída
if nargin == 6
    titulo(1, med_file, sis_file, tol_max, int_max);
end
titulo(fout, med_file, sis_file, tol_max, int_max);
%% Leitura dos dados da rede
[Caso, Barra, Ramo] = ler_sistema(sis_file);
% Exterioriza dados do caso
dados_caso(Caso);
dados_caso(Caso, fout);
% Vref = Valor das tensoes de referencia
if med_opt == 0
    Vref = Barra.tensao .* exp(j * Barra.angulo);   
end
% d = lista das barras DE dos ramos
d = Ramo.de;
% p = lista das barras PARA dos ramos
p = Ramo.para;
% Ybus = Matriz de admitancia da rede
% Yd = Matriz para calculo das correntes do terminal DE
% Yp = Matriz para calculo das correntes do terminal PARA
[Ybus, Yd, Yp] = Ybarra(Barra, Ramo);
%% Ler dados do arquivo de medidores
% Nmed = numero de medidores no arquivo med_file
[medidores, Nmed] = ler_medidores(med_file);
%determinar os pares real+img das medidas
[med_pair] = find_par(medidores);
% Exterioriza as telemedidas
out_med(medidores);
out_med(medidores, fout);
% zmt = valor das telemedidas
zmt = medidores.leitura';
%% Calcula variancia das telemedidas
if med_opt == 0     % Calcula a variância das telemedidas internamente
    VAR = cal_var(medidores,zmt);
    % Calcula o desvio-padrão das telemedidas
    dp = VAR .^ 2;
%    dp(56)=0.0000537;dp(57)=dp(56);
    medidores.dp = dp;
    if S_PESO
        % Matriz de pesos formada com a covariância das telemedidas
        peso = 1 ./ dp';
        disp('Matriz de pesos formada com as covariâncias das telemedidas.')
        fprintf(fout, 'Matriz de pesos formada com as covariâncias das telemedidas.\n');   
    else
        % Utiliza pesos ajustados
        peso = cal_peso(medidores);
        disp('Matriz de pesos formada com valores ajustados.')
        fprintf(fout, 'Matriz de pesos formada com valores ajustados.\n');   
    end
elseif med_opt == 1     % Desvio-padrão das telemedidas informado no arquivo med_file
    dp = medidores.dp';
    peso = 1 ./ dp;
end
% SALVA INFORMAÇÕES PARA ANALISE DE DESVIOS DAS MEDIDAS
% save dp; save peso; save VAR;
%% Inicia o processo de estimaçao
% ESTIMA = 0 => Encerra o processo de remoção de erros grosseiros
crit_med = []; %Struct de medicoes e seus erros
    crit_med.num = 0; %Lista de medicoes com erros
    crit_med.rn = 0; %Lista dos rn 
new_ind_med = []; %resultando da busca IA
ESTIMA = 1;
ia_search = false;
 %% Verifica se há medidor de ângulo desabilitado
    med_ang = find((medidores.tipo == 3) & (medidores.ok == 0));
    med_mod = find((medidores.tipo == 6) & (medidores.ok == 0) & (medidores.PMU_num > 0));
    if isempty(med_ang)
        Med_Ref = 0;
        fprintf(1, 'Não há medidas de ângulo.\n');
        fprintf(fout, 'Não há medidas de ângulo.\n');
    else
        Med_Ref = 1;
        fprintf(1, 'Medidas de ângulo: \n');
        fprintf(1, 'Barra: %d\n', medidores.para(med_ang));
        fprintf(fout, 'Medidas de ângulo: \n');
        fprintf(fout, 'Barra: %d\n', medidores.para(med_ang));
    end
    %% Verifica quais medidores estão desabilitados
    % n_ok = lista de medidores desabilitados
    n_ok = find (medidores.ok');
while ESTIMA
    %% Exterioriza os medidores desabilitados
    if isempty(n_ok)
        fprintf(1,'Não há medidores desabilitados.\n');
        fprintf(fout,'Não há medidores desabilitados.\n');
    else
        fprintf(1,'Medidores desabilitados:\n');
        fprintf(1,'Medidor %d.\n', n_ok);
        fprintf(fout,'Medidores desabilitados:\n');
        fprintf(fout,'Medidor %d.\n', n_ok);
    end
    %% Exclui os medidores desabilitados
    % ind_med = lista dos medidores habilitados
    ind_med = dim_cut(Nmed, n_ok);
    ind_med = ind_med';
    % zm = vetor com apenas os medidores habilitados 
    zm = zmt(ind_med,:);
    %% Inicializa o contador de iteraçoes
    n_it = 0;
    %% Calcula matriz de ponderação
    R = spdiags(dp', 0, Nmed, Nmed );
    % Reduz R para os medidores habilitados
    R = R(ind_med,ind_med);
    % W = Inverso da matriz de ponderação
    W = spdiags( peso, 0, Nmed, Nmed );
    % Reduz W para os medidores habilitados
    W = W(ind_med, ind_med); 
    % V = vetor de tensão nas barras
    V = ones(Caso.NB,1);   % Flat start
    % Transforma vetor de tensao em vetor estados [ANG(V):MOD(V)]
    x = V2x(V, Caso.NB, Caso.Bref, Med_Ref);
    %% Inicia o processo iterativo
    % Iteração por Newton-Raphson
    conv = 0;   % Processo iterativo não convergido
    while (~conv && n_it < int_max)
        % Converte o vetor estado para vetor tensao
        V = x2V(x, Caso.NB, Caso.Bref);
        %% Calcula as telemedidas estimadas
        z = calc_medidas(Ybus, Yd, Yp, d, p, V, medidores);
        medidores.v_estimado = z';
        % Reduz o vetor de telemedidas estimadas para os medidores habilitados
        z = z(ind_med,:);
        %% Calculo do Jacobiano
        H = jacobiano(Ybus, Yd, Yp, d, p, V, Caso.Bref, Med_Ref, medidores);
        % Reduz o Jacobiano para os medidores habilitados
        H = H(ind_med,:);
        %% Calculo de Fx
        fx = H' * W * (zm - z);
        %% Calculo da matriz de ganho
        G = (H' * W * H);
        %% Calculo da inversa da matriz de ganho
        if DBG
            c = condest(G);
            fprintf(1,'Indice de condicionamento de G: %E \n', c)
        end
        G1 = inv(G);
        %% dx(k)
        deltax = G1 * fx;
        %% x(k+1) = x(k) + dx(k)
        x = x + deltax;
        %% Calcula o valor da tolerância
        tol = max(abs(deltax));
        if tol < tol_max;
            % finaliza o processo iterativo
            conv = 1;
        else
            % Incrementa o contador de iterações e continua
            n_it = n_it + 1;
        end
    end
    %% Apresenta o valor final do estado
    if med_opt
        Vref = V;
    end
    mostra_estado(Barra.num, V, Vref, n_it, conv, med_opt);
    mostra_estado(Barra.num, V, Vref, n_it, conv, med_opt, fout);
    %% Calcula as medidas estimadas
    z = calc_medidas(Ybus, Yd, Yp, d, p, V, medidores);
    medidores.v_estimado = z';

    %% Cálculo do Desvio-Padrão das telemedidas estimadas
    E_red = R - H * G1 * H';
    dpc = (diag(E_red).^ 0.5);
    dpc_ex = exp_vec(dpc, n_ok);
    E = exp_mat(E_red, n_ok);
    medidores.dpc = dpc_ex;
    medidores.residuo = medidores.leitura - medidores.v_estimado;
    lim_EG = 3;
    Tol_LB = 1e-6;
    [medidores, mc, EG, c_cand] = residuos_normalizados_1(medidores, lim_EG);
    mostra_residuos(medidores, ind_med, 0, 1);
    mostra_residuos(medidores, ind_med, 0, fout);
    if EG ~= 0
        fprintf(1,'Possível erro grosseiro no medidor %d!\n', EG);
        fprintf(fout,'Possível erro grosseiro no medidor %d!\n', EG);
    else
        fprintf(1,'Não foram identificados erros grosseiros.\n');
        fprintf(fout,'Não foram identificados erros grosseiros.\n');
    end
    if isempty(mc)
        fprintf(1,'Não foram identificadas medidas críticas.\n');
        fprintf(fout,'Não foram identificadas medidas críticas.\n');
    else
        fprintf(1,'Medida crítica %4d!\n', mc);
        fprintf(fout,'Medida crítica %4d!\n', mc);
    end
    %% Mostra os possíveis conjuntos críticos
    [lins,cols] = size(c_cand);
    fprintf(1,'Possíveis conjuntos críticos:\n');
    fprintf(fout,'Possíveis conjuntos críticos:\n');
    for i = 1 : lins
        fprintf(1,'Conjunto %d:', i );
        fprintf(fout,'Conjunto %d:', i );
        nc = length(find(c_cand(i,:)));
        for k = 1 : nc
            fprintf(1,' %d', c_cand(i,k));
            fprintf(fout,' %d', c_cand(i,k));
        end
        fprintf(1,'\n');
        fprintf(fout,'\n');
    end
    %% Calcula a correlação
    for l = 1 : lins
        nc = length(find(c_cand(l,:)));
        for i = 1 : nc
            for k = i : nc
                Eik = E(c_cand(l,i), c_cand(l,k));
                Eii = E(c_cand(l,i), c_cand(l,i));
                Ekk = E(c_cand(l,k), c_cand(l,k));
                LB(i,k) = abs(Eik)/(sqrt(Eii) * sqrt(Ekk));
                if LB(i,k) >= (1 - Tol_LB) && LB(i,k) <= (1 + Tol_LB) && i ~= k
                    % Medidas com alta correlação
                    fprintf(1,'Medidas com alta correlação: %d e %d \n', c_cand(l,i), c_cand(l,k));
                    fprintf(fout,'Medidas com alta correlação: %d e %d \n', c_cand(l,i), c_cand(l,k));
                end
            end
        end 
    end
    ESTIMA = 0;
    if(~ia_search) %verifica se a busca A* foi executadaa
        nr = length(medidores.residuo);
            % prepara para plotar os resíduos normalizados
            for i = 1 : nr
                if medidores.rn(i) >= 3
                    ESTIMA = 1; %Caso possua medidas com EGs continua o processo
                    crit_med(end+1).num = i; %Adiciona na lista de medicoes com EGs
                    crit_med(end).rn = medidores.rn(i); %Adiciona rn na lista de medicoes com EGs
                end
            end
        %%Malha IA do estimador
        if (type_search == "DC")
            %caso considerando o modelo dc para as criticalidades
            idz=logical( medidores.ok==0 & ( medidores.tipo==1 | medidores.tipo==2 | medidores.tipo==3 | medidores.tipo==7 | medidores.tipo==9) ); % medidores ativos de fluxo e injecao
            medidores_dc.num = medidores.num(idz);
            medidores_dc.de = medidores.de(idz);
            medidores_dc.para = medidores.para(idz);
            medidores_dc.tipo = medidores.tipo(idz);
            medidores_dc.PMU_num = medidores.PMU_num(idz);
            medidores_dc.leitura = medidores.leitura(idz);
            [H , order] = LinJ(medidores_dc,Ramo,Barra,Caso);
        else
            %casos considerando o modelo completo da rede
            order = medidores.num;
        end
        if ~isempty(crit_med) && ESTIMA == 1
            result_asearch = read_cks(crit_med, ind_med, Caso, Ramo,order, med_pair,type_search, H, W); 
            ia_search = true; %salva na variavel avisando que a busca foi executada
            ESTIMA = 1;
            if isequal(new_ind_med,result_asearch) %caso a busca nao encontre nenhuma medida nova
                fprintf('Não é possível retirar nenhuma medida do sistema\n');
                break;
            else
                new_ind_med = result_asearch;
                for i = 1:length(new_ind_med)
                    newMed = false;
                    for k = 1:length(n_ok)
                        if new_ind_med(i) == n_ok(k)
                            newMed = true;
                        end
                    end
                    if ~newMed
                        n_ok(end + 1) = new_ind_med(i);
                    end
                end     
            end
        end
    end
%     end
end
fclose(fout);
% nr = length(medidores.residuo);
%         % prepara para plotar os resíduos normalizados
%         for i = 1 : nr
%             if medidores.rn(i) >= 3
%                 crit_med(end+1) = i;
%             end
%         end
%code diog
%chamar matlab pra adequar pra busca
% fileID = fopen('estimator_output.txt','w');
% fprintf(fileID,'%s\n',sis_file);
% fprintf(fileID,'%s\n',med_file);
% nr = length(medidores.residuo);
%         % prepara para plotar os resíduos normalizados
%         for i = 1 : nr
%             if medidores.rn(i) >= 3
%                 fprintf(fileID,'%i\n',i);
%             end
%         end
% fclose(fileID);

% save medidores;
rep = input('Deseja salvar configuracao de medidores S/[N]?: ', 's');
if isempty(rep); rep = 'N'; end
if (rep == 's'|| rep == 'S')
    grava_arq_med(medidores, med_file);
end
msg = 'Deseja plotar os resultados S/[N]?: ';
rep = s_n(msg, 'N');
if (rep == 's'|| rep == 'S')
    if med_opt
        %% plota os resíduos normalizados
        subplot(1,1,1), plot(medidores.rn,'*'), title('RN (pu)');
    else
        nr = length(medidores.residuo);
        % prepara para plotar os resíduos normalizados
        for i = 1 : nr
            if medidores.rn(i) >= 4
                RN(i) = 4;
            else
                RN(i) = medidores.rn(i);
            end
        end
        % Plota a diferenca do estado real para o estado estimado
        EA=100*(abs(V)- Barra.tensao)/Barra.tensao;
        EF=60*180/pi*(Barra.angulo-angle(V));
        createfigure(EA, EF, RN);
%         subplot(3,1,1), plot(EA,'+'), title('Erro de Amplitude (%)');
%         subplot(3,1,2), plot(EF,'+'), title('Erro de Fase (min)');
%         subplot(3,1,3), plot(medidores.rn,'*'), title('RN (pu)');
    end
else
    return
end