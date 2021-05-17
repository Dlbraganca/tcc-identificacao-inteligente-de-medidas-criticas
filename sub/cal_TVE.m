function [TVE, TVE_m] = cal_TVE(Vref, V)
% Calcula o Total Vector Erro do estado
% function [TVE, TVE_m] = cal_TVE(Vref, V)
Xrn = real(V);
Xin = imag(V);
Xr = real(Vref);
Xi = imag(Vref);
TVE = ((((Xrn - Xr).^2 + (Xin - Xi).^2)./(Xr.^2 + Xi.^2)).^0.5) * 100;
n = length (TVE);
TVE_m = 0;
for i = 1 : n
    TVE_m = TVE_m + TVE(i);
end
TVE_m = TVE_m / n;
return