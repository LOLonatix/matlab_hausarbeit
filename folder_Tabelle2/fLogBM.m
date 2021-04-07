function[dMeanLogBM,dSDLogBM,d1stQLogBM,d25stQLogBM,d50stQLogBM,d75stQLogBM,d99stQLogBM] = fLogBM(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cALogBM={};
for i =1:5%numel(cFieldNames)
   
   cABookValue = currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY
   cAMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE
  
   cALogBM=[cALogBM; log(cABookValue/cAMarketValue)];
   
end
dMeanLogBM = mean(cell2mat(cALogBM),'omitnan');
dSDLogBM = std(cell2mat(cALogBM),'omitnan');
d1stQLogBM = quantile(cell2mat(cALogBM),0.01);
d25stQLogBM = quantile(cell2mat(cALogBM),0.25);
d50stQLogBM = quantile(cell2mat(cALogBM),0.50);
d75stQLogBM = quantile(cell2mat(cALogBM),0.75);
d99stQLogBM = quantile(cell2mat(cALogBM),0.99);

end

