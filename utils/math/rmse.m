function [ rmse ] = rmse(vreal,vest)
%rmse Calculates the root mean squared error, provided a vector of "real"
%quantities and a vector of estimated quantities
% Inputs: Real value (vector), estimated value (vector)
%             OR
%           Directly just give one error vector
% Ouput:  Root Mean Squared Error
%
% Developed by Mario Coppola, October 2015

if nargin > 1
    errvec = vreal-vest;
    rmse = sqrt(mean((errvec).^2));
else    
    rmse = sqrt(mean((vreal).^2));
end

end

