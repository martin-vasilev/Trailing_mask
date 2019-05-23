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
% Seq1
if ismember(const.ID, [1, 9, 17, 25, 33, 41, 49])
    filename = [cd '\design\' 'Seq1.txt'];
end

% Seq2
if ismember(const.ID, [2, 10, 18, 26, 34, 42])
    filename = [cd '\design\' 'Seq2.txt'];
end

% Seq3
if ismember(const.ID, [3, 11, 19, 27, 35, 43])
    filename = [cd '\design\' 'Seq3.txt'];
end

% Seq4
if ismember(const.ID, [4, 12, 20, 28, 36, 44])
    filename = [cd '\design\' 'Seq4.txt'];
end

% Seq5
if ismember(const.ID, [5, 13, 21, 29, 37, 45])
    filename = [cd '\design\' 'Seq5.txt'];
end

% Seq6
if ismember(const.ID, [6, 14, 22, 30, 38, 46])
    filename = [cd '\design\' 'Seq6.txt'];
end

% Seq7
if ismember(const.ID, [7, 15, 23, 31, 39, 47])
    filename = [cd '\design\' 'Seq7.txt'];
end

% Seq8
if ismember(const.ID, [8, 16, 24, 32, 40, 48])
    filename = [cd '\design\' 'Seq8.txt'];
end

%filename = [cd '\design\' 'P' num2str(const.ID) '.txt'];
delimiter = ' ';
startRow = 2;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: text (%s)
%   column3: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%s%s%s%[^\n\r]';

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
design = table(dataArray{1:end-1}, 'VariableNames', {'item','sound','diff' 'mask'});
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;