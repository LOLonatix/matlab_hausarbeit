function fLoadRawData()

% abfrage, dass die länge der keys im Land gleich der länge der tabelle -1
% -> nochmal alle Länder getrennt
% checken, ob es auch mit mehreren Ländern auf einmal klappt
% dann kommen die filter

% Get a list of all files and folders in this folder.
vPathRawData = append(pwd, '\', 'folder_RawData');
vFolders = dir(vPathRawData);

% get all the names frum struct_array and delete the first two (github
% folders/files
vCountryNames = extractfield(vFolders, 'name');
vCountryNames = vCountryNames(3:end);

% get all folder/countrie_names
vNumberCountries = length(vCountryNames);

% begin the for-loop to iterate over all sub folders holding the countries'
% data and generate array to hold all the data
sAllCountries = struct;
%keys_for_companies = {};
%bool_static_keys = false;

list_keys = {};
ts_keys = {'NET_INCOME', 'COMMON_EQUITY','DEFFERED_TAXES','SALES','COGS','TOTAL_ASSETS','SG_A','RESEARCH_AND_DEVELOPMENT_COSTS','INTEREST_EXPENSES','ACCOUNTS_RECEIVABLE','INVENTORY','PREPAID_EXPENSES','DEFERRED_REVENUE','TRADE_ACCOUNTS_PAYABLE','ACCRUED_PAYROLL','OTHER_ACCRUED_EXPENSES','CURRENT_ASSETS','CASH_SHORT_TERM_INVESTMENTS','CURRENT_LIABILITIES','SHORT_TERM_DEBTS','INCOME_TAX_PAYABLE','DEPRECIATION','PREFERRED_STOCK','MINORITY_INTEREST','LONG_TERM_DEBT','MARKET_VALUE','UNADJUSTED_PRICE'};
bool_list_keys = false;
  
for i=1:vNumberCountries
    % first of all, generate an array for each country holding the
    % companies data
    vCurrentCountry = cell2mat(vCountryNames(i));
    sAllCountries.(vCurrentCountry) = struct;
    
    % now open the subfolder using country_string and first load static
    current_country_path = append(pwd, '\', vCurrentCountry);
    subfiles = dir(current_country_path);
    subfiles = extractfield(subfiles, 'name');
    subfiles = subfiles(3:end);
    
    % first of all: iterate over each part by taking lenght/2
    amount_parts = length(subfiles)/2;
    
    % iterate over the different parts of one country (e.g. england and
    % india too large to use one list
    for x=1:amount_parts
        % create "PART_NAME"
        string_part = append('PART', int2str(x));
        % find files only containing "PART_NAME"
        current_part_file = contains(subfiles(1:end), string_part);
        all_static_paths = contains(subfiles(1:end),'STATIC');
        all_ts_paths = contains(subfiles(1:end),'TS');
        current_static_part_file = current_part_file & all_static_paths;
        
        
        % the loading process into var cTemp
        load_string = append(current_country_path, '\', cell2mat(subfiles(current_static_part_file)));
        [~,~,cTemp]=xlsread(load_string);
        
        size_cTemp = size(cTemp);
        % list_keys containing var_names from static list like MNOMIC or
        % CURRENCY, create list only once
        if bool_list_keys ~= true
            for row=2:size_cTemp(2)
                key_to_attach = cTemp(1, row);
                key_to_attach = keys_for_static(key_to_attach);
                list_keys{end+1} = key_to_attach;
            end
            for row=1:length(ts_keys)
                list_keys{end+1} = ts_keys{row};
            end
            bool_list_keys = true;
        end
   
        % now create a substruct for each company in current_country_struct
        for row=2:size_cTemp(1)
            current_row = cTemp(row,:);
            % use the 'COMPANY_NAME' as the strukt.key
            company_key = cell_to_string(current_row(1));
            sAllCountries.(country_string_fixed).(company_key) = struct;
            length_keys = length(list_keys);
            
            % initialise as NaN to be able to skip empty lines in ts later
            % on (created by datastream "$ERROR, value not found" 
            for amount_keys=1:length_keys
                sAllCountries.(country_string_fixed).(company_key).(cell2mat(list_keys(amount_keys))) = NaN(1);
            end
            % load static data into strukt.key
            for column=2:size_cTemp(2)
                current_value = cTemp(row, column);
                string_to_use = cell2mat(list_keys(column-1));
                sAllCountries.(country_string_fixed).(company_key).(string_to_use)=cell2mat(current_value);          
            end 
        end
        % create list with all companies to iterate over them in current
        % part for ts
        list_all_companies = fieldnames(sAllCountries.(country_string_fixed));
        length(list_all_companies)
        
        if helper_bool == true
        
        % now load ts
        current_ts_part_file = current_part_file & all_ts_paths;
        % the loading process into var cTemp
        load_string = append(current_country_path, '\', cell2mat(subfiles(current_ts_part_file)));
        sheet_names = sheetnames(load_string);
        
        % generate a counter to save which trait is currently added
        key_counter = 0;
        
        % now iterate over each sheet
        for sheet_num=1:length(sheet_names)
            sheet_string = char(sheet_names(sheet_num))
            % get stepsize (amount of data for each company in succession)
            % hidden in sheetname as "..._TS_stepsize"
            ind = strfind(sheet_string, '_TS_');
            step_size = str2double(sheet_string(ind+4:end));
            
            % load current sheet in var cTemp
            [~,~,cTemp]=xlsread(load_string, sheet_num);
            % delete first column, since it only holds constant dates
            cTemp(:,1) = [];
            
            % get total amount colums in this sheet
            total_columns = size(cTemp);
            total_columns = total_columns(2);
            
            % counter used to count stepts within step_size. reset for each
            % sheet
            counter = 1;
            % index firma currently traits added, reset for each sheet
            index_company = 1;
            
            % iterate over colums in current sheet
            for column=1:total_columns
                
                first_value_for_error = cell2mat(cTemp(1,column));
                bool_contains = contains(first_value_for_error, '#ERROR');
                
                if bool_contains ~= true
                    column_to_load = cell2mat(cTemp(2:end,column));
                    trait_to_use = cell2mat(ts_keys(key_counter+counter));
                    current_company = cell2mat(list_all_companies(index_company));
                    sAllCountries.(country_string_fixed).(current_company).(trait_to_use)=column_to_load;
                end
                
                    % attention: not fixed for more then one part! --> trait
                    % counter has to be set to last time counter or sth like
                    % this
                    % therefore, this solution has to be checked

                    if counter == step_size 
                        counter = 1;
                        % I do not know why I have to use this if here,
                        % otherwise out of bounds exception
                        if index_company < length(list_all_companies)
                            index_company = index_company + 1;
                        end                    
                    else
                        counter = counter + 1;
                    end   
            end
            key_counter = key_counter + step_size;
        end
    end
    end
end
end



function working_string = cell_to_string(input_cell)
    working_string = cell2mat(input_cell);
    if isstring(working_string) ~= true
        working_string = string(working_string);
    end
    
    % starting with digit?
    digit_bools = isstrprop(working_string,'digit');
    if length(digit_bools) > 1
        if digit_bools(1) == 1
        working_string = strcat('number_', working_string);
        end
    end
    % replace ':' with '_'
    working_string = regexprep(working_string, ':', '_');
    % replace '@' with 'at_'
    working_string = regexprep(working_string, '[@]', 'at_');
    % this one removes underscores from the beginning
    working_string = regexprep(working_string,'^_','','emptymatch');
    
%     string = regexprep(string, ' +', '_');
%     string = regexprep(string, '&+', '');
%     string = regexprep(string, '[.]','');
%     string = regexprep(string, '[/]','');
%     string = regexprep(string, '[£]','');
%     string = regexprep(string, '[:]','');
%     string = regexprep(string, '[(]','');
%     string = regexprep(string, '[)]','');
%     string = regexprep(string, '['']','');
%     string = regexprep(string, '[-]','');
%     string = regexprep(string, '[0-9]', '');
%     string = regexprep(string, '[@]', '');
%     string = regexprep(string, '[+]', '');
%     string = regexprep(string, '[$]', '');
%     string = regexprep(string, '[,]', '');
%     string = regexprep(string, '[%]', '');
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

function string = keys_for_static(input_cell)
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
function structure = fill_all_keys(input_structure, input_keys)
    leng = length(input_keys);
    for i=1:leng
        current_key = cell2mat(input_keys(i)); 
        input_structure.(current_key) = 5;
    end
end
