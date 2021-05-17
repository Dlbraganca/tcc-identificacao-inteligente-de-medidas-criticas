function [peso] = cal_peso(medidores)
% Peso dos medidores 
% function [peso] = cal_peso(medidores)
% Estrutura de medidores
% num           nº do medidor
% de            nº da barra DE
% para          nº da barra PARA
% circ          nº do circuito
% tipo          tipo de medidor
% var           variância do medidor
% fs            fundo de escala do medidor
% valor         valor de referencia
% leitura       valor medido
% PMU_num       Medida associada a PMU n
% ok            Utiliza ou nao o medidor           

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

% Pesos selecionados:
% Medidas de potencia:  200
% Medidas de tensao:    400
% Medidas de PMU:       1000

Nmed = length(medidores.num);
peso = [];

for i = 1 : Nmed
    Med_tip = medidores.tipo(i);
    PMU = medidores.PMU_num(i);
    if (Med_tip == 1) || (Med_tip == 2) || (Med_tip == 4) || (Med_tip == 5)
        peso(i,1) = 20;
    elseif PMU ~= 0
        peso(i,1) = 10000;
    elseif (Med_tip == 6) && PMU == 0
        peso(i,1) =  40;
    end 
end

