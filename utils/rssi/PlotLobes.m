function [] = PlotLobes(P_basic, P_lobes, ...
                            RSSI_noise_basic, bearing, phi, mode, hv)
% Horizontal Lobes plot

if strcmp(hv,'v') && size(P_lobes,1) == 1
    warning('Cannot do the vertical lobes if only the horizontal ones have been identified');
    return
end

headings = linspace(-pi,pi,6*100);

if strcmp(hv,'h') || size(P_lobes,1) == 1
    lobes   = G_ang(P_lobes, headings);
    ff = bearing;
    
elseif strcmp(hv,'v') && size(P_lobes,1) == 2
    lobes   = G_ang(P_lobes, zeros(size(headings)),headings);
    ff = phi;
    
end
   
if strcmp(mode,'dirplot')
    dirplot(rad2deg(headings),lobes','r', [10 -40 5]);
   
elseif strcmp(mode,'graph')
    plot((wrapToPi(ff)), RSSI_noise_basic,'.', 'Color', [0 .5 0], 'DisplayName','LD model error','MarkerSize',10)
    hold on
    
    plot((headings),lobes,'-', 'Color', 'r','DisplayName','Lobe','Linewidth',2);
    makeaxespi;
    ylim([-15 15])
    xlabel('Relative Bearing [rad]');
    ylabel('Error [dB]');
    legend('Location','south','Orientation','Horizontal')
    
    plot([-180 180],[0 0],'--k','Linewidth',2);%,'DisplayName','Log-Dist Model');
    
elseif strcmp(mode,'3D')
    
    h_headings = linspace(-pi,pi,2.5*100);
    v_headings  = linspace(-pi/6,pi/6,2.5*100);
    a = setprod(h_headings,v_headings);
    lobes   = G_ang(P_lobes, a(:,1),a(:,2));
    if strcmp(hv,'full')
        lobes = lobes + P_basic(1);
    end
    
    [X,Y,Z] = sph2cart(a(:,1),a(:,2),lobes);
    
    scatter3(X,Y,Z,10,lobes);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    hc = colorbar;
    ylabel(hc, 'RSSI at 1m [dB]')
    view([-57,34]);

    grid on;
    axis equal;

end