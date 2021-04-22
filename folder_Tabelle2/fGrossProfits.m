function [vGrossProfit,cGrossProfit] = fGrossProfits(currentCountryStructure);
%return Fieldnames to later iterate over and initiate empty cell array to
%later add Gross profits of each company into
cFieldNames = fieldnames(currentCountryStructure);
cGrossProfit={};%cell array bietet besser übersichtlichkeit als normaler array der 50000 Stellen lang ist
%start of iteration over each company
for i =1:numel(cFieldNames)
   
   cSales = currentCountryStructure.(cFieldNames{i}).SALES;
   cCOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cTotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   cTotal_Assets = cTotal_Assets(13:end);%delete first 12 months
   cZerosInTA = cTotal_Assets == 0;
   cTotal_Assets(cZerosInTA)=NaN;
   cGrossProfit=[cGrossProfit; (cSales-cCOGS)./cTotal_Assets];%calculate Gross profit of current company and add it to the already existing cell array of gross profits   
end
%Now calculate mean, SD and quantiles by calling fConclude function
[vGrossProfit] = fConclude(cGrossProfit);
end
