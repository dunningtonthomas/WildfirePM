%% Clean Up
close all; clear; clc;

%% Import Data
%Getting the current directory
matFilePath = pwd;

%Directory for data files 
path = '../dataFiles/aranet4OutsideCalibration'; %%%%ENTER FILE DIRECTORY HERE
cd(path);

%Struct containing all of the csv files in the directory
files = dir('*.csv'); 

%Changing directory back
cd(matFilePath);

%TimeDataTot will hold the time data for each sensor, one per cell
%CarbonDataTot will hold the carbon dioxide data for each sensor, one per
%cell
[timeDataTot, carbonDataTot] = importAranet(files);

%% Analysis
%Concatenating for when the sensors were outside
%The sensors were outside from Wed June 15 9:30 am to Wed June 15 3:30 pm
    %%%%Using 10 am so spikes from moving from inside to outside are not
    %%%%evident
time1 = datetime('15-Jun-2022 10:00:00');
time2 = datetime('15-Jun-2022 15:30:00');

%Looping through all sensors and concatenating to be within the times above
for i = 1:length(carbonDataTot)
    tempTime = datetime(timeDataTot{i});
    
    %isbetween returns a logical vector of the times between the two times
    logVecTemp = isbetween(tempTime, time1, time2);
    
    %Concatenating time and carbon
    timeDataTot{i} = timeDataTot{i}(logVecTemp);
    carbonDataTot{i} = carbonDataTot{i}(logVecTemp);
end


%Concatenating all carbon data for average calculations
%Determining the smallest data set
    %%%%This is only necessary if the data sets are not the same size
tempSize = 9999;
fid = 0; %File id to correspond to index in cell array
for i = 1:length(carbonDataTot)
    if(length(carbonDataTot{i}) < tempSize)
       tempSize = length(carbonDataTot{i}); 
       fid = i;
    end
end
%Logical vector to index into arrays and concatenate
logVec = ones(tempSize, 1) == 1; 

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
%rawCarbon2D is a matrix with each column representing a single sensor
rawCarbon2D = zeros(numDataPoints, numSensors);
for i = 1:length(carbonDataTot)
   rawCarbon2D(:,i) = carbonDataTot{i};    
end

%Standard deviation for each data point collected among the sensors
standDev = std(rawCarbon2D, 0, 2);
curveLowRaw = meanCarbon - standDev;
curveHighRaw = meanCarbon + standDev;


%% Plotting

%Smoothing data
plotCarbon = meanCarbon; %Not smoothing for smaller time sets
curveLow = plotCarbon - standDev;
curveHigh = plotCarbon + standDev;

%Plot for the mean of the carbon data
cd('XKCD_RGB');
plotTime = datetime(timeDataTot{1});
figure();
hold on

%Plotting +-3% as provided by the manufacturer error
threeUpper = 1.03 * plotCarbon;
threeLower = 0.97 * plotCarbon;
h3 = fill([plotTime; flip(plotTime)], [threeUpper; flip(threeLower)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',1) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Plotting the standard deviation of the data
h2 = fill([plotTime; flip(plotTime)], [curveHigh; flip(curveLow)], rgb('gray'), 'HandleVisibility', 'off');
set(h2,'facealpha',1) %Makes the shading see-though
h2.LineStyle = 'none'; %Turn off outline

%Average Plot
plot(plotTime, plotCarbon, 'color', rgb('black'), 'linewidth', 0.5); 

%Plotting the expected 428 ppm for outside air on June 15 in Boulder
expectedCarb = 426;
yline(expectedCarb, 'color', rgb('light green'), 'linewidth', 3);

%Plotting +-3% of the expected c02
% threeUpper = (1.03 * expectedCarb) * ones(length(plotTime),1);
% threeLower = (0.97 * expectedCarb) * ones(length(plotTime),1);
% h4 = fill([plotTime; flip(plotTime)], [threeUpper; flip(threeLower)], rgb('light pink'), 'HandleVisibility', 'off');
% set(h4,'facealpha',1) %Makes the shading see-though
% h4.LineStyle = 'none'; %Turn off outline

%Adding patches to get added to legend
xTemp = [1 1 1 1];
yTemp = [0 0 0 0];
patch(xTemp, yTemp, rgb('light pink'));
patch(xTemp, yTemp, rgb('gray'));

%Figure info
title('Standard Deviation and Reported Accuracy Region');
ylabel('Carbon Dioxide (ppm)');
xlabel('Date');
legend('Mean', 'Expected Value', '3% Error Region', 'Standard Deviation');
ylim([310 440]);


%%%%Plotting Average with Correction Factor
figure();
hold on

%Plotting +-3% of the expected c02
threeUpper = (1.03 * expectedCarb) * ones(length(plotTime),1);
threeLower = (0.97 * expectedCarb) * ones(length(plotTime),1);
h4 = fill([plotTime; flip(plotTime)], [threeUpper; flip(threeLower)], rgb('light pink'), 'HandleVisibility', 'off');
set(h4,'facealpha',1) %Makes the shading see-though
h4.LineStyle = 'none'; %Turn off outline

%Correction factor determined by inspection
correctFac = expectedCarb / mean(plotCarbon);

%Plotting the standard deviation of the data
h2 = fill([plotTime; flip(plotTime)], [correctFac * curveHigh; flip(correctFac * curveLow)], rgb('gray'), 'HandleVisibility', 'off');
set(h2,'facealpha',1) %Makes the shading see-though
h2.LineStyle = 'none'; %Turn off outline

%Average Plot
plot(plotTime, correctFac * plotCarbon, 'color', rgb('black'), 'linewidth', 0.5); 

%Plotting the expected 428 ppm for outside air on June 15 in Boulder
yline(expectedCarb, 'color', rgb('light green'), 'linewidth', 3);

%Adding patches to get added to legend
xTemp = [1 1 1 1];
yTemp = [0 0 0 0];
patch(xTemp, yTemp, rgb('light pink'));
patch(xTemp, yTemp, rgb('gray'));

%Figure info
title('Average with Correction Factor Applied');
ylabel('Carbon Dioxide (ppm)');
xlabel('Date');
legend('Mean', 'Expected Value', '3% Error Region', 'Standard Deviation', 'location', 'southeast');
ylim([310 450]);


%%%%Plotting individual sensors on top of average and error range
plotTime = datetime(timeDataTot{1});
figure();
plot(plotTime, plotCarbon, 'color', rgb('black'), 'linewidth', 2); 
hold on

%Plotting +-3% as provided by the manufacturer error
threeUpper = 1.03 * plotCarbon;
threeLower = 0.97 * plotCarbon;
h3 = fill([plotTime; flip(plotTime)], [threeUpper; flip(threeLower)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Patch for the fill to show up on the legend
xTemp = [1 1 1 1];
yTemp = [0 0 0 0];
patch(xTemp, yTemp, rgb('light pink'));

%Color options
colors = {'bright blue'; 'orange'; 'mustard'; 'grass green'; 'strawberry'; 'violet'; 'aqua blue'; 'deep pink'; 'dark brown'; 'dark teal'; 'muted purple'; 'royal'; 'dark green'; 'green'}; 
for i = 1:length(carbonDataTot)
    timeTemp = timeDataTot{i};
    carbonTemp = carbonDataTot{i};
    plot(datetime(timeTemp), carbonTemp, 'linewidth', 0.05, 'color', rgb(colors{i}));
end

%Labeling
ylim([300 380]);
title('Individual Sensor Variation');
ylabel('Carbon Dioxide (ppm)');
xlabel('Date');
legend('Mean', '3% Error Region', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A13', 'NumColumns', 4);


%%%%Plotting 1 sensor per plot so it is clearer to see difference
%Plotting Individuals, 1 per plot
sensorString = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13'};

for i = 1:length(carbonDataTot)
    figure();
    plot(plotTime, plotCarbon, 'color', rgb('black'), 'linewidth', 2); 
    hold on

    %Plotting +-3% as provided by the manufacturer error
    threeUpper = 1.03 * plotCarbon;
    threeLower = 0.97 * plotCarbon;
    h3 = fill([plotTime; flip(plotTime)], [threeUpper; flip(threeLower)], rgb('light pink'), 'HandleVisibility', 'off');
    set(h3,'facealpha',.5) %Makes the shading see-though
    h3.LineStyle = 'none'; %Turn off outline

    %Patch for the fill to show up on the legend
    xTemp = [1 1 1 1];
    yTemp = [0 0 0 0];
    patch(xTemp, yTemp, rgb('light pink'));
    
    
    timeTemp = timeDataTot{i};
    carbonTemp = carbonDataTot{i};
    plot(datetime(timeTemp), carbonTemp, 'linewidth', 0.05, 'color', rgb(colors{i}));
    
    %Labeling
    ylim([300 380]);
    title('Individual Sensor Variation');
    ylabel('Carbon Dioxide (ppm)');
    xlabel('Date');
    legend('Mean', '3% Error Region', sensorString{i});
end

%% Clean Up
cd(matFilePath);