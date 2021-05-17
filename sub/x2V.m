function V = x2V(x, Nbus, Bref)
% Converte o vetor de estado em vetor das tensoes de barra
V = zeros(Nbus, 1);
MV = zeros(Nbus, 1);
TETA = zeros(Nbus, 1);
Nx = length(x);
if Nx == (2 * Nbus)
    for i = 1 : Nbus
        V(i,1) = x(Nbus + i) * exp(j * x(i));
    end
elseif Nx == (2 * Nbus - 1)
    for i = 1 : Nbus
        MV(i,1)=x(Nbus-1 + i);
    end
    k = 1;
    for i = 1 : Nbus
        if i == Bref
            TETA(i,1) = 0;
        else
            TETA(i,1) = x(k);
            k = k + 1;
        end
    end
    for i = 1 : Nbus
        V(i,1) = (MV(i,1) * exp(j * TETA(i,1)));
    end
end
return