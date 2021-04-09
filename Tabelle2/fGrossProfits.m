%function [dMeanGrossProfits,dSDGrossProfits,d1stQGrossProfits,d25stQGrossProfits,d50stQGrossProfits,d75stQGrossProfits,d99stQGrossProfits,cAGrossProfit] = fGrossProfits(currentCountryStructure)
%return Fieldnames to later iterate over and initiate empty cell array to
%later add Gross profits of each company into
cFieldNames = fieldnames(currentCountryStructure);
cAGrossProfit={};
%start of iteration over each company
for i =1:numel(cFieldNames)
   
   cASales = currentCountryStructure.(cFieldNames{i}).SALES;
   cACOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cATotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   test = cASales-cACOGS./cATotal_Assets;
   cAGrossProfit=[cAGrossProfit; test];%calculate Gross profit of current company and add it to the already existing cell array of gross profits
   
end

%Now calculate mean, SD and quantiles by calling fConclude function
%  dMeanGrossProfit = mean(cAGrossProfit,'omitnan');
% dSDGrossProfit = std(cAGrossProfit,'omitnan');
% d1stQGrossProfit = quantile(cAGrossProfit,0.01);
% d25stQGrossProfit = quantile(cAGrossProfit,0.25);
% d50stQGrossProfit = quantile(cAGrossProfit,0.50);
% d75stQGrossProfit = quantile(cAGrossProfit,0.75);
% d99stQGrossProfit = quantile(cAGrossProfit,0.99);
%end
