function fLoadRawData()
    clear; clc; 
    save_var_error = string;
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

    % cell array holding keys, representating information about companies
    cListKeys = {};
    % hardcoded, since in Datastream '$ERROR' cell values occured
    cTsKeys = {'NET_INCOME', 'COMMON_EQUITY','DEFERRED_TAXES','SALES','COGS','TOTAL_ASSETS','SG_A','RESEARCH_AND_DEVELOPMENT_COSTS','INTEREST_EXPENSES','ACCOUNTS_RECEIVABLE','INVENTORY','PREPAID_EXPENSES','DEFERRED_REVENUE','TRADE_ACCOUNTS_PAYABLE','ACCRUED_PAYROLL','OTHER_ACCRUED_EXPENSES','CURRENT_ASSETS','CASH_SHORT_TERM_INVESTMENTS','CURRENT_LIABILITIES','SHORT_TERM_DEBTS','INCOME_TAX_PAYABLE','DEPRECIATION','PREFERRED_STOCK','MINORITY_INTEREST','LONG_TERM_DEBT','MARKET_VALUE','UNADJUSTED_PRICE'};
    lBoolListKeys = false;

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
            
            % remove empty rows (appear if [~,~,this_index] is used
            cTemp(any(cellfun(@(x) any(isnan(x)),cTemp),2),:) = [];
            dSizeCTemp = size(cTemp);
          
            % create list with "keys" from static request once
            if lBoolListKeys ~= true
                for row=2:dSizeCTemp(2)
                    cKey = cTemp(1, row);
                    cKey = fCreateKey(cKey);
                    cListKeys{end+1} = cKey;
                end
                for row=1:length(cTsKeys)
                    cListKeys{end+1} = cTsKeys{row};
                end
                % create keys and their length only once
                dLenghtKeys = length(cListKeys);
                lBoolListKeys = true;
            end

            % now create a substruct for each company in rCountryStructure
            for row=2:dSizeCTemp(1)
                % only take one row at a time
                cCurrentRow = cTemp(row,:);

                % use the 'COMPANY_NAME' as the struct.key
                sCompanyString = fCellToString(cCurrentRow(1));
       
                rCountryStructure.(sCompanyString) = struct;
          
                % initialize as NaN to be able to skip empty lines in TS later
                % on (created by datastream "$ERROR, value not found" 
                for currentKey=1:dLenghtKeys
                   rCountryStructure.(sCompanyString).(cell2mat(cListKeys(currentKey))) = NaN(1);
                end
                % load static data into strukt.key
                for column=2:dSizeCTemp(2)
                    cCurrentValue = cTemp(row, column);
                    sKeyString2Use = cell2mat(cListKeys(column-1));
                    rCountryStructure.(sCompanyString).(sKeyString2Use)=cell2mat(cCurrentValue);          
                end 
            end

            % create list with all companies to iterate over them in current
            % part for ts --> another viable way would be to use
            % "struct_arrays" to use indexing, the latter was discovered close
            % before the deadline
            cAllCompanyKeys = fieldnames(rCountryStructure);

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
                dStep_size = str2double(sSheetString(sStepSize+4:end));

                % load current sheet in var cTemp und cNumTemp
                [cNumTemp,cTemp,~]=xlsread(sLoadString, current_sheet);
                % delete first column, since it only holds constant dates  
               
                if length(cTemp) < 25
                    save_var_error = append(save_var_error, '___', sLoadString, '-', int2str(current_sheet));
                else
                    cTemp(:,1) = [];
                    cNumTemp(:,1) = [];

                    % get total amount colums in this sheet
                    vSizeCTemp = size(cTemp);
                    dColumnsCTemp = vSizeCTemp(2);
                
                
                    
                % counter used to count steps within step_size. reset for each
                % sheet
                dCounter = 1;
                % index firma currently traits added, reset for each sheet
                dIndexCurrentCompany = 1;

                % iterate over colums in current sheet
                for column=1:dColumnsCTemp

                    % check first value, to skip  '#ERROR' and save time
                    sFirstValue = cell2mat(cTemp(1,column));
                    
                    lErrorBool = contains(sFirstValue, '#ERROR');

                    if lErrorBool ~= true
                        % load column as vector holding doubles
                        %vCurrentColumn = cell2mat(cNumTemp(:,column));
                        vCurrentColumn = cNumTemp(:,column);
                        
                        % get current ts item key
                        sCurrentKey = cell2mat(cTsKeys(dKeyCounter+dCounter));
                        % get current company key
                        sCurrentCompanyKey = cell2mat(cAllCompanyKeys(dIndexCurrentCompany));
                        % save in sub struct
                        rCountryStructure.(sCurrentCompanyKey).(sCurrentKey)=vCurrentColumn;
                    end

                    % if following if is true, then data for the next company
                    % is loaded and dCounter is resetted
                    if dCounter == dStep_size 
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
                dKeyCounter = dKeyCounter + dStep_size;
                end
            end
        end
        
        rCountryStructure = fLoadTriData(sPath2Country, rCountryStructure);
        
        % finally save the countrie's loaded data under 'folder_ImportedData'
        % as a .mat file containing the respective struct
        % --> Excel Import is a bottleneck regarding the runtime
        sSavePath = append(pwd, '\folder_ImportedData\', sCurrentCountry, '.mat');
        save(sSavePath, 'rCountryStructure', 'cListKeys', 'save_var_error');
    end
   
end

function rCountryStructure = fLoadTriData(sPath2Country, rCountryStructure)
    % create path to tri-folder
    sPathToTriData = append(sPath2Country, '\', 'TRI_DATA');
    % find all parts/data in this folder
    rFilesInTriFolder = dir(sPathToTriData);
        
    % now take only the true files, removing the github folders 
    lFilesToLoad = ~[rFilesInTriFolder.isdir];
    rFilesInTriFolder = extractfield(rFilesInTriFolder, 'name');
    rFilesInTriFolder = rFilesInTriFolder(lFilesToLoad);

    dAmountParts = length(rFilesInTriFolder)/2;
    
    for i=1:dAmountParts
        % load the static order of companies and their key
        % create string "PART_NAME"
        sCurrentPartString = append('PART', int2str(i),'_');
        
        % find files only containing "PART_NAME"
        lCurrentPartFiles = contains(rFilesInTriFolder, sCurrentPartString);
        
        % create bools for static/ts parts
        lAllStaticParts = contains(rFilesInTriFolder,'STATIC');
        lAllTsParts = contains(rFilesInTriFolder,'TS');

        % start the loading process with the static files for each part,
        % which is a bool-matrix
        lCurrentStaticFile = lCurrentPartFiles & lAllStaticParts;
        lCurrentTsFile =  lCurrentPartFiles & lAllTsParts;

        % find loading path via previous bool-matrix
   
        sLoadStringStatic = append(sPathToTriData, '\', cell2mat(rFilesInTriFolder(lCurrentStaticFile)));
        sLoadStringTs = append(sPathToTriData, '\', cell2mat(rFilesInTriFolder(lCurrentTsFile)));
        
        % load ts and static data
        [~,~,cTextTS]=xlsread(sLoadStringStatic);
        [cNumTS,~,~]=xlsread(sLoadStringTs);
      
        % calculate the amount of companies
        dAmountCompaniesStatic = size(cTextTS);
        dAmountCompaniesStatic = dAmountCompaniesStatic(1);
        
        dAmountCompaniesTs = size(cNumTS);
        dAmountCompaniesTs = dAmountCompaniesTs(2);
        
        % only if the amount of companies is the same save the TRI-Data,
        % write error message otherwise
        for p=2:dAmountCompaniesStatic
            % use same function for creating struct.key string
            sCompanyKey = fCellToString(cTextTS(p,1));
            
            % check if last tri-data-sets were 'ERROR' message, otherwise
            % get tri-data
            if p <= dAmountCompaniesTs
                vTriData = cNumTS(:,p);
            else
                vTriData = NaN;
            end
            
            % save vTriData under tri key for sCompanyKey
            if isfield(rCountryStructure, sCompanyKey) == true
                rCountryStructure.(sCompanyKey).TRI = vTriData;
            % tri data was downloaded later on from datastream, so we 
            % weren't sure whether the lists changed --> error message
            else
                print = "Could not find company key"
                print = sCompanyKey
            end
        end
    end
end

function working_string = fCellToString(input_cell)
    
    working_string = cell2mat(input_cell);
    if isstring(working_string) ~= true
        working_string = string(working_string);
    end
    
    % starting with digit?
    digit_bools = isstrprop(working_string,'digit');
    if length(digit_bools) > 1
        if digit_bools(1) == 1
        working_string = strcat('rNumber_', working_string);
        end
    end
    % replace ':' and '.' with '_'
    working_string = regexprep(working_string, ':', '_');
    working_string = strrep(working_string, '.', '');
    working_string = strrep(working_string, ';', '_');
    % replace '@' with 'at_'
    working_string = regexprep(working_string, '[@]', 'at_');
    % this one removes underscores from the beginning
    working_string = regexprep(working_string,'^_','','emptymatch');
    
    working_string = regexprep(working_string, ' +', '_');
    working_string = regexprep(working_string, '&+', '');
    working_string = regexprep(working_string, '[/]','');
    working_string = regexprep(working_string, '[£]','');
    working_string = regexprep(working_string, '[:]','');
    working_string = regexprep(working_string, '[(]','');
    working_string = regexprep(working_string, '[)]','');
    working_string = regexprep(working_string, '['']','');
    working_string = regexprep(working_string, '[-]','');
    working_string = regexprep(working_string, '[@]', '');
    working_string = regexprep(working_string, '[+]', '');
    working_string = regexprep(working_string, '[$]', '');
    working_string = regexprep(working_string, '[,]', '');
    working_string = regexprep(working_string, '[%]', '');
%     % this one removes underscores from the beginning
%     string = regexprep(string,'^_','','emptymatch');
%     string = regexprep(string,'^_','','emptymatch');
    % since struct.keys can only be as long as 63 characters, remove rest
    if strlength(working_string) > 63
        working_string = working_string(1:63);
    end
    if working_string(1) == '_'
        working_string = working_string(2:end);
    end
end

function string = fCreateKey(input_cell)
  string = cell2mat(input_cell);
    string = regexprep(string, ' +', '_');
    string = regexprep(string, '&+', '');
    string = regexprep(string, '[.]','');
    string = regexprep(string, '[/]','');
    string = regexprep(string, '[£]','');
    string = regexprep(string, '[:]','');
    string = regexprep(string, '[(]','');
    string = regexprep(string, '[)]','');
    string = regexprep(string, '['']','');
    string = regexprep(string, '[-]','');
    string = regexprep(string, '[0-9]', '');
    string = regexprep(string, '[@]', '');
    string = regexprep(string, '[+]', '');
    string = regexprep(string, '[$]', '');
    string = regexprep(string, '[,]', '');
    string = regexprep(string, '[%]', '');
    % this one removes underscores from the beginning
    string = regexprep(string,'^_','','emptymatch');
    string = regexprep(string,'^_','','emptymatch');
   
end

   
  
