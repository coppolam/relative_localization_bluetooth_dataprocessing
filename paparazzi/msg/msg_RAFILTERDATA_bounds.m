function [bounds] = msg_RAFILTERDATA_bounds()

% 6,7: x, y
% 8,9: vx, vy
% 10,11: vx_other, vy_other
% 12, 13: psi_own, psi_other
% 14: z

bounds.time  = 1;
bounds.ID    = 2;
bounds.IDoth = 3;
bounds.rssi  = 4;
bounds.sstr  = 5;
bounds.x     = 6:14;
bounds.vcmd  = 15:16;

% Convert from NED to ENU (flip x y and reverse z)
bounds.x_glob = [7 6, 9 8, 11 10];

end