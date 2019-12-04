function [g] = G_ang(P_t_c, RH, RP)
%G_TS Calculates a first order spline to be used in the Takagi Sugeno lobe
%approximation

gh = fourierseries( wrapToPi(RH), P_t_c(1,1:end-1), P_t_c(1,end) );

% VERTICAL HEADING
if nargin > 2
    gv = fourierseries( wrapToPi(RP), P_t_c(2,1:end-1), P_t_c(2,end) );
    g = gh+gv;
else
    g = gh;
end

end



