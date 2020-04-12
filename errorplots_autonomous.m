%% Initialize
init

%% Load data files
datafolder = 'data';
n_uavs = 2; % change to 2 or 3

%% Data of experiments with 2 drones
if n_uavs == 2
    datafile{1}    = '16_12_17__12_50_18';% - ended in collision
    datafile{2}    = '16_12_17__13_13_01';% - ended due to batteries
    datafile{3}    = '16_12_17__13_44_21';% - early (near) collision followed by successful flight ended due to battery drainage
    datafile{4}    = '16_12_17__14_06_07';% - ended early due to collision.. like.. really early
    IDlist = [201 202];
else
    datafile{1}    = '16_12_17__15_07_31';% - early collision in corner
    datafile{2}    = '16_12_17__15_21_23';% - lasted quite a long time! video is shorted due to low battery. No collisions. Flight ended due to low battery.
    datafile{3}    = '16_12_19__10_28_52';% - corner collision after about 2 and a half minutes
    datafile{4}    = '16_12_19__10_40_21';% - corner collision after about 1 and half minutes
    IDlist = [200 201 202];
end

msgn{1}.name = 'RAFILTERDATA';
msgn{2}.name = 'ROTORCRAFT_FP';
msgn{3}.name = 'ROTORCRAFT_STATUS';
msgn{4}.name = 'OPTIC_FLOW_EST';
msgn{5}.name = 'GPS_INT';

msg          = cell(1,numel(datafile));

for i = 1:numel(datafile)
    msg{i} = getmsgdata(msgn, ['logs_autonomous_final/',datafile{i}]);
end

%% Separate the logs from the different MAVs based on the IDs

nuavs  = length(IDlist);

ml     = 1:nuavs;
uav    = cell(1,numel(datafile));
uavof    = cell(1,numel(datafile));
uavgps    = cell(1,numel(datafile));
time    = cell(1,numel(datafile));

rfd         = msg_RAFILTERDATA_bounds();
[fp,fpscal] = msg_ROTORCRAFT_FP_bounds();
rIDs        = createallIDXcombinations( nuavs, 'relativefirst' );

for m = 1:numel(datafile)
    uav{m} = cell(nuavs,nuavs);
    uavof{m} = cell(nuavs,nuavs);
    uavgps{m} = cell(nuavs,nuavs);
    
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            IDs_own = cell2mat(msg{m}{1}.content(:,rfd.ID   ));
            IDs_oth = cell2mat(msg{m}{1}.content(:,rfd.IDoth));
            pown   = find(IDs_own == IDlist(i));
            poth   = find(IDs_oth == IDlist(j));
            p      = intersect(pown,poth);
            
            uav{m}{i,j} = msgtostruct(msg{m}{1}, msg_RAFILTERDATA_bounds_new, p, uav{m}{i,j});
            uav{m}{i,j} = clearnonmonotonicmembers(uav{m}{i,j});
            
            time{m} = uav{m}{1,2}.time;
            
            uav{m}{i,j}.x = interp1( uav{m}{i,j}.time ,uav{m}{i,j}.x, time{m}, 'linear','extrap');
            uav{m}{i,j}.pos = interp1( uav{m}{i,j}.time ,uav{m}{i,j}.pos, time{m}, 'linear','extrap');
            
        else
            % GET REAL DATA
            
            p = findpointswithID(msg{m}{2},IDlist(i));
            uav{m}{i,i} = msgtostruct(msg{m}{2}, msg_ROTORCRAFT_FP_bounds, p, uav{m}{i,i});
            
            uav{m}{i,i}.gt(:,1:2) = uav{m}{i,i}.gt(:,1:2).*fpscal.position;
            uav{m}{i,i}.gt(:,3:4) = uav{m}{i,i}.gt(:,3:4).*fpscal.velocity;
            uav{m}{i,i}.gt(:,  5) = uav{m}{i,i}.gt(:,  5).*fpscal.attitude;
            uav{m}{i,i}.gt(:,  6) = uav{m}{i,i}.gt(:,  6).*fpscal.position;
            uav{m}{i,i}.z (:,1)   = uav{m}{i,i}.z (:,1)  .*fpscal.position;
            
            uav{m}{i,i} = clearnonmonotonicmembers(uav{m}{i,i},0.1,'time'); % do about half of period % TODO: This could also be extracted automatically
            uav{m}{i,i}.gt = interp1( uav{m}{i,i}.time ,uav{m}{i,i}.gt, time{m}, 'linear','extrap');
        end
        
    end
    
end
disp('Done first phase')
%
for m = 1:numel(datafile)
    
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            % Construct the reference (perfect) output of the EKF
            uav{m}{i,i}.gt(:,[2 1]) = uav{m}{i,j}.pos(:,[1 2]);
            uav{m}{i,j}.realx(:,1:2) = uav{m}{j,i}.pos(:,[1 2]) - uav{m}{i,j}.pos(:,[1 2]);
            uav{m}{i,j}.realx(:,3:4) = uav{m}{i,i}.gt(:,[4 3]);
            uav{m}{i,j}.realx(:,5:6) = uav{m}{j,j}.gt(:,[4 3]);
            uav{m}{i,j}.realx(:,  7) = uav{m}{j,j}.gt(:,6) - uav{m}{i,i}.gt(:,6);
        end
        
    end
    
end
disp('Done second phase')

%
sp = cell(1,numel(datafile));
ep = cell(1,numel(datafile));

for m = 1:numel(datafile)
    [startpoints, endpoints] = getnavstartpoints(time{m}, msg{m}{3},'guided');
    flight           = 1; % select the first flight
    [ sp{m}, ep{m} ]  = selectflight( startpoints, endpoints, flight );
    
end

as = 2;

dmat       = cell(1,numel(datafile));
errmat     = cell(1,numel(datafile));
meanerr    = cell(1,numel(datafile));
dispersion = cell(1,numel(datafile));

for m = 1:numel(datafile)
    dmat{m} = zeros(ep{m}-sp{m}+1,factorial(nuavs));
    errmat{m} = zeros(ep{m}-sp{m}+1,factorial(nuavs));
    cc = 1;
    
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            
            uav{m}{i,j}.error   = mag(uav{m}{i,j}.realx(sp{m}:ep{m},1:2) - uav{m}{i,j}.x(sp{m}:ep{m},1:2),'row');
            uav{m}{i,j}.dist    = mag(uav{m}{i,j}.realx(sp{m}:ep{m},1:2),'row');
            
            uav{m}{i,j}.bearing = cart2pol(uav{m}{i,j}.realx(sp{m}:ep{m},2),    uav{m}{i,j}.realx(sp{m}:ep{m},1));
            
            uav{m}{i,j}.bearing_est    = cart2pol(uav{m}{i,j}.x(sp{m}:ep{m},2), uav{m}{i,j}.x(sp{m}:ep{m},1));
            
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

disp('Done')

%%

rrm = 0;
brm = 0;
cc = 1;
% corresponds to figure 17 on paper
if nuavs == 3
    newfigure(6868,'','Fig19b');
elseif nuavs == 2
    newfigure(6868,'','Fig19a');
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
            plot(time{m}(sp{m}:ep{m})-time{m}(sp{m}),uav{m}{i,j}.bearing_error)
        end
    end
end

ylabel('Bearing Error $[rad]$')
xlabel('Time [s]')

ylim([-pi pi])
ax = gca;

if nuavs == 3
    xlim([0 200])
    ax.XTick = [0:50:200];
    
elseif nuavs == 2
    xlim([0 500])
    ax.XTick = [0:50:500];
end

ax.YTick = [-pi -pi/2 0 pi/2 pi];
ax.YTickLabel = {'$-\pi$','$-\pi/2$','0','$\pi/2$','$\pi$'};
ylim([-pi pi]);

newfigure(6969.'','');
hold on
cc = 1;
for m = 1:numel(datafile)
    
    for idn = 1:length(rIDs)
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            rm(cc) = mean(uav{m}{i,j}.dist_error);
            rs(cc) = std (uav{m}{i,j}.dist_error);
            rrm(cc) = rmse(uav{m}{i,j}.dist_error);
            cc = cc +1;
            plot(time{m}(sp{m}:ep{m})-time{m}(sp{m}),uav{m}{i,j}.dist_error)
        end
    end
end

ylim([-4 4])
ax = gca;
ax.YTick = [-4:1:4];

if nuavs == 3
    xlim([0 200])
    ax.XTick = [0:50:200];
    
elseif nuavs == 2
    xlim([0 500])
    ax.XTick = [0:50:500];
end

ylabel('Range Error $[m]$')
xlabel('Time [s]')
disp(['Root mean squared error Range:',num2str(mean(rrm))])
disp(['Root mean squared error Bearing:',num2str(mean(brm))])

mean(bs)
mean(rs)

% Only the bearing error is saved
latex_printallfigures(get(0,'Children'), 'figures/', 'paper_ultrawide_third',[6868])


%%
combineddata_autonomous_bearingerror = [];

for m = 1:numel(datafile)
    for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            combineddata_autonomous_bearingerror = [combineddata_autonomous_bearingerror; uav{m}{i,j}.bearing_error];
        end
    end
end

cc = 1;
combineddata_autonomous_rangeerror = [];

for m = 1:numel(datafile)
    
   for idn = 1:length(rIDs);
        
        i = rIDs(idn,1);
        j = rIDs(idn,2);
        
        if i ~= j
            combineddata_autonomous_rangeerror = [combineddata_autonomous_rangeerror; uav{m}{i,j}.dist_error];
        end
    end
end
% save([datafolder,'/combineddata_autonomous_',num2str(nuavs)],'combineddata_autonomous_bearingerror','combineddata_autonomous_rangeerror')
% errstd