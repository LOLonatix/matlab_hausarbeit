function [sMarket] = fMSCImarket(sCountryName)
%MSCI MARKET: Functions sorts whether the country is listet by the MSCI as
%emerging (EM) oder developed market (DM)
%   if-loop checking to which market the country belongs to using the
%   country name as described by Ball et al. (2016)
if sCountryName == 'Australia' | 'Austria' | 'Belgium' | 'Canada' | 'Denmark' | ...
                   'Finland' | 'France' | 'Germany' | 'Great Britain' | 'Hong Kong' | ...
                   'Ireland' | 'Italy' | 'Japan' | 'Netherlands' | 'New Zealand' | ...
                   'Norway' | 'Singapore' | 'Spain' | 'Spain' | 'Sweden' | 'Switzerland'
    sMarket = 'DM';
elseif sCountryName == 'Greece' | 'Israel' | 'Portugal'
    sMarket = 'DM/EM';
else sMarket = 'EM';
end
end

