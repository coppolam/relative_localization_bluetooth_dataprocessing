function [ varargout ] = cropvectors(lims, varargin)
%cropvectors Crops all input vectors with the same limits, avoids writing the same thing many times.
% e.g. [x1_cropped, x2_cropped] = cropvectors([lowbound,highound]. x1_original, x2_original)
%
% Developed by Mario Coppola, December 2015


if nargin - 1 ~= nargout
    error('This function should have all the same number of vectors as both inputs and outputs')
end

varargout = varargin;

for i = 1:nargin - 1 
    varargout{i} = varargin{i}(lims(1):lims(2));
end


end