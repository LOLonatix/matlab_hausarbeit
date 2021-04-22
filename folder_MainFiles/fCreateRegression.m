function [tTable_Regression1, tTable_Regression2, tTable_Regression3] = fCreateRegression()
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
    [mOpProfitff] = fOpProfitff(rCountryStructure);
    
    
    %Calculate operating profitability
    [mOpProfit] = fOpProfit(rCountryStructure);
    
    %Calculate natural logarithm of the 1-month lagged market value
    [mLogMV] = fLogMV(rCountryStructure);
    
end

%% Create stacked data set

%delete NaNs if mOpProfitff, mOpProfit and mLogMV have NaNs in the same row
for i = numel(mOpProfitff):-1:1
   
    if isnan(mOpProfitff(i)) == 1 & isnan(mOpProfit(i)) == 1 & isnan(mLogMV(i)) == 1
        
        mOpProfitff(i) = [];
        mOpProfit(i) = [];
        mLogMV(i) = [];
        
    end
    
end

vY = mOpProfitff; %create vector of dependent variable

mX = [mOpProfit, mLogMV]; %create matrix of explanatory variables

%% Estimate regression equation

stats = regstats(vY,mX); 

%% Create Regression Tables

Table_Input_Data = {'Dependent Variable';'Method';'Included Observations'; 'Constant b0'};

Input = {'OpProfitFF';'Least Squares';numel(mOpProfitff); stats.beta(1)};

%Create Table of input Data for regression
tTable_Regression1 = table(Table_Input_Data, Input);

Explanatory_Variable = {'OpProfit'; 'log(MV)'};

Coefficients = {stats.beta(2); stats.beta(3)};

t_Statistics = {stats.tstat.t(2); stats.tstat.t(3)};

%Create Table of output Data for regression
tTable_Regression2 = table(Explanatory_Variable, Coefficients, t_Statistics);  

Table_Output_Data = {'Mean squared error';'R-squared';'F-Statistic';'Durbin-Watson Statistic'};

Output = {stats.mse; stats.rsquare; stats.fstat.f; stats.dwstat.dw};

%Create Table of additional output Data for regression
tTable_Regression3 = table(Table_Output_Data, Output);

end


