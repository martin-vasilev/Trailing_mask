global const Visual sent Monitor el Gaze; 

%const.ntrials=1; % TEMPORARY!!! for testing

HideCursor;

% Calibrate the eye tracker
EyelinkDoTrackerSetup(el);

%% For BlackBoxToolKit testing
%s= serial('COM11');
%set(s, 'BaudRate', 115200, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none')
%fopen(s);
%fprintf(s, 'RR');
%fprintf(s,'FF');


for i=1:const.ntrials
    
    % initialize variables:
    Gaze.trialEnd= false; 
	item= design.item(i);
    Gaze.xCrit= 200;
    Gaze.item= item;
    mask= design.mask(i);
    Gaze.parsed= false;
    
    if strcmp(char(design.mask(i)), 'no') % normal reading
        % condition:
        if strcmp(char(design.sound(i)), 'Silence')
            if strcmp(char(design.diff(i)), 'easy')
                cond=1;
            else
                cond=3;
            end
        end   

        if strcmp(char(design.sound(i)), 'English')
            if strcmp(char(design.diff(i)), 'easy')
                cond=2;
            else
                cond=4;
            end
        end
    else % trailing mask condition
                % condition:
        if strcmp(char(design.sound(i)), 'Silence')
            if strcmp(char(design.diff(i)), 'easy')
                cond=5;
            else
                cond=7;
            end
        end   

        if strcmp(char(design.sound(i)), 'English')
            if strcmp(char(design.diff(i)), 'easy')
                cond=6;
            else
                cond=8;
            end
        end
    end
    
    if item> 24
        cond= 10;
    end
    
    % get sound handle:
    if const.playSound && strcmp(char(design.sound(i)), 'English')
        [y, freq] = audioread([cd '\sounds\' 'E' num2str(sent(item).English) '.wav']);
        playThis= y';
    end
    
        
    % get text coords:
    whichLine= 1;
    
    % sentence rectangle:
    for j= 1:sent(item).nlines
        if j==1
            sentRect(j,:)= [Visual.offsetX Visual.offsetY ...
            Visual.offsetX+ length(char(sent(item).lines(j)))* Visual.Pix_per_Letter ...
            Visual.offsetY+30];
        else
            sentRect(j,:)= [Visual.offsetX Visual.offsetY+(j-1)*Visual.lineSpan ...
            Visual.offsetX+ length(char(sent(item).lines(j)))* Visual.Pix_per_Letter ...
            Visual.offsetY+(j-1)*Visual.lineSpan+30];
        end
    end
    
    Gaze.sentRect= sentRect;
    
    Bnds= {};
    for j=1:sent(item).nlines
        Bnds{j}= getBnds(char(sent(item).lines(j)));
    end
    Bnds= Bnds';
    
    Gaze.Bnds= Bnds;

    %% drift check:
    % Always do a drift check before printing trial ID
    % Otherwise a bug in EyeDoctor will sometimes display trial as aborted
    % if the drift check itself was aborted
    EyelinkDoDriftCorrection(el);
    
    %% Trial presentation:
	stimuliOn= false;
    
    while ~stimuliOn
        if item> const.Maxtrials % if practice
            Eyelink('Message', ['TRIALID ' 'P' num2str(cond) 'I' num2str(item) 'D0']);
			% print trial ID on tracker screen:
            Eyelink('command', ['record_status_message ' [ num2str(i) ':' 'P' num2str(cond) 'I' num2str(item) 'D0']]);
        else
			Eyelink('Message', ['TRIALID ' 'E' num2str(cond) 'I' num2str(item) 'D0']);
			% print trial ID on tracker screen:
			Eyelink('command', ['record_status_message ' [num2str(i) ':' 'E' num2str(cond) 'I' num2str(item) 'D0']]); 
        end
        
        % print text stimuli to edf:
        %stim2edf(sent(item).lines);
        stim2edfML(sent(item).lines)
        
        % prepare Screens:
        if strcmp(design.mask(i), 'no')
            GazeCol= Visual.FGC;
        else
            GazeCol= [6 91 226];
        end
        
        
        Screen('FillRect', Monitor.buffer(1), GazeCol, [Visual.offsetX Visual.offsetY- Visual.GazeBoxSize/2 Visual.offsetX+Visual.GazeBoxSize ...
            Visual.offsetY+ Visual.GazeBoxSize]) % gazebox
        gazeBnds_x= [Visual.offsetX Visual.offsetX+Visual.GazeBoxSize];
		gazeBnds_y= [Visual.offsetY- Visual.GazeBoxSize/2 Visual.offsetY+ Visual.GazeBoxSize];
        
        % sentence:
        Screen('FillRect', Monitor.buffer(2), Visual.BGC);
        Screen('DrawText', Monitor.buffer(2), char(sent(item).lines(whichLine)), Visual.sentPos(1), Visual.sentPos(2), Visual.FGC); % sentence
        
        % fixation check at the end of the sentence
        for j=1:sent(item).nlines
            line_end(j)= Visual.offsetX + length(char(sent(item).lines(j)))* Visual.Pix_per_Letter+ ...
                  const.lineCheck*Visual.Pix_per_Letter;
            if j==1
                  lineCheckRect(j,:)= [line_end(j) Visual.offsetY ...
                  line_end(j)+ const.lineCheckWidth*Visual.Pix_per_Letter ...
                  Visual.offsetY+ const.lineCheckWidth*Visual.Pix_per_Letter];
            else
                  lineCheckRect(j,:)= [line_end(j) Visual.offsetY+(j-1)*Visual.lineSpan ...
                  line_end(j)+ const.lineCheckWidth*Visual.Pix_per_Letter ...
                  Visual.offsetY+(j-1)*Visual.lineSpan+ const.lineCheckWidth*Visual.Pix_per_Letter];
            end
        end
        
        Gaze.lineCheckRect= lineCheckRect;
        
        Screen('FillRect', Monitor.buffer(2), Visual.FGC, lineCheckRect(whichLine, :));
        
        if const.checkPPL
			lngth= length(char(sent(item).lines(whichLine)))*Visual.Pix_per_Letter;
            Screen('FrameRect', Monitor.buffer(2), Visual.FGC, [Visual.offsetX Visual.resY/2- Visual.GazeBoxSize/2 ...
                Visual.offsetX+lngth Visual.resY/2+ Visual.GazeBoxSize])
        end
        
        % Print stimuli to Eyelink monitor:
        for j= 1:sent(item).nlines
            Screen('DrawText', Monitor.buffer(3), char(sent(item).lines(j)), ...
                   sentRect(j,1), sentRect(j,2), Visual.FGC);
        end
        
        imageArray= Screen('GetImage', Monitor.buffer(3), [0 0 Visual.resX Visual.resY]);
        imwrite(imageArray, 'disp.bmp');
    
        Eyelink('Command', 'set_idle_mode');
        Eyelink('Command', 'clear_screen 0');
        status= Eyelink('ImageTransfer', 'disp.bmp', 0, 0, 0, 0,0, 0, 16);
        
        Eyelink('Command', ['draw_filled_box ' num2str(Visual.offsetX) ' ' num2str(Visual.resY/2- Visual.GazeBoxSize/2) ' ' ...
            num2str(Visual.offsetX+Visual.GazeBoxSize) ' ' num2str(Visual.resY/2+ Visual.GazeBoxSize/2) '3']);
        
        
        WaitSecs(0.1);
        Eyelink('StartRecording');
        
        %% Gaze box:
        Screen('CopyWindow', Monitor.buffer(1), Monitor.window);
        Screen('Flip', Monitor.window);
        Eyelink('Message', 'GAZE TARGET ON');
        gazeBoxTriggered=false;
		onTarget= false;
		gazeTimeOut= false;
		gazeStart= GetSecs;

        % loop that triggers the gaze-box
		while ~gazeBoxTriggered && ~onTarget
            evt= Eyelink('NewestFloatSample');
            x = evt.gx(2); 
            y = evt.gy(2);
			%sample= tracker.sample(); % get current eye position
			elapsedTime= GetSecs-gazeStart; % time since gaze box appeared
			onTarget= x>= gazeBnds_x(1) && x<= gazeBnds_x(2) && y>= gazeBnds_y(1) && y<= gazeBnds_y(2);
            
			if onTarget % the eye is on the gaze box
				WaitSecs(Visual.gazeBoxDur/1000);
				onTarget= x>= gazeBnds_x(1) && x<= gazeBnds_x(2) && y>= gazeBnds_y(1) && y<= gazeBnds_y(2);
				if onTarget % eye still on gaze box after x ms
					gazeBoxTriggered= true;
					stimuliOn= true;
					%tracker.send_command("clear_screen %d" % (0))
                else
					onTarget= false;
                end
            end
			
			if elapsedTime> Visual.gazeBoxDisplayTime % gaze box timeout
                Eyelink('Message', 'TRIAL ABORTED');
				Eyelink('StopRecording');
				EyelinkDoTrackerSetup(el);
				onTarget= true;
				gazeBoxTriggered= true;
            end
        end

		Eyelink('Message', 'GAZE TARGET OFF');
        Eyelink('Message', 'DISPLAY ON');
        Eyelink('Message', 'SYNCTIME');
        
    end
    
    %% Display stimuli:
    Gaze.clickMouse= 0;
    Screen('CopyWindow', Monitor.buffer(2), Monitor.window);
    Screen('Flip', Monitor.window);
	Gaze.trialStart= GetSecs;
    
    % play sound:
    if const.playSound && strcmp(char(design.sound(i)), 'English')
        %PsychPortAudio('Start', playThis, const.repetitons, 0, 1);
        Snd('Play', playThis);
    end
       
    while ~Gaze.trialEnd
        %Gaze.trialTime= GetSecs- Gaze.trialStart;
      %  if ~ Gaze.parsed
            parse_line(1, mask);
            parse_line(2, mask);
            parse_line(3, mask);
            parse_line(4, mask);
            parse_line(5, mask);
            parse_line(6, mask);
            if sent(item).nlines>6
                parse_line(7, mask);
            end

            if sent(item).nlines>7
                parse_line(8, mask);
            end
            Gaze.parsed= true;
     %   end        
        
        Gaze.trialEnd=true;
        
    end
     
    if ~Gaze.clickMouse
       while ~Gaze.clickMouse
          [x,y,buttons] = GetMouse(Monitor.window);
          Gaze.trialTime= GetSecs- Gaze.trialStart;
          Gaze.clickMouse= buttons(1); %KbCheck; % TEMPORARY
          if Gaze.trialTime> const.TrialTimeout
              %Gaze.trialEnd=true;
              Gaze.clickMouse=1;
          end
       end
    end
    %% End of trial:
    % stop sound:
    if const.playSound && strcmp(char(design.sound(i)), 'English')
        %PsychPortAudio('Stop', playThis);
        Snd('Quiet');
    end
    
    Screen('FillRect', Monitor.window, Visual.BGC); % clear subject screen
    Screen('FillRect', Monitor.buffer(3), Visual.BGC); % clear subject screen
    Screen('Flip', Monitor.window);
    Eyelink('command', 'clear_screen 0'); % clear tracker screen
	
    WaitSecs(0.5);
    
	% end of trial messages:
    Eyelink('Message', 'ENDBUTTON 5');
    Eyelink('Message', 'DISPLAY OFF');
    Eyelink('Message', 'TRIAL_RESULT 5');
    Eyelink('Message', 'TRIAL OK');

    Eyelink('StopRecording');
    
    
%     %% Questioms:
    if strcmp(char(design.diff(i)), 'easy')
        % Q1:
        Question(sent(item).EQ1, sent(item).EQ1_ans, item, cond, 1);
        % Q2:
        Question(sent(item).EQ2, sent(item).EQ2_ans, item, cond, 2);
    else
        % Q1:
        QuestionMC(sent(item).DQ1, strsplit(sent(item).DQ1_opts, '/n'), ...
        sent(item).DQ1_ans, item, cond, 1);
        % Q2:
        QuestionMC(sent(item).DQ2, strsplit(sent(item).DQ2_opts, '/n'), ...
        sent(item).DQ2_ans, item, cond, 2);
    end
   
end