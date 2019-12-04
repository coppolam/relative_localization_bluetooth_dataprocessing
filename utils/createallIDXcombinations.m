function [ rIDs ] = createallIDXcombinations( nuavs , mode)
% Creates a list of relative IDs so that all data can be corss analyized
% modes:
% 'onlyrelative' only creates relative indexes
% 'relativefirst' puts relative indeces list first
% 'relativelast' puts relative list last
% 'none' leaves it normal (default)
if nargin < 2
    mode = 'none';
end

rIDs = sortrows(combvec(1:nuavs,1:nuavs)',2);

if ~strcmp(mode,'none')
    del = abs(rIDs(:,2)-rIDs(:,1))<0.9;
    rIDs(del,:) = [];
    rIDs = sortrows(rIDs,1);
    if strcmp(mode,'onlyrelative')
        return
    elseif strcmp(mode,'relativefirst')
        rIDs = [rIDs; [ [1:nuavs]', [1:nuavs]']];
    elseif strcmp(mode,'relativelast')
        rIDs = [[ [1:nuavs]', [1:nuavs]']; rIDs];
    else
        error('Unknown mode for ID list generation')
    end
end


end

