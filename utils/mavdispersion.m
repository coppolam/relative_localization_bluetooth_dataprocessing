function [ D ] = mavdispersion( M, radius, dmat )
%mavdispersion calculates the mean dispersion of the mavs
% dmat is a matrix with columns of distances to other robots, one column is
% all zeros, denoting the MAV in question;

d_mean = sum(dmat,2)/factorial(M);

D = d_mean/radius;

end