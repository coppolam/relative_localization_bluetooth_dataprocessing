function [ msg ] = getmsgdata( msg, filename )
%getmsgdata Get data of all messages in the msg structure
% TODO: Extract also period of message, which could be useful

% The user need to specify where the log file is.
fid = fopen([filename,'.data'],'r');
if fid == -1
    error('File not found!');
end

msg = getmsgparameters(msg,filename);

% Get message data line by line for the messages of interest
while feof(fid) == 0
    tline = fgetl(fid);
        
    for i = 1:length(msg)
    
        if  (length(strfind(tline, msg{i}.name))) > 0
            msg{i}.content(msg{i}.lines,:) = textscan(tline,['%f %d %*s ' msg{i}.format],1);
            msg{i}.lines = msg{i}.lines+1;
        end
        
    end
    
end

for i = 1:length(msg)
    fields = {'length','lines'};
    msg{i} = rmfield(msg{i},fields);
end

end

