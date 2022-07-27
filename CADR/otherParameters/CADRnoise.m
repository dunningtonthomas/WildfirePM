%% Clean Up
clear; close all; clc;

%% Load in data

%Flow Rates
oreckHighFlow = [66.2; 48.1; 52.7; 58.4; 50.3];
oransiHighFlow = [40; 34.7; 42.2];
smokeEaterHighFlow = [31; 0.7; 14.5; 17; 19];

%Flow rates has the max flow rate for each intervention
%Sum for the oransi because it has 3 separate outlets
flowRates = [sum(oransiHighFlow); max(oreckHighFlow); max(smokeEaterHighFlow)];
CADRSalt = [295; 213; 121];
CADRSmoke = [288; 197; 127];
avgCADR = mean([CADRSalt, CADRSmoke],2); 

%Max noise
oreckNoise = 52;
oransiNoise = 52;
smokeEaterNoise = 55;

noiseVec = [oransiNoise; oreckNoise; smokeEaterNoise];

%Wattage
oreckWatt = [7.3; 24.5; 86.9];
oransiWatt = [4; 12.3; 40];
smokeEaterWatt = [34.9; 67];





%% Plotting
%CADR vs flow rate
figure();
set(gca, 'defaulttextinterpreter', 'latex');
scatter(flowRates(1), avgCADR(1), 70, 'o', 'MarkerFaceColor', rgb('light purple'), 'MarkerEdgeColor', rgb('light purple'), 'linewidth', 1.25);
hold on
scatter(flowRates(2), avgCADR(2), 70, 'o', 'MarkerFaceColor', rgb('light orange'), 'MarkerEdgeColor', rgb('light orange'), 'linewidth', 1.25);
scatter(flowRates(3), avgCADR(3), 70, 'o', 'MarkerFaceColor', rgb('light blue'), 'MarkerEdgeColor', rgb('light blue'), 'linewidth', 1.25);

ylim([90 320]);
xlim([20, 130]);
ylabel('CADR');
xlabel('Flow Rate');
title('CADR Vs Flow Rate');
legend('Oransi', 'Oreck', 'Smoke Eater', 'location', 'nw', 'interpreter', 'latex');

%Each Intervention with wattage
x = figure();
xStrings = ["Oransi", "Oreck", "Smoke Eater"];
plotX = categorical(xStrings);
%Plotting for legend
scatter(plotX(1), -10, 100, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
hold on
scatter(plotX(1), -10, 100, 's', 'MarkerEdgeColor', 'k');
scatter(plotX(1), -10, 100, '*', 'MarkerEdgeColor', 'k');
%Real plotting
scatter(plotX(1), oransiWatt(1), 70, 'o', 'MarkerFaceColor', rgb('light purple'), 'MarkerEdgeColor', rgb('light purple'), 'linewidth', 1.25);
scatter(plotX(2), oreckWatt(1), 70, 'o', 'MarkerFaceColor', rgb('light orange'), 'MarkerEdgeColor', rgb('light orange'), 'linewidth', 1.25);
scatter(plotX(3), smokeEaterWatt(1), 70, 'o', 'MarkerFaceColor', rgb('light blue'), 'MarkerEdgeColor', rgb('light blue'), 'linewidth', 1.25);

%Medium Setting
scatter(plotX(1), oransiWatt(2), 70, 's', 'MarkerEdgeColor', rgb('light purple'), 'linewidth', 1.25);
scatter(plotX(2), oreckWatt(2), 70, 's', 'MarkerEdgeColor', rgb('light orange'), 'linewidth', 1.25);

%High Setting
scatter(plotX(1), oransiWatt(3), 70, '*', 'MarkerFaceColor', rgb('light purple'), 'MarkerEdgeColor', rgb('light purple'), 'linewidth', 1.25);
scatter(plotX(2), oreckWatt(3), 70, '*', 'MarkerFaceColor', rgb('light orange'), 'MarkerEdgeColor', rgb('light orange'), 'linewidth', 1.25);
scatter(plotX(3), smokeEaterWatt(2), 70, '*', 'MarkerFaceColor', rgb('light blue'), 'MarkerEdgeColor', rgb('light blue'), 'linewidth', 1.25);
set(gca, 'ticklabelinterpreter', 'latex');

ylim([0, 100]);
legend('Low', 'Medium', 'High', 'interpreter', 'latex');
ylabel('Wattage');


%Making Plot for CADR of smoke and CADR of salt
figure();
xStrings = ["Oransi", "Oreck", "Smoke Eater"];
plotX = categorical(xStrings);
yValues = [oraCFM, oreckCFM, seCFM];
colors = {rgb('light blue'), rgb('light purple'), rgb('light orange')};

scatter(plotX(1), 0, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
hold on
scatter(plotX(1), 0, 's', 'MarkerEdgeColor', 'k');


scatter(plotX(1), 288, 70, '*', 'MarkerFaceColor', rgb('light blue'), 'MarkerEdgeColor', rgb('light blue'), 'linewidth', 1.25);
scatter(plotX(2), 197, 70, '*', 'MarkerFaceColor', rgb('light blue'), 'MarkerEdgeColor', rgb('light purple'), 'linewidth', 1.25);
scatter(plotX(3), 127, 70, '*', 'MarkerFaceColor', rgb('light orange'), 'MarkerEdgeColor', rgb('light orange'), 'linewidth', 1.25)
h1 = scatter(plotX(1), yValues(1), 100, 's', 'MarkerEdgeColor', colors{1}, 'linewidth', 1.25);
h2 = scatter(plotX(2), yValues(2), 100, 's', 'MarkerEdgeColor', colors{2}, 'linewidth', 1.25);
h3 = scatter(plotX(3), yValues(3), 100, 's', 'MarkerEdgeColor', colors{3}, 'linewidth', 1.25);
set(gca, 'ticklabelinterpreter', 'latex');



