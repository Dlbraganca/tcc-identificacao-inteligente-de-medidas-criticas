function [result] = find_par(medidores)

active_means = [1 2 3 7 9];  %conjunto de medidas do modelo DC
reactive_means = [4 5 6 8 10]; %conjunto de medidas reativas ou modulo
count = 0;
for i = 1:length(active_means)
   for j = 1:length(medidores.tipo)
       if (medidores.tipo(j) == active_means(i))
           count = count + 1;
           par = 0;
           for k = 1:length(medidores.tipo)
               if (medidores.tipo(k) == reactive_means(i))
                   if (medidores.de(j) == medidores.de(k) && medidores.para(j) == medidores.para(k))
                       par = medidores.num(k);
                       break;
                   end
               end
           end
            result(count,1) = medidores.num(j);
            result(count,2) = par;
       end
   end
end
%parte img faltante
for i = 1:length(medidores.tipo)
    for j = 1:length(reactive_means)
        if (medidores.tipo(i) == reactive_means(j))
            for k = 1:length(result)
                if (medidores.num(i) == result(k,2))
                    break;
                end
                if (k == length(result))
                    result(end+1,1) = 0;
                    result(end, 2) = medidores.num(i);
                end
            end
        end
    end
end