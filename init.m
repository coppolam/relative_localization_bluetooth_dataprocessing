%% Initialization script used in all main files
%
% Mario Coppola, 2019

clear; close all; clc;
addpath(genpath(pwd)); % Add all paths
rng('shuffle'); % Shuffle random seed
format compact;
set(0, 'defaulttextinterpreter', 'latex'); % Needed for plot printing to LaTex

if exist('figures', 'dir')
       mkdir('figures/')
end
    
% Colorlist
colorlist{1} = 'b';
colorlist{2} = 'r';
colorlist{3} = 'k';
colorlist{4} = 'm';
colorlist{5} = [0 .5 0];
colorlist{6} = 'c';
colorlist{7} = 'y';

% Typelist
typelist{1} = 'o';
typelist{2} = 'x';
typelist{3} = 's';
typelist{4} = 'd';
typelist{5} = '^';
typelist{6} = 'v';
typelist{7} = 'p';

% Linelist
linelist{1} = '-';
linelist{2} = '--';
linelist{3} = '-.';
linelist{4} = ':';

count = 0;
ranitalready = 0;
