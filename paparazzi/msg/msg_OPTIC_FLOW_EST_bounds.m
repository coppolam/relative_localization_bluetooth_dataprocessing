function [bounds] = msg_OPTIC_FLOW_EST_bounds()

bounds.time   = 1;
bounds.ID     = 2; % these two are always there

bounds.velxy = 10:11;

end