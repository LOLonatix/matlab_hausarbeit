function[vLogBM] = fLogBM(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cLogBM={};
for i =1:5%numel(cFieldNames)
   
   cBookValue = currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY
   cMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE
  
   cLogBM=[cLogBM; log(cBookValue/cMarketValue)];
   
end
[vLogBM] = fConclude(cLogBM);
end

