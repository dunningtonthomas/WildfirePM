function [popsdata] = importPOPS(path)
%importPOPS Import POPS data
%   %Data should be *.csv from instrument
%   %Output is a single cell array with the data for each individual scan
%   %organized into columns. Multiple text files can be selected.
%   %Last edited KJM 8/13/21

% Open folder
if nargin > 0
    current = cd(path);
elseif nargin == 0
    path = pwd;
end

% Select SMPS data files (can select multiple text files)
filelist = uigetfile('.csv', 'Select POPS data file', 'MultiSelect', 'on');

if ischar(filelist) == 1
    filelist = cellstr(filelist);
end

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 44);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["DateTime", "Status", "PartCt", "PartCon", "BL", "BLTH", "STD", "P", "TofP", "POPS_Flow", "PumpFB", "LDTemp", "LaserFB", "LD_Mon", "Temp", "BatV", "Laser_Current", "Flow_Set", "PumpLife_hrs", "BL_Start", "TH_Mult", "nbins", "logmin", "logmax", "Skip_Save", "MinPeakPts", "MaxPeakPts", "RawPts", "b0", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9", "b10", "b11", "b12", "b13", "b14", "b15"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Create empty table to hold data
popsdata = table();

% Import the data
for i = 1:length(filelist)
    tempdata = readtable([path,'\',filelist{i}], opts);
    popsdata = [popsdata; tempdata];
    tempdata = [];
end

%Sort data
popsdata = sortrows(popsdata);

%Convert time to Matlab datetime
popsdata.DateTime = datetime(popsdata.DateTime, 'ConvertFrom', 'posixtime');

%Return to original folder
if nargin > 0
    cd(current);
end

% Clear temporary variables
clear opts path current filelist
end

