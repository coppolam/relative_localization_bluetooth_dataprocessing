function [msg] = getmsgparameters(msg,filename)

A = fileread([filename,'.log']);

for i = 1:length(msg)
    
    if isempty(msg{i})
        error('Check the cell size for msg')
    end
    
    msg{i}.start=strfind(A, ['<message NAME="', msg{i}.name ] );
    msg{i}.end = strfind(A(msg{i}.start:end), '</message>');
    msg{i}.end = msg{i}.end(1)+msg{i}.start;
    msg{i}.content = A(msg{i}.start:msg{i}.end);
    msg{i}.elementtypes = strfind(msg{i}.content, 'TYPE="');
    msg{i}.length = length(msg{i}.elementtypes);
    msg{i}.types = cell(1,msg{i}.length);
    msg{i}.format = [];
    
    % From the textscan documentation:
    %
    %         Numeric Input Type   Specifier   Output Class
    %         ------------------   ---------   ------------
    %         Integer, signed        %d          int32
    %                                %d8         int8
    %                                %d16        int16
    %                                %d32        int32
    %                                %d64        int64
    %         Integer, unsigned      %u          uint32
    %                                %u8         uint8
    %                                %u16        uint16
    %                                %u32        uint32
    %                                %u64        uint64
    %         Floating-point number  %f          double
    %                                %f32        single
    %                                %f64        double
    %                                %n          double
    %
    
    for k = 1:msg{i}.length
        msg{i}.types{k} = msg{i}.content(msg{i}.elementtypes(k)+6:msg{i}.elementtypes(k)+10);
        
        if strcmp(msg{i}.types{k},'int8')
            f = '%d8';
        elseif strcmp(msg{i}.types{k},'int16')
            f = '%d16';
        elseif strcmp(msg{i}.types{k},'int32')
            f = '%d32';
        elseif strcmp(msg{i}.types{k},'int64')
            f = '%d64';
        elseif strcmp(msg{i}.types{k},'uint8')
            f = '%u8';
        elseif strcmp(msg{i}.types{k},'uint16')
            f = '%u16';
        elseif strcmp(msg{i}.types{k},'uint32')
            f = '%u32';
        elseif strcmp(msg{i}.types{k},'uint64')
            f = '%u64';
        elseif strcmp(msg{i}.types{k},'float') || strcmp(msg{i}.types{k},'double')
            f = '%f';
        elseif strcmp(msg{i}.types{k},'single');
            f = '%f32';
        elseif strcmp(msg{i}.types{k},'string')
            f = '%*s'; % ignore strings
        else % give up, just assume float
            f = '%f';
        end
        
        msg{i}.format = [msg{i}.format, f,' '];
        
    end
    
    msg{i}.lines = 1; %% Initializer for later
    fields = {'start','end','content','elementtypes','types'};
    msg{i} = rmfield(msg{i},fields);
end

end
