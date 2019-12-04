init;
datafolder = 'data/logs_preliminary/stdma_tests/';
%%

[rssi_time_2, rssi_address_2, rssi_value_2] = readrssilog([datafolder,'data_2.rssilog']);
[rssi_time_3, rssi_address_3, rssi_value_3] = readrssilog([datafolder,'data_3.rssilog']);

rssidat_2 = [rssi_time_2, rssi_address_2];
rssidat_3 = [rssi_time_3, rssi_address_3];

%%
a = intersect(unique(rssi_address_2), unique(rssi_address_3));
mine_2 = find(rssidat_2(:,2)==a);
mine_3 = find(rssidat_3(:,2)==a);

%%
rssidat_2 = sortrows(rssidat_2(mine_2),1);
rssidat_3 = sortrows(rssidat_3(mine_3),1);
%%
ms = min(size(rssidat_2,1),size(rssidat_3,1))
msgint_2 = diff(rssidat_2(1:ms,1));
msgint_3 = diff(rssidat_3(1:ms,1));
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
newfigure(1,'','Fig3a');
plot(msgint_2,'k--'); hold on
plot(msgint_3,'r-');
xlabel('Messages')
ylabel('Message interval [s]')
xlim([1 length(msgint_2)])
xlim([0 900])
ax = gca;
ax.XTick = 0:300:900;
ax.YTick = 0:0.5:2;
legend('2 antennas', '3 antennas','Location','NorthOutside','Orientation','Horizontal')

newfigure(2,'','Fig3b');
% x = [0,0.05:0.1:1];
[h2,x] = histcounts(msgint_2,'Normalization','count');
stairs(x(1:end-1),h2,'k--'); hold on
[h3,x] = histcounts(msgint_3,'Normalization','count');
stairs(x(1:end-1),h3,'r-');
xlabel('Message interval [s]');
ylabel('Number of Messages');
xlim([0 0.8])
% ylim([0 800])
ax = gca;
ax.XTick = 0:0.2:1.0;
% ax.YTick = 0:200:800;
legend('2 antennas', '3 antennas','Location','NorthOutside','Orientation','Horizontal')

printallfigureslatex(get(0,'Children'), 'figures/','paper_wide_fourth',[1 2 ])

