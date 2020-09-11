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
F = readtable('Data/Comercial/Pro75M3100_saida_do_trilho.csv'); 
F_array = table2array(F);
F_input = F{:, 1};
F_data = F{:, 2};
% Mdot
MDot = readtable('Data/Comercial/cesaroni_wt_mdot.csv');
MDot_array= table2array(MDot);
MDot_input = MDot{:, 1};
MDot_data = MDot{:, 2};

CD = readtable('Data/Novo_CD.csv');
CD_array = table2array(CD);
CD_input = CD{:, 1};
CD_data = CD{:, 2};

%-------------------------------------------------------------------------------------------------------------------------------
%Fórmulas de suporte às principais
%Parâmtros relacionado às aletas
Af = (Cr + Ct) * span / 2; % fin area

lambda = Ct / Cr; % Cr and Ct proportion
tau = (( span + Ct ) / Ct);
sweep = (Cr - Ct); % calculating que sweep distance
AR= 2 * (span^2) / Af; % Fin Aspect Ratio
Fmc = sqrt( ( ((Cr - Ct) / 2) ^2) + span^2); % Fin mid chord position
yparcial = (Cr + 2 * Ct) / (Cr + Ct); %mean aerodynamic chord distance
Y = rt + (span/3) * yparcial; %mean aerodynamic chord distance with the radius added
gamac = atan( (Cr - Ct) / (2 * span) ); % mid chord angle
Lf = sqrt((Cr / 2 - Ct / 2) ^ 2 + span ^ 2); % pre calculus. No Physical meaning

% auxiliar aerodinamic coefficients
Cf = 0.032 * ((Rs / Lr)^0.2);

Awb = 2 * pi * r0 * l0; % body wetted area
fb = l0 / (2 * rt); % total body fineness ratio

%parâmetro para a cauda
r=rt/r2;

%pré cálculos para contas extensas
a1=((tau-lambda)/tau)-(((1-lambda)/(tau-1))*log(tau));
a2=(tau-1)*(tau+1)/2;
a3=(1-lambda)*((tau^3)-1)/(3*(tau-1));

b1=sqrt((span^2)-(rt^2));
b2=((Cr-Ct)/(2*span))-((4/AR)*((-1/4)*((1-lambda)/(1+lambda))));

c1 = ((Cr+Ct) /  2) * (rt^2) * span;
c2 = ((Cr + 2*Ct)/3) * rt * (span^2);
c3 = ((Cr + 3*Ct)/12) * (span^3);

%Coeficientes de correção para os lift detivatives
KTB = 1+( rt / (span + rt) ); % fórmula oriunda do OpenRocket que coincide com o RocketPy
KBT=( ( (1- (1/(tau^2)) )^2)  /  ( (1- (1/tau))^2) )-KTB;
kTB=(1/ (pi^2) ) * ( ( (pi^4)/4) * ( ((tau+1)^2)/(tau^2) ) + ( ( (pi*((tau^2)+1)^2) / ((tau^2)*((tau-1)^2)) )*asin(((tau^2)-1)/((tau^2)+1)))-((2*pi*(tau+1))/(tau*(tau+1)))+(((((tau^2)+1)^2)/((tau^2)*((tau-1)^2)))*((asin(((tau^2)-1)/((tau^2)+1)))^2))-(((4*(tau+1))/(tau*(tau-1)))*asin(((tau^2)-1)/((tau^2)+1)))+((8/((tau-1)^2))*log(((tau^2)+1)/(2^tau))));
KRB=1+(a1/(a2-a3)); 

%--------------------------------------------------------------------------------------------------------------------------------
%as equações em si
%derivatives para o CP
Cnalfat = ((4 * N * (span / Lr) ^ 2) / (1 + sqrt(1 + (2 * Lf / (Cr + Ct)) ^ 2))) * (1 + rt / (span + rt));
CnTail= -2 * (1 - ((r2 / rt)^2));

CnAlfaNose = 2 * pi * (r0^2) / Ar; %CnaTB = Cnalfat * KTB;

Cnalfa = (CnAlfaNose + Cnalfat + CnTail); % derivativo do coeficiente de força normal total

XTB = pos_aletas - (sweep / 3) * ( (Cr + 2 * Ct) / (Cr + Ct) ) + (1/6) * (Cr + Ct - Cr * Ct / (Cr + Ct)); %centro de pressão das aletas

XB = logiva - logiva/2;
Xtail = pos_tail - (h/3) * (1 + ( (1 - r) / (1 - r^2) ) );
%Cálculo do centro de pressão total
x_ref = (XB * CnAlfaNose + XTB * Cnalfat + Xtail * CnTail) / Cnalfa;

Cnfdelta = N * Y / span; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
Cndomega= (N * (c1 + c2 + c3))/(Ar * span * (Lr)) ; %roll damping moment coefficient derivative (falta fazer: *omega*cos(delta)/v0)
%Os dois coeficientes acima foram renomeados para o nome ficar semelhante ? documenta??o do HL_20
save barrowaman.mat