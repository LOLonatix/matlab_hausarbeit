function[vQLogMV] = fLogMV(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cLogMV={};
for i =1:5%numel(cFieldNames)
   
   cMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   %cAMarketValue(1,:) = [];%delete first cell to create a 1month lagged MV
   cMarketValue=[NaN;cMarketValue];%add a NaN cell to the beginning --> 1 month lagged MV
  
   cLogMV=[cLogMV; log(cMarketValue)];%add together MV of previous firms with current firm's
   
end
[vLogMV] = fConclude(cLogMV);

end


