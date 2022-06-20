function [timeDataTot, carbonDataTot] = importAranet(files)
%IMPORTFILES: This function will take a structure of the files to be
%imported. It will loop through the struct to read in every file and output
%the time and carbon dioxide data.
%Inputs: structure containing all of the files to be read in
%Outputs: [time, carbonDioxide]

%Current Directory
matFileBack = pwd;

opts = delimitedTextImportOptions('NumVariables', 5);
opts.VariableNames(1) = {'Time'};
opts.VariableNames(2) = {'Carbon Dioxide (ppm)'};
opts.VariableNames(3) = {'Temperature (C)'};
opts.VariableNames(4) = {'Relative Humidity (%)'};
opts.VariableNames(5) = {'Atmospheric Pressure (hPa)'};

carbonDataTot = cell(length(files),1);
timeDataTot = cell(length(files),1);

for i = 1:length(files)
    cd(files(i).folder);
    data = readmatrix(files(i).name, opts); %Read in data
    time = data(2:end, 1);
    carbonD = data(2:end,2);
    temperature = data(2:end,3);
    humid = data(2:end,4);
    atmosPress = data(2:end,5);

    %Converting to doubles
    carbonDFinal = zeros(length(carbonD), 1);
    for j = 1:length(carbonD)
        temp = str2double(cell2mat(carbonD(j)));
        carbonDFinal(j) = temp;        
    end
    
    %Concatenate to get rid of initial calibration spikes and final spikes
    carbonDFinal = carbonDFinal(30:end-2);
    carbonDataTot{i} = carbonDFinal;
    
    timeData = time(30:end-2);
    timeDataTot{i} = timeData;  %Raw time data outputed
end

cd(matFileBack); %Going back to matlab file directory
end

