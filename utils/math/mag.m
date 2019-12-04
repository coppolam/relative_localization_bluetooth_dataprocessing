function [ magnitude ] = mag( x , mode)
%mag Takes the magnitude of a vector
%
% Use: [magnitude] = mag(x)
% e.g. if x = [2, 4]
% then magnitude = sqrt(2^2 + 4^2)
%
% Mario Coppola, November 2015

if strcmp(mode,'col')
    f = diag(x'*x);
elseif strcmp(mode,'row')
    f = diag(x*x');
else
    error('Improper mode, specify col or row');
end

magnitude = sqrt(f);

end

