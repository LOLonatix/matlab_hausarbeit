%function [rExchangeRate] = fExchangeRate()
%% EXCHANGE RATES
% Function used to define the exchange rate from US Dollar to the countries
% currency. The value in country currency has to be divided by the exchange
% rate to get the value in US Dollar. If missing exchange rates remain,
% they automatically delete all respective TS items when applied to a
% country due to missing rates being NaNs.
%% REQUIRES
% Nothing due to partial hardcoding
%% RETURNS
% Struct with the exchange rates for Euro and each occuring country
% specific currency (former European currencies)
%% FUNCTION Setup
clear; clc;

% Add folder with excel files to path
addpath(genpath('folder_ExchangeRates'));
% Create an empty struct for the exchange rates (function return)
rExchangeRate = struct;
% Read the file with the exchange rates from Datastream for 324 months
% (31/Jul/1989 -30/Jun/2016)
tExchangeRates = readtable('EXCHANGE_RATES.xlsx');

%% FUNCTION Filter exchange rates
% Use function fFilterExcelNumeric to turn all non-numeric variables to
    % numeric variables
    tExchangeRates = fFilterExcelNumeric(tExchangeRates);
    
%% FUNCTION Write struct
% Write Euro exchange rates into struct
rExchangeRate.EURO = tExchangeRates.(2);

% Country Names in order of appearence in the data (hardcoding faster than
% reading from excel files)
cCountryNames = {'ARGENTINA', 'AUSTRALIA', 'AUSTRIA', 'BELGIUM', 'BRAZIL', 'CANADA', 'CHILE',...
    'CHINA', 'COLOMBIA', 'CZECH', 'DENMARK', 'EGYPT', 'FINLAND', 'FRANCE', 'GERMANY',...
    'GREAT_BRITAIN', 'GREECE', 'HONGKONG', 'HUNGARY', 'INDIA', 'INDONESIA', 'IRELAND',...
    'ISRAEL', 'ITALY', 'JAPAN', 'JORDAN', 'KOREA', 'MALAYSIA', 'MOROCCO', 'NETHERLANDS',...
    'NEW_ZEALAND', 'NORWAY', 'PAKISTAN', 'PERU', 'PHILIPPINES', 'POLAND', 'PORTUGAL',...
    'RUSSIA', 'SINGAPORE', 'SOUTH_AFRICA', 'SPAIN', 'SWEDEN', 'SWITZERLAND', 'TAIWAN',...
    'THAILAND', 'TURKEY'};
dAmountCountries = length(cCountryNames);

% Iterate through countries to add respective exchange rate to struct
for i = 1:dAmountCountries
    % Reading the current country name for variable struct element name
    sCountryName = cCountryNames{i};
    % As Finland and Portugal do not appear in the exchange rate file (no
    % list found), the structs for the countries is NaN and the reference
    % column in the table for following countries is adapted
    if isequal(sCountryName,'FINLAND') || isequal(sCountryName,'PORTUGAL')
        rExchangeRate.(sCountryName) = [];
    elseif i <= 14
        rExchangeRate.(sCountryName) = tExchangeRates.(i+2);
    % After Finland
    elseif i >= 15 && i <= 37
        rExchangeRate.(sCountryName) = tExchangeRates.(i+1);
    % After Portugal
    elseif i >= 38
        rExchangeRate.(sCountryName) = tExchangeRates.(i);
    end
end

%% FUNCTION Exchange rates from TRI data
% Use function fExchangeTRI to calculate exchange rates for each country
% currency
rExchangeTRI = fExchangeTRI(cCountryNames);

% Replace missing exchange rates in the struct with TRI calculated exchange
% rates
for i = 1:dAmountCountries
    sCountryName = cCountryNames{i};
    % Find missing exchange rates
    lExchangeNaN = isnan(rExchangeRate.(sCountryName));
    % Find country currencies
    cCurrencies = fieldnames(rExchangeTRI.(sCountryName));
    % Replace NaNs in rExchangeRate with values from rExchangeTRI, but only
    % for the first currency (Euro is known not to have NaNs)
    rExchangeRate.(sCountryName)(lExchangeNaN) = rExchangeTRI.(sCountryName).(cCurrencies{1})(lExchangeNaN);
    % Exceptions for Finland and Portugal as they have only calculated
    % exchange rates - the whole array with the data of the former currency
    % is added to the struct
    if sum(contains(['FINLAND', 'PORTUGAL'],sCountryName)) == 1
        rExchangeRate.(sCountryName) = rExchangeTRI.(sCountryName).(cCurrencies{1});
    end
end
% Save data for process speed up
save('rExchangeRate.mat','rExchangeRate')
%end