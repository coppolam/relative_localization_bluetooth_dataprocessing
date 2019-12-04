init
%%

day = 'day1'; set = 'log2';
load(['data/logs_preliminary/',day,'/',set]);

cropday3results;

% PlotPath
%%
% Run the Lobe Identification
P_basic = EstimateLogDist(RSSI, dist);
% P_basic = [-53 , 2];
RSSI_basic = logdistdB( P_basic(1), P_basic(2), dist );
RSSI_noise_basic = RSSI - RSSI_basic;

P_lobes = lobeEstimator(RSSI_noise_basic, bearing, psi, 2);

RSSI_lobes = EstimateRSSI(P_basic, P_lobes, dist, bearing, phi);
RSSI_noise_lobes = RSSI - RSSI_lobes;

% Horizontal plot
% count = newfigure(count,'add', ['LobesRadial_H',day,set]);
% PlotLobes(P_basic, P_lobes, RSSI_noise_basic, bearing, [], 'dirplot','h');

newfigure(785,'', ['Lobes_',day,set]);
PlotLobes(P_basic, P_lobes, RSSI_noise_basic, bearing, [], 'graph','h');
ylim([-10 10])

a = gca;
a.YTick = -10:5:10;

%%
% RSSI plot
newfigure(786,'', ['LogDist_',day,set]);
dvec = 0.0:0.01:4.0;
RSSI_basic_lin = logdistdB( P_basic(1), P_basic(2), dvec );

plot(dvec,RSSI_basic_lin,'k-','Linewidth',2,'DisplayName','LD Model');
hold on
plot(dist,RSSI,'.', 'Color', [0 .5 0],'DisplayName','Measured RSSI','MarkerSize',10);

legend('Location','SouthWest')
xlabel('Distance [m]')
ylabel('RSSI [dB]')
ylim([-80 -40])
xlim([min(dvec) max(dvec)])

a = gca;
a.XTick = 0:1:4;
a.YTick = -80:10:-40;
% %% Vertical plot
% if size(P_lobes,1) == 2
%     count = newfigure(count,'add', ['LobesRadial_V',day,set]);
%     PlotLobes(P_basic,P_lobes,RSSI_noise_basic,[],phi,'graph','v');
% end
% 
% %% 3D plot
% if size(P_lobes,1) == 2
%     count = newfigure(count,'add', ['LobesRadial_V',day,set]);
%     PlotLobes(P_basic,P_lobes,[],[],[],'3D','full');
% end

%% RSSI noise with distance
% count = newfigure(count,'add', ['Noise',day,set]);
% plot(dist,RSSI_noise_basic,'k.')
% hold on
% plot(dist,RSSI_noise_lobes,'r.')
% 
% 
% %% RSSI noise with lobes
% count = newfigure(count,'add', ['Noise',day,set]);
% plot(bearing,RSSI_noise_basic,'k.')
% hold on
% plot(bearing,RSSI_noise_lobes,'r.')
% 

%% RSSI noise distribution
newfigure(787,'',['RSSInoise_spread_',day,set]);
dm = 1;
xvec = -20:dm:15;
h= hist(RSSI_noise_basic,xvec);
h = smooth(h);
plot(xvec,h/numel(RSSI_noise_basic),'b');

hold on
check_histogram(h/numel(RSSI_noise_basic));

h = hist(RSSI_noise_lobes,xvec);
h = smooth(h);
plot(xvec,h/numel(RSSI_noise_lobes),'r--');

check_histogram(h/numel(RSSI_noise_lobes));
xlim([-15 15])
ylim([0 0.12])
a = gca;
a.XTick = -15:5:15;
a.YTick = 0:0.02:0.12;
xlabel('RSSI error [dB]')
ylabel('Probability Density [-]')
legend('LD Model', 'LD Model with Lobes','Location','North','Orientation','Horizontal')
% % swtest(h)
%%
[A,B] = GetDistributionParameters( 'normal', RSSI_noise_basic);
disp(['mean: ', num2str(A)])
disp(['std. dev. ' num2str(B)])

[A,B] = GetDistributionParameters( 'normal', RSSI_noise_lobes);
disp(['mean: ', num2str(A)])
disp(['std. dev. ' num2str(B)])


%% Save figures
printallfigureslatex(get(0,'Children'),'figures/','paper_wide_third',[785 786 787])
