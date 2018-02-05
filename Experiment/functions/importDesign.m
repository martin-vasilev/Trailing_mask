%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\EyeTracker\Desktop\Martin Vasilev\DEVS\design\P1.txt
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/09/06 13:42:37

global const;

%% Initialize variables.
filename = [cd '\design\' 'P' num2str(const.ID) '.txt'];
delimiter = ' ';
startRow = 2;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: text (%s)
%   column3: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
design = table(dataArray{1:end-1}, 'VariableNames', {'item','sound','diff'});
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;