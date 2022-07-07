%% Analysis of all the CADR 
%% Clean Up
clear; close all; clc;

%% Import Data
load('Background.mat'); %Background trials
load('SmokeEater.mat'); %Smoke Eater Trials


%% Analysis



%% Plotting

%Total concentration Averages
figure();
set(0, 'defaulttextinterpreter', 'latex');
plot(durationArr, averageConc, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArrSE, averageConcSE, 'linewidth', 2, 'color', rgb('light blue'));

xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Mass Concentration $$\frac{\mu g}{m^{3}}$$');
title('Total Mass Concentrations');
legend('No Intervention', 'Smoke Eater', 'Oransi', 'Oreck');


%Fraction Remaining Averages
figure();
plot(durationArr, averageFrac, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArrSE, averageFracSE, 'linewidth', 2, 'color', rgb('light blue'));

ylim([0 1])
xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Fraction $$(\frac{PM_{2.5}}{PM_{2.5_{0}}})$$');
title('Fraction Remaining');
legend('No Intervention', 'Smoke Eater', 'Oransi', 'Oreck');


%Logarithmic fraction remaining plot
figure();
plot(durationArr, averageFracLog, 'linewidth', 2, 'color', rgb('light red'));
hold on
plot(durationArrSE, averageFracLogSE, 'linewidth', 2, 'color', rgb('light blue'));

xlabel('Time $$(min)$$')
ylabel('$$PM_{2.5}$$ Logarithmic Mass Concentration $$\ln (\frac{\mu g}{m^{3}})$$');
title('Natural Log Transform of Mass Concentration');
legend('No Intervention', 'Smoke Eater', 'Oransi', 'Oreck');

