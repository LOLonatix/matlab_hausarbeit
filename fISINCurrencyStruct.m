function [rISINCurrency] = fISINCurrencyStruct()
%% ISIN AND CURRENCY STRUCT
% Function used to create a struct with the ISIN ID and currency abbreviation
% for each country to determine whether the country fulfills the
% requirements of the filters as described by Hanauer et al. (2018).
%% REQUIRES
% nothing due to hardcoding (function makes calling in other scripts
% easier)
%% RETURNS
% a hardcoded struct with the IDs of every country
%% FUNCTION Identifier lists
% Cell arrays with the strings with the needed identifiers for each
% country. The order of the data/country is the same in each array to
% enable loops.
clear; clc;

% create struct
rISINCurrency = struct;

% Country Names as the imported data
vCountryNames = {'ARGENTINA', 'AUSTRALIA', 'AUSTRIA', 'BELGIUM', 'BRAZIL', 'CANADA', 'CHILE',...
    'CHINA', 'COLOMBIA', 'CZECH', 'DENMARK', 'EGYPT', 'FINLAND', 'FRANCE', 'GERMANY',...
    'GREAT_BRITAIN', 'GREECE', 'HONGKONG', 'HUNGARY', 'INDIA', 'INDONESIA', 'IRELAND',...
    'ISRAEL', 'ITALY', 'JAPAN', 'JORDAN', 'KOREA', 'MALAYSIA', 'MOROCCO', 'NETHERLANDS',...
    'NEW_ZEALAND', 'NORWAY', 'PAKISTAN', 'PERU', 'PHILIPPINES', 'POLAND', 'PORTUGAL',...
    'RUSSIA', 'SINGAPORE', 'SOUTH_AFRICA', 'SPAIN', 'SWEDEN', 'SWITZERLAND', 'TAIWAN',...
    'THAILAND', 'TURKEY'};

% Country ISIN ID
vISIN = {'AR', 'AU', 'AT', 'BE', 'BR', 'CA', 'CL', 'CN', 'CO', 'CZ', 'DK', 'EG', 'FI', 'FR', 'DE',...
    'GB', 'GR', 'HK', 'HU', 'IN', 'ID', 'IE', 'IL', 'IT', 'JP', 'JO', 'KR', 'MY', 'MA', 'NL',...
    'NZ', 'NO', 'PK', 'PE', 'PH', 'PL', 'PT', 'RU', 'SG', 'ZA', 'ES', 'SE', 'CH', 'TW', 'TH', 'TR'};

% Currency short
vCurrency = {'AP', 'A$', 'AS', 'BF' , 'C', 'C$', 'CE', '+++CHINA+++' , 'CP', 'CK', 'DK', 'E£', 'M', 'FF', 'DM',...
    '£', 'DR', 'K$', 'HF', 'IR', 'RI', '£E', 'I£', 'L', 'Y', 'JD', 'KW', 'M$', 'MD', 'FL',...
    'Z$', 'NK', 'PR', 'PS', 'PP', 'PZ', '+++PORTUGAL+++', 'UR', 'S$', 'R', 'E', 'SK', 'SF', 'TW', 'TB', 'TL'};

%% FUNCTION Build and fill struct
% Length of the loop is known due to hardcoding of the countries in the
% list, but like this a more variable use of the loop would be possible.
for i = 1:length(vCountryNames)
    % Reading the current country name for variable struct element name.
    sCountryName = vCountryNames{i};
    
    % Creating an empty cell array at the countries currency to be able to
    % add several currencies if needed.
    rISINCurrency.(sCountryName).ISIN = cell(1);
    % Creating a struct item with the ISIN ID of a country.
    rISINCurrency.(sCountryName).ISIN{1} = vISIN{i};
    
    if isequal(sCountryName, 'HONGKONG')
        rISINCurrency.(sCountryName).ISIN{2} = 'BM';
        rISINCurrency.(sCountryName).ISIN{3} = 'KY';
    elseif isequal(sCountryName, 'CZECH')
        rISINCurrency.(sCountryName).ISIN{2} = 'CS';
    end
        
    
    % Creating an empty cell array at the countries currency to be able to
    % add several currencies if needed.
    rISINCurrency.(sCountryName).CURRENCY = cell(1);
    % Writing the countries currence in the cell array within the struct.
    rISINCurrency.(sCountryName).CURRENCY{1} = vCurrency{i};
    
    % Checking if current country uses the euro (€) and if so, add as
    % second currency. For Spain no other currency than 'E' could be found
    % (propably the same short applied for pesetas before the euro),
    % therefore no second currency is added.
    if isequal(sCountryName, 'AUSTRIA') || isequal(sCountryName, 'BELGIUM') || isequal(sCountryName, 'FINLAND') || isequal(sCountryName, 'FRANCE') ||...
            isequal(sCountryName, 'GERMANY') || isequal(sCountryName, 'GREECE') || isequal(sCountryName, 'IRELAND') || isequal(sCountryName, 'ITALY') ||...
            isequal(sCountryName, 'NETHERLANDS')
        rISINCurrency.(sCountryName).CURRENCY{2} = 'E';
    elseif isequal(sCountryName, 'RUSSIA')
        % For Russia also USD are accepted as currency.
        rISINCurrency.(sCountryName).CURRENCY{2} = 'U$';
    end
    
    % Writing the GEOGRAPHIC_DESCR (GEOGN) and the GEOG_DESC_OF_LSTNG
    % (GEOLN) of country that is usually the same as the countries name.
    % The exceptions are adressed by the if-condition.
    if isequal(sCountryName,'CZECH')
        rISINCurrency.(sCountryName).GEOGN = 'CZECH REPUBLIC';
        rISINCurrency.(sCountryName).GEOLN = 'CZECH REPUBLIC';
    elseif isequal(sCountryName,'GREAT_BRITAIN')
        rISINCurrency.(sCountryName).GEOGN = 'UNITED KINGDOM';
        rISINCurrency.(sCountryName).GEOLN = 'UNITED KINGDOM';
    elseif isequal(sCountryName,'HONGKONG')
        rISINCurrency.(sCountryName).GEOGN = 'HONG KONG';
        rISINCurrency.(sCountryName).GEOLN = 'HONG KONG';
    elseif isequal(sCountryName,'KOREA')
        rISINCurrency.(sCountryName).GEOGN = 'SOUTH KOREA';
        rISINCurrency.(sCountryName).GEOLN = 'SOUTH KOREA';
    elseif isequal(sCountryName,'NEW_ZEALAND')
        rISINCurrency.(sCountryName).GEOGN = 'NEW ZEALAND';
        rISINCurrency.(sCountryName).GEOLN = 'NEW ZEALAND';
    elseif isequal(sCountryName,'RUSSIA')
        rISINCurrency.(sCountryName).GEOGN = 'RUSSIAN FEDERATION';
        rISINCurrency.(sCountryName).GEOLN = 'RUSSIAN FEDERATI';
    elseif isequal(sCountryName,'SOUTH_AFRICA')
        rISINCurrency.(sCountryName).GEOGN = 'SOUTH AFRICA';
        rISINCurrency.(sCountryName).GEOLN = 'SOUTH AFRICA';
    else
        rISINCurrency.(sCountryName).GEOGN = sCountryName;
        rISINCurrency.(sCountryName).GEOLN = sCountryName; 
    end
end
end