function [medidores] = gerenc_med(medidores, opt, med_num)
% Gerencia os medidores
% function [medidores] = gerenc_med(medidores, opt, med_num)
% Opção:
%   opt = 0 => Desabilita todos os medidores SCADA
%   opt = 1 => Desabilita o medidor indicado em med
%   opt = 2 => Habilita todos os medidores SCADA
%   opt = 3 => Habilita o medidor indicado em med
%
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

if nargin < 1
    med_file = input('Entre com o arquivo de medidores: ', 's');
    [medidores] = ler_medidores(med_file);
end
if nargin < 2
    val = [0 1 2 3];
    ent = false;
    display ('opt = 0 => Desabilita todos os medidores SCADA')
    display ('opt = 1 => Desabilita o medidor indicado')
    display ('opt = 2 => Habilita todos os medidores SCADA')
    display ('opt = 3 => Habilita o medidor indicado')
    while ~ent 
        opt = input('Selecione a opção [0 1 2 3]?: ');
        if ismember(opt, val); ent = true; end
    end
end
if nargin < 3 && opt == 1
    med_num = input('Numero do medidor a ser desabilitado?: ');
end
if nargin < 3 && opt == 3
    med_num = input('Numero do medidor a ser habilitado?: ');
end
NMed = length(medidores.num);
if opt == 0
    for i = 1 : NMed
        if medidores.PMU_num(i) == 0
            medidores.ok(i) = 1;
        end
    end
elseif opt == 1
    medidores.ok(med_num) = 1;
elseif opt == 2
    for i = 1 : NMed
        if medidores.PMU_num(i) == 0
            medidores.ok(i) = 0;
        end
    end
elseif opt == 3
        medidores.ok(med_num) = 0;
end
return
