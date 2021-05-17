function [mat_exp] = exp_mat(mat, ind_del)
% Expande matriz nas linhas colunas dadas em ind_del
% mat       = Matriz a ser expandida
% ind_del   = Vetor com os indices das posicoes a serem incluidas
[m,n] = size(mat);
B = length(ind_del);
ndim = m + B;
mat_exp = [B,B];
if m == n
    if ndim > m
        l = 1;
        for i = 1 : ndim
            if i ~= ind_del
                k = 1;
                for j = 1 : ndim
                    if j ~= ind_del
                        mat_exp(i,j) = mat(l,k);
                        k = k + 1;
                    else
                        mat_exp(i,j) = 0;
                    end
                end
                l = l + 1;
            else
                for j = 1 : ndim
                    mat_exp(i,j) = 0;
                end
            end
        end
    else
        mat_exp = mat;
    end
end
                
