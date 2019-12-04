%% Printoutputs

if k < N
    ds1 = sprintf('Step %d \tPercentage %2.2f %', k, k/N*100);
    ds2 = sprintf('\t Pn = %2.2f', Pn);
    ds4 = sprintf('\t gamma = %2.2f',gamma_l);
    ds3 = sprintf('\t RSSIvar. = %2.2f', R(1,1));
    
else
    
    ds1 = sprintf('\nFinished Run %d out of %d ', ii , runs);
    ds2 = sprintf('\n\t Pn = %2.2f', Pn);
    ds4 = sprintf('\n\t gamma = %2.2f',gamma_l);
    ds3 = sprintf('\n\t RSSIvar. = %2.2f', R(1,1));
    
end

    disp([ds1,ds2,ds4,ds3]);
    
