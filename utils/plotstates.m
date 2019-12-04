% Y-axis labels for the plots of each state
% close all
labelstring{1} = '$x_{ji}$ [m]';
labelstring{2} = '$y_{ji}$ [m]';
labelstring{3} = '$\dot{x}_{i}$ [m/s]';
labelstring{4} = '$\dot{y}_{i}$ [m/s]';
labelstring{5} = '$\dot{x}_{ji}$ [m/s]';
labelstring{6} = '$\dot{y}_{ji}$ [m/s]';
labelstring{7} = '$\Psi_{i}$ [rad]';
labelstring{8} = '$\Psi_{j}$ [rad]';
labelstring{9} = '$h_{ji}$ [m]';

distunfiltered = logdistdistest(Pmod(1),Pmod(2),RSSI);

newfigure(449,'','Fig4c');

% Plot the polished range and all the estimated/polished states
% subplot((npl+1)/3,3,1) % First subplot --> Range
plot(time,distunfiltered,'x','color',[0 0.5 0],'MarkerSize',5); % Plot the inverted range with basic model
hold on
plot(time,dist_estimate_mean,'r','LineWidth',2); % Plot the estimated range
plot(time,dist,'k--','LineWidth',2);
hold off

xlabel('Time [s]');
ylabel('$\rho_{ji}$ [m]');
legend('LD (inverted)', 'EKF', 'GT','Location','North','Orientation','Horizontal')
ylim([0 5])
xlim([0 time(end)])
box on
% legend('Inverted RSSI model', 'EKF Estimate', 'Ground-truth')
npl = 2;
% Plot the states
for k=1:npl
%     subplot((npl+1)/3,3,k+1); % Select relevant subplot
if k == 1
    newfigure(450+k,'','Fig4a');
elseif k == 2
    newfigure(450+k,'','Fig4b');
else
    newfigure(450+k,'',['EKFEstimates_',num2str(k),'_',day,set,est]);
end
    box on
    
    hold on% Plot estimated value
%     plot(time, xV(k,:), 'r--','LineWidth',2)
if k == 1
    plot(time, meanx,'r','LineWidth',2)
elseif k == 2
plot(time, meany,'r','LineWidth',2)
end
    plot(time, sV(k,:), 'k--','LineWidth',2) % Plot actual value
    
    ylabel(labelstring(k));
    xlabel('Time [s]');
%     ylim([-max(abs(sV(k,:))) max(abs(sV(k,:)))])
    legend('EKF','GT','Location','North','Orientation','Horizontal')
    % If measurement available, plot measurement values
    if (k == 3 || k == 4 || k == 7 || k == 8)
        
        if k == 3
            mk = 2;
        elseif k== 4
            mk = 3;
        elseif k == 7
            mk = 4;
        elseif k == 8
            mk = 7;
        end
        
        plot (time, zV(mk,:), 'go','LineWidth',1); % Plot measurements
        hold on
        
    end
%     plot(time,0*ones(size(time)),'k')
a = gca;
a.YTick = -4:1:4;
a.XTick = 0:20:180;
xlim([0 180])
ylim([-4 4])
% grid on
end
