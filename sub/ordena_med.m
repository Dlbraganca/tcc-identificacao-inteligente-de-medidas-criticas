function [medidores] = ordena_med(medidores)
% Ordena os medidores por tipo
% function [medidores] = ordena_med(medidores)

% Ordem:
% - Medidas de angulo:                      tipo 3
% - Medidas de fluxo de potencia ativa:     tipo 1
% - Medidas de injecao de potencia ativa:   tipo 2
% - Medidas de corrente de ramo real        tipo 7
% - Medidas de injecao de corrente real     tipo 9
% - Medidas de tensao:                      tipo 6
% - Medidas de fluxo de potencia reativa:   tipo 4
% - Medidas de injecao de potencia reativa: tipo 5
% - Medidas de corrente de ramo imag        tipo 8
% - Medidas de injecao de corrente imag     tipo 10

 NMed = length(medidores.num);
 ORD = 0;
 for i = 1 : NMed
     if medidores.tipo(i) == 3
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
 end
  for i = 1 : NMed
     if medidores.tipo(i) == 1
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 2
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 7
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 9
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 6
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 4
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 5
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 8
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
  for i = 1 : NMed
     if medidores.tipo(i) == 10
         ORD = ORD + 1;
         temp.num(ORD) = ORD;
         temp.de(ORD) = medidores.de(i);
         temp.para(ORD) = medidores.para(i);
         temp.circ(ORD) = medidores.circ(i);
         temp.tipo(ORD) = medidores.tipo(i);
         temp. PMU_num(ORD) = medidores.PMU_num(i);
         temp.ok(ORD) = medidores.ok(i);
         temp.acc(ORD) = medidores.acc(i);
         temp.fs(ORD) = medidores.fs(i);
         temp.dp(ORD) = medidores.dp(i);
         temp.ref(ORD) = medidores.ref(i);
         temp.leitura(ORD) = medidores.leitura(i);
     end
  end
 for i = 1 : NMed
     medidores.num(i) = temp.num(i);
     medidores.de(i) = temp.de(i);
     medidores.para(i) = temp.para(i);
     medidores.circ(i) = temp.circ(i);
     medidores.tipo(i) = temp.tipo(i);
     medidores.PMU_num(i) = temp.PMU_num(i);
     medidores.ok(i) = temp.ok(i);
     medidores.acc(i) = temp.acc(i);
     medidores.fs(i) = temp.fs(i);
     medidores.dp(i) = temp.dp(i);
     medidores.ref(i) = temp.ref(i);
     medidores.leitura(i) = temp.leitura(i);
 end
return