function [ sp, ep ] = selectflight( startpoints, endpoints, flight )
%selectflight extract the start and end index points of a specific flight
%(where a flight is a mode that is currently initiated until it is changed)
 
if numel(endpoints) == 1 && flight > 1
    flight = 1;
    warning('There was only one flight! Analyzing that one!')
end

if flight > numel(endpoints)
    error(['Your flight number does not exist in this round. There were only ',...
        num2str(numel(endpoints)),' flights']);
end

sp = startpoints(flight);
ep = endpoints(flight);

end

