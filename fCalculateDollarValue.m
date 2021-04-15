function [rCurrentCompany] = fCalculateDollarValue(rCurrentCompany,vExchangeRate)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cItems = fieldnames(rCurrentCompany);
for i = 17:44
vTemp = rCurrentCompany.(cItems{i});
dTemp = length(vTemp);
if dTemp == 312
    vTemp = vTemp./vExchangeRates(13:end);
else
    vTemp = vTemp./vExchangeRates;
end
rCurrentCompany.(cItems{i}) = vTemp;
end
end

