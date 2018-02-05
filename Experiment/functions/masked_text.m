function masked_string = masked_text(string, xpos, Bnds, spaces)
% masked_text Summary of this function goes here
%   Detailed explanation goes here

global const Visual;

% % check which words have been read
% words_crossed= [];
% for i=1:length(Bnds)
%     if xpos> Bnds(i)
%         words_crossed(i)= i;
%     end
% end
% % last crossed word:
% whichCrossed= max(words_crossed);

% find empty spaces:

checkCross= xpos>Bnds;
whichCrossed= find(checkCross==0);
whichCrossed= whichCrossed(1) -1;

if whichCrossed>0
    letters_mask= (Bnds(whichCrossed)- Visual.offsetX-1)/ Visual.Pix_per_Letter;
    string(1:letters_mask)='x';
    masked_string= string;
    masked_string(spaces)= ' ';
else
    masked_string= string;
    %no words crossed, return input string
end


end

