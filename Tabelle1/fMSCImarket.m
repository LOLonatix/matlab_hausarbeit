function [sMarket] = fMSCImarket(sCountryName)
%MSCI MARKET: Functions sorts whether the country is listet by the MSCI as
%emerging (EM) oder developed market (DM)
%   if-loop checking to which market the country belongs to using the
%   country name as described by Ball et al. (2016)
if sCountryName == 'AUSTRALIA' | 'AUSTRIA' | 'BELGIUM' | 'CANADA' | 'DENMARK' | ...
                   'FINLAND' | 'FRANCE' | 'GERMANY' | 'GREATBRITAIN' | 'HONGKONG' | ...
                   'IRELAND' | 'ITALY' | 'JAPAN' | 'NETHERLANDS' | 'NEWZEALAND' | ...
                   'NORWAY' | 'SINGAPORE' | 'SPAIN' | 'SWEDEN' | 'SWITZERLAND'
    sMarket = 'DM';
elseif sCountryName == 'GREECE' | 'ISRAEL' | 'PORTUGAL'
    sMarket = 'DM/EM';
else sMarket = 'EM';
end
end

