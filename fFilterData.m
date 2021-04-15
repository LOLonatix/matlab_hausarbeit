function fFilterData()
<<<<<<< HEAD
    clear; clc;
    addpath(genpath('folder_FunctionsFilteringData'));
    
    % Get a list of all files and folders in this folder.
    sPath2ImportedData = append(pwd, '\', 'folder_ImportedData\');
    rFolders = dir(sPath2ImportedData);
=======
clear; clc;

% Get a list of all files and folders in this folder.
sPath2ImportedData = append(pwd, '\', 'folder_ImportedData\');
rFolders = dir(sPath2ImportedData);

% get all the names frum struct_array and remove the first two, if they
% were created by github "." and ".."
cCountryNames = extractfield(rFolders, 'name');
if cell2mat(cCountryNames(1)) == '.'
    cCountryNames = cCountryNames(3:end);
end

lKeysLoaded = false;

% Get struct with country specific filter strings
rStringFiltersStatic = fCreateFilterStrings(cCountryNames);
>>>>>>> f141003c7ee8ba25763f07b5cddd1ae17e771bc2

% Get exchange rates from .mat-file or calculate them from the function
% fExchangeRate
if isfile('rExchangeRate.mat')
    load('rExchangeRate.mat','rExchangeRate');
else
    rExchangeRate = fExchangeRate();
end

% get amount all folder/countrie_names
dNumberCountries = length(cCountryNames);
for i=1:dNumberCountries
    sCurrentCountryName = cell2mat(cCountryNames(i));
    sPath2Country = append(sPath2ImportedData, sCurrentCountryName);
    load(sPath2Country, 'rCountryStructure')
    
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
    
    % cells with company keys to be removed after the filtering process
    cCompanyKeysToBeRemoved = {};
    
    % iterate over companies
    for p=1:dAmountCompanies
        % get current key and the respective structure
        sCurrentCompanyKey = cell2mat(cAllCompanyKeys(p));
        rCurrentCompany = rCountryStructure.(sCurrentCompanyKey);
        
        % turn local currency in US Dollar
        sCountryName = regexprep(sCurrentCountryName,'.mat','');
        cEuro = {'AUSTRIA', 'BELGIUM', 'FINLAND', 'FRANCE', 'GERMANY', 'GREECE', 'IRELAND', 'ITALY', 'NETHERLANDS', 'PORTUGAL', 'SPAIN'};
        lLegalCurrency = contains(rStringFiltersStatic.(sCountryName).CURRENCY,rCurrentCompany.CURRENCY);
        if sum(lLegalCurrency) == 1
            if find(lLegalCurrency) == 2 && sum(contains(cEuro,sCountryName)) == 1
                rCurrentCompany = fCalculateDollarValue(rCurrentCompany,rExchangeRate.EURO);
                %elseif find(lLegalCurrency) == 2 && isequal(sCountryName,'RUSSIA')
                %rCurrentCompany = fCalculateDollarValue(rCurrentCompany,vExchangeRate);
            elseif find(lLegalCurrency) == 1
                rCurrentCompany = fCalculateDollarValue(rCurrentCompany,rExchangeRate.(sCountryName));
            end
        end
        
        % this function calls the static filtering-function
        lRemoveCompany = fStaticScreening(rCurrentCompany, sCurrentCountryName, rStringFiltersStatic);
        
        % if the company has to be removed, add it to the cell-list
        if lRemoveCompany == true
            cCompanyKeysToBeRemoved{end+1} = sCurrentCompanyKey;
        end
<<<<<<< HEAD
             
        % here comes the 25 companies filter
        rCountryStructure = fFilter25Companies(rCountryStructure);
       
        % save the filtered Data under "folder_FilteredData"
        sSavePath = append(pwd, '\folder_FilteredData\', sCurrentCountryName);
        save(sSavePath, 'rCountryStructure', 'cListKeys');
=======
>>>>>>> f141003c7ee8ba25763f07b5cddd1ae17e771bc2
    end
    
    % delete the companies via their key
    dAmountDeletableCompanies = length(cCompanyKeysToBeRemoved);
    for x=1:dAmountDeletableCompanies
        sCompanyKeyToRemove = cell2mat(cCompanyKeysToBeRemoved(x));
        rCountryStructure = rmfield(rCountryStructure, sCompanyKeyToRemove);
    end
    
    % after deleting the companies, calculate the return and call the
    % dynamic filters (since indices were removed, calc. length again)
    cAllCompanyKeys = fieldnames(rCountryStructure);
    dAmountCompanies = length(cAllCompanyKeys);
    
    for p=1:dAmountCompanies
        % get current key and the respective structure
        sCurrentCompanyKey = cell2mat(cAllCompanyKeys(p));
        rCurrentCompany = rCountryStructure.(sCurrentCompanyKey);
        % calculate the return
        rCountryStructure.(sCurrentCompanyKey).RETURN = rCurrentCompany.TRI(2:end,:)./rCurrentCompany.TRI(1:end-1,:)-1;
        % call the dynamic screen
        rCountryStructure.(sCurrentCompanyKey) = fDynamicScreening(rCountryStructure.(sCurrentCompanyKey));
    end
    
    % here comes the 25 companies filter
    rCountryStructure = fFilter25Companies(rCountryStructure);
    
    % save the filtered Data under "folder_FilteredData"
    sSavePath = append(pwd, '\folder_FilteredData\', sCurrentCountryName);
    save(sSavePath, 'rCountryStructure', 'cListKeys');
end
end