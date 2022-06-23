%% Clean
clear; close  all; clc;

%% Import Data

%%%%APS VS OPS
path = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\dataFiles\apsCalibration';
cellArrAPS = importAPS(path);

%Importing OPS data
cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\dataFiles\apsCalibration');
table = readmatrix('VL_CU_OPS_Collocation_20220622_dNdlogDp.csv');
table2 = readtable('VL_CU_OPS_Collocation_20220622_dNdlogDp.csv');

%opsData are the concentration data for the ops
opsData = table(18:end, 6:end);

%Size bin data
diametersOPS = table(18:end, 5);

cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\MATLABFiles\apsCalibrationMAT');

%%%%APS PSL Calibration
cellPSL = importAPS(path);

%% Analysis APS PSL Calibration
diametersPSL = cellArrAPS{2,1}(2:end);
avgConcPSL = mean([cellPSL{3,:}],2);
avgConcPSL = avgConcPSL(2:end);

firstScan = cellPSL{3,1};

logPSL = diametersPSL < 3;
diametersPSL = diametersPSL(logPSL);
avgConcPSL = avgConcPSL(logPSL);

firstScan = firstScan(logPSL);


%% Analysis OPS vs APS

%Reading in time data
for i = 1:length(cellArrAPS(1,:))
    timeData(i) = cellArrAPS{1,i};    
end

%Assuming all size bins are the same, diameters will be the same across
%scans
diametersAPS = cellArrAPS{2,1};
scan1 = cellArrAPS{3,1};

%Getting scans between 2:32 and 2:42
startTime = datetime('22-Jun-2022 14:32:00');
endTime = datetime('22-Jun-2022 14:42:00');
logTimeVec = isbetween(timeData, startTime, endTime);
logTimeVec(23) = 1; %Adding in scan 23, data looks good and matches 24,25,26

usefulAPS = cellArrAPS(:,logTimeVec);
usefulOPS = opsData(:,logTimeVec);

%Average concentrations during time interval
avgConcAPS = mean([usefulAPS{3,:}],2);
avgConcOPS = mean(usefulOPS, 2);

%Concatenating OPS data for greater than 0.5 to match APS
logOPS = diametersOPS >= 0.5 & diametersOPS < 3;
diametersOPS = diametersOPS(logOPS);
avgConcOPS = avgConcOPS(logOPS);

%Concatenating APS data
logAPS = diametersAPS < 3;
diametersAPS = diametersAPS(logAPS);
avgConcAPS = avgConcAPS(logAPS);

%Error region
%APS is 10% reported error
apsErrorLow = avgConcAPS * 0.9;
apsErrorUp = avgConcAPS * 1.1;

pslErrorLow = avgConcPSL * 0.9;
pslErrorUp = avgConcPSL * 1.1;

%% Plotting
figure();
cd('./XKCD_RGB');
plot(diametersAPS, avgConcAPS, 'linewidth', 2, 'color', rgb('red'));
hold on
plot(diametersOPS, avgConcOPS, 'linewidth', 2, 'color', rgb('blue'));

%Plotting the error region
h3 = fill([diametersAPS; flip(diametersAPS)], [apsErrorUp; flip(apsErrorLow)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

set(gca, 'XScale', 'log');
legend('APS', 'OPS');


%%%%PSL plot
figure();
plot(diametersPSL, avgConcPSL, 'linewidth', 2, 'color', rgb('red'));
hold on

%Adding the first scan
plot(diametersPSL, firstScan, 'linewidth', 2, 'color', rgb('blue'));

set(gca, 'XScale', 'log');
xlabel('Dp');
ylabel('dNdlogDp');

%Plotting the error region
h3 = fill([diametersPSL; flip(diametersPSL)], [pslErrorUp; flip(pslErrorLow)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Plotting dashed lines for psl range
xline(0.698, '--');
xline(0.702, '--');

xline(1.98, '--');
xline(2.02, '--');

%% Clean Up
cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\MATLABFiles\apsCalibrationMAT');


