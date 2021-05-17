% clear
%
% Renomear o arquivo com a configuração completa de medidores do sistema
% para "FULL_SCADA.med"
%
[num, de, para, circ, tipo, PMU, ok, acc, fs, dp, ref, leitura]=textread('full_SCADA.med', '%s %s %s %s %s %s %s %s %s %s %s %s');
[nnum, nde, npara, ncirc, ntipo, nPMU, nok, nacc, nfs, ndp, nref, nleitura]=textread('full_SCADA.med');
tamanho=length(num);
%
% Medidas de Fluxo Ativo e Reativo
% Medidas de Injeção Ativa e REativa
% Medidas de Modulo de Tensão ( Medição Convencional )
% Medidas de Angulo de Tensão ( AINDA EM PENSAMENTO )
%
% Se formos usar Medidas de Fluxo ativo e Injeção Reativa responderemos a
% pergunta seguinte com "2"
% 
resposta=input('Quantos tipos de medidores deseja ? [1,2,3,4,5,6]  = ');
contador=1;contam=1;fluxo=0;injecao=0;tensao=0;angulo=0;
while contador <= resposta
    %
    % Usa convenção de Rui e seguindo exemplo anterior deve-se escolher "1"
    % na primeira vez da pergunta e "5" na segunda vez
    %
    tipomed=input('Qual Tipo de Medidor Deseja ? [1 a 10]  = ');
    for i=1:tamanho
        if ntipo(i)==tipomed
            indice(contam)=i;
            contam=contam+1;
        end
        if (ntipo(i)==1) || (ntipo(i)==4)
            fluxo=fluxo+1;
        elseif (ntipo(i)==2) || (ntipo(i)==5)
            injecao=injecao+1;
        elseif ntipo(i)==6
            tensao=tensao+1;
        elseif ntipo(i)==3
            angulo=angulo+1;            
        end
    end
    contador=contador+1;
end
%
% Ecolhe Barras de Injeção
%
contam=contam-1;tamcon=1;
ninjecao=input('Digite a Qtde de Medidas de Injeção ( considere medidas aos pares ):');
for i=1:ninjecao
    barra(i)=input('Barra = ');
end
for j=1:ninjecao
    for k=1:contam
        if (npara(indice(k))==barra(j))
             if (ntipo(indice(k))==2) || (ntipo(indice(k))==5)
                 indicef(tamcon)=indice(k);
                 tamcon=tamcon+1;
             end
        end
    end
end
%
% Ecolhe Barras de Fluxo
%
nfluxo=input('Digite a Qtde de Medidas de Fluxo ( considere medidas aos pares ):');
for i=1:nfluxo
    debarra(i)=input('De Barra = ');
    parabarra(i)=input('Para Barra = ');
end
for j=1:nfluxo
    for k=1:contam
        if (nde(indice(k))==debarra(j)) && (npara(indice(k))==parabarra(j))
            if (ntipo(indice(k))==1) || (ntipo(indice(k))==4)
                indicef(tamcon)=indice(k);
                tamcon=tamcon+1;
            end
        end
    end
end
%
% Ecolhe Barras de Tensão
%
ntensao=input('Digite a Qtde de Medidas de Tensão ( considere medidas de Módulo ):');
for i=1:ntensao
    barrav(i)=input('Barra = ');
end
for j=1:ntensao
    for k=1:contam
        if (npara(indice(k))==barrav(j))
            if (ntipo(indice(k))==6)
                indicef(tamcon)=indice(k);
                tamcon=tamcon+1;
            end
        end
    end
end
%
% Ecolhe Barras de Tensão para ANGULO e DEVE-SE PENSAR COMO CONVERTER
% MEDIDAS DE MODULO EM PMU QUANDO FOR IMPLEMENTAR
%
nangulo=input('Digite a Qtde de Medidas de Tensão ( considere medidas de Angulo ):');
fprintf('Isto automaticamente transforma medidas de Modulo de Tensão em PMU´s nas barras onde forem instaladas\n')
for i=1:nangulo
    barrat(i)=input('Barra = ');
end
%
% IMPLEMENTAÇÃO DA INSTALAÇÃO DE PMU SOMENTE COM TENSÃO
%
%
% GERA ARQUIVO PRINCIPAL
%
tamcon=tamcon-1;
for k=1:tamcon
    M(k,1)=k;
    M(k,2)=nde(indicef(k));
    M(k,3)=npara(indicef(k));
    M(k,4)=ncirc(indicef(k));
    M(k,5)=ntipo(indicef(k));
    M(k,6)=nPMU(indicef(k));
    M(k,7)=nok(indicef(k));
    M(k,8)=nacc(indicef(k));
    M(k,9)=nfs(indicef(k));
    M(k,10)=ndp(indicef(k));
    M(k,11)=nref(indicef(k));
    M(k,12)=nleitura(indicef(k));
end
format = '%04i %04i %04i %02i %02i %03i %01i %05.3f %05.3f %10.6f %+10.5f %+10.5f\n';
fid=fopen('casetest.med', 'wt');
fprintf(fid, format, M');
fclose(fid);
%
% GERA ARQUIVOS COM ERRO GROSSEIRO
%
med='CS1_EG_';
file='.med';
for l=1:tamcon
    M(l,12)=M(l,12)+2;
    med_file=strcat(med,int2str(k),file);
    fid=fopen(med_file, 'wt');
    fprintf(fid, format, M');
    fclose(fid);
    M(l,12)=M(l,12)-2;
end