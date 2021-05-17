function z = calc_medidas(Ybus, Yd, Yp, d, p, V, medidores)
%Calcula as medidas relacionadas ao estado
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

% Numero de medidores
NMed = length(medidores.num);
% aloca o vetor z
z = zeros(NMed,1);
% Numero de ramos
Nramos = length(d);
% Numero de barras
Nbus = length(V);
% Módulo das tensões nodais
ModV = abs(V);
% ângulo de fase das tensões nodais
Teta = angle(V);
% Corrente de ramo DE
Id = Yd*V;
Id_r = real(Id);
Id_i = imag(Id);
% Corrente de ramo PARA
Ip = Yp*V;
Ip_r = real(Ip);
Ip_i = imag(Ip);
% Fluxos de potência nos ramos
Fluxo_P_d = real(V(d).*conj(Id));
Fluxo_P_p = real(V(p).*conj(Ip));
Fluxo_Q_d = imag(V(d).*conj(Id));
Fluxo_Q_p = imag(V(p).*conj(Ip));
% Injeção de corrente nos nós
I = Ybus*V;
Iinj_r = real(I);
Iinj_i = imag(I);
% save I; save Id; save Ip;
% Injeção de potência nos nós
Inj_P = real(V.*conj(I));
Inj_Q = imag(V.*conj(I));
med = 0;
for i = 1 : NMed
    % Medidas de fluxo de potencia ativa
    if medidores.tipo(i) == 1
        med = med +1;
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                z(med)= Fluxo_P_d(k);
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                z(med)= Fluxo_P_p(k);
            end
        end
    end
    % Medidas de injecao de potencia ativa
    if medidores.tipo(i) == 2
        med = med +1;
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                z(med)= Inj_P(k);
            end
        end
    end
    % Medidas de angulo de fase da PMU
    if medidores.tipo(i) == 3
        med = med +1;
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                z(med)= Teta(k);
            end
        end
    end
    % Medida de fluxo de potencia reativa
    if medidores.tipo(i) == 4
        med = med +1;
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                z(med)= Fluxo_Q_d(k);
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                z(med)= Fluxo_Q_p(k);
            end
        end
    end
    % Medida de injecao de potencia reativa
    if medidores.tipo(i) == 5
        med = med + 1;
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                z(med)= Inj_Q(k);
            end
        end
    end
    % Medida de modulo de tensao
    if medidores.tipo(i) == 6
        med = med + 1;
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                z(med)= ModV(k);
            end
        end
    end
    % Medidas de corrente de ramo real
    if medidores.tipo(i) == 7
        med = med +1;
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                z(med)= Id_r(k);
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                z(med)= Ip_r(k);
            end
        end
    end
    % Medidas de corrente de ramo imag
    if medidores.tipo(i) == 8
        med = med +1;
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                z(med)= Id_i(k);
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                z(med)= Ip_i(k);
            end
        end
    end
    % Medidas de injecao de corrente real
    if medidores.tipo(i) == 9
        med = med +1;
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                z(med)= Iinj_r(k);
            end
        end
    end
    % Medidas de injecao de corrente imag
    if medidores.tipo(i) == 10
        med = med +1;
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                z(med)= Iinj_i(k);
            end
        end
    end
end
return