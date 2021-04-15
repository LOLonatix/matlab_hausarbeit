function rExchangeTRI = fExchangeTRI(cCountryNames)
%% TRI CALCULATED EXCHANGE RATES
% Function calculates the exchange rate from US Dollar to the countries
% currency from TRI data (total return index, 'RI' in Datastream). For each
% country the TRI data from firms from the Worldscope list firms
% (Datastream) are downloaded for 324 months (31/Jul/1989 -30/Jun/2016) in
% local currency and US Dollar. The currency of each item is also loaded.
%% REQUIRES
% Cell array with the names of the countries
%% RETURNS
% Struct with the calculated exchange rates for each country currency
%% FUNCTION Setup
% Add folder with excel files to path
addpath(genpath('folder_ExchangeRates'));
% Call function fIDStruct to have the allowed currencies of each country
rID = fIDStruct();
% Create an empty struct for the exchange rates (function return)
rExchangeTRI = struct();


%% FUNCTION Country exchange rates
% Iterate through countries
for i = 1:length(cCountryNames)
    %% Read and prepare data
    % Read country name
    sCountryName = cCountryNames{i};
    % Concatenate Filename
    sFilename = [sCountryName, '_DOLLAR.xlsx'];
    % Define row with currencies as column (variable) names
    opts = detectImportOptions(sFilename);
    opts.VariableNamesRange = 'A2';
    opts.VariableNamingRule = 'preserve';
    % Read excel file with Worldscope list TRI data of currenct country to
    % table
    tExchangeTRI = readtable(sFilename, opts, 'ReadVariableNames', true);
    
    % Calculate the countries amount of accepted currencies
    dAmountCurrencies = length(rID.(sCountryName).CURRENCY);
    
    %% Filter excel data
    % Use function fFilterExcelNumeric to turn all non-numeric variables to
    % numeric variables
    tExchangeTRI = fFilterExcelNumeric(tExchangeTRI);
    
    %% Filter missing currencies
    % Create cell array with column names of table
    cColumnNames = tExchangeTRI.Properties.VariableNames;
    % Find empty columns (column name contrains 'Var' as there is no
    % currency (ERROR in Datastream))
    lEmptyColumns = contains(cColumnNames, 'Var');
    % Define first column as empty as is contains only datetime items, that
    % are not required
    lEmptyColumns(1) = 1;
    % Remove columns that are not containing currencies
    tExchangeTRI = removevars(tExchangeTRI,lEmptyColumns);
    
    %% Filter foreign currencies
    % Create an empty (logical) array
    vUnallowedCurrency = [];
    % Iterate through every firm (every second column, as there are two per
    % firm)
    for h = 1:2:width(tExchangeTRI)
        % Read actualised column names
        cColumnNames = tExchangeTRI.Properties.VariableNames;
        % Extracting the current currency
        % First column names have no number yet, therefore special
        % addressing
        if h == 1
            sCurrency = cColumnNames{2};
            % Currency short is before '_' and number of company with this
            % currency
        else
            sCurrency = extractBefore(cColumnNames{h+1},'_');
            % Currency may appear later for the first time and therefore
            % not have a '_'
            if size(sCurrency) == 0
                sCurrency = tExchangeTRI.Properties.VariableNames{h+1};
            end
        end
        % Check if currency is part of currencies in rID - if not, add to
        % logical array of columns with unallowed currencies (firms)
        lAllowedCurrency = ismember(sCurrency, rID.(sCountryName).CURRENCY);
        if lAllowedCurrency == false
            vUnallowedCurrency = [vUnallowedCurrency h h+1];
        end
    end
    
    % Delete firms with unallowed currencies by removing columns
    tExchangeTRI = removevars(tExchangeTRI,vUnallowedCurrency);
    
    %% Fill struct
    % Create struct item (empty array) for each currency of country
    for g = 1:dAmountCurrencies
        sCurrency = rID.(sCountryName).CURRENCY{g};
        % Modifiy currency name if it contains illegal characters ('$' or
        %'£') and rename in rID to ensure referenceability
        if sum(contains(['AUSTRALIA', 'CANADA', 'HONGKONG', 'NEW_ZEALAND', 'SINGAPORE'],sCountryName)) == 1
            sCurrency = replace(sCurrency, '$', 'D');
            rID.(sCountryName).CURRENCY{1} = sCurrency;
        elseif sum(contains(['EGYPT', 'ISRAEL'],sCountryName)) == 1
            sCurrency = replace(sCurrency, '£', 'L');
            rID.(sCountryName).CURRENCY{1} = sCurrency;
        elseif isequal(sCountryName,'IRELAND') && isequal(sCurrency,'£E')
            sCurrency = 'LE';
            rID.(sCountryName).CURRENCY{1} = sCurrency;
        elseif isequal(sCountryName,'GREAT_BRITAIN')
            sCurrency = 'BP';
            rID.(sCountryName).CURRENCY{1} = sCurrency;
        elseif isequal(sCountryName,'MALAYSIA')
            sCurrency = 'MS';
            rID.(sCountryName).CURRENCY{1} = sCurrency;
        elseif isequal(sCountryName,'RUSSIA') && isequal(sCurrency,'U$')
            sCurrency = 'UD';
            rID.(sCountryName).CURRENCY{2} = sCurrency;
        end
        % Create struct item
        rExchangeTRI.(sCountryName).(rID.(sCountryName).CURRENCY{g})=[];
    end
    
    % Iterate over remaining firms (only every second column)
    for f = 1:2:width(tExchangeTRI)
        % Get currency of current firm
        % Explanation column 1 see above
        if f == 1
            sCurrency = tExchangeTRI.Properties.VariableNames{f+1};
        else
            sCurrency = extractBefore(tExchangeTRI.Properties.VariableNames{f+1},'_');
            % Currency may appear later for the first time and therefore
            % not have a '_'
            if size(sCurrency) == 0
                sCurrency = tExchangeTRI.Properties.VariableNames{f+1};
            end
        end
        % Modifiy currency name if it contains illegal characters ('$' or
        %'£')
        if sum(contains(['AUSTRALIA', 'CANADA', 'HONGKONG', 'NEW_ZEALAND', 'SINGAPORE'],sCountryName)) == 1
            sCurrency = replace(sCurrency, '$', 'D');
        elseif sum(contains(['EGYPT', 'ISRAEL'],sCountryName)) == 1
            sCurrency = replace(sCurrency, '£', 'L');
        elseif isequal(sCountryName,'IRELAND') && isequal(sCurrency,'£E')
            sCurrency = 'LE';
        elseif isequal(sCountryName,'GREAT_BRITAIN')
            sCurrency = 'BP';
        elseif isequal(sCountryName,'MALAYSIA')
            sCurrency = 'MS';
        elseif isequal(sCountryName,'RUSSIA') && isequal(sCurrency,'U$')
            sCurrency = 'UD';
        end
        % Calculate exchange rate and adding to countries correct currency
        % array using sCurrency
        rExchangeTRI.(sCountryName).(sCurrency) = [rExchangeTRI.(sCountryName).(sCurrency), tExchangeTRI.(f+1)./tExchangeTRI.(f)];
    end
    
    %% Calculate means
    % Iterate over the amount of currencies of the country
    for g = 1:dAmountCurrencies
        % Read the name of the currency from rID
        sCurrency = rID.(sCountryName).CURRENCY{g};
        % Replace infinites (Inf) that appeared in the exchange rate
        % calculation with NaNs
        rExchangeTRI.(sCountryName).(sCurrency)(isinf(rExchangeTRI.(sCountryName).(sCurrency))) = NaN;
        % Calculate mean of exchange rates omitting NaNs and replacing array
        % of firms exchange rates of the currency with vector of mean
        % exchange rates of the currency
        rExchangeTRI.(sCountryName).(sCurrency) = mean(rExchangeTRI.(sCountryName).(sCurrency),2,'omitnan');
    end
end
end