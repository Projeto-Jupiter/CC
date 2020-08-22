function [compLiftYB, compLiftZB]  = calculate_attack_angle(input)
load('barrowaman.mat')

compV = [input(1) input(2) input(3)];
compWindV = [input(4) input(5) input(6)];
rho = input(7);

compStreamV = compWindV - compV;
compStreamSpeed = sqrt(compStreamV(1)^2 + compStreamV(2)^2 + compStreamV(3)^2);
compStreamVn = compStreamV(3) / compStreamSpeed;
attack_angle = acos(-compStreamVn);
compLift = (0.5 * rho * (compStreamSpeed ^ 2) * Ar * Cnalfa * attack_angle);

liftDirNorm = (compStreamV(3) ^ 2 + compStreamV(2) ^ 2) ^ 0.5;
compLiftZB = compLift * (compStreamV(3) / liftDirNorm);
compLiftYB = compLift * (compStreamV(2) / liftDirNorm);