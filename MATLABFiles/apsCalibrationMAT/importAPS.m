function [ APSdataArray] = importAPS(path)
%% Import APS data
% Data should be exported to comma delimited text files
% Output is a single cell array with the data for each individual scan
% organized into columns. Multiple text files can be selected.
% Last edited KJM 12/13/2017

%% Import data
% Open folder
% cf = pwd;
% cd([cf,'\APS']);
if nargin > 0
    current = cd(path);
end

% Select APS data files (can select multiple text files)
filelist = uigetfile('.txt', 'Select APS data file', 'MultiSelect', 'on');

% Open files
if ischar(filelist) == 1
    fid = fopen(filelist);
else
    fid = zeros(length(filelist),1);
    for i = 1:length(filelist)
        fid(i) = fopen(filelist{i});
    end
end

% Initialize variables
delimiter = ','; % comma delimited, for textscan
startRow = 11;  % row which dNdlogDp data begins

% Read in data line by line to get number of columns (for formatSpec) date,  
% time, and other data from header lines
colnum = zeros(length(fid),1);
date = cell(1,length(fid));
time = cell(1,length(fid));
row1 = cell(1,length(fid));

for i = 1:length(fid)
    for j = 1:startRow
        if j == 8 %dates
           tline = fgetl(fid(i));
           date(i) = textscan(tline(6:end), '%{MM/dd/uuuu}D', 'Delimiter', delimiter);
        elseif j == 9 %start times
            tline = fgetl(fid(i));
            time(i) = textscan(tline(12:end), '%D', 'Delimiter', delimiter);
        elseif j == startRow
            tline = fgetl(fid(i));
            row1(i) = textscan(tline(2:end), '%f', 'Delimiter', delimiter); %the '<' sign on the first diameter (<0.523) screws up textscan below. Best to process separately.
        else
            tline = fgetl(fid(i)); %skips all other header rows
        end
    end
    colnum(i) = length(date{1,i});
end

% Define format for each file
data = cell(1, length(fid));

for i = 1:length(fid)
    formatSpec = repmat('%f',[1,colnum(i)+1]); %use repmat to generate formatspec for each file
    data{i} = textscan(fid(i), [formatSpec], 'Delimiter', delimiter, 'EmptyValue', NaN); %Read in data
    fclose(fid(i)); % Close file
end

%Return to previous folder
if exist('cf', 'var') == 1
    cd(cf);
end

clearvars i j t tline delimiter startRow filelist formatSpec fid ans cf

%% Organize data into cell array. 
% Each column is a sample with date and start time (row 1), bin diameters
%(row 2), data (row 3), and other parameters (row 4).

%Add row1 back into data
for i = 1:length(date)
    for j = 1:colnum(i)+1
        data{1,i}{1,j} = [row1{1,i}(j); data{1,i}{1,j}];
    end
end

% Add date to timestamp
for i = 1:length(date)
    for j = 1:length(date{1,i})
        time{1,i}(j).Month = date{1,i}(j).Month;
        time{1,i}(j).Day = date{1,i}(j).Day;
        time{1,i}(j).Year = date{1,i}(j).Year + 2000;
        time{1,i}.Format = 'default';
    end
end

%Fill data into array
APSdataArray = cell(4,sum(colnum)); %Create array to hold data
k = 0;

for i = 1:length(date)
    for j = 1:colnum(i);
        APSdataArray{1,j+k} = time{1,i}(j);
        APSdataArray{2,j+k} = data{1,i}{1,1};
        APSdataArray{3,j+k} = data{1,i}{1,j+1};
    end
    k = k+colnum(i);
end

if nargin > 0
    cd(current);
end

clearvars i j k date time colnum date time data date row1 current
end

