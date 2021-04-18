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
    sCurrentCountryName = regexprep(sCurrentCountryName, '_PART1.mat', '');
    sPath2Country = append(sPath2ImportedData, sCurrentCountryName);  
    rCountryStructure = fLoadCountryStructure('folder_FilteredData', sCurrentCountryName);
    
    %Calculate operating profitability farma and french
    %[mOpProfitff] = fOpProfitff(rCountryStructure);
    
    
    %Calculate operating profitability
    %[mOpProfit] = fOpProfit(rCountryStructure);
    
    %Calculate natural logarithm of the 1-month lagged market value
    [mLogMV] = fLogMV(rCountryStructure);
end

%% Create stacked data set

%vY = mOpProfitff; %create vector of dependet variable

%mX = [mOpProfit, mLogMV]; %create matrix of explanatory variables

%% Estimate regression equation

%stats = regstats(vY,mX); 

%r = stats.r;

%beta = stats.beta;
                 




