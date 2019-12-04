function [ e ] = errFunlogdist(P, RSSI, D)

    RSSI_est = P(1) - 10*P(2)*log10(D);
    
    e = sqrt(mean((RSSI - RSSI_est).^2)); %Root Mean Square
    
end