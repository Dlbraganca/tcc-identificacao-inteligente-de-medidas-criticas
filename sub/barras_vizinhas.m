function [vizinhas, nv] = barras_vizinhas (Bnun, Ramo)
% Retorna um vetor com as barras vizinhas
% function [vizinhas] = barras_vizinhas (Bnun, Ramo)
NL=size(Ramo.num,1);
nv = 0;
for i = 1 : NL
    if Ramo.de(i) == Bnun
        nv = nv + 1;
        vizinhas(nv) = Ramo.para(i);
    elseif (Ramo.de(i) ~= 0 && Ramo.para(i) == Bnun)
        nv = nv + 1;
        vizinhas(nv) = Ramo.de(i);
    end
end
return
        
    