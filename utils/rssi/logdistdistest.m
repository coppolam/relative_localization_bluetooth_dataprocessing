function [ distest ] = logdistdistest( Pn, gammal, RSSI )

    power    = Pn - RSSI;
    distest  = 10.^((power)/(10*gammal));

end

