%function[dMeanLogMV,dSDLogMV,d1stQLogMV,d25stQLogMV,d50stQLogMV,d75stQLogMV,d99stQLogMV] = fLogMV(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cALogMV={};
for i =1:5%numel(cFieldNames)
   
   cAMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   %cAMarketValue(1,:) = [];%delete first cell to create a 1month lagged MV
   cAMarketValue=[NaN;cAMarketValue];%add a NaN cell to the beginning --> 1 month lagged MV
  
   cALogMV=[cALogMV; log(cAMarketValue)];%add together MV of previous firms with current firm's
   
end
[dMeanLogMV,dSDLogMV,d1stQLogMV,d25stQLogMV,d50stQLogMV,d75stQLogMV,d99stQLogMV] = fConclude(cALogMV);

%end


