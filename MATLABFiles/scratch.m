%% Clean up
close all; clear; clc;


%% Creating sample log transform plot

x = linspace(0,10,100);
y = 100*exp(-0.5*x);

figure();
plot(x,y, 'linewidth', 2, 'color', rgb('light purple'))
set(gca,'XTick',[], 'YTick', [])

figure();
plot(x, log(y), 'linewidth', 2, 'color', rgb('light purple'))
set(gca,'XTick',[], 'YTick', [])
