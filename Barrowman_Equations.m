%Entrada de dados
%Par�metros de refer�ncia e condi��es de contorno
Lr = 127/1000; % comprimento de refer�ncia
Ar = pi * (Lr^2) / 4; % �rea de refer�ncia
M = 0.5; % n�mero de mach
        
%Par�metros da ogiva
logiva = -558.29/1000; % comprimento da ogiva
r0 = 127 / 2000; % raio na ogiva
Vb = 0.004253; %volume da ogiva

%Par�metros da fuselagem
rt = 127 / 2000; % raio na cauda
l0 = -2.528; % comprimento do foguete (agr ta em 2406mm)
x_cg = -1.278; % posi��o do centro de massa medido da ogiva
Rs = 40/1000000; % Rugosidade RMC (em mm?)

%par�metros das aletas
Cr = 120 / 1000;
Ct = 40 / 1000;
span = 100 / 1000; 
pos_aletas = -2.367; % posi��o das aletas medido da ogiva
N = 4; % n�mero de aletas
delta = pi/60; % valor de inclina��o das aletas fixas

%Par�metros da Cauda
h = 60 / 1000; % comprimento da cauda
r2 = 43.5 / 1000; % menor raio da cauda
pos_tail = l0 + h; % posi��o da cauda medida do ogiva

V = Vb + (2 * pi * (rt^2) * l0) + ( (h * pi / 3) * (rt^2 + rt*r2 + r2^2)); % volume pro Cmalfa

%Entradas pro Simulink
%pho = 0.752; %� a densidade do ar; rever para o apogeu
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
%X1 = F(:,1);
%X2 = F(:,2);
CD = readtable('Data/Novo_CD.csv');
CD_array = table2array(CD);
CD_input = CD{:, 1};
CD_data = CD{:, 2};

%-------------------------------------------------------------------------------------------------------------------------------
%F�rmulas de suporte �s principais
%Par�mtros relacionado �s aletas
Af = (Cr + Ct) * span / 2; % fin area
%Aw = 2 * Af; % fin wetted area
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
beta=sqrt( abs(1 - (M^2) ) ); % correction to compressible subsonic flow varialble (comes from Prandtl)
Cf = 0.032 * ((Rs / Lr)^0.2);
Cfc = Cf * (1 - (0.09 * (M^2)) );
%q = (1/2) * pho * vo * vo % calculation for the dynamic pressure

Awb = 2 * pi * r0 * l0; % body wetted area
fb = l0 / (2 * rt); % total body fineness ratio

%par�metro para a cauda
r=rt/r2;

%pr� c�lculos para contas extensas
a1=((tau-lambda)/tau)-(((1-lambda)/(tau-1))*log(tau));
a2=(tau-1)*(tau+1)/2;
a3=(1-lambda)*((tau^3)-1)/(3*(tau-1));

b1=sqrt((span^2)-(rt^2));
b2=((Cr-Ct)/(2*span))-((4/AR)*((-1/4)*((1-lambda)/(1+lambda))));

c1 = ((Cr+Ct) /  2) * (rt^2) * span;
c2 = ((Cr + 2*Ct)/3) * rt * (span^2);
c3 = ((Cr + 3*Ct)/12) * (span^3);

%Coeficientes de corre��o para os lift detivatives
KTB = 1+( rt / (span + rt) ); % f�rmula oriunda do OpenRocket que coincide com o RocketPy
KBT=(((1-(1/(tau^2)))^2)/((1-(1/tau))^2))-KTB;
kTB=(1/(pi^2))*(((pi^4)/4)*(((tau+1)^2)/(tau^2))+(((pi*((tau^2)+1)^2)/((tau^2)*((tau-1)^2)))*asin(((tau^2)-1)/((tau^2)+1)))-((2*pi*(tau+1))/(tau*(tau+1)))+(((((tau^2)+1)^2)/((tau^2)*((tau-1)^2)))*((asin(((tau^2)-1)/((tau^2)+1)))^2))-(((4*(tau+1))/(tau*(tau-1)))*asin(((tau^2)-1)/((tau^2)+1)))+((8/((tau-1)^2))*log(((tau^2)+1)/(2^tau))));
KRB=1+(a1/(a2-a3)); 

%--------------------------------------------------------------------------------------------------------------------------------
%as equa��es em si
%derivatives para o CP
Cnalfa0 = 2 * pi / beta;
Cnalfa1 = ( 2 * pi * AR * (Af / Ar) ) / (2 + sqrt( 4 + ( (beta * AR / (cos(gamac)) )^2 ) ) );
Cnalfat = ((4 * N * (span / Lr) ^ 2) / (1 + sqrt(1 + (2 * Lf / (Cr + Ct)) ^ 2))) * (1 + rt / (span + rt));
Cntail= -2 * (1 - ((r2 / rt)^2));

Cnab = 2 * pi * (r0^2) / Ar; %CnaTB = Cnalfat * KTB;
%CnaBT = Cnalfat * KBT;
Cnalfa = (Cnab + Cnalfat + Cntail); % derivativo do coeficiente de for�a normal total
%centros de press�o (A f�rmula 2 do Opk ta divergindo do Brwmn)
XTB = pos_aletas - (sweep / 3) * ( (Cr + 2 * Ct) / (Cr + Ct) ) + (1/6) * (Cr + Ct - Cr * Ct / (Cr + Ct)); %centro de press�o das aletas
%XBT = pos_aletas + (Cr / 4) + (( b1 * acosh(span / rt) - span + (pi * rt /2)) / ((rt / b1) * acosh(span / rt) + (span / rt) - (pi / 2))) * b2;
%XB = logiva + (Vb / (2 * pi * r0^2) );
XB = logiva - logiva/2;
Xtail = pos_tail - (h/3) * (1 + ( (1 - r) / (1 - r^2) ) );
%C�lculo do centro de press�o total
x_ref = (XB * Cnab + XTB * Cnalfat + Xtail * Cntail) / Cnalfa;

Cnfdelta = N * Cnalfa1 * Y / span; % roll forcing moment coefficient derivative
Cndomega= (N * Cnalfa0 * Lr * (c1 + c2 + c3))/(Ar * span * (Lr)) ; %roll damping moment coefficient derivative (falta fazer: *omega*cos(delta)/v0)
%Os dois coeficientes acima foram renomeados para o nome ficar semelhante ? documenta??o do HL_20
