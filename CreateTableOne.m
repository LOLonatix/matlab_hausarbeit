%%Table 1
%Script used to call the functions needed to fill table 1 and in the
%following create the table itself.


%Adding folder with functions for the table to the paths so that the
%functions can be used.
clear; clc;
addpath(genpath('Tabelle1'));

aTable1={};

tDates=readtable('TSDates.xlsx');

%Copy from fFilterData to read all files and get the Structs
% Get a list of all files and folders in this folder.
sPath2ImportedData = append(pwd, '\', 'folder_FilteredData\');
rFolders = dir(sPath2ImportedData);

% get all the names frum struct_array and remove the first two, if they
% were created by github "." and ".."
cCountryNames = extractfield(rFolders, 'name');
if cell2mat(cCountryNames(1)) == '.'
cCountryNames = cCountryNames(3:end);
end 
    
lKeysLoaded = false;

% get amount all folder/countrie_names
dNumberCountries = length(cCountryNames);

for i=1:dNumberCountries
        sCurrentCountryName = cell2mat(cCountryNames(i));
        sPath2Country = append(sPath2ImportedData, sCurrentCountryName);  
        load(sPath2Country, 'rCountryStructure') %mit dem struct weitr arbeiten
      
        
        if lKeysLoaded ~= true
            load(sPath2Country, 'cListKeys');
            lKeysLoaded = true;
        end
        
        % get a list with all company-keys 
        % struct-array could have been advantageous, although this way
        % makes deleting substructs easier, since iterating over chaning
        % lenght can lead to out of bounds exceptions
        cAllCompanyKeys = fieldnames(rCountryStructure);
        dAmountCompanies = length(cAllCompanyKeys);
        
        % iterate over companies
        for p=1:dAmountCompanies
            % get current key and the respective structure
            sCurrentCompanyKey = cell2mat(cAllCompanyKeys(p));
            rCurrentCompany = rCountryStructure.(sCurrentCompanyKey);
        end
        
%read contryname from filename and transform it into string
sName = string(regexprep(sCurrentCountryName,'.mat',''));

%determine to which market the country belongs according to MSCI using
%function 'fMSCImarket'
sMarket = fMSCImarket(sName);

%add the market values of each firm of the country to one matrix using
%funtion 'fAllMV'
mMVall=fAllMV(dAmountCompanies,cAllCompanyKeys,rCountryStructure);

%determine the average monthly mean and median size of the firms of the
%country using function 'fMeanMedSize'
[dMeanSize,dMedianSize] = fMeanMedSize(mMVall);

%Counting the minimal and maximal active firms in a country
%function requires dAmountCompanies (total amount of firms in country),
%cAllCompanyKeys (keys of the above mentioned firms to alter struct),
%rCountryStructure (struct with the data of all firms)
[dMinFirms,dMaxFirms,vFirms]=fMinMaxFirms(mMVall);

%average total size of firms of the country calculated using function 
%'faverageTotalSize'
dAverageTotalSize = faverageTotalSize(rCountryStructure);

%determine the start and end date of availability of data for the country
%as first/last month with at least one active company using function
%'fStartEndDate'
[sStartDate,sEndDate]=fStartEndDate(vFirms,tDates);

%CREATING TABLE preallocation not feasible with writing strings and
%doublesin a table at the same time
aCurrentTable={sName,sMarket,dAmountCompanies,dMinFirms,dMaxFirms,dMeanSize,dMedianSize,dAverageTotalSize,0,sStartDate,sEndDate};
aTable1=[aTable1,aCurrentTable];
end

tTable1=cell2table(aTable1);
dGlobalSize=sum(tTable1.(8));
tTable1.(9)=(tTable1.(8)/dGlobalSize)*100;

vColumnNames={'Country','Market','Total no. firms','Min no. firms',...
    'Max no. firms','Mean size','Median size','Average total size',...
    'Average total size in %','Start date','End date'};

tTable1.Properties.VariableNames=vColumnNames;