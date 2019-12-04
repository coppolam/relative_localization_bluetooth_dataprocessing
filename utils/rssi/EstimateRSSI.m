function [ RSSIest ] = EstimateRSSI(P_basic, P_lobes, dist, bearing, phi)
%EstimateRSSI Estimates the RSSI with the model identified for a
%combination of distance and bearing vectors.

FSL = logdistdB(P_basic(1), P_basic(2), dist);

if nargin < 4
    HG = 0;
else
    if size(P_lobes,1) == 1
        HG = G_ang(P_lobes, bearing);
    elseif size(P_lobes,1) == 2
        HG = G_ang(P_lobes, bearing, phi);
    else
        HG = 0;
    end
end

% keyboard
RSSIest = FSL + HG;

end