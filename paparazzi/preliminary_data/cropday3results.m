if  strcmp(day,'day3') && ranitalready == 0
    ranitalready = 1;
    % Crop all crap between take-off and landing
    f=find(z < - 0.90,1,'first');
    l=find(z < - 0.90,1,'last');
    [time,x,y,z,vx,vy,vz,phi,theta,psi,dist,bearing,RSSI] = ...
        cropvectors([f,l],time,x,y,z,vx,vy,vz,phi,theta,psi,dist,bearing,RSSI);
    
    % Crop the experiment
    tolerance = 0.5;
    f=find(z > tolerance,1,'first');
    l=find(z < tolerance,1,'last');
    [time,posx,posy,posz,vx,vy,vz,phi,theta,psi,dist,bearing,RSSI] = ...
        cropvectors([f,l],time,x,y,z,vx,vy,vz,phi,theta,psi,dist,bearing,RSSI);

    if strcmp(set,'log1')
    [time,posx,posy,posz,vx,vy,vz,phi,theta,psi,dist,bearing,RSSI] = ...%             cropvectors([75,700],time,posx,posy,posz,vx,vy,vz,phi,theta,psi,dist,bearing,RSSI)
            cropvectors([1,700],time,posx,posy,posz,vx,vy,vz,phi,theta,psi,dist,bearing,RSSI);
    end
    
else
    [ posx, posy, posz ] = makevertical(x,y,z);
end
