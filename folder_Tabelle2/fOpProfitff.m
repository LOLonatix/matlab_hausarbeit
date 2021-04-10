function [dMeanOpProfitff,dSDOpProfitff,d1stQOpProfitff,d25stQOpProfitff,d50stQOpProfitff,d75stQOpProfitff,d99stQOpProfitff] = fOpProfitff(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAOpProfitff={};
for i =1:numel(cFieldNames)
   
   cASales = currentCountryStructure.(cFieldNames{i}).SALES;
   cACOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cASGA = currentCountryStructure.(cFieldNames{i}).SG_A;
   cAIE=currentCountryStructure.(cFieldNames{i}).INTEREST_EXPENSES;
   cABookEquity= currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY;
   %hier weiter
   cAOpProfitff=[cAOpProfitff; cASales-cACOGS-cASGA-cAIE./cABookEquity] ; 
end
dMeanOpProfitff = mean(cell2mat(cAOpProfitff),'omitnan');
dSDOpProfitff = std(cell2mat(cAOpProfitff),'omitnan');
d1stQOpProfitff = quantile(cell2mat(cAOpProfitff),0.01);
d25stQOpProfitff = quantile(cell2mat(cAOpProfitff),0.25);
d50stQOpProfitff = quantile(cell2mat(cAOpProfitff),0.50);
d75stQOpProfitff = quantile(cell2mat(cAOpProfitff),0.75);
d99stQOpProfitff = quantile(cell2mat(cAOpProfitff),0.99);
end


