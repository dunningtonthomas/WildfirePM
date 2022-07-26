%% Clean Up
clear; close all; clc;

%% Analysis
load('CADR_Salt.mat');
load('CADR_Smoke.mat');


%% Plotting
figure();
xStrings = ["Oransi", "Oreck", "Smoke Eater"];
plotX = categorical(xStrings);
yValues = [oraCFM_Smoke, oreckCFM_Smoke, seCFM_Smoke];
colors = {rgb('light blue'), rgb('light purple'), rgb('light orange')};

%These are for the legends
scatter(plotX(1), 0, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
hold on
scatter(plotX(1), 0, 's', 'MarkerEdgeColor', 'k');

scatter(plotX(1), oraCFM_Salt, 30, 'o', 'MarkerFaceColor', rgb('light blue'), 'MarkerEdgeColor', rgb('light blue'), 'linewidth', 1.25);
scatter(plotX(2), oreckCFM_Salt, 30, 'o', 'MarkerFaceColor', rgb('light purple'), 'MarkerEdgeColor', rgb('light purple'), 'linewidth', 1.25);
scatter(plotX(3), seCFM_Salt, 30, 'o', 'MarkerFaceColor', rgb('light orange'), 'MarkerEdgeColor', rgb('light orange'), 'linewidth', 1.25);
h1 = scatter(plotX(1), yValues(1), 50, 's', 'MarkerEdgeColor', colors{1}, 'linewidth', 1.25);
h2 = scatter(plotX(2), yValues(2), 50, 's', 'MarkerEdgeColor', colors{2}, 'linewidth', 1.25);
h3 = scatter(plotX(3), yValues(3), 50, 's', 'MarkerEdgeColor', colors{3}, 'linewidth', 1.25);
set(gca, 'ticklabelinterpreter', 'latex');

%Error Bars
% yneg = [oraCFMLow, oreckCFMLow, seCFMLow];
% ypos = [oraCFMUp, oreckCFMUp, seCFMUp];
% errorbar(plotX(1), yValues(1), yValues(1)-yneg(1), ypos(1)-yValues(1), 'color', colors{1});
% errorbar(plotX(2), yValues(2), yValues(2)-yneg(2), ypos(2)-yValues(2), 'color', colors{2});
% errorbar(plotX(3), yValues(3), yValues(3)-yneg(3), ypos(3)-yValues(3), 'color', colors{3});

ylim([90,350]);
ylabel('CADR $$(cfm)$$');
title('Clean Air Delivery Rates');
legend('Salt CADR', 'Smoke CADR', 'interpreter', 'latex');



