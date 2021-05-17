function [dSinj_dVa, dSinj_dVm, dIinj_dVa, dIinj_dVm] = dSinj_dV(Ybus, V)
% Calcula as derivada parciais das injeçoes nas barras
%function [dSinj_dVa, dSinj_dVm, dIinj_dVa, dIinj_dVm] = dSinj_dV(Ybus, V)

j = sqrt(-1);
nb = length(V);

% Calculo das correntes
Ibus = Ybus * V;

% Tensao normalizada
Vnorm = V./abs(V);

% Derivadas das injecoes de potencia
if issparse(Ybus)           %% Versao esparsa (se Ybus esparsa)
    diagV       = spdiags(V, 0, nb, nb);
    diagIbus    = spdiags(Ibus, 0, nb, nb);
    diagVnorm   = spdiags(Vnorm, 0, nb, nb);
else                        %% Versao densa
    diagV       = diag(V);
    diagIbus    = diag(Ibus);
    diagVnorm   = diag(Vnorm);
    
end
% Derivadas das injecoes de potencia
dSinj_dVa = j * diagV * conj(diagIbus - Ybus * diagV);
dSinj_dVm = diagV * conj(Ybus * diagVnorm) + conj(diagIbus) * diagVnorm;

% Derivadas das injecoes de corrente
dIinj_dVa = Ybus * j * diagV;
dIinj_dVm = Ybus * diagVnorm;
return;

%   Rotina derivada de:
%   DSBUS_DV   Computes partial derivatives of power injection w.r.t. voltage.
%   [dSbus_dVm, dSbus_dVa] = dSbus_dV(Ybus, V) returns two matrices containing
%   partial derivatives of the complex bus power injections w.r.t voltage
%   magnitude and voltage angle respectively (for all buses). If Ybus is a
%   sparse matrix, the return values will be also. The following explains
%   the expressions used to form the matrices:
%
%   S = diag(V) * conj(Ibus) = diag(conj(Ibus)) * V
%
%   Partials of V & Ibus w.r.t. voltage magnitudes
%       dV/dVm = diag(V./abs(V))
%       dI/dVm = Ybus * dV/dVm = Ybus * diag(V./abs(V))
%
%   Partials of V & Ibus w.r.t. voltage angles
%       dV/dVa = j * diag(V)
%       dI/dVa = Ybus * dV/dVa = Ybus * j * diag(V)
%
%   Partials of S w.r.t. voltage magnitudes
%       dS/dVm = diag(V) * conj(dI/dVm) + diag(conj(Ibus)) * dV/dVm
%              = diag(V) * conj(Ybus * diag(V./abs(V)))
%                                       + conj(diag(Ibus)) * diag(V./abs(V))
%
%   Partials of S w.r.t. voltage angles
%       dS/dVa = diag(V) * conj(dI/dVa) + diag(conj(Ibus)) * dV/dVa
%              = diag(V) * conj(Ybus * j * diag(V))
%                                       + conj(diag(Ibus)) * j * diag(V)
%              = -j * diag(V) * conj(Ybus * diag(V))
%                                       + conj(diag(Ibus)) * j * diag(V)
%              = j * diag(V) * conj(diag(Ibus) - Ybus * diag(V))
%
%
%   MATPOWER
%   $Id: dSbus_dV.m,v 1.4 2004/08/23 20:56:14 ray Exp $
%   by Ray Zimmerman, PSERC Cornell
%   Copyright (c) 1996-2004 by Power System Engineering Research Center (PSERC)
%   See http://www.pserc.cornell.edu/matpower/ for more info.

