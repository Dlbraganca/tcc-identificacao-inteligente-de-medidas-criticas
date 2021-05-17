function [ckList] = read_cks (crit_med, ind_med, Caso, Ramo,order,med_pair, type_search, H, W)

%crit_med = [5 10 13 11];
% cd('.') % change path to \root folder
% current_path=pwd; % get current path
Hfile='H.txt';
Mfile='M.txt';
MUfile='MU.txt';
Afile='A.txt';
Wfile='W.txt';
ck_setup_file='ck_directives.txt';
conj_med='PAIR.txt';
Jposition='HPOS.txt';
%%create branch to node incidence matrix
A=zeros(Caso.NR, Caso.NB);
for i=1:Caso.NR
    A(i,Ramo.de(i))=+1;
    A(i,Ramo.para(i))=-1;
end


%%create measurement to branch incidence matrix (not implemented)
M=A;

% write H.txt
nrows=size(H,1);
ncols=size(H,2);
vec=H(:);
fid=fopen(Hfile,'wt');
fprintf(fid,'%d\n',nrows);
fprintf(fid,'%d\n',ncols);
vec = full(vec);
for i=1:length(vec)
    if (i < length(vec))
        %fprintf('%d ',vec(i));
        fprintf(fid,'%d ',vec(i));
    else
        %fprintf('%d\n',vec(i));
        fprintf(fid,'%d\n',vec(i));
    end
end
fclose(fid);

% write W.txt
nrows=size(W,1);
ncols=size(W,2);
vec=W(:);
fid=fopen(Wfile,'wt');
fprintf(fid,'%d\n',nrows);
fprintf(fid,'%d\n',ncols);
vec = full(vec);    
for i=1:length(vec)
    if (i < length(vec))
        %fprintf('%d ',vec(i));
        fprintf(fid,'%d ',vec(i));
    else
        %fprintf('%d\n',vec(i));
        fprintf(fid,'%d\n',vec(i));
    end
end
fclose(fid);




% write A.txt
nrows=size(A,1);
ncols=size(A,2);
vec=A(:);
fid=fopen(Afile,'wt');
fprintf(fid,'%d\n',nrows);
fprintf(fid,'%d\n',ncols);
for i=1:length(vec)
    if (i < length(vec))
        %fprintf('%d ',vec(i));
        fprintf(fid,'%d ',vec(i));
    else
        %fprintf('%d\n',vec(i));
        fprintf(fid,'%d\n',vec(i));
    end
end
fclose(fid);
% write EGs

%File CK_SETUP
fid=fopen(ck_setup_file,'wt');
    fprintf(fid, type_search);
for i = 2:length(crit_med)
    fprintf(fid,'\n%d %f',crit_med(i).num, crit_med(i).rn);
end
fclose(fid);
% File conjMED
fid=fopen(conj_med,'wt');
for i = 1:length(med_pair)
    fprintf(fid,'%d %d\n',med_pair(i,1), med_pair(i,2));
end
fclose(fid);
%File Posicao no Jacobiano
 fid=fopen(Jposition,'wt');
for i = 1:length(order)
    fprintf(fid,'%d %d\n',order(i), i);
end
fclose(fid);

% 
% fid=fopen(MUfile,'wt');
% %fprintf('%d %d\n',nm,nmu);
% fprintf(fid,'%d %d\n',nm,nmu);
% for i=1:nmu
%     %fprintf('%d',mu_location(i));
%     fprintf(fid,'%d',mu_location(i));
%     for j=1:nm
%         if(meas_location(j)==i)
%             %fprintf(' %d',j);
%             fprintf(fid,' %d',j);
%         end
%     end
%     %fprintf('\n');
%     fprintf(fid,'\n');
% end
% fclose(fid);

%%le os valores de cks resultante da busca IA
system('ck_search.exe');

if  exist('.\critical_tuples.txt', 'file')==2
    fid=fopen('critical_tuples.txt','r');
    ckList = fscanf(fid,'%d\n');
    fprintf('Medidas Encontradas\n');
    dim = length(ckList);
    for i = 1:dim
        fprintf('%d ', ckList(i));
    end
    
    fclose(fid);
    delete('.\critical_tuples.txt');
end

end 
