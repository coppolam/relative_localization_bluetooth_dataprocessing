function [ x, err ] = leastsquarefit(A, y, W)
%leastsquarefit Gets the least square fit for linear function y = Ax,
%where:
%   A is a matrix of known values
%   x is a vector of function coefficients to be found
%   
% Inputs: [A, y, W (options)]
% W is the weight vector for weighted least squares (default = identity matrix)
%
% Outputs: [x, err]
%          x = ((A'*A)\(A'))*y
%          err = y - A*x
%
% Developed by Mario Coppola, January 2016

[A, y] = makevertical(A, y);

if nargin < 3;
    W = eye(length(y));
end

x = ((A'*W*A)\(A'*W))*y;

err = y - A*x;

end