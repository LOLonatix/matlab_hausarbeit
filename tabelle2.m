%% Script start and setup
clear; clc;

% Adding folder with functions for the table to the paths so that the
% functions can be used.
addpath(genpath('Tabelle2'));
%create arrays that are later being filled?
mGrossProfit_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mOpProfit_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mOpProfitff_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mCbOpProfit_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
%load data

% Get a list of all files and folders in this folder.
sPath2ImportedData = append(pwd, '\', 'folder_FilteredData\');
rFolders = dir(sPath2ImportedData)

% Get all the names frum struct_array and remove the first two, if they
% were created by github "." and "..".
cCountryNames = extractfield(rFolders, 'name');
if cell2mat(cCountryNames(1)) == '.'
cCountryNames = cCountryNames(3:end);
end 

% Get amount all folder/countrie_names.
dNumberCountries = length(cCountryNames);

% Create an empty cell array that is used as a preliminary table for
% preallocation with the same amount of rows as countries and with 11
% columns as the table 1 in the paper (Hanauer et al., 2018).
cTable1=cell(dNumberCountries,11);

%% Country Data
% For-loop also copied from fFilterData up to the definition of 'sName'.

for i=1:dNumberCountries
    % Loading the struct of the current country.
    sCurrentCountryName = cell2mat(cCountryNames(i));
    sPath2Country = append(sPath2ImportedData, sCurrentCountryName);  
    load(sPath2Country, 'rCountryStructure');
        
    % Get a list with all company-keys and determine amount of companies.
    cAllCompanyKeys = fieldnames(rCountryStructure);
    dAmountCompanies = length(cAllCompanyKeys);
%call function to check 
%replace NaNs with 0s
cFieldNames = fieldnames(rCountryStructure);
vItem = {'TRI'};
for i = 1:numel(cFieldNames)
    for j = 1:numel(vItem)
        mTemp = rCountryStructure.(cFieldNames{i}).(vItem{j});
        mTemp(isnan(mTemp))=0;        
        rCountryStructure.(cFieldNames{i}).(vItem{j}) = mTemp;
    end
end

%calculate gross profits
[vGrossProfit,cGrossProfit] = fGrossProfits(rCountryStructure);
%calculate Operating profitability ball 2016
[vOpProfit,cOpProfit] = fOpProfit(rCountryStructure);
%calculate operating profitability fama 
[vOpProfitff] = fOpProfitff(rCountryStructure);
%Calculate Cash based operating profitability
[vCbOpProfit] = fCbOpProfit(rCountryStructure,cOpProfit);
%Calculate Cash based gross profit
%[vCbGrossProfit] = fCbOpProfit(rCountryStructure,cGrossProfit);
%calculate other stuff



%Add all means, sd and quantiles into one array for all countries
%gross profit arrays
mGrossProfit_AllCountries=[mGrossProfit_AllCountries(:),vGrossProfit(:)];

%operating profitability arrays 
mOpProfit_AllCountries=[mOpProfit_AllCountries(:),vOpProfit(:)];
%Operating profit ff
mOpProfitff_AllCountries=[mOpProfitff_AllCountries(:),vOpProfitff(:)];
%repeat with all countries
end%end of for schleife
%calculate mean of each row of each array
vMeanGrossProfit_AllCountries=mean(mGrossProfit_AllCountries,2);
vMeanOpProfit_AllCountries=mean(mOpProfit_AllCountries,2);
vMeanOpProfitff_AllCountries=mean(mOpProfitff_AllCountries,2);
%create table2; containing all values 
tTabelle2=table(vMeanGrossProfit_AllCountries,vMeanOpProfitff_AllCountries,vMeanOpProfit_AllCountries,'VariableNames',{'GP','OPff','OP'},'RowNames',{'Mean','Standard Deviation','1% Quantiles','25% Quantiles','50% Quantiles','75% Quantiles','99% Quantiles'});
clc;










