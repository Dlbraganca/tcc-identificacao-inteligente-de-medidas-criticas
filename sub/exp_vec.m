function vet_exp = exp_vec(vet, ind_del)
% Expande vetor em posicoes especificas
% vet       = Vetor a ser expandido
% ind_del   = Vetor com os indices das posicoes a serem incluidas

dim_vet = length(vet);
B = length(ind_del);
n_size = dim_vet + B;
if B > 0
    j = 1;
    for i = 1 : n_size
        if i ~= ind_del
            vet_exp(i) = vet(j);
            j = j + 1;
        else
            vet_exp(i) = 0;
        end
    end
    vet_exp = vet_exp;
else
    vet_exp = vet;   
end
                
