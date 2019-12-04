function [ mode ] = paparazzi_ap_modes()
%paparazzi_modes Creates a structure for all paparazzi AutoPilot Modes to their
%corresponding number, so that they can be easily located in the data.
% The list of all IDs can be found in
% paparazzi/sw/airborne/firmwares/rotorcraft/autopilot.h
%
%
% #define AP_MODE_KILL              0
% #define AP_MODE_FAILSAFE          1
% #define AP_MODE_HOME              2
% #define AP_MODE_RATE_DIRECT       3
% #define AP_MODE_ATTITUDE_DIRECT   4
% #define AP_MODE_RATE_RC_CLIMB     5
% #define AP_MODE_ATTITUDE_RC_CLIMB 6
% #define AP_MODE_ATTITUDE_CLIMB    7
% #define AP_MODE_RATE_Z_HOLD       8
% #define AP_MODE_ATTITUDE_Z_HOLD   9
% #define AP_MODE_HOVER_DIRECT      10
% #define AP_MODE_HOVER_CLIMB       11
% #define AP_MODE_HOVER_Z_HOLD      12
% #define AP_MODE_NAV               13
% #define AP_MODE_RC_DIRECT         14  // Safety Pilot Direct Commands for helicopter direct control
% #define AP_MODE_CARE_FREE_DIRECT  15
% #define AP_MODE_FORWARD           16
% #define AP_MODE_MODULE            17
% #define AP_MODE_FLIP              18
% #define AP_MODE_GUIDED            19

mode.kill               = 0;
mode.failsafe           = 1;
mode.home               = 2;
mode.rate_direct        = 3;
mode.attitude_direct    = 4;
mode.rate_rc_climb      = 5;
mode.attitude_rc_climb  = 6;
mode.attitude_climb     = 7;
mode.rate_z_hold        = 8;
mode.attitude_z_hold    = 9;
mode.hover_direct       = 10;
mode.hover_climb        = 11;
mode.hover_z_hold       = 12;
mode.nav                = 13;
mode.rc_direct          = 14;
mode.care_free_direct   = 15;
mode.forward            = 16;
mode.module             = 17;
mode.flip               = 18;
mode.guided             = 19;

end