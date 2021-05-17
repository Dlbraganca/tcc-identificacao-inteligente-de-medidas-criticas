function rep = s_n(msg, dft)
%Funcao para opcao sim ou nao
%function rep = s_n(msg, dft)
val = ['s' 'S' 'n' 'N'];
ent = false;
while ~ent 
    rep = input(msg, 's');
    if isempty(rep); 
        rep = dft;
        ent = true;
    elseif ismember(rep, val)
        ent = true;
    end
end