%% Clean up
close all; clear; clc;


%% Creating color array
x = linspace(0,10,100);
y = sin(x);
colorCell = cell(10,1);
greenValues = linspace(0,1,10);

for i = 1:length(colorCell)
   colorCell{i} = [1 0.75 - greenValues(i) 0];    
end

figure();
plot(x,y,'color',colorCell{1})
hold on
for i = 1:length(greenValues)
    plot(x, y-0.1*i, 'color', [1 greenValues(i) 0]);    
end