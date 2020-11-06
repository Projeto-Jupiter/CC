%Entrada de dados
Posicao_CM_completo = 1491/1000 ;
Posicao_CM_graos    =  1979.307/1000;
Posicao_aletas      =  2314.28/1000;
Posicao_nozzle      =  2426.849/1000;
Posicao_ogiva       =  0.274;

%Parâmetros de referência e condições de contorno
Lr = 80/1000; % comprimento de referência
Ar = pi * (Lr^2) / 4; % área de referênciap
        
%Parâmetros da ogiva
logiva = Posicao_ogiva; % comprimento da ogiva
r0 = 80 / 2000; % raio na ogiva
%Vb = 8.131/10^5; %volume da ogiva

%Parâmetros da fuselagem
rt = 80 / 2000; % raio na cauda
l0 = -Posicao_nozzle; % comprimento do foguete (agr ta em 2406mm)
x_cg = -Posicao_CM_completo; % posição do centro de massa medido da ogiva
Rs = 40/1000000; % Rugosidade RMC

%parâmetros das aletas
Cr = 0.058;
Ct = 0.018;
span = 0.077;
pos_aletas = -Posicao_aletas; % posição das aletas medido da ogiva
N = 3; % número de aletas
delta = 0; % valor de inclinação das aletas fixas

%Parâmetros da Cauda - Valetudo não tem cauda
h = 0 / 1000; % comprimento da cauda
r2 = 0 / 1000; % menor raio da cauda
pos_tail = 0 + h; % posição da cauda medida da ogiva

%V = Vb + (2 * pi * (rt^2) * l0) + ( (h * pi / 3) * (rt^2 + rt*r2 + r2^2)); % volume pro Cmalfa

%Entradas pro Simulink
m_propelente = 1.409;
mcarregado = 9666/1000;
mdescarregado = mcarregado - m_propelente;
MatrizDeInercia = [0.008 0 0; 0 4.031 0; 0 0 4.031];
MatrizDeInerciaDescarregado = [0.008 0 0; 0 3.7 0; 0 0 3.7];
F = readtable('../Data/Keron/thrustCurve.csv'); 
F_array = table2array(F);
F_input = F{:, 1};
F_data = F{:, 2};
% Mdot
MDot = readtable('../Data/Keron/mDot.csv');
MDot_array= table2array(MDot);
MDot_input = MDot{:, 1};
MDot_data = MDot{:, 2}; 
V_Exhaust = 1004.589;               % SOURCE: ROCKETPY CALCULATIONS

CD = readtable('../Data/powerOff_Valetudo.csv');
CD_array = table2array(CD);
CD_input = CD{:, 1};
CD_data = CD{:, 2};