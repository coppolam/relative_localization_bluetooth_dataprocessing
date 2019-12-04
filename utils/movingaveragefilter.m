function [ xV ] = movingaveragefilter( k, filterSize, xV, cols)
% use in a for loop to iterate through a whole vector

% Moving average post-filter
if k > filterSize
    
    for i = 1:length(cols)
        xv_st = sum(xV(cols(i),k-filterSize+1:k))/filterSize;
        xV(cols(i),k) = xv_st(1,end);
    end
    
else
    for i = 1:length(cols)
        xV(cols(i),k) = xV(cols(i),k);
    end
end

end


