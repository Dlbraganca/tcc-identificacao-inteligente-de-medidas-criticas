function []=compare_ck(filename1,filename2)
ck_list1=dlmread(filename1);
ck_list2=dlmread(filename2);
nm_1=size(ck_list1,2);
nm_2=size(ck_list2,2);
nck_1=size(ck_list1,1);
nck_2=size(ck_list2,1);
if((nm_1~=nm_2)||(nck_1~=nck_2))
    fprintf('critical lists do not macth');
    return;
else
    match=0;
    for i=1:nck_1
        for j=1:nck_2
            count=0;
            for k=1:nm_1
                if(ck_list1(i,k)~=ck_list2(j,k)) % criticalities do not match
                    break;
                else
                    count=count+1;
                end
            end
            if(count==nm_1)
                match=match+1; % critical tuples match !!
                break;
            end
        end
    end
    if (match==nck_1)
        fprintf('critical lists macth indeed !!!');
    else
        fprintf('critical lists do not macth');
    end
    
end
return;
end