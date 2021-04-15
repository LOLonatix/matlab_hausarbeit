function fFilterData()
    clear; clc;
    addpath(genpath('folder_FunctionsFilteringData'));
    addpath(genpath('folder_FunctionsCurrency'));

    % Get a list of all files and folders in this folder.
    sPath2ImportedData = append(pwd, '\', 'folder_ImportedData\');
    rFolders = dir(sPath2ImportedData);
    
    %% Remove the first 2 files created by GitHub
    cCountryNames = extractfield(rFolders, 'name');
    if cell2mat(cCountryNames(1)) == '.'
        cCountryNames = cCountryNames(3:end);
    end
    %% Get struct with country specific filter strings from function fCreateFiltersStrings
    lKeysLoaded = false;

    % Get struct with country specific filter strings
    rStringFiltersStatic = fCreateFilterStrings(cCountryNames);
        
    %% Get exchange rates from .mat-file or calculate them from the function
    % fExchangeRate
    if isfile('rExchangeRate.mat')
        load('rExchangeRate.mat','rExchangeRate');
    else
        rExchangeRate = fExchangeRate();
    end
    %% start iterating over each country
    dNumberCountries = length(cCountryNames);
    for i=1:dNumberCountries
        sCurrentCountryName = cell2mat(cCountryNames(i));
        sPath2Country = append(sPath2ImportedData, sCurrentCountryName);
        load(sPath2Country, 'rCountryStructure')

        if lKeysLoaded ~= true
            load(sPath2Country, 'cListKeys');
            lKeysLoaded = true;
        end

        %% start iterating over each company
        cAllCompanyKeys = fieldnames(rCountryStructure);
        dAmountCompanies = length(cAllCompanyKeys);

        % cells with company keys to be removed after the filtering process
        cCompanyKeysToBeRemoved = {};

        % iterate over companies
        for p=1:dAmountCompanies
            % get current key and the respective structure
            sCurrentCompanyKey = cell2mat(cAllCompanyKeys(p));
            rCurrentCompany = rCountryStructure.(sCurrentCompanyKey);

            %% transforming local currency in USD
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
            
            %% call the static filtering function fStaticScreening
            lRemoveCompany = fStaticScreening(rCurrentCompany, sCurrentCountryName, rStringFiltersStatic);

            % if the company has to be removed, add it to the cell-list
            if lRemoveCompany == true
                cCompanyKeysToBeRemoved{end+1} = sCurrentCompanyKey;
            end
        end

        %% delete the companies via their key, fi they were filtered by static filter
        dAmountDeletableCompanies = length(cCompanyKeysToBeRemoved);
        for x=1:dAmountDeletableCompanies
            sCompanyKeyToRemove = cell2mat(cCompanyKeysToBeRemoved(x));
            rCountryStructure = rmfield(rCountryStructure, sCompanyKeyToRemove);
        end

        %% after deleting the companies, calculate the return and call the dynamic filters (since indices were removed, calc. length again)
        cAllCompanyKeys = fieldnames(rCountryStructure);
        dAmountCompanies = length(cAllCompanyKeys);

        for p=1:dAmountCompanies
            % get current key and the respective structure
            sCurrentCompanyKey = cell2mat(cAllCompanyKeys(p));
            rCurrentCompany = rCountryStructure.(sCurrentCompanyKey);
            % calculate the return
            rCountryStructure.(sCurrentCompanyKey).RETURN = rCurrentCompany.TRI(2:end,:)./rCurrentCompany.TRI(1:end-1,:)-1;
            %% call the dynamic screen, which calls the fDynamicDataAvailabilityFilter-function
            rCountryStructure.(sCurrentCompanyKey) = fDynamicScreening(rCountryStructure.(sCurrentCompanyKey));
        end

        %% Filter for <25 companies active at a given time
        rCountryStructure = fFilter25Companies(rCountryStructure);

        %% save the filtered Data under "folder_FilteredData", depending on their size
        sLastWarning = ('');
        sSavePath = append(pwd, '\folder_FilteredData\', sCurrentCountryName);
        save(sSavePath, 'rCountryStructure', 'cListKeys');
        [~,id]=lastwarn('');
        if strcmp(id,'MATLAB:save:sizeTooBigForMATFile')
            print = "saved as -v7.3"
            save(sSavePath, 'rCountryStructure', 'cListKeys', '-v7.3');
        end
    end
end