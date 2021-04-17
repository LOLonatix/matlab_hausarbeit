function[mLogMV] = fLogMV(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
mLogMV=[];
for i =1:numel(cFieldNames)
   
   cMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   cMarketValue(1,:) = []; %delete first cell to create a 1month lagged MV
   cMarketValue=[NaN;cMarketValue];
  
   mLogMV=[mLogMV; log(cMarketValue)];
   
end

end