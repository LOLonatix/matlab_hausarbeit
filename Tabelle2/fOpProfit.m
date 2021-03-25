function [dMeanOpProfit,dSDOpProfit,d1stQOpProfit,d25stQOpProfit,d50stQOpProfit,d75stQOpProfit,d99stQOpProfit] = fOpProfit(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
for i =1:numel(cFieldNames)
   cAOpProfit={};
   cASales = currentCountryStructure.(cFieldNames{i}).SALES;
   cACOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cARepSGA = currentCountryStructure.(cFieldNames{i}).SG_A-currentCountryStructure.(cFieldNames{i}).RESEARCH_AND_DEVELOPMENT_COSTS;
   cATotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   cAOpProfit=[cAOpProfit; cASales-cACOGS-cARepSGA./cATotal_Assets];  
end
dMeanOpProfit = mean(cell2mat(cAOpProfit),'omitnan');
dSDOpProfit = std(cell2mat(cAOpProfit),'omitnan');
d1stQOpProfit = quantile(cell2mat(cAOpProfit),0.01);
d25stQOpProfit = quantile(cell2mat(cAOpProfit),0.25);
d50stQOpProfit = quantile(cell2mat(cAOpProfit),0.50);
d75stQOpProfit = quantile(cell2mat(cAOpProfit),0.75);
d99stQOpProfit = quantile(cell2mat(cAOpProfit),0.99);
end

