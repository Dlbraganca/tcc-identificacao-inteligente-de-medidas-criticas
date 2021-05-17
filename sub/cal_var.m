function [var] = cal_var(medidores,z)
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
% ORIGINAL DO RUI

NMed = length(medidores.num);
var = zeros(1,NMed);
for i = 1 : NMed
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