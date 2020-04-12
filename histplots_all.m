init
datafolder = 'data/';

%% bearing error autonomous

load([datafolder,'combineddata_autonomous_2.mat'])
combineddata_autonomous_bearingerror_2 = combineddata_autonomous_bearingerror;

load([datafolder,'combineddata_autonomous_3.mat'])
combineddata_autonomous_bearingerror_3 = combineddata_autonomous_bearingerror;

clear combineddata_autonomous_bearingerror combineddata_autonomous_rangeerror

newfigure(1000,'','Fig19c')
dm = 2*pi/40;
xvec = -pi:dm:pi;
h1= hist(combineddata_autonomous_bearingerror_2 , xvec);
plot(xvec,h1/numel(combineddata_autonomous_bearingerror_2),'k--'); hold on
h2= hist(combineddata_autonomous_bearingerror_3 , xvec);
plot(xvec,h2/numel(combineddata_autonomous_bearingerror_3),'r');
hold off
clear h1 h2
makeaxespi(gca,[-pi pi],'x')
ax.YTick = 0:0.05:0.15;
ylim([0 0.15])
% ax.YTickLabel = {'$-\pi$','$-\pi/2$','0','$\pi/2$','$\pi$'};
xlabel('Bearing Error $[rad]$')
ylabel('Probability Density [-]')
legend('2 AR.Drones', '3 AR.Drones','Location','NorthOutside','Orientation','Horizontal')

%% 
load([datafolder,'combineddata_optitrack_2.mat'])
combineddata_optitrack_bearingerror_2 = combineddata_optitrack_bearingerror;
combineddata_optitrack_rangeerror_2 = combineddata_optitrack_rangeerror;
clear combineddata_optitrack_bearingerror combineddata_optitrack_rangeerror

load([datafolder,'combineddata_optitrack_3.mat'])
combineddata_optitrack_bearingerror_3 = combineddata_optitrack_bearingerror;
combineddata_optitrack_rangeerror_3 = combineddata_optitrack_rangeerror;

clear combineddata_optitrack_bearingerror combineddata_optitrack_rangeerror
newfigure(1001,'','Fig16c');

dm = 8/40;
xvec = -4:dm:4;
h1= hist(combineddata_optitrack_rangeerror_2,xvec);
plot(xvec,h1/numel(combineddata_optitrack_rangeerror_2),'k--'); hold on

h2= hist(combineddata_optitrack_rangeerror_3,xvec);
plot(xvec,h2/numel(combineddata_optitrack_rangeerror_3),'r');

hold off
clear h1 h2

xlim([-4 4])
ax = gca;

ax.YTick = 0:0.05:0.15;
ylim([0 0.15])
xlabel('Range Error $[m]$')
ylabel('Probability Density [-]')
legend('2 AR.Drones', '3 AR.Drones','Location','NorthOutside','Orientation','Horizontal')

newfigure(1002,'','Fig16f');
dm = 2*pi/40;
xvec = -pi:dm:pi;
h1= hist(combineddata_optitrack_bearingerror_2,xvec);
plot(xvec,h1/numel(combineddata_optitrack_bearingerror_2),'k--');
hold on

h2= hist(combineddata_optitrack_bearingerror_3,xvec);
plot(xvec,h2/numel(combineddata_optitrack_bearingerror_3),'r-');
hold on
clear h1 h2
legend('2 AR.Drones', '3 AR.Drones','Location','NorthOutside','Orientation','Horizontal')

makeaxespi(gca,[-pi pi],'x')

ax.YTick = 0:0.05:0.25;
ylim([0 0.25])
xlabel('Bearing Error $[rad]$')
ylabel('Probability Density [-]')

%% Print the figures
latex_printallfigures(get(0,'Children'), 'figures/', 'paper_square_fourth',[1000 1001 1002])

