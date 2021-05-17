function [g_sh,b_sh]= Yshunt(Barra, MVA_Base)

% Injeção líquida em cada barra, em pu
P_Inj = (Barra.ger_MW - Barra.carga_MW)./MVA_Base
Q_Inj = (Barra.ger_MVAR - Barra.carga_MVAR)./MVA_Base

% Valor da admitancia shunt, considerando a tensão de referência
Vm2 = Barra.tensao .^2
D2 = P_Inj .^2 + Q_Inj .^2

g_sh = D2 ./(P_Inj .* Vm2)

b_sh = D2 ./(Q_Inj .* Vm2)


