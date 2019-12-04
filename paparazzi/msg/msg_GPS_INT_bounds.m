function [bounds] = msg_GPS_INT_bounds()

bounds.time   = 1;
bounds.ID     = 2;
bounds.pos_xyz = [1:3]+2;
bounds.vel_xyz = [8:10]+2;

end