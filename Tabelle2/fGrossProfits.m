function [dMeanGrossProfits,dSDGrossProfits,d1stQGrossProfits,d25stQGrossProfits,d50stQGrossProfits,d75stQGrossProfits,d99stQGrossProfits] = fGrossProfits(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
for i =1:numel(cFieldNames)
   cAGrossProfit={};
   cAGrossProfit=[cAGrossProfit; currentCountryStructure.(cFieldNames{i}).SALES-currentCountryStructure.(cFieldNames{i}).COGS./currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS];  
end
dMeanGrossProfits = mean(cell2mat(cAGrossProfit),'omitnan');
dSDGrossProfits = std(cell2mat(cAGrossProfit),'omitnan');
d1stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.01);
d25stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.25);
d50stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.50);
d75stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.75);
d99stQGrossProfits = quantile(cell2mat(cAGrossProfit),0.99);


end

