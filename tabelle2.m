%% Script start and setup
clear; clc;

% Adding folder with functions for the table to the paths so that the
% functions can be used.
addpath(genpath('folder_Tabelle2'));
%create arrays that are later being filled?
mGrossProfit_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mOpProfit_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mOpProfitff_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mCbOpProfit_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mCbGrossProfit_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mLogBM_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mLogMV_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mMomentum_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
m1MLReturn_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mAccruals_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
mGrowthTA_AllCountries = [];%leerer vektor; sieben nullen für mean, sd und 5 quantiles
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

%% Country Data
% For-loop also copied from fFilterData up to the definition of 'sName'.

for i=1:dNumberCountries
    % Loading the struct of the current country.
     % Loading the struct of the current country.
    sCurrentCountryName = cell2mat(cCountryNames(i));
    sCurrentCountryName = regexprep(sCurrentCountryName, '_PART1.mat', '');
    sPath2Country = append(sPath2ImportedData, sCurrentCountryName);  
    rCountryStructure = fLoadCountryStructure('folder_FilteredData', sCurrentCountryName);
        
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
%hier start und enddatum einbauen für jedes Land, alles davor und danach löschen

%calculate gross profits
[vGrossProfit,cGrossProfit] = fGrossProfits(rCountryStructure);
%calculate Operating profitability ball 2016
[vOpProfit,cOpProfit] = fOpProfit(rCountryStructure);
%calculate operating profitability fama 
[vOpProfitff] = fOpProfitff(rCountryStructure);
%Calculate Cash based operating profitability
[vCbOpProfit] = fCbOpProfit(rCountryStructure,cOpProfit);
%Calculate Cash based gross profit
[vCbGrossProfit] = fCbOpProfit(rCountryStructure,cGrossProfit);
%calculate other stuff
[vLogMV] = fLogMV(rCountryStructure);
[vLogBM] = fLogBM(rCountryStructure);
[vMomentum] = fMomentum(rCountryStructure);
[v1MLReturn] = f1MLReturn(rCountryStructure);
[vAccruals] = fAccruals(rCountryStructure);
[vGrowthTA] = fGrowthTA(rCountryStructure);

%Add all means, sd and quantiles into one array for all countries
%gross profit arrays
%mGrossProfit_AllCountries=[mGrossProfit_AllCountries(:),vGrossProfit(:)]
mGrossProfit_AllCountries=horzcat(mGrossProfit_AllCountries,vGrossProfit);
%operating profitability arrays 
mOpProfit_AllCountries=[mOpProfit_AllCountries,vOpProfit];
%Operating profit ff
mOpProfitff_AllCountries=[mOpProfitff_AllCountries,vOpProfitff];
%repeat with all countries
mCbOpProfit_AllCountries=[mCbOpProfit_AllCountries,vCbOpProfit];
mCbGrossProfit_AllCountries=[mCbGrossProfit_AllCountries,vCbGrossProfit];
mLogMV_AllCountries=[mLogMV_AllCountries,vLogMV];
mLogBM_AllCountries=[mLogBM_AllCountries,vLogBM];
mMomentum_AllCountries=[mMomentum_AllCountries,vMomentum];
m1MLReturn_AllCountries=[m1MLReturn_AllCountries,v1MLReturn];
mAccruals_AllCountries=[mAccruals_AllCountries,vAccruals];
mGrowthTA_AllCountries=[mGrowthTA_AllCountries,vGrowthTA];
end%end of for schleife
%calculate mean of each row of each array
vMeanGrossProfit_AllCountries=mean(mGrossProfit_AllCountries,2);
vMeanOpProfit_AllCountries=mean(mOpProfit_AllCountries,2);
vMeanOpProfitff_AllCountries=mean(mOpProfitff_AllCountries,2);
vMeanCbOpProfit_AllCountries=mean(mCbOpProfit_AllCountries,2);
vMeanCbGrossProfit_AllCountries=mean(mCbGrossProfit_AllCountries,2);
vMeanLogMV_AllCountries=mean(mLogMV_AllCountries,2);
vMeanLogBM_AllCountries=mean(mLogBM_AllCountries,2);
vMeanMomentum_AllCountries=mean(mMomentum_AllCountries,2);
vMean1MLReturn_AllCountries=mean(m1MLReturn_AllCountries,2);
vMeanAccruals_AllCountries=mean(mAccruals_AllCountries,2);
vMeanGrowthTA_AllCountries=mean(mGrowthTA_AllCountries,2);
%create table2; containing all values 
tTabelle2=table(vMeanGrossProfit_AllCountries,vMeanOpProfitff_AllCountries,vMeanOpProfit_AllCountries,vMeanCbOpProfit_AllCountries,vMeanCbGrossProfit_AllCountries,vMeanAccruals_AllCountries,vMeanLogBM_AllCountries,vMeanLogMV_AllCountries,vMean1MLReturn_AllCountries,vMeanMomentum_AllCountries,vMeanGrowthTA_AllCountries,...
    'VariableNames',{'GP','OPff','OP','CbOP','CbGP','Accr','log(B/M)','log(MV)','r1,1','r12,2','dA/A'},'RowNames',{'Mean','Standard Deviation','1% Quantiles','25% Quantiles','50% Quantiles','75% Quantiles','99% Quantiles'});
clc;










