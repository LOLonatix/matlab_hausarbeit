function fFilterData()
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
            
            % this function calls the real filtering-function
            bRemoveCompany = fStaticScreening(rCurrentCompany, sCurrentCountryName);
      
            % if the company has to be removed, add it to the cell-list
            if bRemoveCompany == true
              cCompanyKeysToBeRemoved{end+1} = sCurrentCompanyKey;
            end     
        end
        
        % delete the companies via their key
        dAmountDeletableCompanies = length(cCompanyKeysToBeRemoved);
        for x=1:dAmountDeletableCompanies
            sCompanyKeyToRemove = cell2mat(cCompanyKeysToBeRemoved(x));
            %rCountryStructure = remove(rCountryStructure, sCompanyKeyToRemove);   
        end
        
        % save the filtered Data under "folder_FilteredData"
        sSavePath = append(pwd, '\folder_FilteredData\', sCurrentCountryName);
        save(sSavePath, 'rCountryStructure', 'cListKeys');
    end
end

% the real filter process is written as an extra function for more clearity
% in the code
function bReturn = fStaticScreening(rCompany, sCountry)
    
    % check screening 1-3 --> major, equity and primary
    if rCompany.MAJOR_FLAG ~= 'Y' | rCompany.STOCK_TYPE ~= 'EQ' | rCompany.QUOTE_INDICATOR ~= 'P'
        bReturn = true;
   
    % check screening 4, 5--> country code needed (7 still missing, since
    % needs another shortcut)
    elseif contains(sCountry, rCompany.GEOGRAPHIC_DESCR) == false | contains(sCountry, rCompany.GEOG_DESC_OF_LSTNG) == false
        bReturn = true;
    % screening 6, 7 8 still missing, therefore the generic keyword
    % deletion
    
    else
        bReturn = false;
    end
end