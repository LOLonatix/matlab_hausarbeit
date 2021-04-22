function[vLogMV] = fLogMV(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cLogMV={};
for i =1:numel(cFieldNames)
   
   cMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   
   cMarketValue=[NaN;cMarketValue];%add a NaN cell to the beginning --> 1 month lagged MV
   if length(cMarketValue) == 313 
        cLogMV=[cLogMV; log(cMarketValue)];%add together MV of previous firms with current firm's
   end
end
[vLogMV] = fConclude(cLogMV);

end


