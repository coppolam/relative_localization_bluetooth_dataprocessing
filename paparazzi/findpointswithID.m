function p = findpointswithID( msg_struct, IDsofinterest )
% ID in Paparazzi logs is always on the second line

IDs = cell2mat(msg_struct.content(:,2));
p   = find(IDs == IDsofinterest);
       
end

