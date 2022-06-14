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

carbonDataTot = cell(length(files),1);
timeDataTot = cell(length(files),1);
for i = 1:length(files)
    
    data = readmatrix(files(i).name, opts); %Read in data
    time = data(2:end, 1);
    carbonD = data(2:end,2);
    temperature = data(2:end,3);
    humid = data(2:end,4);
    atmosPress = data(2:end,5);

    %Converting to doubles
    carbonDFinal = zeros(length(carbonD), 1);
    for j = 1:length(carbonD)
        temp = str2double(cell2mat(carbonD(j)));
        carbonDFinal(j) = temp;        
    end
    
    %Concatenate to get rid of initial calibration spikes and final spikes
    carbonDFinal = carbonDFinal(30:end-2);
    carbonDataTot{i} = carbonDFinal;
    
    
    timeData = time(30:end-2);
    timeDataTot{i} = timeData;  %Raw time data outputed
    
    %Creating time data for the inputted times
    timeData = datetime(timeData);
    
    
    %% Plotting
    plot(timeData, carbonDFinal);
    hold on    
end

title('Carbon Dioxide Concentrations');
ylabel('Carbon Dioxide (ppm)');
xlabel('Time');

%% Further Analysis
%Concatenating all carbon data for average calculations
%Determining the smallest data set
tempSize = 9999;
fid = 0; %File id to correspond to index in cell array
for i = 1:length(carbonDataTot)
    if(length(carbonDataTot{i}) < tempSize)
       tempSize = length(carbonDataTot{i}); 
       fid = i;
    end
end
logVec = ones(tempSize, 1) == 1; %Logical vector to index into arrays and concatenate

for i = 1:length(carbonDataTot) %Concatenating lengths of the arrays
    carbonDataTot{i} = carbonDataTot{i}(logVec);
    timeDataTot{i} = timeDataTot{i}(logVec);
end

%Computing the average at the time intervals
%NOTE: the time intervals do not line up perfectly so I used the first data
%sets time to plot and the averages are not lined up perfectly
%Maybe I can interpolate later?

meanCarbon = zeros(length(carbonDataTot{1}), 1); %Vector to store average values
for i = 1:length(carbonDataTot{1}) %Looping through length of the concatenated data vectors
    sum = 0;
   for j = 1:length(carbonDataTot) %Looping through each sensor
       sum = sum + carbonDataTot{j}(i);       
   end
   meanCarbon(i) = sum / length(carbonDataTot{1});
end

%% Plotting

%Plot for the mean of the carbon data
plotTime = datetime(timeDataTot{1});
figure();
plot(plotTime, meanCarbon); 

%% Clean Up
%Changing directory back
pathBack = '../../MATLABFiles';
cd(pathBack);
