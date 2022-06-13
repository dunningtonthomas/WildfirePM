close all; clear; clc;
%%To do: Import Data from xls file, import first column as string and then
%%convert to datetime

%% Import Data

path = '../dataFiles/aranet4Prelim'; %Directory for data files
cd(path);

data = xlsread('10200_2022-06-13T13_30_07-0600.csv'); %Read in data

%Column 1 is carbon dioxide (ppm)
%Column 2 is temperature (C)
%Column 3 is Relative Humidity (%)
%Column 4 is Atmosphereic Pressure (hPa)

%Getting the time data from the csv file
fid = fopen('10200_2022-06-13T13_30_07-0600.csv');
x = textscan(fid, '%s%s%s%s%s');

%% Analysis

carbonD = data(:,1);
temp = data(:,2);
humid = data(:,3);
atmosPress = data(:,4);


timeCell = x{1,2};
dateCell = x{1,1};
timeCell = timeCell(2:end);
dateCell = dateCell(2:end);


%Combining the date and the time
totalCellMat = cell(length(timeCell),1);
for j = 1:length(timeCell) %Concatenating strings into one cell array
    str1 = char(dateCell(j));
    str2 = char(timeCell(j));
    strings = [str1, ' ', str2];
    totalCellMat{j} = strings;    
end

timeData = datetime(totalCellMat, 'InputFormat', 'dd/MM/yyyy HH:mm:ss');

%% Plotting
figure();
plot(timeData, carbonD);
