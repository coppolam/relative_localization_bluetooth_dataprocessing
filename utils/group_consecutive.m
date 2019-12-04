function [ x ] = group_consecutive( x , delta, mode )
%group_consecutive Groups consecutive values in a list (at the first point)
% The standard difference between values is assumed 1, otherwise specify it

if nargin < 2
    delta = 1;
end

if nargin < 3
    mode = 'first';
end

del = [];
groupsize = 0;

if strcmp(mode,'first')
    
    for i = 2:length(x)
        if x(i) == x(i-1) + delta
            del = [del i];
        end
    end
    
elseif strcmp(mode,'last')
    x = flipud(x);
    
    for i = 2:length(x)
        if x(i) == x(i-1) - delta
            del = [del i];
        end
    end
    
end

x(del) = [];

if strcmp(mode,'last')
    x = flipud(x);
end

end

