function [dMeanGrossProfits] = fGrossProfits(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
for i =1:numel(cFieldNames)
   cAGrossProfit={};
   cAGrossProfit=[cAGrossProfit; currentCountryStructure.(cFieldNames{i}).SALES-currentCountryStructure.(cFieldNames{i}).COGS./currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS];  
end
dMeanGrossProfits = mean(cell2mat(cAGrossProfit),'omitnan');
dSDGrossProfits = sd
end

