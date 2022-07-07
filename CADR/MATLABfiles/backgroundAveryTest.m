%% Clean Up
clear; clc; close all;

%% Import Data

%SMPS import
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\CADR\data\backgroundWithAvery\SMPS';
smpsData = importSMPS(pathSMPS);
smpsDataRaw = smpsData;


%APS import
pathAPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\CADR\data\backgroundWithAvery\APS';
apsData = importAPS(pathAPS);
apsDataRaw = apsData;

%% Analysis

%Converting mass concentrations to micro grams per meter cubed and
%truncating APS to less than 2.5 microns ans SMPS to less than 0.523
%microns
logVecAPS = apsData{2,1} <= 2.5;
logVecSMPS = smpsData{2,1} < (0.523 * 1000); %in nanometers

for i = 1:length(apsData(3,:))
    apsData{3,i} = apsData{3,i} * 1000;
    apsData{3,i} = apsData{3,i}(logVecAPS);
    apsData{2,i} = apsData{2,i}(logVecAPS);
    
    smpsData{3,i} = smpsData{3,i}(logVecSMPS);
    smpsData{2,i} = smpsData{2,i}(logVecSMPS);
end

%Calculating the total mass for each scan, storing in the 4th row of the
%cell array
numScans = length(apsData(3,:));
for i = 1:numScans
    apsData{4,i} = sum(apsData{3,i});
    smpsData{4,i} = sum(smpsData{3,i});    
end

%Computing Average if there are more than 1 scans (3 scans in our case)
scanIndices = [33, 26, 27,27]; %The number of scans for each file SCAN1 SCAN2 SCAN3 respectively
smpsScan1 = smpsData(:,1:33);
smpsScan2 = smpsData(:,34:59);
smpsScan3 = smpsData(:,60:86);
smpsScan4 = smpsData(:,87:113);

apsScan1 = apsData(:,1:33);
apsScan2 = apsData(:,34:59);
apsScan3 = apsData(:,60:86);
apsScan4 = apsData(:,87:113);

%Truncating the scans based on start/stop times
scan1Start = datetime(2022, 07, 05, 13, 20, 00);
scan1End = datetime(2022, 07, 05, 14, 30, 00);

scan2Start = datetime(2022, 07, 05, 15, 00, 00);
scan2End = datetime(2022, 07, 05, 16, 03, 00);

scan3Start = datetime(2022, 07, 05, 16, 30, 00);
scan3End = datetime(2022, 07, 05, 17, 33, 00);

scan4Start = datetime(2022, 07, 06, 14, 53, 00);
scan4End = datetime(2022, 07, 06, 15, 53, 00);

tempLog = isbetween([smpsScan1{1,:}], scan1Start, scan1End);
smpsScan1 = smpsScan1(:,tempLog);
apsScan1 = apsScan1(:,tempLog);

tempLog = isbetween([smpsScan2{1,:}], scan2Start, scan2End);
smpsScan2 = smpsScan2(:,tempLog);
apsScan2 = apsScan2(:,tempLog);

tempLog = isbetween([smpsScan3{1,:}], scan3Start, scan3End);
smpsScan3 = smpsScan3(:,tempLog);
apsScan3 = apsScan3(:,tempLog);

tempLog = isbetween([smpsScan4{1,:}], scan4Start, scan4End);
smpsScan4 = smpsScan4(:,tempLog);
apsScan4 = apsScan4(:,tempLog);

%If some scans ran longer than others, truncate so they are all the
%smallest length
minsize = min([length(smpsScan1(1,:)), length(smpsScan2(1,:)), length(smpsScan3(1,:))]);
smpsScan1 = smpsScan1(:,1:minsize);
smpsScan2 = smpsScan2(:,1:minsize);
smpsScan3 = smpsScan3(:,1:minsize);
smpsScan4 = smpsScan4(:,1:minsize);

apsScan1 = apsScan1(:,1:minsize);
apsScan2 = apsScan2(:,1:minsize);
apsScan3 = apsScan3(:,1:minsize);
apsScan4 = apsScan4(:,1:minsize);

%TOTAL SCANS ANALYSIS
%Total mass concentrations over time
totalConc1 = [smpsScan1{4,:}] + [apsScan1{4,:}];
totalConc2 = [smpsScan2{4,:}] + [apsScan2{4,:}];
totalConc3 = [smpsScan3{4,:}] + [apsScan3{4,:}];
totalConc4 = [smpsScan4{4,:}] + [apsScan4{4,:}];

%Truncating so they start at the peak and include only decay
%Truncating all plots so they start at the peak
[~,ind1] = max(totalConc1);
totalConc1 = totalConc1(ind1:end);
[~,ind2] = max(totalConc2);
totalConc2 = totalConc2(ind2:end);
[~,ind3] = max(totalConc3);
totalConc3 = totalConc3(ind3:end);
[~,ind4] = max(totalConc4);
totalConc4 = totalConc4(ind4:end);


%Creating plot time based on the length of each trial
plotTime = [smpsScan1{1,:}]; %Time used to plot
durationArr = minutes(plotTime(ind1:end) - plotTime(1)); %All plots are on 1 hour scale
durationArr = durationArr - durationArr(1); %Start at t=0 mins


%Truncating based on the size of the duration array
if(length(totalConc1) ~= length(durationArr))
    totalConc1 = totalConc1(1:length(durationArr));
end

if(length(totalConc2) ~= length(durationArr))
    totalConc2 = totalConc2(1:length(durationArr));
end

if(length(totalConc3) ~= length(durationArr))
    totalConc3 = totalConc3(1:length(durationArr));
end

if(length(totalConc4) ~= length(durationArr))
    totalConc4 = totalConc4(1:length(durationArr));
end

%Variables for percent plot
peakConc1 = max(totalConc1);
peakConc2 = max(totalConc2);
peakConc3 = max(totalConc3);
peakConc4 = max(totalConc4);
concPercent1 = totalConc1 / peakConc1;
concPercent2 = totalConc2 / peakConc2;
concPercent3 = totalConc3 / peakConc3;
concPercent4 = totalConc4 / peakConc4;

%Logarithmic Transform
logConc1 = log(totalConc1);
logConc2 = log(totalConc2);
logConc3 = log(totalConc3);
logConc4 = log(totalConc4);

%Calculating the slopes for the log transformed decay curves
%Creating linear fit curves
coeff1 = polyfit(durationArr, logConc1, 1);
coeff2 = polyfit(durationArr, logConc2, 1);
coeff3 = polyfit(durationArr, logConc3, 1);
coeff4 = polyfit(durationArr, logConc4, 1);

%Corresponding slopes
decaySlope1 = coeff1(1);
decaySlope2 = coeff2(1);
decaySlope3 = coeff3(1);
decaySlope4 = coeff4(1);

%Testing log transform on the percent remaning rather than the total
%concentrations
logFrac1 = log(concPercent1);
logFrac2 = log(concPercent2);
logFrac3 = log(concPercent3);
logFrac4 = log(concPercent4);

%Calculating the slopes for the log transformed decay curves
%Creating linear fit curves
coeffFrac1 = polyfit(durationArr, logFrac1, 1);
coeffFrac2 = polyfit(durationArr, logFrac2, 1);
coeffFrac3 = polyfit(durationArr, logFrac3, 1);
coeffFrac4 = polyfit(durationArr, logFrac4, 1);

%Corresponding slopes
decaySlopeFrac1 = coeffFrac1(1);
decaySlopeFrac2 = coeffFrac2(1);
decaySlopeFrac3 = coeffFrac3(1);
decaySlopeFrac4 = coeffFrac4(1);


%Calculating the averages to export and use in total comparison for both
%mass and fractional concentrations for both normal and log scale
averageConc = (totalConc1 + totalConc2 + totalConc3 + totalConc4) / 3;
averageFrac = (concPercent1 + concPercent2 + concPercent3 + totalConc4) / 3;
stdConc = std([totalConc1', totalConc2', totalConc3', totalConc4'], 0, 2);
stdFrac = std([concPercent1', concPercent2', concPercent3', concPercent3'], 0, 2);

averageConcLog = (logConc1 + logConc2 + logConc3 + logConc4) / 3;
averageFracLog = (logFrac1 + logFrac2 + logFrac3 + logFrac4) / 3;
stdConcLog = std([logConc1', logConc2', logConc3', logConc4'], 0, 2);
stdFracLog = std([logFrac1', logFrac2', logFrac3', logFrac4'], 0, 2);

%save('Background', 'averageConc', 'averageFrac', 'stdConc', 'stdFrac', 'averageConcLog', 'averageFracLog', 'stdConcLog', 'stdFracLog', 'durationArr');


%% Raw Avery Trial Analysis
averySmps = smpsDataRaw(:,87:end);
averyAps = apsDataRaw(:,87:end);

%Truncating aps and smps
logVecAPS = averyAps{2,1} <= 2.5;
logVecSMPS = averySmps{2,1} < (0.523 * 1000); %in nanometers

for i = 1:length(averyAps(3,:))
    averyAps{3,i} = averyAps{3,i} * 1000;
    averyAps{3,i} = averyAps{3,i}(logVecAPS);
    averyAps{2,i} = averyAps{2,i}(logVecAPS);
    
    averySmps{3,i} = averySmps{3,i}(logVecSMPS);
    averySmps{2,i} = averySmps{2,i}(logVecSMPS);
end

%Calculating the total mass for each scan, storing in the 4th row of the
%cell array
for i = 1:length(averyAps(1,:))
    averyAps{4,i} = sum(averyAps{3,i});
    averySmps{4,i} = sum(averySmps{3,i});    
end

%Creating another duration array based on avery's experiment
averyTime = [averySmps{1,:}]; %Time used to plot
durationArrAvery = minutes(averyTime - averyTime(1)); %All plots are on 1 hour scale
durationArrAvery = durationArrAvery - durationArrAvery(1); %Start at t=0 mins

%Calculating total concentration
totalAvery = [averySmps{4,:}] + [averyAps{4,:}];


%% Plotting

%Total concentration plot
figure();
set(0, 'defaulttextinterpreter', 'latex');
plot(durationArr, totalConc1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, totalConc2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, totalConc3, 'linewidth', 2, 'color', rgb('light green'));
plot(durationArr, totalConc4, 'linewidth', 2, 'color', rgb('Dark Red'));

xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Mass Concentration $$\frac{\mu g}{m^{3}}$$');
title('Total Mass Concentrations');
legend('Trial 1', 'Trial 2', 'Trial 3', 'Avery Trial');

%Percentage plot
figure();
plot(durationArr, concPercent1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, concPercent2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, concPercent3, 'linewidth', 2, 'color', rgb('light green'));
plot(durationArr, concPercent4, 'linewidth', 2, 'color', rgb('Dark Red'));

ylim([0 1])
xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('Trial 1', 'Trial 2', 'Trial 3', 'Avery Trial');


%Log Scale Plot Concentration
figure();
plot(durationArr, logConc1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, logConc2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, logConc3, 'linewidth', 2, 'color', rgb('light green'));
plot(durationArr, logConc4, 'linewidth', 2, 'color', rgb('Dark Red'));

xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Logarithmic Mass Concentration $$\ln (\frac{\mu g}{m^{3}})$$');
title('Natural Log Transform of Mass Concentration');
legend('Trial 1', 'Trial 2', 'Trial 3', 'Avery Trial');

%Log Scale Plot Fractional
figure();
plot(durationArr, logFrac1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, logFrac2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, logFrac3, 'linewidth', 2, 'color', rgb('light green'));
plot(durationArr, logFrac4, 'linewidth', 2, 'color', rgb('Dark Red'));

xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Logarithmic Fraction Remaining $$\ln (\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Natural Log Transform of First Order Decay');
legend('Trial 1', 'Trial 2', 'Trial 3', 'Avery Trial');

