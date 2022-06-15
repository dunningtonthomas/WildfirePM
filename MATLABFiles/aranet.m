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

%Changing directory back
pathBack = '../../MATLABFiles';
cd(pathBack);

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

numDataPoints = length(carbonDataTot{1});
numSensors = length(carbonDataTot);

meanCarbon = zeros(numDataPoints, 1); %Vector to store average values
for i = 1:numDataPoints %Looping through length of the concatenated data vectors
    sum = 0;
   for j = 1:numSensors %Looping through each sensor
       sum = sum + carbonDataTot{j}(i);       
   end
   meanCarbon(i) = sum / numSensors;
end

%Standard Deviation Calculation
rawCarbon2D = zeros(numDataPoints, numSensors);

for i = 1:length(carbonDataTot)
   rawCarbon2D(:,i) = carbonDataTot{i};    
end

standDev = std(rawCarbon2D, 0, 2);
curveLow = meanCarbon - standDev;
curveHigh = meanCarbon + standDev;


%% Plotting

%Smoothing data
plotCarbon = smoothdata(meanCarbon);
curveLow = plotCarbon - standDev;
curveHigh = plotCarbon + standDev;

%Plot for the mean of the carbon data
plotTime = datetime(timeDataTot{1});
figure();
plot(plotTime, plotCarbon, 'r', 'linewidth', 2); 
hold on

%Plotting the standard deviation of the data
cd('XKCD_RGB');
h2 = fill([plotTime; flip(plotTime)], [curveHigh; flip(curveLow)], rgb('light blue'), 'HandleVisibility', 'off');
set(h2,'facealpha',.5) %Makes the shading see-though
h2.LineStyle = 'none'; %Turn off outline

%Plotting +-3% as provided by the manufacturer error
threeUpper = 1.03 * plotCarbon;
threeLower = 0.97 * plotCarbon;
h3 = fill([plotTime; flip(plotTime)], [threeUpper; flip(threeLower)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline


%% Clean Up
cd('../');