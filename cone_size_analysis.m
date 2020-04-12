init

%%
R = 0.2;

%%
clc
eps = 0.5;
r = 0:0.01:5;

ka = 1:4;
ka_mat = repmat(ka,length(r),1);
r_mat      = repmat(r,length(ka),1)';

% alpha_cc = pi-CCSIZE_mat.*log10(r_mat+1-(R*2));
alpha_cc = 2*atan((r_mat+eps+R)./(ka_mat.*r_mat));
% alpha_cc = keepbounded(alpha_cc, [pi, 0]);
asymptote = 2*atan(1./ka);%
asymptote_mat = repmat(asymptote,length(r),1);

newfigure(765,'','Fig6'); hold on;

for i = 1:length(ka)
plot(r, alpha_cc(:,i), linelist{i}, 'linewidth',2,'color',colorlist{i})   
end

for i = 1:length(ka)
plot(r,asymptote_mat(:,i),'-.','color',colorlist{i});% ones(size(r_mat)).*asymptote);
end
hold off
xlim([0 max(r)])
ylim([0 3.5])
xlabel('Distance [m]')
ylabel('$\alpha_{CC}$ [rad]')
legend('$\kappa_\alpha$ = 1','$\kappa_\alpha$ = 2','$\kappa_\alpha$ = 3','$\kappa_\alpha$ = 4',...
    'Location','North','Orientation','Horizontal')
box on
%%
clc

eps = -0.15:0.2:0.6;
r   = 0:0.01:5;
ka  = 1;
acc_pref = 1.7;

eps_mat = repmat(eps,length(r),1);
ka_mat  = repmat(ka,length(r),1);
r_mat   = repmat(r,length(eps),1)';

% alpha_cc = pi-CCSIZE_mat.*log10(r_mat+1-(R*2));
alpha_cc = 2*atan((r_mat+eps_mat+R)./(ka.*r_mat));

% alpha_cc = keepbounded(alpha_cc, [pi, 0]);
asymptote = 2*atan(1./ka);%
asymptote_mat = repmat(asymptote,length(r),1);

newfigure(767,'','Fig7'); hold on;

for i = 1:length(eps)
    plot(r, alpha_cc(:,i), linelist{i},'linewidth',2,'color',colorlist{i})   
end

plot(r,acc_pref*ones(size(r)),'k-.');% ones(size(r_mat)).*asymptote);
% text(0.1,acc_pref+0.15,'$\alpha_{{CC}_{eq}}$','HorizontalAlignment','left')

% for i = 1:length(shapeparam)
% plot(r,asymptote_mat(:,i),'-.','color',colorlist{ia});% ones(size(r_mat)).*asymptote);
% end
% hold off
xlim([0 max(r)])
xlabel('Distance [m]')
ylabel('$\alpha_{CC}$ [rad]')
legend('$\varepsilon_{\alpha}$ = -0.15',...
    '$\varepsilon_{\alpha}$ = 0.05',...
    '$\varepsilon_{\alpha}$ = 0.25',...
    '$\varepsilon_{\alpha}$ = 0.45',...
    '$\alpha_{{CC}_{eq}}$','Location','NorthEast','Orientation','Vertical');
box on
%%
ka       = 1.0;
roomsize = 0.5:0.5:2.5;
disp('new')

R = 0.1;
acc_pref = 1.7;
eps_pref = (ka*roomsize*tan(acc_pref/2)) - (R + roomsize)

%%
latex_printallfigures(get(0,'Children'), 'figures/','paper_wide_half',[765 767])