function [dSfd_dVa, dSfd_dVm, dSfp_dVa, dSfp_dVm, dId_dVa, dId_dVm, dIp_dVa, dIp_dVm] = dSf_dV(Yd, Yp, d, p, V)
% Calcula as derivada parciais dos fluxos e correntes nos ramos
%function [dSfd_dVa, dSfd_dVm, dSfp_dVa, dSfp_dVm,dId_dVa, dId_dVm, dIp_dVa, dIp_dVm] = dSf_dV(Yd, Yp, d, p, V)
% Yd - Matriz para calculo das corrente DE
% Yp - Matriz para calculo das corrente PARA
% d  - Lista das barras DE dos ramos
% p  - Lista das barras PARA dos ramos
% V  - Tensao das barras (Complexo)
j = sqrt(-1);

nb = length(V);
nl = length(d);

% Calculo das correntes
Id = Yd * V;
Ip = Yp * V;

% Tensao normalizada
Vnorm = V./abs(V);


if issparse(Yd)             %% Versao esparsa (se Yd esparsa)
    diagVd      = spdiags(V(d), 0, nl, nl);
    diagId      = spdiags(Id, 0, nl, nl);
    diagVp      = spdiags(V(p), 0, nl, nl);
    diagIp      = spdiags(Ip, 0, nl, nl);
    diagV       = spdiags(V, 0, nb, nb);
    diagVnorm   = spdiags(Vnorm, 0, nb, nb);
    % Derivadas dos fluxos nos ramos
    dSfd_dVa = j * (conj(diagId) * sparse(1:nl, d, V(d), nl, nb) - diagVd * conj(Yd * diagV));
    dSfd_dVm = diagVd * conj(Yd * diagVnorm) + conj(diagId) * sparse(1:nl, d, Vnorm(d), nl, nb);
    dSfp_dVa = j * (conj(diagIp) * sparse(1:nl, p, V(p), nl, nb) - diagVp * conj(Yp * diagV));
    dSfp_dVm = diagVp * conj(Yp * diagVnorm) + conj(diagIp) * sparse(1:nl, p, Vnorm(p), nl, nb);
    % Derivadas das correntes nos ramos
    dId_dVa = Yd * j * diagV;
    dId_dVm = Yd * diagVnorm;
    dIp_dVa = Yp * j * diagV; 
    dIp_dVm = Yp * diagVnorm;
else                        %% Versao densa
    diagVd      = diag(V(d));
    diagId      = diag(Id);
    diagVp      = diag(V(p));
    diagIp      = diag(Ip);
    diagV       = diag(V);
    diagVnorm   = diag(Vnorm);
    
    temp1       = zeros(nl, nb);    temp1(sub2ind([nl,nb],(1:nl)', d)) = V(d);
    temp2       = zeros(nl, nb);    temp2(sub2ind([nl,nb],(1:nl)', d)) = Vnorm(d);
    temp3       = zeros(nl, nb);    temp3(sub2ind([nl,nb],(1:nl)', p)) = V(p);
    temp4       = zeros(nl, nb);    temp4(sub2ind([nl,nb],(1:nl)', p)) = Vnorm(p);
    % Derivadas dos fluxos nos ramos
    dSfd_dVa = j * (conj(diagId) * temp1 - diagVd * conj(Yd * diagV));
    dSfd_dVm = diagVd * conj(Yd * diagVnorm) + conj(diagId) * temp2;
    dSfp_dVa = j * (conj(diagIp) * temp3 - diagVp * conj(Yp * diagV));
    dSfp_dVm = diagVp * conj(Yp * diagVnorm) + conj(diagIp) * temp4;
    % Derivadas das correntes nos ramos
    dId_dVa = Yd * j * diagV;
    dId_dVm = Yd * diagVnorm;
    dIp_dVa = Yp * j * diagV; 
    dIp_dVm = Yp * diagVnorm;
end

return;
%
%   Rotina derivada de:
%   DSBR_DV   Computes partial derivatives of power flows w.r.t. voltage.
%   [dSf_dVa, dSf_dVm, dSt_dVa, dSt_dVm, Sf, St] = dSbr_dV(branch, Yf, Yt, V)
%   returns four matrices containing partial derivatives of the complex
%   branch power flows at "from" and "to" ends of each branch w.r.t voltage
%   magnitude and voltage angle respectively (for all buses). If Yf is a
%   sparse matrix, the partial derivative matrices will be as well. Optionally
%   returns vectors containing the power flows themselves. The following
%   explains the expressions used to form the matrices:
%
%   If = Yf * V;
%   Sf = diag(Vf) * conj(If) = diag(conj(If)) * Vf
%
%   Partials of V, Vf & If w.r.t. voltage angles
%       dV/dVa  = j * diag(V)
%       dVf/dVa = sparse(1:nl, f, j * V(f)) = j * sparse(1:nl, f, V(f))
%       dIf/dVa = Yf * dV/dVa = Yf * j * diag(V)
%
%   Partials of V, Vf & If w.r.t. voltage magnitudes
%       dV/dVm  = diag(V./abs(V))
%       dVf/dVm = sparse(1:nl, f, V(f)./abs(V(f))
%       dIf/dVm = Yf * dV/dVm = Yf * diag(V./abs(V))
%
%   Partials of Sf w.r.t. voltage angles
%       dSf/dVa = diag(Vf) * conj(dIf/dVa)              + diag(conj(If)) * dVf/dVa
%               = diag(Vf) * conj(Yf * j * diag(V))     + conj(diag(If)) * j * sparse(1:nl, f, V(f))
%               = -j * diag(Vf) * conj(Yf * diag(V))    + j * conj(diag(If)) * sparse(1:nl, f, V(f))
%               = j * (conj(diag(If)) * sparse(1:nl, f, V(f)) - diag(Vf) * conj(Yf * diag(V)))
%
%   Partials of Sf w.r.t. voltage magnitudes
%       dSf/dVm = diag(Vf) * conj(dIf/dVm)              + diag(conj(If)) * dVf/dVm
%               = diag(Vf) * conj(Yf * diag(V./abs(V))) + conj(diag(If)) * sparse(1:nl, f, V(f)./abs(V(f)))
%
%   Derivations for "to" bus are similar.
%
%   MATPOWER
%   $Id: dSbr_dV.m,v 1.5 2004/08/23 20:56:13 ray Exp $
%   by Ray Zimmerman, PSERC Cornell
%   Copyright (c) 1996-2004 by Power System Engineering Research Center (PSERC)
%   See http://www.pserc.cornell.edu/matpower/ for more info.
