function [ checkmap, percentage ] = checkareacoverage(x_gt, y_gt, sep, arenalength )
%checkareacoverage Checks how much of a squared area has been covered by a set of
%agents.
%
% [map, percentage] = checkareacoverage( x_gt, y_gt, sep, arenalength )
%
% returns a 2D matrix of as a map with 1 in the locations that were covered
% and 0 in the locations that were not covered.
% X axis - vertical direction (from negative to positive upwards)
% Y axis - horizontal direction (from negative to positive towards right)
%
% Note that this function relies on the ground truth data. It does not
% interpolate between those points, which means that if they were recorded
% at a low frequency then using a too fine grid will mean that a path in
% between two points is not recorded as having been crossed. You can fix
% this by using the interp1 function appropriately to extrapolate more
% details regarding the path.
%
% By Mario Coppola, May 2016

if nargin < 4
    error('Please specify arena details')
end
if isscalar(sep) && isscalar(arenalength) % Make a squared area
    s_x = round(-arenalength:sep:arenalength,5);
    s_y = s_x;
    sep_x = sep; sep_y = sep;
    
else % If we are already providing our own custom coordinates
    s_x = round(sep,5);          % (not actually sep, but a vector of x coordinates)
    s_y = round(arenalength,5);  % (not actually arenalength, but a vector of y coordinate)

    if range(round(diff(s_x),5)) == 0 && range(round(diff(s_y),5)) == 0
        sep_x = diff(s_x(1:2));
        sep_y = diff(s_y(1:2));
    else
        error('Please use even spacing in your custom x and y grids')
    end
    
end

checkmap  = zeros(length(s_y),length(s_x));

[~,x_idx]  = ismember(round(roundtomultiple(x_gt+min(abs(s_x)),sep_x),3),round(s_x+min(abs(s_x)),5));
[~,y_idx]  = ismember(round(roundtomultiple(y_gt+min(abs(s_y)),sep_y),3),round(s_y+min(abs(s_y)),5));

idx        = y_idx+(length(s_y)*(x_idx-1));
idx(idx<1) = [];

checkmap(round(idx,5)) = 1;

if nargout > 1 % else don't bother
    percentage = sum(checkmap(:))/numel(checkmap)*100;
end

end