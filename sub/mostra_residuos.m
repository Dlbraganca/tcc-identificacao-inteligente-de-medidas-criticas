function  [med_sus, max_res] = mostra_residuos(medidores, ind_med, opt, fout)
% Apresenta os residuos, com opçoes de ordenação
% opt = 0 Todos os resíduos ordenados decrescentemente
% opt = 1 Resíduos classificados por tipo de medidor
tipo = ['Fluxo de potencia ativa    ',                  
        'Injeção de potencia ativa  ',        
        'Ângulo de fase da tensão   ',         
        'Fluxo de potencia reativa  ',       
        'Injeção de potencia reativa',     
        'Módulo da tensão           ',  
        'Corrente de ramo (real)    ',  
        'Corrente de ramo (imag)    ',   
        'Injeção de corrente (real) ',  
        'Injeção de corrente (imag) '];
A = medidores.num(ind_med)';
B = medidores.de(ind_med)';
C = medidores.para(ind_med)';
% medidores.circ(ind_med)';
D = medidores.tipo(ind_med)';
% medidores.PMU_num(ind_med)';
% medidores.ok(ind_med)';
% medidores.acc(ind_med)';
% medidores.fs(ind_med)';
% medidores.dp(ind_med)';
E = medidores.ref(ind_med)';
F = medidores.leitura(ind_med)';
G = medidores.v_estimado(ind_med)';
H = medidores.residuo(ind_med)';
% medidores.dpc(ind_med)';
I = medidores.rn(ind_med)';
RES = sortrows([ A B C D E F G H I ],9);
[Num_RES, col] = size(RES);
max_res = RES(Num_RES,9);
med_sus = RES(Num_RES,1);
fprintf(fout, '--- RESIDUOS NORMALIZADOS --------------------------------------------------------\n');
relat = '%4d %4d %4d %2d %+10.4f %+10.4f %+10.4f  %+10.4e %10.3f \n';
if opt == 0
    fprintf(fout, '   N    D    P  TP      Real     Medido   Estimado      Med-Est        rn \n');
    fprintf(fout, '----------------------------------------------------------------------------------\n');
    for i = Num_RES : -1 : 1
        fprintf(fout,relat,RES(i,:));
    end
end
if opt == 1
    for j = 1 : 10
        if ismember(j, RES(:, 4))
            fprintf(fout, '--- %26s --------------------------------------------------\n', tipo(j,:));
            fprintf(fout, '   N    D    P  TP      Real     Medido   Estimado      Med-Est        rn \n');
            fprintf(fout, '----------------------------------------------------------------------------------\n');
            for i = Num_RES : -1 : 1
                if RES(i,4) == j
                    fprintf(fout,relat,RES(i,:));
                end
            end
        end
    end
end
fprintf(fout, '----------------------------------------------------------------------------------\n');
% if ~isempty(mc)
%     fprintf(fout, '--- MEDIDAS CRÍTICAS -------------------------------------------------------------\n');
%     fprintf(fout,'%4d', mc);
%     fprintf(fout, '\n');
%     fprintf(fout, '----------------------------------------------------------------------------------\n');
% end
return