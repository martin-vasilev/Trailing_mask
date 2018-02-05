global const Visual sent Monitor el; 

const.ntrials=1; % TEMPORARY!!! for testing

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
    
    letters_mask= '';
    masked_string= '';
    B= [];
    checkCross= [];
    whichCrossed= [];
    
    trialEnd= false; 
	item= design.item(i);
	
	% condition:
    if strcmp(char(design.sound(i)), 'Silence')
        if strcmp(char(design.diff(i)), 'easy')
            cond=1;
        else
            cond=5;
        end
    end
    
    if strcmp(char(design.sound(i)), 'Noise')
        if strcmp(char(design.diff(i)), 'easy')
            cond=2;
        else
            cond=6;
        end
    end    
    
    if strcmp(char(design.sound(i)), 'Mandarin')
        if strcmp(char(design.diff(i)), 'easy')
            cond=3;
        else
            cond=7;
        end
    end
    
    if strcmp(char(design.sound(i)), 'English')
        if strcmp(char(design.diff(i)), 'easy')
            cond=4;
        else
            cond=8;
        end
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
  
	%sentenceString= char(sent(item).lines(whichLine));
    %spaces= strfind(char(sent(item).lines(whichLine)), ' ');

    % get word boundaries:
    %Bnds= getBnds(char(sent(item).lines(whichLine)));
    
    Bnds{1,:}= getBnds(char(sent(item).lines(1)));
    for j=2:sent(item).nlines
        Bnds{j,:}= getBnds(char(sent(item).lines(j)));
    end
    
    % boundary crossed?
    BndCrossed= zeros(1, length(cell2mat(Bnds(whichLine,:))));
    
    % line check triggered?
    LineCheckTriggered= zeros(1, sent(item).nlines);
    
    % drift check:
    % Always do a drift check before printing trial ID
    % Otherwise a bug in EyeDoctor will sometimes display trial as aborted
    % if the drift check was aborted
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
        Screen('FillRect', Monitor.buffer(1), Visual.FGC, [Visual.offsetX Visual.offsetY- Visual.GazeBoxSize/2 Visual.offsetX+Visual.GazeBoxSize ...
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
        
        %line_end= Visual.offsetX + length(char(sent(item).lines(whichLine)))* Visual.Pix_per_Letter+ ...
        %    const.lineCheck*Visual.Pix_per_Letter;

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
        
        imageArray= Screen('GetImage', Monitor.buffer(3), [0 0 1024 768]);
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
    Screen('CopyWindow', Monitor.buffer(2), Monitor.window);
    Screen('Flip', Monitor.window);
	trialStart= GetSecs;
       
    while ~trialEnd
        trialTime= GetSecs- trialStart;
        [x, y, buttons] = GetMouse(Monitor.window);
        trialEnd= buttons(1); %KbCheck; % TEMPORARY
        
        evt= Eyelink('NewestFloatSample');
        xpos = evt.gx(2);
        
        if const.seeEye % for testing ONLY (see the position of your eye as a dot)
            Screen('FillRect', Monitor.window, Visual.BGC);
            Screen('DrawText', Monitor.window, char(sent(item).lines(whichLine)), Visual.sentPos(1), Visual.sentPos(2), Visual.FGC); % sentence
            Screen('DrawDots', Monitor.window, [xpos, 540], 10, [0 0 0], [],2);
            Screen('Flip', Monitor.window);
        end
        
        %% Gaze-contingent manipulation:
        % Display line check:
        
        if IsInRect(xpos,lineCheckRect(whichLine, 2)+1, lineCheckRect(whichLine, :)) && ~LineCheckTriggered(whichLine) && whichLine< sent(item).nlines
            Eyelink('Message',sprintf('LINE CHECK REGION %i %i %i %i', ...
            lineCheckRect(whichLine,:)));
            Eyelink('Message', ['LINE CROSS ' num2str(whichLine) ' STARTED']);
            LineCheckTriggered(whichLine)= 1;
            Screen('FillRect', Monitor.buffer(2), Visual.BGC, lineCheckRect(whichLine, :));
            
            whichLine= whichLine+1;
            
            if whichLine ~= sent(item).nlines
                Screen('FillRect', Monitor.buffer(2), Visual.FGC, lineCheckRect(whichLine, :));
            end
            
            BndCrossed= zeros(1, length(cell2mat(Bnds(whichLine,:))));
            
            Screen('DrawText', Monitor.buffer(2), char(sent(item).lines(whichLine)), ...
                   sentRect(whichLine,1), sentRect(whichLine,2), Visual.FGC);
            Screen('CopyWindow', Monitor.buffer(2), Monitor.window);
            Screen('Flip', Monitor.window);
            Eyelink('Message', ['LINE CROSS ' num2str(whichLine) ' COMPLETED']);
        end
        
        B= Bnds{whichLine,:};
        checkCross= xpos> B;
        whichCrossed= find(checkCross==1);


        if ~ isempty(whichCrossed)
            whichCrossed= whichCrossed(end);
            
            if BndCrossed(whichCrossed)==0 % if boundary is not yet crossed
               Eyelink('Message', ['DC STARTED L' ...
                   num2str(whichLine) ' W' num2str(whichCrossed) ...
                   ' @ ' num2str(B(whichCrossed))]);
               if whichCrossed ~= length(B)
                   letters_mask= (B(whichCrossed)- Visual.offsetX-1)/ Visual.Pix_per_Letter;
                   masked_string= char(sent(item).lines(whichLine));
                   masked_string(1:letters_mask)='x';
                   masked_string(strfind(char(sent(item).lines(whichLine)), ' '))= ' ';
               else
                   masked_string= char(sent(item).lines(whichLine));
                   masked_string(1:end)='x';
                   masked_string(strfind(char(sent(item).lines(whichLine)), ' '))= ' ';
               end
               
               
               %Screen('FillRect', Monitor.window, Visual.BGC, sentRect(whichLine,:));
               %Screen('DrawText', Monitor.window, masked_string, ...
                %   sentRect(whichLine,1), sentRect(whichLine,2), Visual.FGC); % sentence
               %Screen('Flip', Monitor.window)
               
               %Screen('FillRect', Monitor.buffer(2), Visual.BGC);
               %Screen('FillRect', Monitor.buffer(2), Visual.FGC, lineCheckRect);
               Screen('FillRect', Monitor.buffer(2), Visual.BGC, sentRect(whichLine,:));
               Screen('DrawText', Monitor.buffer(2), masked_string, ...
                   sentRect(whichLine,1), sentRect(whichLine,2), Visual.FGC); % sentence
               Screen('CopyWindow', Monitor.buffer(2), Monitor.window)%, ...
                   %sentRect(whichLine, :), sentRect(whichLine, :));
               Screen('Flip', Monitor.window);
               Eyelink('Message', ['DC COMPLETED L' ...
                   num2str(whichLine) ' W' num2str(whichCrossed) ...
                   ' @ ' num2str(B(whichCrossed))]);
               
               % mark boundary as crossed
               BndCrossed(whichCrossed)=1;
            end
        end
        
        
        %% check trial end:
        if trialTime> const.TrialTimeout % end trial automatically if no response by participant
             trialEnd= true;
             %tracker.log('TRIAL ABORTED')
 			 Screen('FillRect', Monitor.window, Visual.BGC); % clear subject screen
             Screen('Flip', Monitor.window);
        end
        
     end
    %% End of trial:
    Screen('FillRect', Monitor.window, Visual.BGC); % clear subject screen
    Screen('Flip', Monitor.window);
    Eyelink('command', 'clear_screen 0'); % clear tracker screen
	
	% end of trial messages:
    Eyelink('Message', 'ENDBUTTON 5');
    Eyelink('Message', 'DISPLAY OFF');
    Eyelink('Message', 'TRIAL_RESULT 5');
    Eyelink('Message', 'TRIAL OK');

    Eyelink('StopRecording');
    
    
%     %% Questioms:
%     if cell2mat(hasQuest(item))==1
%         answer= Question(char(quest(item)), corr_ans(item), item, cond);
%     end
%     
    
end