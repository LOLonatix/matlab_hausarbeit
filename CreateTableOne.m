%% Table 1
% Script used to call the functions needed to fill table 1 and in the
% following create the table itself.
%% Script start and setup
clear; clc;

% Adding folder with functions for the table to the paths so that the
% functions can be used.
addpath(genpath('Tabelle1'));

%% Reading required files
% Read the file containing the dates of the TS items to transform the start
% and end date position into a proper date.
tDates = readtable('TSDates.xlsx');

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
    load(sPath2Country, 'rCountryStructure')
        
    % Get a list with all company-keys and determine amount of companies.
    cAllCompanyKeys = fieldnames(rCountryStructure);
    dAmountCompanies = length(cAllCompanyKeys);
     
%% Rename countries    
    % Read contry name from filename and transform it into string.
    sName = (regexprep(sCurrentCountryName,'.mat',''));
    % Adjusting orthography of country name using the function
    % 'fOrthography'.
    sName = fOrthography(sName);

%% Determine market
    % Determine to which market the country belongs according to MSCI using
    % function the 'fMSCImarket'.
    sMarket = fMSCImarket(sName);

%% Size related country data
    % Add the market values of each firm of the country to one matrix using
    % the funtion 'fAllMV'.
    mMVall = fAllMV(dAmountCompanies,cAllCompanyKeys,rCountryStructure);

    % Determine the average monthly mean and median size of the firms of
    % the country using the function 'fMeanMedSize'.
    [dMeanSize,dMedianSize] = fMeanMedSize(mMVall);

    % Counting the minimal and maximal active firms in a country and the
    % vector containing the active firms to determine the start and end
    % date of data availability using the function 'fMinMaxFirms'.
    [dMinFirms,dMaxFirms,vFirms] = fMinMaxFirms(mMVall);

    % average total size of firms of the country calculated using the
    % function 'faverageTotalSize'.
    dAverageTotalSize = fAverageTotalSize(rCountryStructure);

%% Start and end date of data availability
    % Determine the start and end date of availability of data for the
    % country as first/last month with at least one active company using
    % the function 'fStartEndDate'.
    [sStartDate,sEndDate] = fStartEndDate(vFirms,tDates);

%% Summarizing data
    % Summarizing country data into one cell array.
    cCurrentTable = {sName,sMarket,dAmountCompanies,dMinFirms,dMaxFirms,dMeanSize,dMedianSize,dAverageTotalSize,0,sStartDate,sEndDate};
    % Filling the preliminary array with country data, except the 'average
    % total size in %'. This column is left empty, as it can only be
    % calculated with all average total sizes accessible.
    cTable1(i,:)=cCurrentTable;
end

%% Creating table 1
% Turning cell array with results into table.
tTable1 = cell2table(cTable1);
% Defining the global average total size as sum of all average total sizes
% of the countries.
dGlobalSize = sum(tTable1.(8));
% Defining the average total size in % of each country using the global
% total size.
tTable1.(9) = (tTable1.(8)/dGlobalSize)*100;

% Defining the column names of the table.
cColumnNames = {'Country','Market','Total no. firms','Min no. firms',...
    'Max no. firms','Mean size','Median size','Average total size',...
    'Average total size in %','Start date','End date'};

% Renaming the columns of the table.
tTable1.Properties.VariableNames = cColumnNames;

% TABLE 1 is complete 