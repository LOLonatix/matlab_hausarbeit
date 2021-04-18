function fLoadRawData()
    clear; clc; 
    %% First get all countries as folders in "folder_RawData"
    addpath(genpath('folder_FunctionsLoadingRawData'));

    % Get a list of all files and folders in this folder.
    sPath2RawData = append(pwd, '\', 'folder_RawData');
    rFolders = dir(sPath2RawData);

    % get all the names frum struct_array and remove the first two, if they
    % were created by github "." and ".."
    cCountryNames = extractfield(rFolders, 'name');
    if cell2mat(cCountryNames(1)) == '.'
        cCountryNames = cCountryNames(3:end);
    end 
   
    % get amount all folder/countrie_names
    dNumberCountries = length(cCountryNames);
    
    %% Cell array holding keys, representating static information about companies
    cListKeys = {};
    % hardcoded, since in Datastream '$ERROR' cell values occured
    cTsKeys = {'NET_INCOME', 'COMMON_EQUITY','DEFERRED_TAXES','SALES','COGS','TOTAL_ASSETS','SG_A','RESEARCH_AND_DEVELOPMENT_COSTS','INTEREST_EXPENSES','ACCOUNTS_RECEIVABLE','INVENTORY','PREPAID_EXPENSES','DEFERRED_REVENUE','TRADE_ACCOUNTS_PAYABLE','ACCRUED_PAYROLL','OTHER_ACCRUED_EXPENSES','CURRENT_ASSETS','CASH_SHORT_TERM_INVESTMENTS','CURRENT_LIABILITIES','SHORT_TERM_DEBTS','INCOME_TAX_PAYABLE','DEPRECIATION','PREFERRED_STOCK','MINORITY_INTEREST','LONG_TERM_DEBT','MARKET_VALUE','UNADJUSTED_PRICE'};
    lBoolListKeys = false;
    %% Start iterating over each country
    for i=1:dNumberCountries
        % first, get the country i and create a structure for it
        sCurrentCountry = cell2mat(cCountryNames(i));        
        rCountryStructure = struct;
        
        % now open the country folder, which is organized as in the following:
        % some lists were to large --> splitted in different "PART"s
        % each list has their own "_STATIC" and "_TS" list

        % !!!IMPORTANT!!! the order of companies are the same in the "_STATIC"
        % and "_TS" lists of the same part
        sPath2Country = append(sPath2RawData, '\', sCurrentCountry);
        rFilesInCountry = dir(sPath2Country);
        test = sPath2Country
        % now take only the true files, removing the github folders and
        % tri-data folders
        lFilesToLoad = ~[rFilesInCountry.isdir];
        rFilesInCountry = extractfield(rFilesInCountry, 'name');
        rFilesInCountry = rFilesInCountry(lFilesToLoad);
 
        % find amount parts by length/2 (STATIC and TS)
        dAmountParts = length(rFilesInCountry)/2;

        % iterate over different parts
        for x=1:dAmountParts
            % create a sub struct for each part
            rCountryPartStructure = struct;
            
            % create string "PART_NAME"
            sCurrentPartString = append('PART', int2str(x));
            % find files only containing "PART_NAME"
            lCurrentPartFiles = contains(rFilesInCountry(1:end), sCurrentPartString);
            % create bools for static/ts parts
            lAllStaticParts = contains(rFilesInCountry(1:end),'STATIC');
            lAllTsParts = contains(rFilesInCountry(1:end),'TS');

            % start the loading process with the static files for each part,
            % which is a bool-matrix
            lCurrentStaticFile = lCurrentPartFiles & lAllStaticParts;

            % find loading path via previous bool-matrix
            sLoadString = append(sPath2Country, '\', cell2mat(rFilesInCountry(lCurrentStaticFile)));
            [~,~,cTemp]=xlsread(sLoadString);
          
            % check for empty rows at the end, happening for JAPAN_PART2
            % somehow an error in excel leads to this
            lFoundNonEmptyRow = false;
            while lFoundNonEmptyRow == false
                dFirstVal = cell2mat(cTemp(end,1));
                dSecondVal = cell2mat(cTemp(end,2));
                dThirdVal = cell2mat(cTemp(end,3));
                if isa(dFirstVal, 'double') == true && isa(dSecondVal, 'double') == true && ...
                        isa(dThirdVal, 'double') == true && isnan(dFirstVal) == true && ...
                        isnan(dSecondVal) == true && isnan(dThirdVal) == true 
                       
                    cTemp(end,:) = [];      
                else
                    lFoundNonEmptyRow = true;
                end
            end

            dSizeCTemp = size(cTemp);
          
            % create list with "keys" from static request once
            if lBoolListKeys ~= true
                for column=2:17
                    cKey = cTemp(1, column);
                    cKey = fCreateKey(cKey);
                    cListKeys{end+1} = cKey;
                end
                for column=1:length(cTsKeys)
                    cListKeys{end+1} = cTsKeys{column};
                end
                % create keys and their length only once
                dLenghtKeys = length(cListKeys);
                lBoolListKeys = true;
            end

            
            % now create a substruct for each company in rCountryStructure
            for row=2:dSizeCTemp(1)
                % only take one row at a time
                % start with using mnemonic for the key
                cCurrentRow = cTemp(row,:);
                sFieldToUse = cell2mat(cCurrentRow(2));
 
                % otherwise use the datastream-code
                if isa(sFieldToUse, 'char') == true | isa(sFieldToUse, 'string') == true
                    if matches(sFieldToUse, 'NA') == true |...
                       matches(sFieldToUse, '#N/A')== true | matches(sFieldToUse, '#NA')== true ...
                       | matches(sFieldToUse, 'N/A')== true
                        
                        sFieldToUse = cell2mat(cCurrentRow(1));
                    end    
                elseif isa(sFieldToUse, 'double')== true & isnan(sFieldToUse) == true
                    sFieldToUse = cell2mat(cCurrentRow(1));
                end

                % make it to an usable string
                sCompanyString = fStringToStructKey(sFieldToUse);

                % create struct.key
                rCountryPartStructure.(sCompanyString) = struct;

                % initialize as NaN to be able to skip empty lines in TS later
                % on (created by datastream "$ERROR, value not found" 
                for currentKey=1:dLenghtKeys
                    rCountryPartStructure.(sCompanyString).(cell2mat(cListKeys(currentKey))) = NaN(1);
                end
                % load static data into strukt.key
                for column=2:17
                    cCurrentValue = cell2mat(cTemp(row, column));
                    sKeyString2Use = cell2mat(cListKeys(column-1));
                    if isa(cCurrentValue, 'char') == true
                        if matches(cCurrentValue, 'NA') == true | matches(cCurrentValue, '#N/A')== true | ...
                                matches(cCurrentValue, '#NA')== true
                            cCurrentValue = NaN;
                        end
                    end
                    rCountryPartStructure.(sCompanyString).(sKeyString2Use)=cCurrentValue;          
                end 
                
            end

            % create list with all companies to iterate over them in current
            % part for ts --> another viable way would be to use
            % "struct_arrays" to use indexing, the latter was discovered close
            % before the deadline
            cAllCompanyKeys = fieldnames(rCountryPartStructure);
            print = sLoadString
            dAmountCompanies = length(cAllCompanyKeys)
           

            % now load ts
            lCurrentTSFile = lCurrentPartFiles & lAllTsParts;
            % the loading process into cell-var cTemp
            
            sLoadString = append(sPath2Country, '\', cell2mat(rFilesInCountry(lCurrentTSFile)));
            sSheetNames = sheetnames(sLoadString);

            % generate a counter to save which trait is currently added
            dKeyCounter = 0;

            % now iterate over each sheet
            for current_sheet=1:length(sSheetNames)
            
                sSheetString = char(sSheetNames(current_sheet));
                % get stepsize (amount of data for each company in succession)
                % hidden in sheetname as "..._TS_stepsize"
                sStepSize = strfind(sSheetString, '_TS_');
                dStepSize = str2double(sSheetString(sStepSize+4:end));

                % load current sheet in var cTemp und cNumTemp
                [~,~,cTemp]=xlsread(sLoadString, current_sheet);
                % delete first column, since it only holds constant dates  

                cTemp(:,1) = [];

                % get total amount colums in this sheet
                dCompaniesInSheet = dAmountCompanies*dStepSize;
                print = current_sheet
                % counter used to count steps within step_size. reset for each
                % sheet
                dCounter = 1;
                % index firma currently traits added, reset for each sheet
                dIndexCurrentCompany = 1;

                % iterate over colums in current sheet
                for column=1:dCompaniesInSheet
               
                    % check first value, to skip  '#ERROR' and save time
                    sFirstValue = cell2mat(cTemp(1,column));
                    if isa(sFirstValue, 'double') == true && isnan(sFirstValue) == true
                        lErrorBool = true;
                    else                  
                        lErrorBool = contains(sFirstValue, '#ERROR');
                    end
                    
                    if lErrorBool ~= true
                        % load column as vector holding doubles, replace
                        % string with NaN
                        vCurrentColumn = cTemp(2:313,column);
                        vCurrentColumn(cellfun(@ischar, vCurrentColumn)) = {nan};
                        vCurrentColumn = cell2mat(vCurrentColumn);

                        % get current ts item key
                        sCurrentKey = cell2mat(cTsKeys(dKeyCounter+dCounter));
                        % get current company key
                        sCurrentCompanyKey = cell2mat(cAllCompanyKeys(dIndexCurrentCompany));
                        % save in sub struct
                         rCountryPartStructure.(sCurrentCompanyKey).(sCurrentKey)=vCurrentColumn;
                    end

                    % if following if is true, then data for the next company
                    % is loaded and dCounter is resetted

                    if dCounter == dStepSize 
                        dCounter = 1;
                        % I do not know why I have to use this if here,
                        % otherwise out of bounds exception
                        if dIndexCurrentCompany < length(cAllCompanyKeys)
                            dIndexCurrentCompany = dIndexCurrentCompany + 1;
                        end

                        % otherwise dCounter += 1
                    else
                        dCounter = dCounter + 1;
                    end   
                end
                
            % after finishing one sheet, use the next ts-item-keys 
            dKeyCounter = dKeyCounter + dStepSize;
            end
        end
            
        % finally append  rCountryPartStructure to rCountryStructure        
        cAllCompanies = fieldnames(rCountryPartStructure); 
        for t=1:length(cAllCompanies)
            sCompanyName = cell2mat(cAllCompanies(t));
            rCompany =  rCountryPartStructure.(sCompanyName);
            rCountryStructure.(sCompanyName) = rCompany;
        end

        rCountryStructure = fLoadTriData(sPath2Country, rCountryStructure);
        rCountryStructure = fLoad12MonthsTA(sPath2Country, rCountryStructure);

        % finally save the countrie's loaded data under 'folder_ImportedData'
        % as a .mat file containing the respective struct
        % --> Excel Import is a bottleneck regarding the runtime
        fSaveCountryStructure('folder_ImportedData', sCurrentCountry, rCountryStructure);
    end
end



   
  
