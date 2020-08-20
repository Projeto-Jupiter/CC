function Cnalfa1=calculate_cnalfa1(M)
load('barrowaman.mat')
beta=sqrt( abs(1 - (M^2) ) ); % correction to compressible subsonic flow varialble (comes from Prandtl)
Cnalfa1 = ( 2 * pi * AR * (Af / Ar) ) / (2 + sqrt( 4 + ( (beta * AR / (cos(gamac)) )^2 ) ) );