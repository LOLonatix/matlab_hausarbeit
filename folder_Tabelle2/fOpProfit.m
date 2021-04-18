function [vOpProfit,cOpProfit] = fOpProfit(currentCountryStructure)
%return Fieldnames to later iterate over and initiate empty cell array to
%later add operating profits of each company into
cFieldNames = fieldnames(currentCountryStructure);
cOpProfit={};
for i =1:numel(cFieldNames)
   cSales = currentCountryStructure.(cFieldNames{i}).SALES;
   cCOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cRepSGA = currentCountryStructure.(cFieldNames{i}).SG_A-currentCountryStructure.(cFieldNames{i}).RESEARCH_AND_DEVELOPMENT_COSTS;
   cTotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   cTotal_Assets = cTotal_Assets(13:end);%delete first 12 months
   cZerosInTA = cTotal_Assets == 0;
   cTotal_Assets(cZerosInTA)=NaN;
   cOpProfit=[cOpProfit; (cSales-cCOGS-cRepSGA)./cTotal_Assets];  %calculate operating profit of current company and add it to the already existing cell array of operating profits
end
%Now calculate mean, SD and quantiles by calling fConclude function
[vOpProfit] = fConclude(cOpProfit);
end

