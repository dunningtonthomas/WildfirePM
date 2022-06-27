%% Clean
clear; close  all; clc;

%% Import Data

%%APS

%Desktop
path = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\dataFiles\apsCalibrationPSL';
%Laptop
% path = '';

cellArrAPS = importAPS(path);


%% Analysis APS Calibration POST POTENTIOMETER

%SCANS 5 through 10 are prior to any cleaning or potentiometer alterations
cellArrAPSPre = cellArrAPS(:,5:10);

%SCANS 25 through 29 are post potentiometer alterations with only the APS
cellArrAPS = cellArrAPS(:,25:29);

%Reading in time data
for i = 1:length(cellArrAPS(1,:))
    timeData(i) = cellArrAPS{1,i};    
end

%Assuming all size bins are the same, diameters will be the same across
%scans
diametersAPS = cellArrAPS{2,1};

%Average concentrations during time interval
avgConcAPS = mean([cellArrAPS{3,:}],2);

%Concatenating to less than 3 microns and above the minimum bin
logVec = diametersAPS < 3 & diametersAPS > 0.523;
avgConcAPS = avgConcAPS(logVec);
diametersAPS = diametersAPS(logVec);

%Error region
%APS is 10% reported error
apsErrorLow = avgConcAPS * 0.9;
apsErrorUp = avgConcAPS * 1.1;

%% Analysis APS Calibration PRE POTENTIOMETER
%Average concentrations during time interval
avgConcAPSPre = mean([cellArrAPSPre{3,:}],2);


%Concatenating to less than 3 microns
avgConcAPSPre = avgConcAPSPre(logVec);

%Error region
%APS is 10% reported error
apsErrorLowPre = avgConcAPSPre * 0.9;
apsErrorUpPre = avgConcAPSPre * 1.1;


%% Plotting
%%%%PRE POTENTIOMETER
figure();
set(0, 'defaultTextInterpreter', 'latex');
cd('./XKCD_RGB');
plot(diametersAPS, avgConcAPSPre, 'linewidth', 2, 'color', rgb('red'));
hold on

%Plotting the error region
h3 = fill([diametersAPS; flip(diametersAPS)], [apsErrorUpPre; flip(apsErrorLowPre)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

set(gca, 'XScale', 'log');

%Plotting dashed lines for psl range
xline(0.698, '--');
xline(0.702, '--', 'PSL Error');

xline(1.98, '--');
xline(2.02, '--', 'PSL Error');

xlabel('Dp');
ylabel('dNdlogDp');
title('Average Concentrations PRE Potentiometer');

%%%%POST POTENTIOMETER
figure();
plot(diametersAPS, avgConcAPS, 'linewidth', 2, 'color', rgb('red'));
hold on

%Plotting the error region
h3 = fill([diametersAPS; flip(diametersAPS)], [apsErrorUp; flip(apsErrorLow)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

set(gca, 'XScale', 'log');

%Plotting dashed lines for psl range
xline(0.698, '--');
xline(0.702, '--', 'PSL Error');

xline(1.98, '--');
xline(2.02, '--', 'PSL Error');

xlabel('Dp');
ylabel('dNdlogDp');
title('Average Concentrations POST Potentiometer');

%% Clean Up
%Desktop
cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\MATLABFiles\apsCalibrationMAT');
%Laptop
% cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\MATLABFiles\apsCalibrationMAT');


