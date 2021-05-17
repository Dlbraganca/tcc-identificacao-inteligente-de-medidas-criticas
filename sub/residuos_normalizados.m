function [medidores, mc] = residuos_normalizados(medidores)
% Calcula os residuos normalizados
nn = length(medidores.residuo);
mc = [];
% calcula os resíduos normalizados
n_mc = 0;
for i = 1 : nn
    % Medidor está habilitado
    if medidores.ok(i) == 0
        if medidores.residuo(i) == 0 && medidores.dpc(i) == 0
            % medida e critica
            n_mc = n_mc + 1;
            medidores.rn(i) = 0;
            medidores.mc(i) = 1;
            mc(n_mc) = medidores.num(i);
        elseif medidores.dpc(i) ~= 0
            % Calcula resíduo normalizado
            medidores.rn(i) = abs(medidores.residuo(i) ./ medidores.dpc(i));
        elseif medidores.dpc(i) == 0
            % Resíduo normalizado infinito
            medidores.rn(i) = 1e99;
        end
    end
end
return
