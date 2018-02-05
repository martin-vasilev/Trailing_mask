function [] = stim2edfML(sentenceString)
%stim2edf Prints sentence to edf
%   Detailed explanation goes here

global Visual;
    
    %% Multiple line stims:
    
    char_count= 0;
    linespan= 67;
    x_start= [];
    x_end= [];
    y_start= Visual.LineBndOffset;
    y_end= Visual.LineBndOffset+linespan;
    
    Eyelink('Message', 'DISPLAY TEXT 1');

    for i=1:length(sentenceString) % for each line..
        if i>1
            y_start= y_start+ linespan+1;
            y_end= y_end+ linespan+1;
        end
        string= sentenceString{i};
        
        for j=1:length(string) % for each letter
            if j==1
                x_start(j)= Visual.sentPos(1);
		        x_end(j)= Visual.sentPos(1)+ Visual.Pix_per_Letter;
            else
                x_start(j)= x_end(j-1);
		        x_end(j)= x_end(j-1)+ Visual.Pix_per_Letter;
            end
            
                Eyelink('Message', ['REGION CHAR ' num2str(char_count) ' 1 ' string(j) ...
                    ' ' num2str(x_start(j)) ' ' num2str(y_start) ...
                    ' ' num2str(x_end(j)) ' ' num2str(y_end)]);
                WaitSecs(0.001); % wait time for consitency purposes with Eyetrack
                Eyelink('Message', 'DELAY 1 MS');
                char_count= char_count+1;
       end
    end
    

end % function end

