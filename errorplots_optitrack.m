%% Initialize
init

%% Load data files
datafolder = 'data';
n_uavs = 2; % change to 2 or 3

%% Data of experiments with 2 drones
if n_uavs == 2
    datafile{1}    = '16_06_01__13_23_30';% - End due to battery
    datafile{2}    = '16_06_01__13_37_59';% - Collision (after ~5 min) (flight2)
    datafile{3}    = '16_06_01__14_38_07';% - End due to battery
    datafile{4}    = '16_06_01__14_51_35';% - End due to battery
    IDlist = [200 201];
elseif n_uavs == 3
    datafile{1}    = '16_06_01__15_30_44';% - End due to battery (but light brush at one point)
    datafile{2}    = '16_06_01__16_11_58';% - Collision (after ~1-2 min)
    datafile{3}    = '16_06_01__16_17_04';% - Collision (after ~5 min)
    datafile{4}    = '16_06_01__16_39_15';% - Collision (after ~2 min)
    datafile{5}    = '16_06_01__17_27_09';% - Collision (after ~2 min)
    datafile{6}    = '16_06_01__17_34_58';% - Collision (after ~3 min)
    IDlist = [200 201 202];
end

msgn{1}.name = 'RAFILTERDATA';
msgn{2}.name = 'ROTORCRAFT_FP';
msgn{3}.name = 'ROTORCRAFT_STATUS';

msg          = cell(1,numel(datafile));

for i = 1:numel(datafile)
    msg{i} = getmsgdata(msgn, [datafolder, '/logs_controlled_final/',datafile{i}]);
end

%% Load and organize all the data into matlab

nuavs  = length(IDlist);
uav    = cell(1,numel(datafile));
rfd         = msg_RAFILTERDATA_bounds();
[~,fpscal]  = msg_ROTORCRAFT_FP_bounds();
rIDs        = createallIDXcombinations( nuavs, 'relativefirst' );

for m = 1:numel(datafile)
    uav{m} = cell(nuavs,nuavs);
    
    for idn = 1:length(rIDs)
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            
            IDs_own = cell2mat(msg{m}{1}.content(:,rfd.ID   ));
            IDs_oth = cell2mat(msg{m}{1}.content(:,rfd.IDoth));
            pown   = find(IDs_own == IDlist(i));
            poth   = find(IDs_oth == IDlist(j));
            p      = intersect(pown,poth);
            
            uav{m}{i,j} = msgtostruct(msg{m}{1}, msg_RAFILTERDATA_bounds, p, uav{m}{i,j});
            uav{m}{i,j} = clearnonmonotonicmembers(uav{m}{i,j});
            
            time = uav{m}{1,2}.time;
            
            for k = 1:length(uav{m}{i,j}.x)
                uav{m}{i,j}.x = movingaveragefilter( k, 3, uav{m}{i,j}.x', [1 2 5 6])';
            end
            uav{m}{i,j}.rssi = interp1( uav{m}{i,j}.time ,uav{m}{i,j}.rssi, time, 'linear','extrap');
        else
            
            % GET REAL DATA
            p = findpointswithID(msg{m}{2},IDlist(i));
            uav{m}{i,i} = msgtostruct(msg{m}{2}, msg_ROTORCRAFT_FP_bounds, p, uav{m}{i,i});
            
            uav{m}{i,i}.gt(:,1:2) = uav{m}{i,i}.gt(:,1:2).*fpscal.position;
            uav{m}{i,i}.gt(:,3:4) = uav{m}{i,i}.gt(:,3:4).*fpscal.velocity;
            uav{m}{i,i}.gt(:,  5) = uav{m}{i,i}.gt(:,  5).*fpscal.attitude;
            uav{m}{i,i}.gt(:,  6) = uav{m}{i,i}.gt(:,  6).*fpscal.position;
            
            uav{m}{i,i} = clearnonmonotonicmembers(uav{m}{i,i});
            
            uav{m}{i,i}.gt = interp1( uav{m}{i,i}.time ,uav{m}{i,i}.gt, time, 'linear','extrap');
            
        end
        
    end
    
end

for m = 1:numel(datafile)
    
    for idn = 1:length(rIDs)
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            % Construct the reference (perfect) output of the EKF
            uav{m}{i,j}.realx(:,1:2) = uav{m}{j,j}.gt(:,[2 1]) - uav{m}{i,i}.gt(:,[2 1]);
            uav{m}{i,j}.realx(:,3:4) = uav{m}{i,i}.gt(:,[4 3]);
            uav{m}{i,j}.realx(:,5:6) = uav{m}{j,j}.gt(:,[4 3]);
            uav{m}{i,j}.realx(:,  7) = deg2rad(uav{m}{i,i}.gt(:,5));
            uav{m}{i,j}.realx(:,  8) = deg2rad(uav{m}{j,j}.gt(:,5));
            uav{m}{i,j}.realx(:,  9) = (-uav{m}{j,j}.gt(:,6)) - (-uav{m}{i,i}.gt(:,6));
        end
        
    end
    
end

%% Extract the starting points of the flights
sp = cell(1,numel(datafile));
ep = cell(1,numel(datafile));

for m = 1:numel(datafile)
    [startpoints, endpoints] = getnavstartpoints(uav{m}{1,2}.time, msg{m}{3},'guided');
    
    if numel(IDlist) == 2
        flight         = numel(startpoints);
    elseif numel(IDlist) == 3
        flight           = 1;
        
    end
    
    [ sp{m}, ep{m} ]  = selectflight( startpoints, endpoints, flight );
    
end

%% Evaluate errors
as = 2;
dmat       = cell(1,numel(datafile));
errmat     = cell(1,numel(datafile));
meanerr    = cell(1,numel(datafile));
dispersion = cell(1,numel(datafile));

for m = 1:numel(datafile)
    dmat{m} = zeros(ep{m}-sp{m}+1,factorial(nuavs));
    errmat{m} = zeros(ep{m}-sp{m}+1,factorial(nuavs));
    cc = 1;
    
    for idn = 1:length(rIDs)
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            
            uav{m}{i,j}.error   = mag(uav{m}{i,j}.realx(sp{m}:ep{m},1:2) - uav{m}{i,j}.x(sp{m}:ep{m},1:2),'row');
            uav{m}{i,j}.dist    = mag(uav{m}{i,j}.realx(sp{m}:ep{m},1:2),'row');
            uav{m}{i,j}.bearing = cart2pol(uav{m}{i,j}.realx(sp{m}:ep{m},2),    uav{m}{i,j}.realx(sp{m}:ep{m},1));
            uav{m}{i,j}.bearing_est = cart2pol(uav{m}{i,j}.x(sp{m}:ep{m},2), uav{m}{i,j}.x(sp{m}:ep{m},1));
            uav{m}{i,j}.bearing_error  = wrapToPi(uav{m}{i,j}.bearing-uav{m}{i,j}.bearing_est);
            uav{m}{i,j}.dist_est = mag(uav{m}{i,j}.x(sp{m}:ep{m},1:2),'row');
            uav{m}{i,j}.dist_error = uav{m}{i,j}.dist_est - uav{m}{i,j}.dist;
            
            dmat{m}(:,cc)   = [uav{m}{i,j}.dist];
            errmat{m}(:,cc) = [uav{m}{i,j}.error];
            cc = cc+1;
            
        else
            
            checkmap = 0;
            
            for i = 1:nuavs
                checkmap = checkmap + checkareacoverage(uav{m}{i,i}.gt(:,1),uav{m}{i,i}.gt(:,2), 0.2, 2);
            end
            checkmap(checkmap > 1) = 1;
            perc(m) = sum(checkmap(:))/numel(checkmap);
            
        end
        
    end
    meanerr{m} = mean(errmat{m},2);
    dispersion{m} = mavdispersion(nuavs, as*2, dmat{m});
    clear dmat_j
end

%% Store data
if length(IDlist) == 2
    uav_2 = uav;
    sp_2 = sp;
    ep_2 = ep;
    t_2 = time;
else
    uav_3 = uav;
    sp_3 = sp;
    ep_3 = ep;
    t_3 = time;
end

%% Plot the range and Bearing errors (figures 15 a/d or b/e)
rrm = 0;
brm = 0;
cc = 1;
if nuavs == 2
    newfigure(6868,'','Fig16d');
elseif nuavs == 3
    newfigure(6868,'','Fig16e');
end

hold on

bs = zeros(1,nuavs^2-nuavs*numel(datafile));
rs = zeros(1,nuavs^2-nuavs*numel(datafile));
bm = zeros(1,nuavs^2-nuavs*numel(datafile));
rm = zeros(1,nuavs^2-nuavs*numel(datafile));

for m = 1:numel(datafile)
    for idn = 1:length(rIDs)
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            bm(cc) = mean(uav{m}{i,j}.bearing_error);
            bs(cc) = std( uav{m}{i,j}.bearing_error);
            brm(cc) = rmse(uav{m}{i,j}.bearing_error);
            cc = cc+1;
            plot(uav{m}{i,j}.time(sp{m}:ep{m})-uav{m}{i,j}.time(sp{m}),uav{m}{i,j}.bearing_error)
            % add collision cone size?
        end
    end
end

ylabel('Bearing Error $[rad]$')
xlabel('Time [s]')

ylim([-pi pi])
ax = gca;

if nuavs == 3
    xlim([0 300])
    ax.XTick = 0:50:300;
    
elseif nuavs == 2
    xlim([0 450])
    ax.XTick = 0:50:450;
end

ax.YTick = [-pi -pi/2 0 pi/2 pi];
ax.YTickLabel = {'$-\pi$','$-\pi/2$','0','$\pi/2$','$\pi$'};
ylim([-pi pi]);

if nuavs == 2
    newfigure(6969,'','Fig16a');
elseif nuavs == 3
    newfigure(6969,'','Fig16b');
end

hold on
cc = 1;
for m = 1:numel(datafile)
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            rm(cc) = mean(uav{m}{i,j}.dist_error);
            rs(cc) = std (uav{m}{i,j}.dist_error);
            rrm(cc) = rmse(uav{m}{i,j}.dist_error);
            cc = cc +1;
            plot(uav{m}{i,j}.time(sp{m}:ep{m})-uav{m}{i,j}.time(sp{m}),uav{m}{i,j}.dist_error)
        end
    end
end
ylim([-4 4])
ax = gca;
ax.YTick = [-4:1:4];

if nuavs == 3
    xlim([0 300])
    ax.XTick = [0:50:300];
    
elseif nuavs == 2
    xlim([0 450])
    ax.XTick = [0:50:450];
end

ylabel('Range Error $[m]$')
xlabel('Time [s]')

mean(rrm)
mean(bs)
mean(rs)
printallfigureslatex(get(0,'Children'), 'figures/', 'paper_ultrawide_half_alternative',[6868, 6969])

%% Combine all errors in one vector for some extra analysis if you like.
% This is needed to generate the histograms in a separate script
combineddata_optitrack_bearingerror = [];

for m = 1:numel(datafile)
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            combineddata_optitrack_bearingerror = [combineddata_optitrack_bearingerror; uav{m}{i,j}.bearing_error];
        end
    end
end

combineddata_optitrack_rangeerror = [];

for m = 1:numel(datafile)
    
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            combineddata_optitrack_rangeerror = [combineddata_optitrack_rangeerror; uav{m}{i,j}.dist_error];
        end
    end
end

save([datafolder,'/combineddata_optitrack_',num2str(nuavs)],'combineddata_optitrack_bearingerror','combineddata_optitrack_rangeerror')

%% Auxiliaty plot, 3 drones, bad flight

if nuavs == 3
    % Figure of bearing error
    newfigure(68684.'',['exp_bearingerror_badflight',num2str(nuavs)]);
    hold on

    m = 2;
    i = 2;
    j = 1;
    plot(uav{m}{i,j}.time(sp{m}:ep{m})-uav{m}{1,2}.time(sp{m}),uav{m}{1,2}.bearing_error(:,1),'b--')
    ylabel('Bearing Error $[rad]$')
    xlabel('Time [s]')
    
    newfigure(435345);
    hold on
    plot( uav{m}{1,1}.gt(sp{m}:ep{m},1),  uav{m}{1,1}.gt(sp{m}:ep{m},2),'bo')
    plot( uav{m}{2,2}.gt(sp{m}:ep{m},1),  uav{m}{2,2}.gt(sp{m}:ep{m},2),'ro')
    plot( uav{m}{3,3}.gt(sp{m}:ep{m},1),  uav{m}{3,3}.gt(sp{m}:ep{m},2),'mo')

    plot( uav{m}{1,1}.gt(sp{m},1),  uav{m}{1,1}.gt(sp{m},2),'g.')
    plot( uav{m}{2,2}.gt(sp{m},1),  uav{m}{2,2}.gt(sp{m},2),'g.')
    plot( uav{m}{3,3}.gt(sp{m},1),  uav{m}{3,3}.gt(sp{m},2),'g.')

end
%% Convergence (Figures 17a (2mavs) or 17b (3mavs) )
cc = 1;
if nuavs == 2
    newfigure(6868682,'','Fig17a');
elseif nuavs == 3
    newfigure(6868682,'','Fig17b');
end
hold on

bs = zeros(1,nuavs^2-nuavs*numel(datafile));
rs = zeros(1,nuavs^2-nuavs*numel(datafile));
bm = zeros(1,nuavs^2-nuavs*numel(datafile));
rm = zeros(1,nuavs^2-nuavs*numel(datafile));

for m = 1:numel(datafile)
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            bm(cc) = mean(uav{m}{i,j}.bearing_error);
            bs(cc) = std( uav{m}{i,j}.bearing_error);
            brm(cc) = rmse(uav{m}{i,j}.bearing_error);
            cc = cc+1;
            plot(uav{m}{i,j}.time(sp{m}:ep{m})-uav{m}{i,j}.time(sp{m}),uav{m}{i,j}.bearing_error)
        end
    end
end

ylabel('Bearing Error $[rad]$')
xlabel('Time [s]')

ylim([-pi pi])
ax = gca;

xlim([0 30])
ax.XTick = [0:5:30];

ax.YTick = [-pi -pi/2 0 pi/2 pi];
ax.YTickLabel = {'$-\pi$','$-\pi/2$','0','$\pi/2$','$\pi$'};
ylim([-pi pi]);
axis square
printallfigureslatex(get(0,'Children'), 'figures/', 'paper_square_fourth',[6868682])

%% Standard deviation RSSI
ccc = 1;
errstd = zeros(1,nuavs^2-nuavs*numel(datafile));
for m = 1:numel(datafile)
    for idn = 1:length(rIDs)
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            error = uav{m}{i,j}.rssi(sp{m}:ep{m}) - logdistdB(-67,2,uav{m}{i,j}.dist);
            errstd(ccc) = std(error);
            ccc = ccc + 1;
        end
    end
end
errstd
