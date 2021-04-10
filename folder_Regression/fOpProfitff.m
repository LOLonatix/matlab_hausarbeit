function [AOpProfitff] = fOpProfitff(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
AOpProfitff=[];
for i =1:numel(cFieldNames)
   
   cASales = currentCountryStructure.(cFieldNames{i}).SALES;
   cACOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cASGA = currentCountryStructure.(cFieldNames{i}).SG_A;
   cAIE=currentCountryStructure.(cFieldNames{i}).INTEREST_EXPENSES;
   cABookEquity= currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY;
   %hier weiter
   AOpProfitff=[AOpProfitff; cASales-cACOGS-cASGA-cAIE./cABookEquity] ; 
end
end