function x = V2x(V, Nbus, Bref, Med_Ref)
% Converte o vetor de tensoes em vetor de estado
% Se houver medicao de angulo na Barra de Referencia
% o vetor de estado possui todos os angulos e modulos
if Med_Ref == 1
    x = zeros(2 * Nbus, 1);
    for i = 1 : Nbus
        x(i,1) = angle(V(i));
        x(i + Nbus,1) = abs(V(i));
    end
else
    k = 0;
    x = zeros(2 * Nbus - 1, 1);
    for i = 1 : Nbus
        if Bref ~= i
            k = k + 1;
            x(k,1) = angle(V(i));
        end
    end
    for i = 1 : Nbus
        k = k + 1;
        x(k,1) = abs(V(i));
    end
end
return