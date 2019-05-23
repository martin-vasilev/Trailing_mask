global Visual const Audio;


%% Visual settings:
Visual.resX= 1024; % horizontal screen resolution
Visual.resY= 768; % vertical screen resolution
Visual.frameRate= 100; % frame rate of monitor (not important here)
Visual.offsetX= 50; % horizontal sentence offset (in pixels)
Visual.offsetY= 178; % vertical sentence offset (in pixels); %Visual.resY/2
Visual.lineSpan= 68; % vertical length of each line of text (in pixels)
Visual.LineBndOffset= 150; % offset of rectangle to be printed in the data
Visual.sentPos= [Visual.offsetX Visual.offsetY];
Visual.FGC= [0 0 0]; % stimuli colour (black)
Visual.BGC= [255 255 255]; % background colour (white)
Visual.Pix_per_Letter= 11; % letter width in pixels
Visual.FontSize= 14; % 18pt: ppl 14; 16pt: 13ppl; 14pt: 11ppl

Visual.Font= 'Courier New';
%Visual.TextSize= 18; %
Visual.GazeBoxSize= 40; % size of the gaze box (in pixels)
Visual.GazeBoxColor= [0 0 0]; % color of the gaze box (black as default)
Visual.gazeBoxDur= 100; % how many ms the eye needs to stay on the gaze box before triggering it
Visual.gazeBoxDisplayTime= 7; % how many seconds to wait to trigger the gaze box

%% Experiment settings:
const.TrialTimeout= 60; % automatically terminates trial after x seconds
const.ncond= 8; % number of conditions (not currently in use)
const.Maxtrials= 24; % number of experimental trials (not in use)
const.soundDur= 0.06; % min duration between playing 2 sounds (in seconds)
const.repetitons=1; % how many times to play sounds
const.seeEye= false; % if true, shows gaze position as a dot on the screen (for testing ONLY!!)
const.maxCross= 1800; % what is the max location for crossing a gaze-contingent boundary?
% this helps with blinks triggering the changes (sometimes)
const.lineCheck= 3; % fixation check offset for each line (in chars)
const.lineCheckWidth= 1.5; % fixation check width (in chars)
const.playSound= true; % play sounds in experiment?

const.checkPPL= false;  % if true, draws a rectangle around sentence to make sure letter width is correct
const.expName = 'TM'; % used for saving data (keep at <= 5 letters)
const.caltype= 'HV9'; % calibration type; use 'HV9' for 9-point and 'H3' for 3-point grid
const.saccvelthresh = 35;% degrees per second, saccade velocity threshold (don't change)
const.saccaccthresh = 9500; % degrees per second, saccade acceleration threshold (don't change)
const.sampingRate= 1000; % (don't change unless you know what you are doing)
