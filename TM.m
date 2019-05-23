% Auditory distraction in the absence of re-reading. Re-reading is prevented
% with a gaze-contingent trailing mask (a la Schotter et al., 2014).

% Martin R. Vasilev, 2018

global const; 

%% settings:
clear all;
clear mex;
clear functions;

cd('C:\Documents and Settings\psychadmin\Desktop\Martin Vasilev\Trailing mask_103')
%cd('C:\Users\EyeTracker\Desktop\Martin Vasilev\Trailing mask_103')
addpath([cd '\functions'], [cd '\corpus'], [cd '\design'], [cd '\sounds']);

settings; % load settings
ExpSetup; % do window and tracker setup

%% Load stimuli and design:
importDesign;
load('sent.mat');
%load('quest.mat');
%load('hasQuest.mat');
%load('corr_ans.mat');
const.ntrials= height(design);

%% Run Experiment:
runTrials;

%% Save file & Exit:
status= Eyelink('ReceiveFile');
Eyelink('Shutdown');

Screen('CloseAll');
