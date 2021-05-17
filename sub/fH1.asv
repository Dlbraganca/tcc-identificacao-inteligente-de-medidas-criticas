function nh = fH(Matriz, ind_del)
% Redimensiona matriz H apos excluir elementos das colunas  com PMU
% Matriz    = Matriz H original
% ind_del   = Vetor com os indices a serem excluidos
% NH        = Nova Matriz H com os indices restantes
tam=size(Matriz)
tam1=size(ind_del)
ind_del(tam1(2)+1)=tam(2)+1
coluna=1;
nh=zeros(tam(1),tam(2)-tam1(2));
size(nh)
for i=1:tam(1)
    for k=1:tam(2)
        Matrix(i,k)=Matriz(i,k);
    end
end 
k=1;
for j=1:tam(2)
	if j == ind_del(k)
		k=k+1;
    else
    	nh(:,coluna)=Matrix(:,j);
        coluna=coluna+1;
    end
end
size(Matrix)
size(nh)