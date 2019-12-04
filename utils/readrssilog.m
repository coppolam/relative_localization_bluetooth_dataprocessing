function [rssi_time, rssi_address, rssi_value] = readrssilog(filerssilog)
fid = fopen(filerssilog, 'r');
datacell = textscan(fid, '%f %s %f');
rssi_time = datacell{1};
rssi_address =  cellfun(@(x)str2double(x),datacell{2});
rssi_value = datacell{3};
fclose(fid);
end

