function CheckHistogram( input )
%CheckHistogram Checks if histogram was successful (sum of all elements in the input vector = 1)
    if abs(sum(abs(input)))-1 > 0.01
        error('Sum of histogram does not equal 1. Something went wrong!')
    end

end

