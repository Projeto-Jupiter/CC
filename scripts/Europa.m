%Entrada de dados
%Parâmetros de referência e condições de contorno
Lr = 127/1000; % comprimento de referência
Ar = pi * (Lr^2) / 4; % área de referênciap
        
%Parâmetros da ogiva
logiva = -558.29/1000; % comprimento da ogiva
r0 = 127 / 2000; % raio na ogiva
Vb = 0.004253; %volume da ogiva

%Parâmetros da fuselagem
rt = 127 / 2000; % raio na cauda
l0 = -2.528; % comprimento do foguete (agr ta em 2406mm)
x_cg = -1.278; % posição do centro de massa medido da ogiva
Rs = 40/1000000; % Rugosidade RMC

%parâmetros das aletas
Cr = 120 / 1000;
Ct = 40 / 1000;
span = 100 / 1000; 
pos_aletas = -2.367; % posição das aletas medido da ogiva
N = 4; % número de aletas
delta = 0; % valor de inclinação das aletas fixas

%Parâmetros da Cauda
h = 60 / 1000; % comprimento da cauda
r2 = 43.5 / 1000; % menor raio da cauda
pos_tail = l0 + h; % posição da cauda medida da ogiva

V = Vb + (2 * pi * (rt^2) * l0) + ( (h * pi / 3) * (rt^2 + rt*r2 + r2^2)); % volume pro Cmalfa

%Entradas pro Simulink
mcarregado = 18.48;
mdescarregado = 15.576;
MatrizDeInercia = [0.03616 0 0; 0 8.458 0; 0 0 8.457];
MatrizDeInerciaDescarregado = [0.034 0 0; 0 6.839 0; 0 0 6.838];
F = readtable('../Data/Comercial/Pro75M3100_saida_do_trilho.csv'); 
F_array = table2array(F);
F_input = F{:, 1};
F_data = F{:, 2};
% Mdot
MDot = readtable('../Data/Comercial/cesaroni_wt_mdot.csv');
MDot_array= table2array(MDot);
MDot_input = MDot{:, 1};
MDot_data = MDot{:, 2};

CD = readtable('../Data/Novo_CD.csv');
CD_array = table2array(CD);
CD_input = CD{:, 1};
CD_data = CD{:, 2};