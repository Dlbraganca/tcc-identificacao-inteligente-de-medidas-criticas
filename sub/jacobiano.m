function H = jacobiano(Ybus, Yd, Yp, d, p, V, Bref, Med_Ref, medidores)
% Calcula o Jacobiano
%function H = Jacobiano(Ybus, Yd, Yp, d, p, V, Bref, Med_Ref, medidores)
% Estrutura de medidores
% num           nº do medidor
% de            nº da barra DE
% para          nº da barra PARA
% circ          nº do circuito
% tipo          tipo de medidor
% var           variancia do medidor
% fs            fundo de escala do medidor
% valor         valor de referencia
% leitura       valor medido
% PMU_num       Medida associada a PMU n
% ok            Utiliza ou nao o medidor

% Convençoes:
% - Medidas de fluxo de potencia ativa:     tipo 1
% - Medidas de injecao de potencia ativa:   tipo 2
% - Medidas de angulo:                      tipo 3
% - Medidas de fluxo de potencia reativa:   tipo 4
% - Medidas de injecao de potencia reativa: tipo 5
% - Medidas de tensao:                      tipo 6
% - Medidas de corrente de ramo real        tipo 7
% - Medidas de corrente de ramo imag        tipo 8
% - Medidas de injecao de corrente real     tipo 9
% - Medidas de injecao de corrente imag     tipo 10
% - Medidas de fluxo de 1 => 2   ---> de=1 e para=2
% - Medidas de tensao na barra 3 ---> de=0 e para=3

% medidores.num=[];
% medidores.de=[];
% medidores.para=[];
% medidores.circ=[];
% medidores.tipo=[];
% medidores.var=[];
% medidores.fs=[];
% medidores.valor=[];
% medidores.leitura=[];
% medidores.PMU_num=[];
% medidores.ok=[];
% S = sparse(i,j,s,m,n,nzmax)

NMed = length(medidores.num);
Nramos = length(d);
Nbus = length(V);

% Calcula as derivadas parciais das injecoes
[dSinj_dVa, dSinj_dVm, dIinj_dVa, dIinj_dVm] = dSinj_dV(Ybus, V);

%Calcula as derivadas parciais dos fluxos
[dSfd_dVa, dSfd_dVm, dSfp_dVa, dSfp_dVm, dId_dVa, dId_dVm, dIp_dVa, dIp_dVm] = dSf_dV(Yd, Yp, d, p, V);

%Aloca a matriz H esparsa
H = spalloc(NMed,2*Nbus,4*Nbus);

for i = 1 : NMed
    if medidores.tipo(i) == 1  % Medidas de fluxo de potencia ativa
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                H(i,d(k))        = real(dSfd_dVa(k,d(k)));
                H(i,p(k))        = real(dSfd_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = real(dSfd_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = real(dSfd_dVm(k,p(k)));
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                H(i,d(k))        = real(dSfp_dVa(k,d(k)));
                H(i,p(k))        = real(dSfp_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = real(dSfp_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = real(dSfp_dVm(k,p(k)));
            end
        end
    end
    if medidores.tipo(i) == 2  % Medidas de injecao de potencia ativa
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                H(i,:) = [real(dSinj_dVa(k,:)), real(dSinj_dVm(k,:))];
            end
        end
    end
    if medidores.tipo(i) == 3  % Medidas de angulo de fase
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                H(i,k) = 1;
            end
        end
    end
    if medidores.tipo(i) == 4  % Medidas de fluxo de potencia reativa
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                H(i,d(k))        = imag(dSfd_dVa(k,d(k)));
                H(i,p(k))        = imag(dSfd_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = imag(dSfd_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = imag(dSfd_dVm(k,p(k)));
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                H(i,d(k))        = imag(dSfp_dVa(k,d(k)));
                H(i,p(k))        = imag(dSfp_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = imag(dSfp_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = imag(dSfp_dVm(k,p(k)));
            end
        end
    end
    if medidores.tipo(i) == 5  % Medidas de injecao de potencia reativa
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                H(i,:) = [imag(dSinj_dVa(k,:)), imag(dSinj_dVm(k,:))];
            end
        end
    end
    if medidores.tipo(i) == 6  % Medidas de modulo de tensao
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                H(i,k+Nbus) = 1;
            end
        end
    end
    if medidores.tipo(i) == 7  % Medidas de corrente de ramo real
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                H(i,d(k))        = real(dId_dVa(k,d(k)));
                H(i,p(k))        = real(dId_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = real(dId_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = real(dId_dVm(k,p(k)));
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                H(i,d(k))        = real(dIp_dVa(k,d(k)));
                H(i,p(k))        = real(dIp_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = real(dIp_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = real(dIp_dVm(k,p(k)));
            end
        end
    end
    if medidores.tipo(i) == 8  % Medidas de corrente de ramo imag
        for k = 1 : Nramos
            if medidores.de(i)== d(k) && medidores.para(i) == p(k)
                H(i,d(k))        = imag(dId_dVa(k,d(k)));
                H(i,p(k))        = imag(dId_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = imag(dId_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = imag(dId_dVm(k,p(k)));
            elseif medidores.de(i)== p(k) && medidores.para(i) == d(k)
                H(i,d(k))        = imag(dIp_dVa(k,d(k)));
                H(i,p(k))        = imag(dIp_dVa(k,p(k)));
                H(i,(d(k)+Nbus)) = imag(dIp_dVm(k,d(k)));
                H(i,(p(k)+Nbus)) = imag(dIp_dVm(k,p(k)));
            end
        end
    end
    if medidores.tipo(i) == 9  % Medidas de injecao de corrente real
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                H(i,:) = [real(dIinj_dVa(k,:)), real(dIinj_dVm(k,:))];
            end
        end
    end
    if medidores.tipo(i) == 10  % Medidas de injecao de corrente imag
        for k = 1 : Nbus
            if medidores.de(i)== 0 && medidores.para(i) == k
                H(i,:) = [imag(dIinj_dVa(k,:)), imag(dIinj_dVm(k,:))];
            end
        end
    end
end
if ~Med_Ref
    Nj = size(H,2);
    cols = dim_cut(Nj, Bref);
    H = H(:,cols);
end
return