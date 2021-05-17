function [var] = cal_var1(medidores,z)
% Obtem o valor da variancia dos medidores 
% function [var] = cal_var(medidores,z)
% Estrutura de medidores
% num           nº do medidor
% de            nº da barra DE
% para          nº da barra PARA
% circ          nº do circuito
% tipo          tipo de medidor
% PMU_num       Medida associada a PMU n
% ok            Utiliza ou nao o medidor
% acc           exatidão do medidor
% fs            fundo de escala do medidor
% dp            desvio-padrão
% ref           valor de referencia
% leitura       valor medido
%
% Convençoes:
% - Medidas de fluxo de potencia ativa:     tipo 1
% - Medidas de injecao de potencia ativa:   tipo 2
% - Medidas de angulo:                      tipo 3
% - Medidas de fluxo de potencia reativa:   tipo 4
% - Medidas de injecao de potencia reativa: tipo 5
% - Medidas de tensao:                      tipo 6
% - Medidas de corrente de ramo real        tipo 7
% - Medidas de corrente de ramo imag        tipo 8
% - Medidas de injecao de corrente real     tipo 9
% - Medidas de injecao de corrente imag     tipo10
% - Medidas de fluxo de 1 => 2   ---> de=1 e para=2
% - Medidas de tensao na barra 3 ---> de=0 e para=3
% sequencia certa será primeiro o V, depois os tetas e depois V e Teta de
% cada barra que possua PMU.load peso;
%
W=cal_W;
N=max(medidores.para);
NM = length(medidores.num);
var = zeros(1,NM);
%
% Calcula Desvio do estado estimado em A
%
for j=1:N*2
    if j<N+1
        var(1,j)=1/(W(j,j))^0.5;
    elseif j==N+1
        var(1,j)=(0.02*pi/180)/3;
    elseif j>N+1
        var(1,j)=1/(W(j-1,j-1))^0.5;
    end
end
%
% Calcula desvios normalmente das PMU´s
%
for i = N*2+1 : NM
    Med_tip = medidores.tipo(i);
    PMU_num = medidores.PMU_num(i);
    % Medidores de potencia
    if (Med_tip == 1) || (Med_tip == 2) || (Med_tip == 4) || (Med_tip == 5)
         var(1,i) = (medidores.acc(i)*abs(z(i))+0.0052*medidores.fs(i))/3;
    % Medida de angulo
    elseif (Med_tip == 3)
        var(1,i) = ((medidores.acc(i))*pi/180)/3;
    % Medidor de tensao
    elseif (Med_tip == 6 && PMU_num == 0)
        var(1,i) = (medidores.acc(i)*abs(z(i)))/3;
    elseif (Med_tip == 6 && PMU_num ~= 0)
        var(1,i) = (medidores.acc(i)*abs(z(i)))/3;
    elseif (Med_tip == 7 || Med_tip == 8 || Med_tip == 9 ||Med_tip == 10)
        var(1,i) = (medidores.acc(i)*abs(z(i)))/3;
    end 
end
save NM;
save var;
save N;