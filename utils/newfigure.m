function [handlenumber, handle] = newfigure( handlenumber, ifadd, figurename)
%newfigure Creates a new figure and clears an old one if it exists
% Input 1: figure handle number
% Input 2: 'add' if count is to be increased, else ''
% Input 3: figure name (optional)
% newfigure(handle, "name")
%
% Mario Coppola, 2017

if nargin > 1 
    if strcmp(ifadd,'add')
        handlenumber = handlenumber+1;
    elseif nargin < 3
        figurename = ifadd;
   end
end

if ishandle(handlenumber)
    close(handlenumber)
end
handle = figure(handlenumber);

if nargin >= 2
    set(handlenumber,'Name',figurename);
end

box on

end

