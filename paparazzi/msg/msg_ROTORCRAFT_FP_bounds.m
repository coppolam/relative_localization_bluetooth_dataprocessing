function [bounds,factor] = msg_ROTORCRAFT_FP_bounds()
% Position scaling 0.0039063
% Velocity scaling 0.0000019
% Attitude scaling 0.0139882

bounds.time   = 1;
bounds.ID     = 2;
bounds.pos_xy = 3:4;
bounds.vel_xy = 6:7;
bounds.psi = 11;
bounds.z = 5;
bounds.pos = 3:5;
bounds.vel = 6:8;
bounds.att = 9:11;

bounds.gt     = [3,4,6,7,11,5];

factor.position = 0.0039063;
factor.velocity = 0.0000019;
factor.attitude = 0.0139882;

end