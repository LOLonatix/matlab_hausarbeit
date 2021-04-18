function [rCurrentCompany] = fCalculateDollarValue(rCurrentCompany,vExchangeRate)
%% CALCULATE DOLLAR VALUE
% Apply the exchange rate to each time series item of the current company.
%% REQUIRES
% - the struct of the current company with it's static and time series data
% - the vector with the exchange rates for the companies currency
%% RETURNS
% the company's struct with TS items in US dollar
%% FUNCTION
% Get a list of all fieldnames of the struct to be able to address them in
% the struct
cItems = fieldnames(rCurrentCompany);
% Iterate over the TS items
for i = 17:44
    % Save current TS item data temporarily
    vTemp = rCurrentCompany.(cItems{i});
% define data length to apply exchange rates correctly
    dTemp = length(vTemp);
% for data starting 31/07/1990
    if dTemp == 312
        vTemp = vTemp./vExchangeRate(13:324);
    else
        % for data starting 31/07/1989
        if dTemp ~= 1
            vTemp = vTemp./vExchangeRate;
        end
    end
% write dollar values in company struct
rCurrentCompany.(cItems{i}) = vTemp;
end
end

