%% plotevolutions

if estimatePn
    est = '_estonline';
    count = newfigure(count,'add',['PnEstimate_',estimator,'_avgover',num2str(runs),'runs_',day,set,est]);
    
    toplim = -30;
    
    plot(time,Pnstore,'-');
    
    xlabel('Time [s]')
    ylabel('P_n estimate [dB]')
    xlim([0 time(end)])
    ylim([-80 toplim])
    text(50,toplim-5,['P_n nominal: ',num2str(Pld(1),'%2.1f')])
    text(50,toplim-8,['P_n achieved (mean): ',num2str(mean(Pnstore(end,:)),'%2.1f')])
    text(50,toplim-11,['P_n initial: ',num2str(mean(Pmod0(1)),'%2.1f')])

    count = newfigure(count,'add',['gammaEstimate_',estimator,'_avgover',num2str(runs),'runs_',day,set,est]);
    
    plot(time,gammalstore,'-');
    
    xlabel('Time [s]')
    ylabel('\gamma_l [-]')
    xlim([0 time(end)])
    toplim = round(max(gammalstore(:)),2)+0.1;
    ylim([round(min(gammalstore(:)),1)-0.1, toplim])
    text(time(end)/2,toplim - 0.1 ,['\gamma_l nominal: ',num2str(Pld(2),'%2.1f')])
    text(time(end)/2,toplim - 0.15,['\gamma_l achieved (mean): ',num2str(mean(gammalstore(end,:)),'%2.1f')])
    text(time(end)/2,toplim - 0.2 ,['gamma_l initial: ',num2str(mean(Pmod0(2)),'%2.1f')])    
else
    est = '';
end
