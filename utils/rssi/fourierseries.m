function [ out ] = fourierseries( x, weights, a0)
%fourierseries out = fourierseries (weights, phases, angles, a0 (optional)).
%
% weights ans phases must be arrays with the same length.
% angles may be a matrix with width being the same as the angles.
%
% f(x) = (1/2 a_0) + sum{a_n*cos(nx)} + sum{b_n*cos(nx)}, 

if is_even(length(weights)) == 0
    error('An must equal Bn, so weights length must be even')
end

an = weights(1:length(weights)/2);
bn = weights(length(weights)/2+1:end);

f = makevertical(x)*(1:length(weights)/2);

out = sin(f)*makevertical(an) + cos(f)*makevertical(bn);

if nargin > 2
    out = out + a0;
end

end

