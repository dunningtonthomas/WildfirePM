close all; clear; clc;
%%To do: Import Data from xls file, import first column as string and then
%%convert to datetime
% Use the delimited text import options to split the data up

%% Import Data

path = '../dataFiles/aranet4Prelim'; %Directory for data files
cd(path);

%Defining the variable names and their corresponding columns
opts = delimitedTextImportOptions('NumVariables', 5);
opts.VariableNames(1) = {'Time'};
opts.VariableNames(2) = {'Carbon Dioxide (ppm)'};
opts.VariableNames(3) = {'Temperature (C)'};
opts.VariableNames(4) = {'Relative Humidity (%)'};
opts.VariableNames(5) = {'Atmospheric Pressure (hPa)'};

files = dir('*.csv'); %Struct containing all of the csv files in the directory

for i = 1:length(files)
    
    data = readmatrix(files(i).name, opts); %Read in data

    %% Analysis
    time = data(2:end, 1);
    carbonD = data(2:end,2);
    temperature = data(2:end,3);
    humid = data(2:end,4);
    atmosPress = data(2:end,5);

    %Creating time data for the inputted times
    timeData = datetime(time); %Getting rid of the first data point for callibration

    %Converting to doubles
    carbonDFinal = zeros(length(carbonD), 1);
    for j = 1:length(carbonD)
        temp = str2double(cell2mat(carbonD(j)));
        carbonDFinal(j) = temp;        
    end
    
    %Concatenate to get rid of initial calibration spikes and final spikes
    carbonDFinal = carbonDFinal(10:end-2);
    timeData = timeData(10:end-2);

    %% Plotting
    plot(timeData, carbonDFinal);
    hold on    
end

title('Carbon Dioxide Concentrations');
ylabel('Carbon Dioxide (ppm)');
xlabel('Time');

%% Clean Up
%Changing directory back
pathBack = '../../MATLABFiles';
cd(pathBack);
