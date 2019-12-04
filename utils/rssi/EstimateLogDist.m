function [P_complete ] = EstimateLogDist(RSSI, dist)
%EstimateLobes Estimates the lobes of the antenna
% Heading related model parameters

P = zeros(1,2);

Aeq = [];
Beq = [];
lb = [-100, 0];
ub = [1, 3];

fMinConOpts = optimoptions('fmincon','Display','off','MaxFunEvals',10000);

errFun = @(P)errFunlogdist(P, RSSI, dist);
P_complete = fmincon(errFun, P,[],[], Aeq, Beq, lb, ub, [], fMinConOpts);

end

