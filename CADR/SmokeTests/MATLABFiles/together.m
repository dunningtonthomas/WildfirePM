%% Analysis of all the CADR 
%% Clean Up
clear; close all; clc;

%% Import Data
load('Background.mat'); %Background trials
load('SmokeEater.mat'); %Smoke Eater Trials
load('Oransi.mat');
load('BackgroundOccupied.mat');
load('Oreck.mat');

%% Analysis
%Clean Air Delivery Rate Analysis

%Standard Deviation Calculations
backgroundUp = averageFrac + stdFrac;
backgroundLow = averageFrac - stdFrac;

occupiedUp = occupiedFrac + occupiedFracStd;
occupiedLow = occupiedFrac - occupiedFracStd;

SEUp = averageFracSE + stdFracSE;
SELow = averageFracSE - stdFracSE;

ORAUp = averageFracORA + stdFracORA;
ORALow = averageFracORA - stdFracORA;

oreckUp = averageFracOreck + stdFracOreck;
oreckLow = averageFracOreck - stdFracOreck;

%Log std
backgroundUpLog = averageFracLog + stdFracLog;
backgroundLowLog = averageFracLog - stdFracLog;

SEUpLog = averageFracLogSE + stdFracLogSE;
SELowLog = averageFracLogSE - stdFracLogSE;

ORAUpLog = averageFracLogORA + stdFracLogORA;
ORALowLog = averageFracLogORA - stdFracLogORA;

oreckUpLog = averageFracLogOreck + stdFracLogOreck;
oreckLowLog = averageFracLogOreck - stdFracLogOreck;

%CFM Analysis
%NEED: decay constants for each PAC and natural deposition unocc and occ
%Also need: std of each
roomSize = 1341.96;     %ft^3

%CFM calculations with upper and lower error regions
seCFM = (-1*seK - (-1)*unoccupiedK) * roomSize;
seCFMLow = ((-1)*(seK - seStd) - (-1)*(unoccupiedK + unoccupiedStd)) * roomSize;
seCFMUp = ((-1)*(seK + seStd) - (-1)*(unoccupiedK - unoccupiedStd)) * roomSize;

%Oreck
oreckCFM = (-1*oreckK - (-1)*occupiedK) * roomSize;
oreckCFMLow = ((-1)*(oreckK - oreckStd) - (-1)*(occupiedK + occupiedStd)) * roomSize;
oreckCFMUp = ((-1)*(oreckK + oreckStd) - (-1)*(occupiedK - occupiedStd)) * roomSize;

%Oransi
oraCFM = (-1*oraK - (-1)*unoccupiedK) * roomSize;
oraCFMLow = ((-1)*(oraK - oraStd) - (-1)*(unoccupiedK + unoccupiedStd)) * roomSize;
oraCFMUp = ((-1)*(oraK + oraStd) - (-1)*(unoccupiedK - unoccupiedStd)) * roomSize;

%Manufacturer reported values
oraM = 333;
seM = 275;

seCFM_Smoke = seCFM;
oreckCFM_Smoke = oreckCFM;
oraCFM_Smoke = oraCFM;
save('CADR_Smoke', 'seCFM_Smoke', 'oreckCFM_Smoke', 'oraCFM_Smoke');


%% Plotting

%Fraction Remaining Averages
set(0, 'defaulttextinterpreter', 'latex');
figure();
plot(durationArr, averageFrac, 'linewidth', 2, 'color', rgb('green'));
hold on
plot(durationArrSE, averageFracSE, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArrOreck, averageFracOreck, 'linewidth', 2, 'color', rgb('light orange'));
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

%Plotting the Standard Deviation Oreck
h3 = fill([durationArrOreck, flip(durationArrOreck)], [oreckUp, flip(oreckLow)], rgb('light orange'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

ylim([0 1])
xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('No Intervention', 'Smoke Eater', 'Oreck', 'Oransi');


%Logarithmic fraction remaining plot
figure();
plot(durationArr, averageFracLog, 'linewidth', 2, 'color', rgb('green'));
hold on
plot(durationArrSE, averageFracLogSE, 'linewidth', 2, 'color', rgb('light blue'));
plot(durationArrOreck, averageFracLogOreck, 'linewidth', 2, 'color', rgb('light orange'));
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

%Plotting the Standard Deviation Oreck
h3 = fill([durationArrOreck, flip(durationArrOreck)], [oreckUpLog, flip(oreckLowLog)], rgb('light orange'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Logarithmic Fraction Remaining $$\ln (\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Natural Log Transform of First Order Decay');
legend('No Intervention', 'Smoke Eater', 'Oreck', 'Oransi');


%Comparing Control Triplicate to Avery Intervention Fraction Remaining
figure();
plot(durationArr, averageFrac, 'linewidth', 2, 'color', rgb('green'));
hold on

%Plotting the Standard Deviation Background
h3 = fill([durationArr, flip(durationArr)], [(backgroundUp), flip(backgroundLow)], rgb('tea green'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%Plotting the 5% error region
plot(durationArr, 1.05*averageFrac, 'linestyle', '--', 'color', rgb('green'));

%Avery Inside Average of 3 trials
plot(durationArr, occupiedFrac(1:length(durationArr)), 'linewidth', 2, 'color', rgb('darkish pink'));

%Avery Inside Standard Deviation
h3 = fill([durationArr, flip(durationArr)], [(occupiedUp(1:length(durationArr))), flip(occupiedLow(1:length(durationArr)))], rgb('light pink'), 'HandleVisibility', 'off');
set(h3,'facealpha',0.5) %Makes the shading see-though
h3.LineStyle = 'none'; %Turn off outline

%5% error region, after everything so we do not have to include a legend
%entry for it
plot(durationArr, 0.95*averageFrac, 'linestyle', '--', 'color', rgb('green'));

ylim([0 1])
xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('Unoccupied Deposition', '5% Error Region', 'Occupied Deposition');


% Making CFM Plot
figure();
xStrings = ["Oransi", "Oreck", "Smoke Eater"];
plotX = categorical(xStrings);
yValues = [oraCFM, oreckCFM, seCFM];
colors = {rgb('light blue'), rgb('light purple'), rgb('light orange')};

scatter(plotX(1), 0, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
hold on
scatter(plotX(1), 0, 's', 'MarkerEdgeColor', 'k');
scatter(plotX(1), oraM, 70, 'o', 'MarkerFaceColor', rgb('light blue'), 'MarkerEdgeColor', rgb('light blue'), 'linewidth', 1.25)
scatter(plotX(3), seM, 70, 'o', 'MarkerFaceColor', rgb('light orange'), 'MarkerEdgeColor', rgb('light orange'), 'linewidth', 1.25)
h1 = scatter(plotX(1), yValues(1), 100, 's', 'MarkerEdgeColor', colors{1}, 'linewidth', 1.25);
h2 = scatter(plotX(2), yValues(2), 100, 's', 'MarkerEdgeColor', colors{2}, 'linewidth', 1.25);
h3 = scatter(plotX(3), yValues(3), 100, 's', 'MarkerEdgeColor', colors{3}, 'linewidth', 1.25);
set(gca, 'ticklabelinterpreter', 'latex');

%Error Bars
yneg = [oraCFMLow, oreckCFMLow, seCFMLow];
ypos = [oraCFMUp, oreckCFMUp, seCFMUp];
errorbar(plotX(1), yValues(1), yValues(1)-yneg(1), ypos(1)-yValues(1), 'color', colors{1});
errorbar(plotX(2), yValues(2), yValues(2)-yneg(2), ypos(2)-yValues(2), 'color', colors{2});
errorbar(plotX(3), yValues(3), yValues(3)-yneg(3), ypos(3)-yValues(3), 'color', colors{3});

ylim([90,350]);
ylabel('CADR $$(cfm)$$');
title('Clean Air Delivery Rates');
legend('Manufacturer Reported', 'Experimentally Determined', 'interpreter', 'latex');


