function [dMeanGrossProfits,dSDGrossProfits,d1stQGrossProfits,d25stQGrossProfits,d50stQGrossProfits,d75stQGrossProfits,d99stQGrossProfits,cAGrossProfit] = fGrossProfits(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAGrossProfit={};
for i =1:numel(cFieldNames)
   
   cASales = currentCountryStructure.(cFieldNames{i}).SALES;
   cACOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cATotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   cAGrossProfit=[cAGrossProfit; cASales-cACOGS./cATotal_Assets];
   
end
dMeanGrossProfits = mean(cell2mat(cAGrossProfit),'omitnan');
dSDGrossProfits = std(cell2mat(cAGrossProfit),'omitnan');
d1stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.01);
d25stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.25);
d50stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.50);
d75stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.75);
d99stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.99);


end

