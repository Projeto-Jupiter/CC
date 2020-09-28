%-------------------------------------------------------------------------------------------------------------------------------
%Support formulations to further use
%Fin-related parameters
sweep = (Cr - Ct); % calculating que sweep distance
Af = (Cr + Ct) * span / 2; % fin area
AR= 2 * (span^2) / Af; % Fin Aspect Ratio
gamac = atan( (Cr - Ct) / (2 * span) ); % mid chord angle
yparcial = (Cr + 2 * Ct) / (Cr + Ct); %mean aerodynamic chord distance
Y = rt + (span/3) * yparcial; %mean aerodynamic chord distance with the radius added
Lf = sqrt((Cr / 2 - Ct / 2) ^ 2 + span ^ 2); % Pre calculus. No Physical meaning

% Pre calculus for extense calculations
c1 = ((Cr+Ct) /  2) * (rt^2) * span;
c2 = ((Cr + 2*Ct)/3) * rt * (span^2);
c3 = ((Cr + 3*Ct)/12) * (span^3);

%--------------------------------------------------------------------------------------------------------------------------------
% The Barrowman Equations
% Center of pressure derivatives calculations
CnAlfaNose = 2 * pi * (r0^2) / Ar;

CnalfaBody = 2.2 * lTubo; % As the reference area is equal to the diameter, 
%both terms were removed to accelerate calculations

Cnalfat = ((4 * N * (span / Lr) ^ 2) / (1 + sqrt(1 + (2 * Lf / (Cr + Ct)) ^ 2))) * (1 + rt / (span + rt));

%Condition for rockets withot tail; and tail center od pressure
%calculations
if r2 ~= 0
    r=rt/r2;
    Xtail = pos_tail - (h/3) * (1 + ( (1 - r) / (1 - r^2) ) );
    CnAlfaTail= -2 * (1 - ((r2 / rt)^2));
else
    r = 0;
    Xtail = 0;
    CnAlfaTail = 0;
end

Cnalfa = (CnAlfaNose + Cnalfat + CnAlfaTail); % Total normal force derivative

XTB = pos_aletas - (sweep / 3) * ( (Cr + 2 * Ct) / (Cr + Ct) ) + (1/6) * (Cr + Ct - Cr * Ct / (Cr + Ct)); % Fin's center of pressure

XB = -(logiva - logiva/2); % Nosecone center of pressure

% Total center of pressure
x_ref = (XB * CnAlfaNose + XTB * Cnalfat + Xtail * CnAlfaTail) / Cnalfa;

Cnfdelta = N * Y / span; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
Cndomega= (N * (c1 + c2 + c3))/(Ar * span * (Lr)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)

save barrowaman.mat