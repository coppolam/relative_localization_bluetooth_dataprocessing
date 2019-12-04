function [ L ] = logdistdB( Pn, gamma_l, d )
%logdistdB calculates the power loss according to the log-distance model in
%dB

L = Pn - 10*gamma_l.*log10(d);

end

