function[vGrowthTA] = fGrowthTA(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAGrowthTA={};
cAGrowthTA_CurrentCompany = {};
for i =1:numel(cFieldNames)
   rCurrentCompany = currentCountryStructure.(cFieldNames{i});
   cATotalAssets = rCurrentCompany.TOTAL_ASSETS;
   if length(cATotalAssets) ~=1 
       for k = 13:312
           cAdA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(k)-rCurrentCompany.TOTAL_ASSETS(k-12);
           cAA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(k);
           cAGrowthTA_CurrentCompany = cAdA_TotalAssets/cAA_TotalAssets;
       end 
   end    
   %cAMarketValue(1,:) = [];%delete first cell to create a 1month lagged MV
   %cAMarketValue=[NaN;cAMarketValue];%add a NaN cell to the beginning --> 1 month lagged MV
  
   cAGrowthTA=[cAGrowthTA; cAGrowthTA_CurrentCompany];%add together Growth in total assets of previous firms with current firm's
   
end

[vGrowthTA] = fConclude(cAGrowthTA);

end

