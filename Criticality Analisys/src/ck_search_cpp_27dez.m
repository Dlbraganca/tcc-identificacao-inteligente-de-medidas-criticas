function []=ck_search_cpp_27dez()
% Find critical ck-tuple through search algorithms
clear
original_path=pwd;
cd('..') % change path to \Criticality Analysis folder
cd('..') % change path to \Criticality Analysis folder
cd('..') % change path to \Criticalidade Matlab(Monte Carlo) folder
current_path=pwd; % get current path
addpath(strcat(current_path,'\LinearSE'),path); % add Linear SE folder
addpath(strcat(current_path,'\medidas'),path); % add medidas folder
addpath(strcat(current_path,'\sistemas'),path); % add sistemas folder
cd(original_path);
clc

%##########################################################################
%% 03 bus TEST SYSTEM
%med_file='3Barras_tese.med';
%med_file='3Barras_tese(2).med';
%sis_file='3Barras_tese.cdf';
%##########################################################################
%% 06 bus TEST SYSTEM
%med_file='6BusCase01_TPS2015.med';
%med_file='6BusCase02_TPS2015.med';
%med_file='6BusCase05_TPS2015.med';
%med_file='6BusCase06_TPS2015.med';
%med_file='6BusCase07_TPS2015.med';
%med_file='6BusCase08_TPS2015.med';
med_file='6Bus_v2Case03_TPS2015.med';
%med_file='6Bus_v2Case04_TPS2015.med';
%med_file='6BusCaseUM1.med';
%med_file='6BusCaseUM2.med';
%med_file='6BusCaseUM3.med';
%med_file='6BusCaseUM4.med';
%med_file='6BusCaseUM5.med';
%med_file='6BusCaseUM6.med';
%med_file='6Busv2CaseUM5_UM6.med';

%sis_file='6Bus.cdf';
sis_file='6Busv2.cdf';
%##########################################################################
%% IEEE 06 bus TEST SYSTEM
%med_file='ieee6Case01.med';
%sis_file='ieee6.cdf';
%##########################################################################
%% IEEE 14 bus TEST SYSTEM
%med_file='CASE03_Csets.med';

%med_file='CASE02_Csets.med';

%med_file='CASE01_Csets.med';

%med_file='ieee14_milton_teste.med';

%med_file='ieee14_full_scada.med';

%med_file='ieee14_london.med';

%med_file='ieee14_london_teste.med';

%med_file='ieee14exampleTPS2017.med';

%sis_file='ieee14.cdf';
%##########################################################################
%% IEEE 17 bus TEST SYSTEM
%med_file='S1_CS10_43M.med';
%med_file='S1_CS10_62M_PMU26491012.med';

%sis_file='ieee17.cdf';
%##########################################################################
%% IEEE 24 bus TEST SYSTEM
%sis_file='ieee24.cdf';

%med_file='ieee24Case01_SBSE2014.med';
%med_file='ieee24Case02(4)CBA2016.med';
%med_file='ieee24Case01_CBA2016- F16-15OUT.med';
%med_file='ieee24Case01_CBA2016- P15F22-17IN.med';
%med_file='ieee24Case01_CBA2016- P15P22IN.med';
%med_file='IEEE24Case02_TPS2015.med';
%med_file='ieee24Case03_TPS2015.med';
%med_file='ieee24Case04_TPS2015.med';
%med_file='ieee24Case05_TPS2015.med';
%med_file='ieee24Case06_TPS2015.med';
%med_file='ieee24Case07_TPS2015.med';
%med_file='ieee24Case07(1)_TPS2015.med';
%med_file='ieee24Case07(2)_TPS2015.med';
%med_file='ieee24Case07(3)_TPS2015.med';
%med_file='ieee24Case08_TPS2015.med';
%med_file='IEEE24Case08(2)_TPS2015.med';
%med_file='IEEE24Case08(3)_TPS2015.med';
%med_file='ieee24Case10_TPS2015.med';
%med_file='ieee24Case11_TPS2015.med';
%med_file='ieee24Case12_TPS2015.med';
%med_file='ieee24Case13_TPS2015.med';
%med_file='ieee24Case14_TPS2015.med';
%med_file='ieee24_gen_meet_2013_Obs_CASE01.med';
%med_file='ieee24_gen_meet_2013_Obs_CASE01.med';
%med_file='ieee24_gen_meet_2013_case02.med';
%med_file='ieee24_gen_meet_2013_case03.med';
%med_file='ieee24_gen_meet_2013_case04.med';
%med_file='ieee24_gen_meet_2013_case05.med';
%##########################################################################
%% IEEE 30 bus TEST SYSTEM
%med_file='ieee30_observability_full_2014.med';

%med_file='ieee30_observability_PSCC_2014.med';

%med_file='S1_CS10_81M.med';

%med_file='S1_CS10_81M_62M_PMU26491012.med';

%med_file='ieee30_observability_PSCC_2014B.med';

%sis_file='ieee30.cdf';
%##########################################################################
%% IEEE 118 bus TEST SYSTEM

%med_file='S1_CS5_352M.med';

%med_file='S1_CS5_352M_90M_PMU.med';

%sis_file='ieee118.cdf';
%##########################################################################
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
%##########################################################################

[Caso, Barra, Ramo]=ler_sistema(sis_file); % read network data
[medidores]=ler_medidores(med_file); % read measurement data

% select the criticality type to be considered
if nargin==0
    fprintf('\nPower network with %d Buses, %d Branches and %d Measurements\n',Caso.NB, Caso.NR, length(medidores.num));
    fprintf('\nMeasurement system design:\n\t1-From file:\tdefault\n\t2-Custom(complete measurement units):\tcustom\n'); % selects the measurement design to be assessed
    Measurement_system_design=input('\nMeasurement_system_design:       ','s');
    
end

%create branch to node incidence matrix
A=zeros(Caso.NR, Caso.NB);
for i=1:Caso.NR
    A(i,Ramo.de(i))=+1;
    A(i,Ramo.para(i))=-1;
end

% create Jacobian matrix and measurement system with only real/active measurements
switch Measurement_system_design
    case 'custom'
        fprintf('\nNumber of system buses: %d\n',Caso.NB);
        %meas_location=zeros(1,nm); %reset meas_location
        mu_location=input('installed MUs (vector):   ');
        is_pmu=input('MU type of each MU: 0(conventional) or 1(phasor)');
        if(isempty(mu_location))
            mu_location=1:Caso.NB;
        end
        if(isempty(is_pmu))% all installed MUs are conventional
            is_pmu=zeros(1,Caso.NB);
        end
        % overwrite current measurement system
        [medidores]=generate_complete_munits(mu_location,is_pmu,A,Caso);
        [H , order] = LinJ(medidores,Ramo,Barra,Caso);
        medidores.num = medidores.num(order);
        medidores.de = medidores.de(order);
        medidores.para = medidores.para(order);
        medidores.tipo = medidores.tipo(order);
        medidores.PMU_num = medidores.PMU_num(order);
        medidores.leitura = medidores.leitura(order);
        [nm,ns]=size(H);
        
        %create Measurement unit and measurement location arrays
        meas_location=zeros(1,nm);
        for i=1:nm
            if(medidores.tipo(i)==1 || medidores.tipo(i)==7) % check if the ith measurement is a power flow/branch current
                pos=find(logical(mu_location==medidores.de(i)),1); %give the fort ocurrence of the bus in mu_location
                meas_location(i)=pos;
            else if (medidores.tipo(i)==2 || medidores.tipo(i)==3) % check if the ith measurement is a power injection or voltage angle
                    pos=find(logical(mu_location==medidores.para(i)),1); %give the fort ocurrence of the bus in mu_location
                    meas_location(i)=pos;
                end
            end
        end
        nmu=length(mu_location);
        
        
        %          nmu=length(mu_location);
        %          fprintf('\nNumber of measurements units: %d\n',length(mu_location));
        %          dim=length(mu_location);
        %          kmax=input('Maximum cardinality to be searched:   ');
        %          kmin=input('Minimum cardinality to be searched:   ');
        %          klim=kmax;
    case 'default'
        idz=logical( medidores.ok==0 & ( medidores.tipo==1 | medidores.tipo==2 | medidores.tipo==3 | medidores.tipo==7 | medidores.tipo==9) ); % medidores ativos de fluxo e injecao
        medidores.num = medidores.num(idz);
        medidores.de = medidores.de(idz);
        medidores.para = medidores.para(idz);
        medidores.tipo = medidores.tipo(idz);
        medidores.PMU_num = medidores.PMU_num(idz);
        medidores.leitura = medidores.leitura(idz);
        [H , order] = LinJ(medidores,Ramo,Barra,Caso);
        medidores.num = medidores.num(order);
        medidores.de = medidores.de(order);
        medidores.para = medidores.para(order);
        medidores.tipo = medidores.tipo(order);
        medidores.PMU_num = medidores.PMU_num(order);
        medidores.leitura = medidores.leitura(order);
        [nm,ns]=size(H);
        %create Measurement unit and measurement location arrays
        meas_location=zeros(1,nm);
        mu_location=zeros(1,Caso.NB);
        nmu=0;
        for i=1:nm
            if(medidores.tipo(i)==1 || medidores.tipo(i)==7) %check if it is a power flow/branch current measurement
                pos=find(logical(mu_location==medidores.de(i)),1); %get the first ocurrence of the bus in mu_location
                if(isempty(pos)) % check if the bus is present in mu_location
                    nmu=nmu+1; %increase the number of measurement units
                    mu_location(nmu)=medidores.de(i); %add pmu location
                    meas_location(i)=nmu;
                else
                    meas_location(i)=pos;
                end
            else if (medidores.tipo(i)==2 || medidores.tipo(i)==3 || medidores.tipo(i)==9) %check if it is a active power/ real current injection or a voltage phase measurement
                    pos=find(logical(mu_location==medidores.para(i)),1); %get the first ocurrence of the bus in mu_location
                    if(isempty(pos)) % check if the bus is present in mu_location
                        nmu=nmu+1;
                        mu_location(nmu)=medidores.para(i); %add pmu location
                        meas_location(i)=nmu;  %increase the number of measurement units
                    else
                        meas_location(i)=pos;
                    end
                end
            end
        end
        mu_location((nmu+1):end)=[];% shrink mu_location
end

%create measurement to branch incidence matrix (not implemented)
M=A;

% write H.txt
nrows=size(H,1);
ncols=size(H,2);
vec=H(:);
fid=fopen('H.txt','wt');
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

% write A.txt
nrows=size(A,1);
ncols=size(A,2);
vec=A(:);
fid=fopen('A.txt','wt');
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

% write M.txt
nrows=size(M,1);
ncols=size(M,2);
vec=M(:);
fid=fopen('M.txt','wt');
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

fid=fopen('MU.txt','wt');
%fprintf('%d %d\n',nm,nmu);
fprintf(fid,'%d %d\n',nm,nmu);
for i=1:nmu
    %fprintf('%d',mu_location(i));
    fprintf(fid,'%d',mu_location(i));
    for j=1:nm
        if(meas_location(j)==i)
            %fprintf(' %d',j);
            fprintf(fid,' %d',j);
        end
    end
    %fprintf('\n');
    fprintf(fid,'\n');
end
fclose(fid);

% fid=fopen('non_critical_elements.txt','wt');
% critical_elements_list=input('Specify the critical elements');
% if(isempty(critical_elements_list))
%     fprintf(fid,'%d',mu_location(i));    
%     for i=1:nmu
%         fprintf(fid,' %d',mu_location(i));
%     end
% else
%     first=1;
%     for i=1:nmu
%         idx=logical(mu_location(i)==critical_elements_list);
%         pos=find(idx,1);
%         if(isempty(pos))
%             if(first)
%               fprintf(fid,'%d',mu_location(i));
%               first=0;
%             else
%               fprintf(fid,' %d',mu_location(i));
%             end
%         end
%     end
%     fprintf(fid,'\n');
% end
% fclose(fid);

if nargin==0
    fprintf('\n Available criticality types:\n 1-single measurements - measurement\n 2-measurement units - munit\n 4-mixed(MUs and meas) - mx_mu_meas\n 5-complement=comp_mu_meas\n 6-topology=top\n');
    criticality_type=input('Select criticality type:      ','s');
end

switch criticality_type
    case 'measurement'
        fprintf('\nNumber of measurements: %d \n Number of states: %d \n maximum cardinality: %d \n',nm,ns,nm-ns+1);
        dim=nm;
        klim=nm-ns+1;
        kmax=input('Maximum cardinality to be searched:   ');
        kmin=1;
        
    case 'top'
        fprintf('\nNumber of branches: %d \n Number of buses: %d \n maximum cardinality: %d \n',Caso.NR,Caso.NB,Caso.NR);
        dim=Caso.NR;
        klim=Caso.NR;
        kmax=input('Maximum cardinality to be searched:   ');
        kmin=1;        
    
    case 'munit'
        fprintf('\nNumber of measurements: %d \nNumber of measurement units: %d \n',nm,nmu);
        dim=length(mu_location);
        kmax=input('Maximum cardinality to be searched:   ');
        kmin=input('Minimum cardinality to be searched:   ');
        klim=kmax;
        
    case 'complete_munit'%,'ckmed_ckmunit','ckmed_ckmunit_complete'}
        fprintf('\nNumber of measurements: %d \nNumber of measurement units: %d \n',nm,nmu);
        dim=length(mu_location);
        kmax=input('Maximum cardinality to be searched:   ');
        kmin=input('Minimum cardinality to be searched:   ');
        klim=kmax;
end


if nargin==0
    fprintf('\n\nSearch methods:\n\t 1-Branch_and_Bound - DFS(bb_dfs)\n\t 2-Branch_and_Bound - BFS(bb_bfs)\n\t 3-Exhaustive search(exh)\n');
    search_method=input('\nSelected search method:      ','s'); % colocar dois niveis de pergunta
end


fprintf(strcat('SEARCH_METHOD=',search_method,'\n'));
fprintf(strcat('DIM=',int2str(dim),'\n'));
fprintf(strcat('KLIM=',int2str(klim),'\n'));
fprintf(strcat('KMAX=',int2str(kmax),'\n'));
fprintf(strcat('KMIN=',int2str(kmin),'\n'));
fprintf(strcat('CRIT_TYPE=',criticality_type,'\n'));

fid=fopen('ck_directives.txt','wt');
fprintf(fid,'%s\n',search_method);
fprintf(fid,'%d\n',klim);
fprintf(fid,'%d\n',kmin);
fprintf(fid,'%d\n',kmax);
fprintf(fid,'%d\n',dim);
fprintf(fid,'%s\n',criticality_type);
fclose(fid);

terminate=input('Terminate execution (T) or continue(C) ???       ','s');
if (isempty(terminate) || strcmpi(terminate,'T'))
    disp('Execution terminate by request of the user');
    return;
    
else
    switch criticality_type
        case {'munit','complete_munit','measurement'}
            %dos('Single_crit_analysis.exe');
            dos('single_criticality_19mai.exe');
        case {'med_mu','med_complete_mu'}
            fprintf('metodo ainda nao implementado  !!!!!!!!!');
            return;
            %implement whatever is needed
        case 'top'
            dos('single_criticality.exe');
    end
end

%return;

switch criticality_type
    case {'munit','measurement','top'}
        Critical_List=dlmread('critical_tuples.txt');
        fprintf('\n Filtering solutions ...');
        [cktuples]=filter_solutions4(Critical_List);
        fprintf('done !!!');
        fprintf('\n Generating distribution ...');
        %create tuple distance plots
        [tuple_max_dist_vec,tuple_mean_dist_vec]=get_tuple_distance(Caso, Ramo, cktuples, criticality_type, meas_location);
        figure;    
        plot(tuple_max_dist_vec);
        title('Maximum distance between elements in k-tuples');
        figure;    
        plot(tuple_mean_dist_vec);
         title('Mean distance between elements in k-tuples');
        figure;
        k_vec=sum(cktuples,2);
        for k=kmin:kmax
            idx=logical(k_vec==k);
            subplot(1,(kmax-kmin+1),k);
            boxplot(tuple_max_dist_vec(idx),'labels',k);
        end
        title('Max. distances distributions');
        %create tupel distribution plot
        Critical_List_k=sum(Critical_List,2);
        Critical_List_k=sort(Critical_List_k);
        K=kmin:kmax;
        K_freq=zeros(size(K));
        for k=kmin:kmax
            idx=logical(Critical_List_k==k);
            K_freq(k)=sum(idx);
        end
        figure;
        bar_plot=bar(K,K_freq);
        title_str=strcat('Ck-tuples distribution by cardinality (up to k=',num2str(kmax));
        title_str=strcat(title_str,')');
        title(title_str);
        xlabel('Cardinality');
        ylabel('Number of Ck-tuples');
        bar_width=get(bar_plot,'BarWidth');
        ax=gca;
        ax.XLim=[(0+(bar_width/2)) (kmax+(bar_width/2)+(bar_width/4))];
        ax.XTick=kmin:kmax;    
        ax.YLim=[0 (max(K_freq)+1)];
        ax.YTick=0:(max(K_freq)+1);      
        incrx=input('Interval between horizontal ticks:     ');
        incry=input('Interval between vertical ticks:     ');
        if ~isempty(incry)
            ax.YTick=0:incry:(max(K_freq)+1);
        end
        if ~isempty(incrx)
            ax.XTick=kmin:incrx:kmax;
        end
        fprintf('done !!!  ');
        switch criticality_type
            case 'measurement'
                [z_str]=meas_str2num(medidores);
                [ck_tuples]=knum2kstr(z_str,cktuples,kmax);
            case 'top'                
                [z_str]=branch_str2num(Ramo);
                [ck_tuples]=knum2kstr(z_str,cktuples,kmax);
            case 'munit'
                [mu_str]=mu_str2num(mu_location);
                [ck_tuples]=knum2kstr(mu_str,cktuples,kmax);
        end
        %% save in excel file
        fprintf('\n Writing results ...');
        xls_file_name=input('Excel file name:     ','s');
        for i=1:length(ck_tuples)
            sheet_name=strcat('C',num2str(i));
            sheet_name=strcat(sheet_name,'-tupla');
            if isempty(ck_tuples(i).str_set)
                error_ck_tuple={'----'};
                xlswrite(xls_file_name,error_ck_tuple,sheet_name);
            else
                xlswrite(xls_file_name,ck_tuples(i).str_set,sheet_name);
            end
        end
        distribution=[K' K_freq'];
        xlswrite(xls_file_name,distribution,'ditribution');
        fprintf('done !!!');
        %     case {'ckmed_ckmunit','ckmed_ckmunit_complete'}
        %         dos('Project12_c.exe'); % call c++ exe file
        %         Critical_meas_size_list=dlmread('critical_meas_size.txt');
        %         Critical_mu_list=dlmread('critical_tuples.txt');
        %         Critical_meas_list=dlmread('critical_meas_tuples.txt');
        %         n_cp=size(Critical_mu_list,1);
        %         [z_str]=meas_str2num(medidores);
        %         [mu_str]=mu_str2num(Caso);
        %         str_ck_cp_tuples(1:n_cp)=struct('mu_set',[],'mu_str_set',[],'meas_set',[],'meas_str_set',[]);
        %         first=1;
        %         for i=1:n_cp
        %             last=first+(Critical_meas_size_list(i)-1);
        %             [str_ck_cp_tuples(i)]=knum2kstr_ck_cp(mu_str,z_str,Critical_mu_list(i,:),Critical_meas_list(first:last,:));
        %             first=last+1;
        %         end
        %         fprintf('done !!!');
        %         %% save in excel file
        %         print_ok=input('print ck cp xls ?[Y/N] (N)');
        %         if (~isempty(print_ok) && strcmpi(print_ok,'Y'))
        %             fprintf('\n Writing results ...');
        %             xls_file_name=input('Excel file name:     ','s');
        %             for i=1:n_cp
        %                 sheet_name=strcat('Cp_tupla   ',num2str(i));
        %                 if isempty(str_ck_cp_tuples(i).mu_str_set)
        %                     error_ck_tuple={'----'};
        %                     xlswrite(xls_file_name,error_ck_tuple,sheet_name,'A1');
        %                 else
        %                     xlswrite(xls_file_name,str_ck_cp_tuples(i).mu_str_set,sheet_name,'A1');
        %                     if isempty(str_ck_cp_tuples(i).meas_str_set)
        %                         error_ck_tuple={'----'};
        %                         xlswrite(xls_file_name,error_ck_tuple,sheet_name,'A3');
        %                     else
        %                         xlswrite(xls_file_name,str_ck_cp_tuples(i).meas_str_set,sheet_name,'A3');
        %                     end
        %                 end
        %             end
        %         end
        %         ck_cp_statistics(Critical_meas_list,Critical_mu_list,N);
        %         fprintf('done !!!');
end
% Critical_List_k=sum(Critical_List,2);
% Critical_List_k=sort(Critical_List_k);
% K=kmin:kmax;
% K_freq=zeros(size(K));
% for k=kmin:kmax
%     idx=logical(Critical_List_k==k);
%     K_freq(k)=sum(idx);
% end
% bar(K,K_freq);
% title('Ck-tuples distribution by cardinality');
% xlabel('Cardinality');
% ylabel('Number of Ck-tuples');
% ax=gca;
% ax.YLim=[0 (max(K_freq)+1)];
% ax.YTick=0:(max(K_freq)+1);
end

function [ck_tuples]=filter_solutions4(Critical_List)
if nargin == 0
    load('Critical_list.mat','Critical_List');
end
solution_rank=sum(Critical_List,2);
[solution_rank,idx]=sort(solution_rank,'ascend');
ck_tuples=Critical_List(idx,:);
List_size=size(ck_tuples,1);
i=1;
while i < List_size
    non_critical=logical(solution_rank > solution_rank(i)); % soluions with rank greater than the current one
    non_equal=logical(solution_rank == solution_rank(i)); % soluions with rank equal to the current one
    j=find(non_critical,1); % soluions with rank greater than the current one
    ej=find(non_equal,1,'last'); % soluions with rank equal to the current one
    for k = j:List_size
        result=ck_tuples(i,:) & ck_tuples(k,:);
        if ~isequal(ck_tuples(i,:),result) %non minimal tuple
            non_critical(k)=false;
        end
    end
    for ek = i+1:ej
        if isequal(ck_tuples(i,:) , ck_tuples(ek,:))
            non_critical(ek)=false;
        end
    end
    ck_tuples= ck_tuples(~non_critical,:);
    solution_rank=  solution_rank(~non_critical);
    List_size=size(ck_tuples,1);
    i=i+1;
end
end

function [z_str]=meas_str2num(medidores)
m=size(medidores.tipo,2);
z_str=cell(1,m);
for i=1:m
    switch medidores.tipo(i)
        case 1
            z_str{i}=['F',num2str(medidores.de(i)),'-',num2str(medidores.para(i))];
        case 2
            z_str{i}=['P',num2str(medidores.para(i))];
        case 3
            z_str{i}=['A',num2str(medidores.para(i))];
        case 4
            z_str{i}=['G',num2str(medidores.de(i)),'-',num2str(medidores.para(i))];
        case 5
            z_str{i}=['Q',num2str(medidores.para(i))];
        case 6
            z_str{i}=['V',num2str(medidores.para(i))];
        case 7
            z_str{i}=['Re(Iramo)',num2str(medidores.de(i)),'-',num2str(medidores.para(i))];
        case 8
            z_str{i}=['Im(Iramo)',num2str(medidores.de(i)),'-',num2str(medidores.para(i))];
        case 9
            z_str{i}=['Re(Ibarra)',num2str(medidores.para(i))];
        case 10
            z_str{i}=['Im(Ibarra)',num2str(medidores.para(i))];
    end
end
end

function [mu_str]=mu_str2num(mu_location)
%nb=Caso.NB;
mu_str=cell(1,length(mu_location));
for i=1:length(mu_location)
    mu_str{i}=['UM-',num2str(mu_location(i))];
end
end

function [branch_str]=branch_str2num(Ramo)
nr=length(Ramo.de);
branch_str=cell(1,nr);
for i=1:nr
    branch_str{i}=['RAMO-',num2str(Ramo.de(i)),'-',num2str(Ramo.para(i))];
end
end

function [str_ck_tuples]=knum2kstr(z_str,cktuples,kmax)
str_ck_tuples(1:kmax)=struct('set',[],'str_set',[]);
num_of_tuples=size(cktuples,1);
k=sum(cktuples,2);
for i=1:num_of_tuples
    v=find(cktuples(i,:));
    str_ck_tuples(k(i)).set=[str_ck_tuples(k(i)).set ; v]; %add tuple to the ck-tuple set
end
for i=1:kmax
    set_size=size(str_ck_tuples(i).set,1);
    for j=1:set_size
        for k=1:i
            str_ck_tuples(i).str_set{j,k}=z_str{str_ck_tuples(i).set(j,k)};
        end
    end
end
end

% function [str_ck_cp_tuples]=knum2kstr_ck_cp(mu_str,z_str,cp_mu,ck_meas)
% str_ck_cp_tuples=struct('mu_set',[],'mu_str_set',[],'meas_set',[],'meas_str_set',[]);
% v=find(cp_mu);
% str_ck_cp_tuples.mu_set=v;
% for k=1:length(v)
%     str_ck_cp_tuples.mu_str_set{1,k}=mu_str{str_ck_cp_tuples.mu_set(k)};
% end
% num_of_tuples=size(ck_meas,1);
% k=sum(ck_meas,2);
% str_ck_cp_tuples.meas_set=zeros(num_of_tuples,max(k));
% for i=1:num_of_tuples
%     v=find(ck_meas(i,:));
%     str_ck_cp_tuples.meas_set(i,1:length(v))=v; %add tuple to the ck-tuple set
%     for j=1:max(k)
%         if str_ck_cp_tuples.meas_set(i,j) == 0
%             str_ck_cp_tuples.meas_str_set{i,j}={'----'};
%         else
%             str_ck_cp_tuples.meas_str_set{i,j}=z_str{str_ck_cp_tuples.meas_set(i,j)};
%         end
%     end
% end
% end