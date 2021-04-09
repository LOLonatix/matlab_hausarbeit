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
[dMeancAOpProfitff,dSDcAOpProfitff,d1stQcAOpProfitff,d25stQcAOpProfitff,d50stQcAOpProfitff,d75stQcAOpProfitff,d99stQcAOpProfitff] = fConclude(cAOpProfitff)
end


