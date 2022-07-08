%% Analysis of all the CADR 
%% Clean Up
clear; close all; clc;

%% Import Data
load('Background.mat'); %Background trials
load('SmokeEater.mat'); %Smoke Eater Trials
load('Oransi.mat');
load('BackgroundAvery.mat');

%% Analysis
%Clean Air Delivery Rate Analysis
roomSize = 1341.96;     %ft^3


%Standard Deviation Calculations
backgroundUp = averageFrac + stdFrac;
backgroundLow = averageFrac - stdFrac;

SEUp = averageFracSE + stdFracSE;
SELow = averageFracSE - stdFracSE;

ORAUp = averageFracORA + stdFracORA;
ORALow = averageFracORA - stdFracORA;

backgroundUpLog = averageFracLog + stdFracLog;
backgroundLowLog = averageFracLog - stdFracLog;

SEUpLog = averageFracLogSE + stdFracLogSE;
SELowLog = averageFracLogSE - stdFracLogSE;

ORAUpLog = averageFracLogORA + stdFracLogORA;
ORALowLog = averageFracLogORA - stdFracLogORA;

%% Plotting

%Fraction Remaining Averages
figure();
plot(durationArr, averageFrac, 'linewidth', 2, 'color', rgb('green'));
hold on
plot(durationArrSE, averageFracSE, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArrORA, averageFracORA, 'linewidth', 2, 'color', rgb('light purple'));

%Plotting the Standard Deviation Background
h3 = fill([durationArr, flip(durationArr)], [(backgroundUp), flip(backgroundLow)], rgb('tea green'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Plotting the Standard Deviation Smoke Eater
h3 = fill([durationArrSE, flip(durationArrSE)], [SEUp, flip(SELow)], rgb('light blue'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Plotting the Standard Deviation Oransi
h3 = fill([durationArrORA, flip(durationArrORA)], [ORAUp, flip(ORALow)], rgb('light purple'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline


ylim([0 1])
xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('No Intervention', 'Smoke Eater', 'Oransi');


%Logarithmic fraction remaining plot
figure();
plot(durationArr, averageFracLog, 'linewidth', 2, 'color', rgb('green'));
hold on
plot(durationArrSE, averageFracLogSE, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArrORA, averageFracLogORA, 'linewidth', 2, 'color', rgb('light purple'));

%Plotting the Standard Deviation Background
h3 = fill([durationArr, flip(durationArr)], [(backgroundUpLog), flip(backgroundLowLog)], rgb('tea green'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Plotting the Standard Deviation Smoke Eater
h3 = fill([durationArrSE, flip(durationArrSE)], [SEUpLog, flip(SELowLog)], rgb('light blue'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Plotting the Standard Deviation Oransi
h3 = fill([durationArrORA, flip(durationArrORA)], [ORAUpLog, flip(ORALowLog)], rgb('light purple'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline


xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Logarithmic Fraction Remaining $$\ln (\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Natural Log Transform of First Order Decay');
legend('No Intervention', 'Smoke Eater', 'Oransi');


%Comparing Control Triplicate to Avery Intervention Fraction Remaining
figure();
plot(durationArr, averageFrac, 'linewidth', 2, 'color', rgb('green'));
hold on

%Plotting the Standard Deviation Background
h3 = fill([durationArr, flip(durationArr)], [(backgroundUp), flip(backgroundLow)], rgb('tea green'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

xTemp = [0 0 0 0];
yTemp = [-1 -1 -1 -1];
patch(xTemp, yTemp, rgb('tea green'));

%Plotting the 5% error region
plot(durationArr, 1.05*averageFrac, 'linestyle', '--', 'color', rgb('green'));

%Avery Inside
plot(durationArr, averyFrac, 'linewidth', 2, 'color', rgb('darkish pink'));

%5% error region
plot(durationArr, 0.95*averageFrac, 'linestyle', '--', 'color', rgb('green'));


ylim([0 1])
xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('No Intervention', 'Standard Deviation', 'Error Region', 'Avery Inside');


%Comparing Control Triplicate to Avery Intervention Natural Log Transform
figure();
plot(durationArr, averageFracLog, 'linewidth', 2, 'color', rgb('green'));
hold on

%Plotting the Standard Deviation Background
h3 = fill([durationArr, flip(durationArr)], [(backgroundUpLog), flip(backgroundLowLog)], rgb('tea green'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

xTemp = [0 0 0 0];
yTemp = [-1 -1 -1 -1];
patch(xTemp, yTemp, rgb('tea green'));

%Plotting the 5% error region
plot(durationArr, 1.05*averageFracLog, 'linestyle', '--', 'color', rgb('green'));

%Avery Inside
plot(durationArr, averyFracLog, 'linewidth', 2, 'color', rgb('darkish pink'));

%5% error region
plot(durationArr, 0.95*averageFracLog, 'linestyle', '--', 'color', rgb('green'));


xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Logarithmic Fraction Remaining $$\ln (\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Natural Log Transform of First Order Decay');
legend('No Intervention', 'Standard Deviation', 'Error Region', 'Avery Inside');
