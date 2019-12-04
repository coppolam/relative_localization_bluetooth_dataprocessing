function [ datastruct ] = clearnonmonotonicmembers(datastruct, tol, timefieldname)
%clearnonmonotonicmembers Clears all members of a structure where the time
%vector has the same member multiple times

if nargin < 3
    timefieldname = 'time';
end

if nargin < 2
    tol = 0.1;
end

del = diff(datastruct.(timefieldname))<tol;
         
if sum(del) > 0
    fname = fieldnames(datastruct);
    for ff = 1:length(fname)
        datastruct.(fname{ff})(del,:) = [];
    end
end

end

