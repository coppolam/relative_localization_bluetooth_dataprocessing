function [ var ] = msgtostruct( msg, bounds_struct, horizontal_selection, var)
%msgtostruct Takes a message structure and writes it to variables according
%to the bounds in bounds_struct

if nargin < 4
    var = 0;
end

if nargin < 3
    horizontal_selection = 1:size(msg{1}.content,1);
end

fname = fieldnames(bounds_struct);

for ff = 1:length(fname)
    var.(fname{ff}) = double(cell2mat( msg.content (horizontal_selection,bounds_struct.(fname{ff})) )); 
end   
         

end