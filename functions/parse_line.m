function [outcome] = parse_line(whichLine, mask)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    global Gaze Monitor Visual sent const;
    
    %whichLine= 1;
    Gaze.maxWord= 0;
    Gaze.B= Gaze.Bnds{whichLine,:};
    lineEnd= 0;
    x_feed= [0,0,0,0,0,0];
    y_feed= [0,0,0,0,0,0];
    xTrig= 0;
    left= [];
    onLine= 0;
    
    if whichLine==1
        %%
        while ~lineEnd
            
        Gaze.trialTime= GetSecs- Gaze.trialStart;
        if Gaze.trialTime> const.TrialTimeout % end trial automatically if no response by participant
             Gaze.trialEnd= true;
             lineEnd= 1;
             Gaze.clickMouse=1;
        end
        
        % Eyetrack samples:
        evt= Eyelink('NewestFloatSample');
        xpos = evt.gx(2);
        y = evt.gy(2);
        
        checkCross= xpos> Gaze.B;
        whichCrossed= find(checkCross==1);
        
        if ~ isempty(whichCrossed)
            whichCrossed= whichCrossed(end);
            
            if whichCrossed>Gaze.maxWord
                if strcmp(mask, 'yes')
                    letter_mask(Gaze.B, whichLine, whichCrossed, Gaze.sentRect, Gaze.item);
                end
                %letter_mask(Gaze.B, whichLine, whichCrossed, Gaze.sentRect, Gaze.item);
                Gaze.maxWord= whichCrossed;
            end
            
            if whichCrossed== length(Gaze.B)
                Eyelink('Message',sprintf('LINE CHECK REGION %i %i %i %i', ...
                Gaze.lineCheckRect(whichLine,:)));
                Eyelink('Message', ['LINE ' num2str(whichLine) ' CROSS' ' STARTED']);
                Screen('FillRect', Monitor.buffer(2), Visual.BGC, Gaze.lineCheckRect(whichLine, :));
                
                Screen('DrawText', Monitor.buffer(2), char(sent(Gaze.item).lines(whichLine+1)), ...
                Gaze.sentRect(whichLine+1,1), Gaze.sentRect(whichLine+1,2), Visual.FGC);
                Screen('FillRect', Monitor.buffer(2), Visual.FGC, Gaze.lineCheckRect(whichLine+1, :));
                Screen('CopyWindow', Monitor.buffer(2), Monitor.window);

                Screen('Flip', Monitor.window);
                Eyelink('Message', ['LINE ' num2str(whichLine) ' CROSS' ' COMPLETED']);
                
                lineEnd= 1;
                outcome=1;
                WaitSecs(0.5);
            end
            
        end
        
        end

    else
            %%
        while ~lineEnd
        
        Gaze.trialTime= GetSecs- Gaze.trialStart;
        if Gaze.trialTime> const.TrialTimeout % end trial automatically if no response by participant
             Gaze.trialEnd= true;
             lineEnd= 1;
             Gaze.clickMouse=1;
        end    
            
        % Eyetrack samples:
        evt= Eyelink('NewestFloatSample');
        xpos = evt.gx(2);
        y = evt.gy(2);
 
        % keep track of previous samples:
        x_feed= [x_feed, xpos];
        y_feed= [y_feed, y];
 
        % keep feed from growing infinitely large:
        if length(x_feed)>30 % cut off sample feed at 10
            x_feed= x_feed(2:31);
        end
        
        if length(y_feed)>30
            y_feed= y_feed(2:31);
        end
         
        if x_feed(end)-x_feed(length(x_feed)-5) >0.3
           left= 1; % eye is moving leftwards
        else
           left= 0; % eye is moving rightwards
        end
        
        if xpos< Gaze.xCrit && ~left
             xTrig=1;
             y_feed= [0,0,0,0,0,0];
        end
        
        if IsInRect(xpos, mean(y_feed),[0, Gaze.sentRect(whichLine, 2)-28-50, Visual.resX, Gaze.sentRect(whichLine, 4)+9+50])
            onLine=1;
        else
            onLine=0;
        end

        
        checkCross= xpos> Gaze.B;
        whichCrossed= find(checkCross==1);
        
        if ~ isempty(whichCrossed) && xTrig && left && onLine
            whichCrossed= whichCrossed(end);
            
            if whichCrossed>Gaze.maxWord
                if strcmp(mask, 'yes')
                    letter_mask(Gaze.B, whichLine, whichCrossed, Gaze.sentRect, Gaze.item);
                end
                Gaze.maxWord= whichCrossed;
            end
            
            if whichCrossed== length(Gaze.B)
                Eyelink('Message',sprintf('LINE CHECK REGION %i %i %i %i', ...
                Gaze.lineCheckRect(whichLine,:)));
                Eyelink('Message', ['LINE ' num2str(whichLine) ' CROSS' ' STARTED']);
                Screen('FillRect', Monitor.buffer(2), Visual.BGC, Gaze.lineCheckRect(whichLine, :));
                
                if whichLine+1<= sent(Gaze.item).nlines
                    Screen('DrawText', Monitor.buffer(2), char(sent(Gaze.item).lines(whichLine+1)), ...
                    Gaze.sentRect(whichLine+1,1), Gaze.sentRect(whichLine+1,2), Visual.FGC);
                    
                        Screen('FillRect', Monitor.buffer(2), Visual.FGC, Gaze.lineCheckRect(whichLine+1, :));
                   % end
                    
                end
                

                Screen('CopyWindow', Monitor.buffer(2), Monitor.window);

                Screen('Flip', Monitor.window);
                Eyelink('Message', ['LINE ' num2str(whichLine) ' CROSS' ' COMPLETED']);
                
                lineEnd= 1;
                outcome=1;
                if whichLine == sent(Gaze.item).nlines
                    Screen('FillRect', Monitor.buffer(2), Visual.BGC, Gaze.lineCheckRect(whichLine, :));
                end
                %WaitSecs(0.5);
            end
            
        end
        
        end
   
    end
    
    

    
end

