function ExpSetup
global Visual const Monitor el Audio;

% get participant number:
const.ID= input('Please enter participant number: ');
const.edffilename= [const.expName '' num2str(const.ID) '' '.edf'];
 if exist(const.edffilename, 'file')==2 %check if file already exists
     error('Participant file already exists!');
 end

%% Open screen
oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
	
% Find out how many screens and use largest screen number.
whichScreen = max(Screen('Screens'));

% Setup window:
Monitor.window = Screen('OpenWindow', whichScreen);
Screen(Monitor.window, 'TextSize', Visual.FontSize);
Screen(Monitor.window, 'TextFont', Visual.Font);
Screen(Monitor.window, 'TextStyle', 0); % normal
Screen('FillRect', Monitor.window, Visual.BGC);
Screen('Flip', Monitor.window);

for i=1:3
   Monitor.buffer(i)= Screen(Monitor.window, 'OpenOffscreenWindow');
end

for i=1:3
   Screen(Monitor.buffer(i), 'TextSize', Visual.FontSize);
   Screen(Monitor.buffer(i), 'TextFont', Visual.Font);
   Screen(Monitor.buffer(i), 'TextStyle', 0); % normal
end
%% Open Eyelink connection:
dummymode=0;
el=EyelinkInitDefaults(Monitor.window);

% Initialization of the connection with the Eyelink Gazetracker.
% exit program if this fails.
if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    cleanup;  % cleanup function
    return;
end

% open file to record data to
Eyelink('openfile', const.edffilename);

%% Eyelink setup:
% log some details to EDF file:
Eyelink('Message', ['DISPLAY COORDS ' num2str(0) ' ' num2str(0) ' ' num2str(Visual.resX-1) ' ' num2str(Visual.resY-1)]);
Eyelink('Message', ['FRAMERATE ' num2str(Visual.frameRate)]);

% send commands to tracker:
Eyelink('command', ['screen_pixel_coords = 0 0 ' num2str(Visual.resX-1) ' ' num2str(Visual.resY-1)]);
Eyelink('command', ['saccade_velocity_threshold = ' num2str(const.saccvelthresh)]);
Eyelink('command', ['saccade_acceleration_threshold = ' num2str(const.saccaccthresh)]);
Eyelink('command', ['calibration_type= ' '' const.caltype]);
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON');
Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,HTARGET');
Eyelink('command', ['sample_rate= ' num2str(const.sampingRate)]);


%% Sounds set-up:
% if const.playSound
%     InitializePsychSound;
%     % PsychPortAudio('Open', 2, 2, 2, 48000, 2)
%     
%     % Noise:
%     [y, freq] = audioread([cd '\sounds\' 'noise.wav']);
%     wavedata = y';
%     nrchannels = size(wavedata,1); % Number of rows == number of channels.
%     
%     Audio.pamaster = PsychPortAudio('Open', [], 1+8, 1, [], nrchannels);
%     PsychPortAudio('Volume', Audio.pamaster, 1);
%     PsychPortAudio('Start', Audio.pamaster, 0, 0, 1);
% 
%     %% create slaves:
%     % Noise:
%     Audio.Noise = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     
%     Audio.English1 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.English2 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.English3 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.English4 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.English5 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.English6 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     
%     Audio.Mandarin1 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.Mandarin2 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.Mandarin3 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.Mandarin4 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.Mandarin5 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     Audio.Mandarin6 = PsychPortAudio('OpenSlave', Audio.pamaster, 1, nrchannels);
%     
%     %% Fill buffers:
%     PsychPortAudio('FillBuffer', Audio.Noise, wavedata); % Noise
%     
%     % English
%     for i= 1:6
%         [y, freq] = audioread([cd '\sounds\' 'E' num2str(i) '.wav']);
%         wavedata = y';
%         PsychPortAudio('FillBuffer', eval(['Audio.English' num2str(i)]), wavedata);
%     end
%     
%     % Mandarin
%     for i= 1:6
%         [y, freq] = audioread([cd '\sounds\' 'M' num2str(i) '.wav']);
%         wavedata = y';
%         PsychPortAudio('FillBuffer', eval(['Audio.Mandarin' num2str(i)]), wavedata);
%     end 
% 
% end
 