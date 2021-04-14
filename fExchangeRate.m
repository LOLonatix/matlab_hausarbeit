%function [rExchangeRate] = fExchangeRate()
clear; clc;

rExchangeRate = struct;
tExchangeRates = readtable('EXCHANGE_RATES.xlsx');

vNumerics = varfun(@isnumeric,tExchangeRates,'output','uniform');
vNonnumerics = find(vNumerics < 1);
dLengthNonnumeric = length(vNonnumerics);

for i = 2:dLengthNonnumeric
    cTemp = tExchangeRates.(vNonnumerics(i));
    dLengthTemp = length(cTemp);
    for j = 1:dLengthTemp
        if  string(cTemp{j}) == "NA";
            cTemp{j} = NaN;
        else
            cTemp{j} = str2num(string(cTemp{j}));
        end
    end
    tTemp = cell2table(cTemp);
    tExchangeRates.(vNonnumerics(i)) = tTemp.cTemp;
end

% Country Names in order of appearence in the data (Finland and Portugal
% are omitted, as they have no data)
vCountryNames = {'ARGENTINA', 'AUSTRALIA', 'AUSTRIA', 'BELGIUM', 'BRAZIL', 'CANADA', 'CHILE',...
    'CHINA', 'COLOMBIA', 'CZECH', 'DENMARK', 'EGYPT', 'FINLAND', 'FRANCE', 'GERMANY',...
    'GREAT_BRITAIN', 'GREECE', 'HONGKONG', 'HUNGARY', 'INDIA', 'INDONESIA', 'IRELAND',...
    'ISRAEL', 'ITALY', 'JAPAN', 'JORDAN', 'KOREA', 'MALAYSIA', 'MOROCCO', 'NETHERLANDS',...
    'NEW_ZEALAND', 'NORWAY', 'PAKISTAN', 'PERU', 'PHILIPPINES', 'POLAND', 'PORTUGAL',...
    'RUSSIA', 'SINGAPORE', 'SOUTH_AFRICA', 'SPAIN', 'SWEDEN', 'SWITZERLAND', 'TAIWAN',...
    'THAILAND', 'TURKEY'};
dAmountCountries = length(vCountryNames)

rExchangeRate.EURO = tExchangeRates.(2);

for i = 1:dAmountCountries
    % Reading the current country name for variable struct element name.
    sCountryName = vCountryNames{i};
    
    if isequal(sCountryName,'FINLAND') || isequal(sCountryName,'PORTUGAL')
        rExchangeRate.(sCountryName) = NaN;
    elseif i <= 14
        rExchangeRate.(sCountryName) = tExchangeRates.(i+2);
    elseif i >= 15 && i <= 37
        rExchangeRate.(sCountryName) = tExchangeRates.(i+1);
    elseif i >= 38
        rExchangeRate.(sCountryName) = tExchangeRates.(i);
    end
end
