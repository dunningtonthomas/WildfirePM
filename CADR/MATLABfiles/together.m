%% Analysis of all the CADR 
%% Clean Up
clear; close all; clc;

%% Import Data
load('Background.mat'); %Background trials
load('SmokeEater.mat'); %Smoke Eater Trials
load('Oransi.mat');
load('AveryThomas.mat');
load('Oreck.mat');

%% Analysis
%Clean Air Delivery Rate Analysis
roomSize = 1341.96;     %ft^3


%Standard Deviation Calculations
backgroundUp = averageFrac + stdFrac;
backgroundLow = averageFrac - stdFrac;

averyUp = averyFrac + averyStdFrac;
averyLow = averyFrac - averyStdFrac;

SEUp = averageFracSE + stdFracSE;
SELow = averageFracSE - stdFracSE;

ORAUp = averageFracORA + stdFracORA;
ORALow = averageFracORA - stdFracORA;

oreckUp = averageFracOreck + stdFracOreck;
oreckLow = averageFracOreck - stdFracOreck;

%Log std
backgroundUpLog = averageFracLog + stdFracLog;
backgroundLowLog = averageFracLog - stdFracLog;

averyUpLog = averyFracLog + averyStdFracLog;
averyLowLog = averyFracLog - averyStdFracLog;

SEUpLog = averageFracLogSE + stdFracLogSE;
SELowLog = averageFracLogSE - stdFracLogSE;

ORAUpLog = averageFracLogORA + stdFracLogORA;
ORALowLog = averageFracLogORA - stdFracLogORA;

oreckUpLog = averageFracLogOreck + stdFracLogOreck;
oreckLowLog = averageFracLogOreck - stdFracLogOreck;

%% Plotting

%Fraction Remaining Averages
figure();
plot(durationArr, averageFrac, 'linewidth', 2, 'color', rgb('green'));
hold on
plot(durationArrSE, averageFracSE, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArrORA, averageFracORA, 'linewidth', 2, 'color', rgb('light purple'));
plot(durationArrOreck, averageFracOreck, 'linewidth', 2, 'color', rgb('light orange'));

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

%Plotting the Standard Deviation Oreck
h3 = fill([durationArrOreck, flip(durationArrOreck)], [oreckUp, flip(oreckLow)], rgb('light orange'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline


ylim([0 1])
xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('No Intervention', 'Smoke Eater', 'Oransi', 'Oreck');


%Logarithmic fraction remaining plot
figure();
plot(durationArr, averageFracLog, 'linewidth', 2, 'color', rgb('green'));
hold on
plot(durationArrSE, averageFracLogSE, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArrORA, averageFracLogORA, 'linewidth', 2, 'color', rgb('light purple'));
plot(durationArrOreck, averageFracLogOreck, 'linewidth', 2, 'color', rgb('light orange'));

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

%Plotting the Standard Deviation Oreck
h3 = fill([durationArrOreck, flip(durationArrOreck)], [oreckUpLog, flip(oreckLowLog)], rgb('light orange'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline



xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Logarithmic Fraction Remaining $$\ln (\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Natural Log Transform of First Order Decay');
legend('No Intervention', 'Smoke Eater', 'Oransi', 'Oreck');


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

%Avery Inside Average of 3 trials
plot(durationArr, averyFrac, 'linewidth', 2, 'color', rgb('darkish pink'));

%Avery Inside Standard Deviation
h3 = fill([durationArr, flip(durationArr)], [(averyUp), flip(averyLow)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

xTemp = [0 0 0 0];
yTemp = [-1 -1 -1 -1];
patch(xTemp, yTemp, rgb('light pink'));

%5% error region, after everything so we do not have to include a legend
%entry for it
plot(durationArr, 0.95*averageFrac, 'linestyle', '--', 'color', rgb('green'));


ylim([0 1])
xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('No Intervention', 'Standard Deviation', 'Error Region', 'Occupied', 'Standard Deviation');



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

%Avery Inside Standard Deviation
h3 = fill([durationArr, flip(durationArr)], [(averyUpLog), flip(averyLowLog)], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

xTemp = [0 0 0 0];
yTemp = [-1 -1 -1 -1];
patch(xTemp, yTemp, rgb('light pink'));

%5% error region
plot(durationArr, 0.95*averageFracLog, 'linestyle', '--', 'color', rgb('green'));


xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Logarithmic Fraction Remaining $$\ln (\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Natural Log Transform of First Order Decay');
legend('No Intervention', 'Standard Deviation', 'Error Region', 'Occupied', 'Standard Deviation');
