function mostra_estado(Bnum, V, Vref, n_it, conv, med_opt, fout)
% Mostra o resultado da estimação
% function mostra_estado(V, Vref, n_it, conv, med_opt, fout)
% V     = tensão nodal estimada
% Vref  = tensão nodal de referência
% n_it = número da interação
% conv  = 1 se o estimador convergiu
% med_opt = 1 se houver Vref
if nargin < 7
    fout = 1;
end
if conv && ~med_opt
    mod_Vref = abs(Vref);
    ang_Vref = angle(Vref);
    mod_V = abs(V);
    ang_V = angle(V);
    [TVE, TVE_m] = cal_TVE(Vref, V);
    EST = [Bnum mod_Vref ang_Vref*180/pi mod_V ang_V*180/pi TVE ]';
    fprintf(fout, '============= Estado Ref =============== Estado Est ================ TVE =========\n');
    fprintf(fout, 'Barra     Mod(pu)    Ang(graus)      Mod(pu)   Ang(graus)            (%%)         \n');
    fprintf(fout, '----------------------------------------------------------------------------------\n');
    fprintf(fout, '%4i   %10.4f   %10.2f    %10.4f   %10.2f      %10.4f \n', EST);
    fprintf(fout, '----------------------------------------------------------------------------------\n');
    fprintf(fout, 'Convergiu em: %4i iteraçoes com TVE medio de %10.4f \n', n_it, TVE_m);
    fprintf(fout, '----------------------------------------------------------------------------------\n');
elseif conv && med_opt
    mod_V = abs(V);
    ang_V = angle(V);
    EST = [Bnum mod_V ang_V*180/pi]';
    fprintf(fout, '============================== Estado Estimado ===================================\n');
    fprintf(fout, '                 Barra     Mod(pu)    Ang(graus)              \n');
    fprintf(fout, '----------------------------------------------------------------------------------\n');
    fprintf(fout, '                 %4i        %10.4f        %10.2f        \n', EST);
    fprintf(fout, '----------------------------------------------------------------------------------\n');
    fprintf(fout, 'Convergiu em: %4i iteraçoes. \n', n_it);
    fprintf(fout, '----------------------------------------------------------------------------------\n');
elseif ~conv   
    fprintf(fout, '----------------------------------------------------------------------------------\n');
    fprintf(fout, 'Não convergiu em %4i iteraçoes.\n', n_it);
    fprintf(fout, '----------------------------------------------------------------------------------\n');
end
return