function [Ybus, Yd, Yp] = Ybarra(Barra, Ramo)
% Monta YBus
nb = length(Barra.num);                        %% Numero de barras
nl = length(Ramo.num);                         %% Numero de ramos

% Para cada ramo, calcula os elementos da matriz de admitancia do ramo
%
%      | Id |   | Ydd  Ydp |   | Vd |
%      |    | = |          | * |    |
%      | Ip |   | Ypd  Ypp |   | Vp |

% Linhas
Ys = Ramo.status ./ (Ramo.r + j * Ramo.x);      % Admitancia serie do ramo
Bc = Ramo.status .* Ramo.b;                     % Susceptancia shunt do ramo

% Transformadores com tape variavel e defasadores 
tap = ones(nl, 1);                              % Tapes de todos os ramos = 1 (default)
i = find(Ramo.rel_tr);                          % Indice dos ramos com tape nao zero
tap(i) = Ramo.rel_tr(i);                        % Inclui os valores dos tapes nao zero
tap = tap .* exp(j*pi/180 * Ramo.ang_tr);       % Acrescenta a defasagem angular

% Formulacao generica do ramo PI
Ypp = Ys + j*Bc/2;
Ydd = Ypp ./ (tap .* conj(tap));
Ydp = - Ys ./ conj(tap);
Ypd = - Ys ./ tap;

% Admitancia shunt da Barra
% Considera:
%      Pshunt a potencia ativa consumida pelo shunt com V = 1.0 p.u.
%      Qshunt a potencia reativa injetada pelo shunt com V = 1.0 p.u.
%      Entao:
%          Pshunt - j Qshunt = V * conj(Ysh * V) = conj(Ysh) = Gs - j Bs,
%          Com Ysh = Pshunt + j Qshunt
%
Ysh = (Barra.g + j * Barra.b);                  % Vetor das admitancias shunt

d = Ramo.de;
p = Ramo.para;

% Monta a matriz Ybus esparsa
Cd = sparse(d, 1:nl, ones(nl, 1), nb, nl);      % Matriz de conexao para linhas e barras DE
Cp = sparse(p, 1:nl, ones(nl, 1), nb, nl);      % Matriz de conexao para linhas e barras PARA
Ybus = spdiags(Ysh, 0, nb, nb) + ...            % Monta a diagonal com o vetor de admitancias shunt 
  Cd * spdiags(Ydd, 0, nl, nl) * Cd' + ...      % Inclui o termo Ydd das admitancias dos ramos
  Cd * spdiags(Ydp, 0, nl, nl) * Cp' + ...      % Inclui o termo Ydp das admitancias dos ramos
  Cp * spdiags(Ypd, 0, nl, nl) * Cd' + ...      % Inclui o termo Ypd das admitancias dos ramos
  Cp * spdiags(Ypp, 0, nl, nl) * Cp';           % Inclui o termo Ypp das admitancias dos ramos

% Constroi Yd and Yp tal que Yd*V eh o vetor das correntes de ramo
% injetadas nas barras DE do ramo e Yp eh o mesmo para a barra PARA
if nargout > 1
    i = [(1:nl)'; (1:nl)'];         
    Yd = sparse(i, [d; p], [Ydd; Ydp], nl, nb);
    Yp = sparse(i, [d; p], [Ypd; Ypp], nl, nb);
end
% save Yd; save Yp; save d; save p; save Ybus; save V;
return;
