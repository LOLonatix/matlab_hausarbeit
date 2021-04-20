function[dMeanGrowthTA,dSDGrowthTA,d1stQGrowthTA,d25stQGrowthTA,d50stQGrowthTA,d75stQGrowthTA,d99stQGrowthTA] = fGrowthTA(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAGrowthTA={};
for i =1:5%numel(cFieldNames)
   rCurrentCompany = currentCountryStructure.(cFieldNames{i});
   cATotalAssets = rCurrentCompany.TOTAL_ASSETS;
   for k = 13:312
       cAdA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(k)-rCurrentCompany.TOTAL_ASSETS(k-12);
       cAA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(k);
       cAGrowth_TA = cAdA_TotalAssets/cAA_TotalAssets;
   end    
   %cAMarketValue(1,:) = [];%delete first cell to create a 1month lagged MV
   %cAMarketValue=[NaN;cAMarketValue];%add a NaN cell to the beginning --> 1 month lagged MV
  
   cAGrowthTA=[cAGrowthTA; cAGrowth_TA];%add together Growth in total assets of previous firms with current firm's
   
end

% dMeanGrowthTA = mean(cell2mat(cAGrowthTA),'omitnan');
% dSDGrowthTA = std(cell2mat(cAGrowthTA),'omitnan');
% d1stQGrowthTA = quantile(cell2mat(cAGrowthTA),0.01);
% d25stQGrowthTA = quantile(cell2mat(cAGrowthTA),0.25);
% d50stQGrowthTA = quantile(cell2mat(cAGrowthTA),0.50);
% d75stQGrowthTA = quantile(cell2mat(cAGrowthTA),0.75);
% d99stQGrowthTA = quantile(cell2mat(cAGrowthTA),0.99);

end

