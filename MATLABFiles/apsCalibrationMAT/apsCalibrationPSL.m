%% Clean
clear; close  all; clc;

%% Import Data

%%APS

%Desktop
% path = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\dataFiles\apsCalibrationPSL';
%Laptop
path = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\dataFiles\apsCalibrationPSL';
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


%Getting into matrix
dataStd = zeros(length(cellArrAPS{3,1}), length(cellArrAPS(3,:)));
for i = 1:length(cellArrAPS(3,:))
    dataStd(:,i) = cellArrAPS{3,i};
end

%Calculating std
stdConcAPS = std(dataStd, 0, 2);

%Concatenating to less than 3 microns and above the minimum bin
logVec = diametersAPS < 3 & diametersAPS > 0.523;
avgConcAPS = avgConcAPS(logVec);
diametersAPS = diametersAPS(logVec);
stdConcAPS = stdConcAPS(logVec);

%Error region
%APS is 10% reported error
apsErrorLow = avgConcAPS - stdConcAPS;
apsErrorUp = avgConcAPS + stdConcAPS;

%% Analysis APS Calibration PRE POTENTIOMETER
%Average concentrations during time interval
avgConcAPSPre = mean([cellArrAPSPre{3,:}],2);

%Concatenating to less than 3 microns
avgConcAPSPre = avgConcAPSPre(logVec);

%Getting into matrix
dataStdPre = zeros(length(cellArrAPSPre{3,1}), length(cellArrAPSPre(3,:)));
for i = 1:length(cellArrAPSPre(3,:))
    dataStdPre(:,i) = cellArrAPSPre{3,i};
end

%Calculating std
stdConcAPSPre = std(dataStdPre, 0, 2);
stdConcAPSPre = stdConcAPSPre(logVec);

%Error region
%APS is 10% reported error
apsErrorLowPre = avgConcAPSPre - stdConcAPSPre;
apsErrorUpPre = avgConcAPSPre + stdConcAPSPre;


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

%Adding patch so I can add fill to the legend
xTemp = [1 1 1 1];
yTemp = [0 0 0 0];
patch(xTemp, yTemp, rgb('light pink'));

set(gca, 'XScale', 'log');

%Plotting dashed lines for psl range, +-10% range
xline(0.702 - 0.1*0.702, '--', 'color', rgb('blue'));
xline(0.702 + 0.1*0.702, '--', 'APS Error', 'color', rgb('blue'));

%PSL error range
xline(0.696, '--', 'color', rgb('purple'));
xline(0.708, '--', 'PSL Error', 'color', rgb('purple'));

xlabel('Dp');
ylabel('dNdlogDp');
title('Average Concentrations PRE Potentiometer');
xlim([0,1]);
legend('Average', 'Standard Deviation');

%%%%POST POTENTIOMETER
figure();
plot(diametersAPS, avgConcAPS, 'linewidth', 2, 'color', rgb('red'));
hold on

%Plotting the error region
h3 = fill([diametersAPS; flip(diametersAPS)], [apsErrorUp; flip(apsErrorLow)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

set(gca, 'XScale', 'log');

%Adding patch so I can add fill to the legend
xTemp = [1 1 1 1];
yTemp = [0 0 0 0];
patch(xTemp, yTemp, rgb('light pink'));

%Plotting dashed lines for psl range, +-10% range
xline(0.702 - 0.1*0.702, '--', 'color', rgb('blue'));
xline(0.702 + 0.1*0.702, '--', 'APS Error', 'color', rgb('blue'));

%PSL error range
xline(0.696, '--', 'color', rgb('purple'));
xline(0.708, '--', 'PSL Error', 'color', rgb('purple'));

xline(1.98, '--');
xline(2.02, '--', 'PSL Error');

xlabel('Dp');
ylabel('dNdlogDp');
title('Average Concentrations POST Potentiometer');
xlim([0,1]);

legend('Average', 'Standard Deviation');

%% Clean Up
%Desktop
% cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\MATLABFiles\apsCalibrationMAT');
%Laptop
cd('C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\MATLABFiles\apsCalibrationMAT');


% bool = 0;
% for i = 1:length(smps{1,:})
%     for j = 1:length(time)
%         if(time(j) == smps{1,i}) %Found the time
%             bool = 1;            
%         end        
%     end
%     if(~bool) %Not found
%         badTime = smps{1,i};
%     end
%     bool = 0;
% end




