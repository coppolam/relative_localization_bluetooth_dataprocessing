function [ A, B ,a ] = GetDistributionParameters( disttype, bb)
%GetDistributionParameters Extracts the Distribution parameters calculated
%with fitdist as two outputs A and B. This is to deal with different noise
%distributions without going too crazy every time.
% Inputs: Distribution type (string) to be used with fitdist, data
% vector
% Output: Distribution parameters, changes depending on distribution
% For 'lognormal': mu, sigma
% For 'gamma': A, B
% For 'nakagami': mu, omega
% For 'weibull' or 'wbl': A, B
% For 'poisson': lambda, []
% For 'normal': mu, sigma
% For 'beta': a, b
% For 'binomial': N, p
% For 'exponential': mu, []
%
% The third output is the actual output from fitdist, which can be useful
%
% Developed by Mario Coppola, November 2015

a = fitdist(bb,disttype);

if strcmp(disttype,'lognormal')
    A = a.mu;
    B = a.sigma;
elseif strcmp(disttype,'gamma')
    A = a.a;
    B = a.b;
elseif strcmp(disttype,'nakagami')
    A = a.mu;
    B = a.omega;
elseif strcmp(disttype,'weibull') || strcmp(disttype,'wbl')
    A = a.A;
    B = a.B;
elseif strcmp(disttype,'poisson')
    A = a.lambda;
    B = [];
elseif strcmp(disttype,'normal')
    A = a.mu;
    B = a.sigma;
elseif strcmp(disttype,'beta')
    A = a.a;
    B = a.b;
elseif strcmp(disttype,'binomial')
    A = a.N;
    B = a.p;
elseif strcmp(disttype,'exponential')
    A = a.mu;
    B = [];
end

end