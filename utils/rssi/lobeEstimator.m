function [P ] = lobeEstimator(RSSI, bearing, psi, order, phi, k)
%EstimateLobes Estimates the lobes of the antenna

P1 = ones(1,order);
P  = [P1 P1 0];

% rH1    = bearing;                   % The relative heading is the relative bearing + the absolute heading of the eigenantenna
% rH2    = bearing + psi;             % The relative heading is the relative bearing + the absolute heading of the drone;

% ub =  5*ones(1,length(P)); % Bounds of optimization values
% lb = -5*ones(1,length(P));

% fMinConOpts = optimoptions('fmincon','Display','iter-detailed','MaxFunEvals',10000); %'Display','off'
% 
% if nargin > 4
%     rP1  = phi;
%     rP2  = -phi;
%     P    = [P; P];
%     efunc = @(P)errFun_ang(P, RSSI, rH1, rH2, rP1, rP2);
% elseif nargin == 4
%     efunc = @(P)errFun_ang(P, RSSI, rH1, rH2);
% end
% 
% P = fmincon(efunc, P, [], [], [], [], lb, ub, [], fMinConOpts);

f = makevertical(bearing)*(1:length(P1));
W = eye(length(RSSI));
A = [sin(f) cos(f) ones(size(bearing))];    
P = leastsquarefit(A, RSSI, W);
P = makevertical(P)';

end