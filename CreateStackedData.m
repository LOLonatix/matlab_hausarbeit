%% Start script

clc;clear;

%% add folder with functions for regression to this path

addpath(genpath('folder_Regression'));

%% Get Country data

% Copy from fFilterData to read all files and get the structs of each
% country and firm and determine the amount of countries.

% Get a list of all files and folders in this folder.
sPath2ImportedData = append(pwd, '\', 'folder_FilteredData\');
rFolders = dir(sPath2ImportedData);

% Get all the names frum struct_array and remove the first two, if they
% were created by github "." and "..".
cCountryNames = extractfield(rFolders, 'name');
if cell2mat(cCountryNames(1)) == '.'
cCountryNames = cCountryNames(3:end);
end 

% Get amount all folder/countrie_names.
dNumberCountries = length(cCountryNames);

%% Calculate data for stacked data set

for i=1:dNumberCountries
    % Loading the struct of the current country.
    sCurrentCountryName = cell2mat(cCountryNames(i));
    sPath2Country = append(sPath2ImportedData, sCurrentCountryName);  
    load(sPath2Country, 'rCountryStructure');
    
    %Calculate operating profitability farma and french
    [AOpProfitff] = fOpProfitff(rCountryStructure);
    
    
    %Calculate operating profitability
    [AOpProfit] = fOpProfit(rCountryStructure);
    
    %Calculate natural logarithm of the 1-month lagged market value
    [ALogMV] = fLogMV(rCountryStructure);
end

%% Create Table of stacked data set


