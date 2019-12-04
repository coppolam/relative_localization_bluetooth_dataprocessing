function [ range ] = get_range( p1, p2)
%get_range Gets the range between two points in a global frame, works for
%arrays as well
% Inputs: points1 = [x y] point2 = [x y]. vectors are allowed
% Output: range
%
% Developed by Mario Coppola, October 2015

dim   = size(p1,2);
rm    = p1 - p2;
range = sqrt(sum(abs(rm).^2,dim));

end

