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
if r2 ~= 0
    r=rt/r2;
    Xtail = pos_tail - (h/3) * (1 + ( (1 - r) / (1 - r^2) ) );
    CnTail= -2 * (1 - ((r2 / rt)^2));
else
    r = 0;
    Xtail = 0;
    CnTail = 0;
end

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

CnAlfaNose = 2 * pi * (r0^2) / Ar; %CnaTB = Cnalfat * KTB;

Cnalfa = (CnAlfaNose + Cnalfat + CnTail); % derivativo do coeficiente de força normal total

XTB = pos_aletas - (sweep / 3) * ( (Cr + 2 * Ct) / (Cr + Ct) ) + (1/6) * (Cr + Ct - Cr * Ct / (Cr + Ct)); %centro de pressão das aletas

XB = -(logiva - logiva/2);
%Cálculo do centro de pressão total
x_ref = (XB * CnAlfaNose + XTB * Cnalfat + Xtail * CnTail) / Cnalfa;

Cnfdelta = N * Y / span; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
Cndomega= (N * (c1 + c2 + c3))/(Ar * span * (Lr)) ; %roll damping moment coefficient derivative (falta fazer: *omega*cos(delta)/v0)
%Os dois coeficientes acima foram renomeados para o nome ficar semelhante ? documenta??o do HL_20
save barrowaman.mat