function [dMeanOpProfit,dSDOpProfit,d1stQOpProfit,d25stQOpProfit,d50stQOpProfit,d75stQOpProfit,d99stQOpProfit,cAOpProfit] = fOpProfit(currentCountryStructure)
%return Fieldnames to later iterate over and initiate empty cell array to
%later add operating profits of each company into
cFieldNames = fieldnames(currentCountryStructure);
cAOpProfit={};
for i =1:numel(cFieldNames)
   cASales = currentCountryStructure.(cFieldNames{i}).SALES;
   cACOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cARepSGA = currentCountryStructure.(cFieldNames{i}).SG_A-currentCountryStructure.(cFieldNames{i}).RESEARCH_AND_DEVELOPMENT_COSTS;
   cATotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   cAOpProfit=[cAOpProfit; cASales-cACOGS-cARepSGA./cATotal_Assets];  %calculate operating profit of current company and add it to the already existing cell array of operating profits
end
%Now calculate mean, SD and quantiles by calling fConclude function
[dMeanOpProfit,dSDOpProfit,d1stQOpProfit,d25stQOpProfit,d50stQOpProfit,d75stQOpProfit,d99stQOpProfit] = fConclude(cAOpProfit);


end

