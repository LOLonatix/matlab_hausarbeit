function[ALogMV] = fLogMV(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
ALogMV=[];
for i =1:numel(cFieldNames)
   
   cAMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   cAMarketValue(1,:) = []; %delete first cell to create a 1month lagged MV
   cAMarketValue=[NaN;cAMarketValue];
  
   ALogMV=[ALogMV; log(cAMarketValue)];
   
end

end