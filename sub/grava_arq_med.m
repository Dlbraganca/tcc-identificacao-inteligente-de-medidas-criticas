function grava_arq_med(medidores, med_file)
% Grava a estrutura dos medidores no arquivo filename
%
% grava_arq_med                         -> Solicita o nome do arquivo de dados
% grava_arq_med(medidores, med_file)    -> Utiliza o arquivo especificado
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

if nargin < 2
    disp('====================================================================')
    med_file = input('Salvar medidores no arquivo:[medidores.dat] ', 's');
    if isempty(med_file); med_file = 'medidores.dat'; end
end
NMed=length(medidores.num);
format = '%04i %04i %04i %02i %02i %03i %01i %05.3f %05.3f %10.6f %+10.5f %+10.5f\n';
for i=1:NMed
    dados(i,1) = medidores.num(i);     
    dados(i,2) = medidores.de(i);      
    dados(i,3) = medidores.para(i);    
    dados(i,4) = medidores.circ(i);    
    dados(i,5) = medidores.tipo(i);    
    dados(i,6) = medidores.PMU_num(i); 
    dados(i,7) = medidores.ok(i);      
    dados(i,8) = medidores.acc(i);     
    dados(i,9) = medidores.fs(i);      
    dados(i,10) =medidores.dp(i);      
    dados(i,11) = medidores.ref(i);    
    dados(i,12) = medidores.leitura(i);
end
% Abre o arquivo para escrita
fid = fopen(med_file, 'wt');
% Grava os dados dos medidores
fprintf(fid, format, dados');
% Fecha o arquivo de medidores
fclose(fid);
return