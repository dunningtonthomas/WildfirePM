%% Clean Up
clear; clc; close all;

%% Import Data

%SMPS import
pathSMPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\CADR\data\ambientDecay\SMPS';
smpsData = importSMPS(pathSMPS);
smpsDataRaw = smpsData;


%APS import
pathAPS = 'C:\Users\Thomas\Documents\MATLAB\GitHub\SPUR\WildfirePM\WildfirePM\CADR\data\ambientDecay\APS';
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

%Total mass concentrations over time
smpsTime = [smpsData{1,:}];
smpsTotalConc = [smpsData{4,:}];

apsTime = [apsData{1,:}];
apsTotalConc = [apsData{4,:}];

totalConc = apsTotalConc + smpsTotalConc;

%Variables for percent plot
peakConc = max(totalConc);
concPercent = totalConc / peakConc;

%Size Distribution Analysis
[~, maxInd] = max(totalConc); %Peak Concentration
smpsPeakBins = smpsData{2, maxInd} / 1000; %Converting to microns
smpsPeakDist = smpsData{3, maxInd};
apsPeakBins = apsData{2, maxInd};
apsPeakDist = apsData{3, maxInd};

%% Plotting 
start_time = datetime(2022, 07, 05, 13, 20, 00); %nebulizer on
stop_time = datetime(2022, 07, 05, 14, 30, 00); %End of collection

%Total concentration plot
figure();
set(0, 'defaulttextinterpreter', 'latex');
plot(smpsTime, totalConc, 'linewidth', 2, 'color', rgb('light red'));
hold on

%xlim([start_time stop_time]);
xlabel('Time')
ylabel('$$PM_{2.5}$$ Mass Concentration $$\frac{\mu g}{m^{3}}$$');
title('Total Mass Concentrations');

%Percentage plot
figure();
plot(smpsTime, concPercent, 'linewidth', 2, 'color', rgb('light blue'));

%xlim([start_time stop_time]);
ylim([0 1])
xlabel('Time')
ylabel('$$PM_{2.5}$$ Percent');
title('Percent Remaining');

%Size Distribution Plot
figure();
plot(smpsPeakBins, smpsPeakDist, 'linewidth', 2, 'color', rgb('light blue'));
hold on
plot(apsPeakBins, apsPeakDist, 'linewidth', 2, 'color', rgb('light green'));
set(gca, 'XScale' , 'log');

legend('SMPS', 'APS', 'location', 'NW');
xlabel('Size Bins $$(\mu m)$$')
ylabel('$$PM_{2.5}$$ Mass Concentration $$\frac{\mu g}{m^{3}}$$');
title('Size Distribution');

%% Final Clean