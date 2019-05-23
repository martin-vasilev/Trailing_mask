function [ ] = letter_mask(B, whichLine, whichCrossed, sentRect, item)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    global Visual Monitor sent;


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
    
   Screen('FillRect', Monitor.buffer(2), Visual.BGC, sentRect(whichLine,:));
   Screen('DrawText', Monitor.buffer(2), masked_string, ...
          sentRect(whichLine,1), sentRect(whichLine,2), Visual.FGC); % sentence
   Screen('CopyWindow', Monitor.buffer(2), Monitor.window)%, ...
         %sentRect(whichLine, :), sentRect(whichLine, :));
   Screen('Flip', Monitor.window);
   Eyelink('Message', ['DC COMPLETED L' ...
          num2str(whichLine) ' W' num2str(whichCrossed) ...
          ' @ ' num2str(B(whichCrossed))]);
    
end % end of fun

