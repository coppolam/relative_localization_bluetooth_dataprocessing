function [ R ] = R_2D(yaw)
%Rotation matrix from the body frame of reference (North-East-Down) to a fixed earth
%frame of reference

sy = sin(yaw);
cy = cos(yaw);

R11 = cy;
R12 = - sy;

R21 = sy;
R22 = cy;

R = [R11 R12 ;
     R21 R22 ];

end