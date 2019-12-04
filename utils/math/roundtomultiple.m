function x = roundtomultiple( x , m )
%roundtomultiple, rounds the first number to the closest number that is a
%multiple of the second input. Both inputs should be scalar.
%
% e.g.   x_rounded = roundtomultiple(x, multiple)
%
% Vectors/Matrices are also accepted

x = round(x./m).*m;

end

