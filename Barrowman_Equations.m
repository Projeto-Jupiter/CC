run('scripts/Europa.m')
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
Cnalfat = Cnalfat * (1 + r0/(span + r0)); %interference factor

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
CndNi= (N * (c1 + c2 + c3))/(Ar * (Lr)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)

%--------------------------------------------------------------------------------
c1_canard = ((Cr+Ct) /  2) * (rt^2) * span;
c2_canard = ((Cr + 2*Ct)/3) * rt * (span^2);
c3_canard = ((Cr + 3*Ct)/12) * (span^3);
sweep_canard = (Cr_canard - Ct_canard); % calculating que sweep_canard distance
Af_canard = (Cr_canard + Ct_canard) * span_canard / 2; % fin area
AR_canard= 2 * (span_canard^2) / Af_canard; % Fin Aspect Ratio
gamac_canard = atan( (Cr_canard - Ct_canard) / (2 * span_canard) ); % mid chord angle
yparcial_canard = (Cr_canard + 2 * Ct_canard) / (Cr_canard + Ct_canard); %mean aerodynamic chord distance
Y_canard = rt + (span_canard/3) * yparcial_canard; %mean aerodynamic chord distance with the radius added
Lf_canard = sqrt((Cr_canard / 2 - Ct_canard / 2) ^ 2 + span_canard ^ 2); % Pre calculus. No Physical meaning

%XTB_canard = pos_canard - (sweep_canard / 3) * ( (Cr_canard + 2 * Ct_canard) / (Cr_canard + Ct_canard) ) + (1/6) * (Cr_canard + Ct_canard - Cr_canard * Ct_canard / (Cr_canard + Ct_canard)); % Fin's center of pressure
XTB_canard = x_cg;
Cnalfat_canard = ((4 * N_canard * (span_canard / Lr) ^ 2) / (1 + sqrt(1 + (2 * Lf_canard / (Cr_canard + Ct_canard)) ^ 2))) * (1 + rt / (span_canard + rt));
Cnalfat_canard = Cnalfat_canard * (1 + r0/(span_canard + r0)); %interference factor

Cnfdelta_canard = N_canard * Y_canard / span_canard; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
CndNi_canard= (N_canard * (c1_canard + c2_canard + c3_canard))/(Ar * (Lr)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)

save barrowaman.mat