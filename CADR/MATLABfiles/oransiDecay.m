%% Clean Up
clear; clc; close all;

%% Import Data

%SMPS import
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\CADR\data\oransiDecay\SMPS';
smpsData = importSMPS(pathSMPS);
smpsDataRaw = smpsData;


%APS import
pathAPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\CADR\data\oransiDecay\APS';
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
scanIndices = [26, 26, 26]; %The number of scans for each file SCAN1 SCAN2 SCAN3 respectively
smpsScan1 = smpsData(:,1:26);
smpsScan2 = smpsData(:,27:52);
smpsScan3 = smpsData(:,53:78);

apsScan1 = apsData(:,1:26);
apsScan2 = apsData(:,27:52);
apsScan3 = apsData(:,53:78);

%Truncating the scans based on start/stop times
scan1Start = datetime(2022, 07, 07, 11, 23, 00);
scan1End = datetime(2022, 07, 07, 12, 25, 00);

scan2Start = datetime(2022, 07, 07, 12, 48, 00);
scan2End = datetime(2022, 07, 07, 13, 50, 00);

scan3Start = datetime(2022, 07, 07, 14, 18, 00);
scan3End = datetime(2022, 07, 07, 15, 20, 00);

tempLog = isbetween([smpsScan1{1,:}], scan1Start, scan1End);
smpsScan1 = smpsScan1(:,tempLog);
apsScan1 = apsScan1(:,tempLog);

tempLog = isbetween([smpsScan2{1,:}], scan2Start, scan2End);
smpsScan2 = smpsScan2(:,tempLog);
apsScan2 = apsScan2(:,tempLog);

tempLog = isbetween([smpsScan3{1,:}], scan3Start, scan3End);
smpsScan3 = smpsScan3(:,tempLog);
apsScan3 = apsScan3(:,tempLog);

%If some scans ran longer than others, truncate so they are all the
%smallest length
minsize = min([length(smpsScan1(1,:)), length(smpsScan2(1,:)), length(smpsScan3(1,:))]);
smpsScan1 = smpsScan1(:,1:minsize);
smpsScan2 = smpsScan2(:,1:minsize);
smpsScan3 = smpsScan3(:,1:minsize);

apsScan1 = apsScan1(:,1:minsize);
apsScan2 = apsScan2(:,1:minsize);
apsScan3 = apsScan3(:,1:minsize);

%TOTAL SCANS ANALYSIS
%Total mass concentrations over time
totalConc1 = [smpsScan1{4,:}] + [apsScan1{4,:}];
totalConc2 = [smpsScan2{4,:}] + [apsScan2{4,:}];
totalConc3 = [smpsScan3{4,:}] + [apsScan3{4,:}];

%Truncating so they start at the peak and include only decay
%Truncating all plots so they start at the peak
[~,ind1] = max(totalConc1);
totalConc1 = totalConc1(ind1:end);
[~,ind2] = max(totalConc2);
totalConc2 = totalConc2(ind2:end);
[~,ind3] = max(totalConc3);
totalConc3 = totalConc3(ind3:end);

%Creating plot time based on the length of each trial
plotTime = [smpsScan1{1,:}]; %Time used to plot
durationArr = minutes(plotTime(ind1:end) - plotTime(1)); %All plots are on 1 hour scale
durationArr = durationArr - durationArr(1); %Start at t=0 mins

%Variables for percent plot
peakConc1 = max(totalConc1);
peakConc2 = max(totalConc2);
peakConc3 = max(totalConc3);
concPercent1 = totalConc1 / peakConc1;
concPercent2 = totalConc2 / peakConc2;
concPercent3 = totalConc3 / peakConc3;

%Logarithmic Transform
logConc1 = log(totalConc1);
logConc2 = log(totalConc2);
logConc3 = log(totalConc3);

%Calculating the slopes for the log transformed decay curves
%Creating linear fit curves
coeff1 = polyfit(durationArr, logConc1, 1);
coeff2 = polyfit(durationArr, logConc2, 1);
coeff3 = polyfit(durationArr, logConc3, 1);

%Corresponding slopes
decaySlope1 = coeff1(1);
decaySlope2 = coeff2(1);
decaySlope3 = coeff3(1);

%Testing log transform on the percent remaning rather than the total
%concentrations
logFrac1 = log(concPercent1);
logFrac2 = log(concPercent2);
logFrac3 = log(concPercent3);

%Calculating the slopes for the log transformed decay curves
%Creating linear fit curves
coeffFrac1 = polyfit(durationArr, logFrac1, 1);
coeffFrac2 = polyfit(durationArr, logFrac2, 1);
coeffFrac3 = polyfit(durationArr, logFrac3, 1);

%Corresponding slopes
decaySlopeFrac1 = coeffFrac1(1);
decaySlopeFrac2 = coeffFrac2(1);
decaySlopeFrac3 = coeffFrac3(1);


%Calculating the averages to export and use in total comparison for both
%mass and fractional concentrations for both normal and log scale
averageConcORA = (totalConc1 + totalConc2 + totalConc3) / 3;
averageFracORA = (concPercent1 + concPercent2 + concPercent3) / 3;
stdConcORA = std([totalConc1', totalConc2', totalConc3'], 0, 2);
stdFracORA = std([concPercent1', concPercent2', concPercent3'], 0, 2);

averageConcLogORA = (logConc1 + logConc2 + logConc3) / 3;
averageFracLogORA = (logFrac1 + logFrac2 + logFrac3) / 3;
stdConcLogORA = std([logConc1', logConc2', logConc3'], 0, 2);
stdFracLogORA = std([logFrac1', logFrac2', logFrac3'], 0, 2);

save('Oransi', 'averageConcORA', 'averageFracORA', 'stdConcORA', 'stdFracORA', 'averageConcLogORA', 'averageFracLogORA', 'stdConcLogORA', 'stdFracLogORA', 'durationArrORA');

%% Plotting

%Total concentration plot
figure();
set(0, 'defaulttextinterpreter', 'latex');
plot(durationArr, totalConc1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, totalConc2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, totalConc3, 'linewidth', 2, 'color', rgb('light green'));

xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Mass Concentration $$\frac{\mu g}{m^{3}}$$');
title('Total Mass Concentrations');
legend('Trial 1', 'Trial 2', 'Trial 3');

%Percentage plot
figure();
plot(durationArr, concPercent1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, concPercent2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, concPercent3, 'linewidth', 2, 'color', rgb('light green'));

ylim([0 1])
xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('Trial 1', 'Trial 2', 'Trial 3');


%Log Scale Plot Concentration
figure();
plot(durationArr, logConc1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, logConc2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, logConc3, 'linewidth', 2, 'color', rgb('light green'));

xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Logarithmic Mass Concentration $$\ln (\frac{\mu g}{m^{3}})$$');
title('Natural Log Transform of Mass Concentration');
legend('Trial 1', 'Trial 2', 'Trial 3');

%Log Scale Plot Fractional
figure();
plot(durationArr, logFrac1, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArr, logFrac2, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArr, logFrac3, 'linewidth', 2, 'color', rgb('light green'));

xlabel('Time (min)')
ylabel('$$PM_{2.5}$$ Logarithmic Fraction Remaining $$\ln (\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Natural Log Transform of First Order Decay');
legend('Trial 1', 'Trial 2', 'Trial 3');