function [ startpoints, endpoints, sptime_mode, eptime_mode ] = getnavstartpoints( xtime , msg_rotorcraft_status, mode)
%getnavstartpoints The localization scheme is reset every time a new flight
%starts. This helps detect these locations and separate the experiment

% Load the mode properties
statusbounds = msg_ROTORCRAFT_STATUS_bounds();
modelist     = paparazzi_ap_modes();

% Get time vector and mode vector from the status message
time         = cell2mat(msg_rotorcraft_status.content(:,statusbounds.time));
apmode       = cell2mat(msg_rotorcraft_status.content(:,statusbounds.ap_mode));

% Get start all start and end points
startpoints  = group_consecutive(find(apmode == modelist.(mode)),1,'first');
endpoints    = group_consecutive(find(apmode == modelist.(mode)),1,'last');

% Relate that back to the message that you want (since they might be sent
% at different frequencies, these may not necesserily be the same).
sptime_mode  = time(startpoints);
eptime_mode  = time(endpoints);

for i = 1:length(sptime_mode)
    startpoints(i) = find(xtime >= sptime_mode(i),1,'first');
    endpoints(i)   = find(xtime <  eptime_mode(i),1,'last');
end

% Display to know it's done
disp(['The experiment consisted of ', num2str(numel(endpoints)),...
    ' flights in ', mode, ' mode']);

end