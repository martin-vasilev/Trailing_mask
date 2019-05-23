function [] = stim2edf(sentenceString)
%stim2edf Prints sentence to edf
%   Detailed explanation goes here

global Visual;

Eyelink('Message', 'DISPLAY TEXT 1');


sentenceString= sentenceString{1};
    %chars= list(sent) #get characters in sentence
x_start= [];
x_end= [];
y_start= 520;
y_end= 560;



for k=1:length(sentenceString)% loop to calulate x position of letters
	if k==1
		x_start(k)= Visual.sentPos(1);
		x_end(k)= Visual.sentPos(1)+ Visual.Pix_per_Letter;
    else
		x_start(k)= x_end(k-1);
		x_end(k)= x_end(k-1)+ Visual.Pix_per_Letter;
    end
    
    Eyelink('Message', ['REGION CHAR ' num2str(k-1) ' 1 ' sentenceString(k) ' ' num2str(x_start(k)) ' ' num2str(y_start) ' ' num2str(x_end(k)) ' ' num2str(y_end)]);
	WaitSecs(0.001); % wait time for consitency purposes with Eyetrack
    Eyelink('Message', 'DELAY 1 MS');
end


end % function end

