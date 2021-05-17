function ind = dim_cut(dim, ind_del)
% Redimensiona vetor apos excluir elemento
% dim       = Dimensão do vetor original
% ind_del   = Vetor com os indices a serem excluidos
% ind       = Vetor com os indices restantes
k = 0;
if ~isempty(ind_del)
    for i = 1 : dim
        if i ~= ind_del
            k = k + 1;
            ind(1,k)= i;
        end
    end
else
    for i = 1 : dim
        k = k + 1;
        ind(1,k) = i;
    end
end
