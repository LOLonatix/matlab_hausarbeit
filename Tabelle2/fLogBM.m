function[dMeanLogBM,dSDLogBM,d1stQLogBM,d25stQLogBM,d50stQLogBM,d75stQLogBM,d99stQLogBM] = fLogBM(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cALogBM={};
for i =1:5%numel(cFieldNames)
   
   cABookValue = currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY
   cAMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE
  
   cALogBM=[cALogBM; log(cABookValue/cAMarketValue)];
   
end
[dMeanLogBM,dSDLogBM,d1stQLogBM,d25stQLogBM,d50stQLogBM,d75stQLogBM,d99stQLogBM] = fConclude(cALogBM);
end

