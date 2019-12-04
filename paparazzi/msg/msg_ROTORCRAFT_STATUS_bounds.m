function [bounds] = msg_ROTORCRAFT_STATUS_bounds()

bounds.time             = 1;
bounds.ID               = 2;

bounds.link_imu_nb_err  = 3;
bounds.motor_nb_error   = 4;
bounds.rc_status        = 5;

bounds.frame_rate       = 6;
bounds.gps_status       = 7;
bounds.ap_mode          = 8;

bounds.ap_in_flight     = 9;
bounds.ap_motors_on     = 10;
bounds.ap_h_mode        = 11;
bounds.ap_v_mode        = 12;
bounds.ap_vsupply       = 13;
bounds.ap_cpu_time      = 14;

end