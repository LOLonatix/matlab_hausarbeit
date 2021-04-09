%function[dMean1MLReturn,dSD1MLReturn,d1stQ1MLReturn,d25stQ1MLReturn,d50stQ1MLReturn,d75stQ1MLReturn,d99stQ1MLReturn] = f1MLReturn(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cA1MLReturn={};
for i =1:5%numel(cFieldNames)
   cATotalReturnIndex = currentCountryStructure.(cFieldNames{i}).TOTAL_RETURN_INDEX;
    \(r_{i,t}=\frac{P_{i,t}}{P_{i,t-1}}-1\)
   cAMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   %cAMarketValue(1,:) = [];%delete first cell to create a 1month lagged MV
   cAMarketValue=[NaN;cAMarketValue];%add a NaN cell to the beginning --> 1 month lagged MV
  
   cA1MLReturn=[cA1MLReturn; log(cAMarketValue)];%add together MV of previous firms with current firm's
   
end
[dMean1MLReturn,dSD1MLReturn,d1stQ1MLReturn,d25stQ1MLReturn,d50stQ1MLReturn,d75stQ1MLReturn,d99stQ1MLReturn] = fConclude(cA1MLReturn);

%end

