% %% ploterror Plots the error over distance
% 
% % Calculate the slope of the line with a least squares fit
% [slope_rxV ] = leastsquarefit(dist_estimate_mean , emag);
% [slope_dist] = leastsquarefit(dist , emag);
% 
% % lim  = max(round(max(dist)+0.5,0), round(max(dist_estimate_mean)+0.5,0)); % Graph limit
% lim = 3.5;
% dvecplot = linspace(0,lim,N);
% 
% newfigure(490,'',['errorfit_',estimator,'_avgover',num2str(runs),'runs_',day,set,est]);
% % plot3(dist, emag,time,'r.');                     % Real Error
% plot3(dist, emag, time, 'r.','MarkerSize',10)                     % Real Error
% hold on
% % plot3(dist_estimate_mean, emag, time, 'rx')      % Error based on estimate
% % plot(dist_estimate_mean, emag, 'rx')      % Error based on estimate
% plot([0 lim], [0 lim], 'k-','LineWidth',1); % 1 to 1 line --> Below line = Good
% % plot(dvecplot, dvecplot.*slope_dist(1), 'b--');  % Real error fit
% % plot(dvecplot, dvecplot.*slope_rxV(1) , 'r--');  % Estimated error fit
% hold off
% view([0 90])
% xlabel('$\rho_{ji}$ [m]');
% ylabel('$| \vec{e}_{ji} |$ [m]');
% zlabel('Time [s]');
% 
% xlim([0 lim]);
% ylim([0 lim]);
% % zlim([0 time(end)])
% legend('Error','One-to-One Diagonal','Location','North','Orientation','Horizontal')
% % legend('Real Error','Error on Estimated distance','Diagonal','Location','NorthWest')
% box on
% % addgrid
%% Bearing error
newfigure(499,'','Fig4d');

bearing_err=(bearing_estimate_mean-bearing');
% plot(time,wrapToPi(bearing_err),'r.'); 
plot(time,wrapToPi(bearing_est-bearing'),'r-','Linewidth',2);hold on;
% plot(time,-pi/4*ones(size(bearing_err)),'k--');
% plot(time,pi/4*ones(size(bearing_err)),'k--');

ax = gca;
ax.YTick = [-pi -pi/2 0 pi/2 pi];
ax.YTickLabel = {'$-\pi$','$-\pi/2$','0','$\pi/2$','$\pi$'};
ylim([-pi pi]);
% legend('EKF','GT')
xlabel('Time [s]');
ylabel('$\beta_{ji} $ error [rad]');
xlim([0 180])

%%
% inbounds = (abs(wrapToPi(bearing_err))<pi/4);
% sum(inbounds)
% 
%     % newfigure(499,'',['Bearingerr','_avgover',num2str(runs),'runs_',day,set,est]);
%     % bearing_err=(bearing_estimate_mean-bearing');
%     % plot(wrapToPi(bearing_err),'r.'); hold on;
%     % plot(-pi/4*ones(size(bearing_err)),'k--');
%     % plot(pi/4*ones(size(bearing_err)),'k--');
% 
% %%
% newfigure(491,'',['PercError','_avgover',num2str(runs),'runs_',day,set,est]);
% % hold on
% % percerror  = emag;
% plot(time,emag,'r-','Linewidth',2)
% xlabel('Time [s]')
% ylabel('$| \vec{e}_{ji} |$ [m]');
% xlim([0 180])
% a = gca;
% a.XTick = 0:20:180;
% box on