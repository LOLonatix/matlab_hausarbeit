function [vOpProfitff] = fOpProfitff(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cOpProfitff={};
for i =1:numel(cFieldNames)
   
   cSales = currentCountryStructure.(cFieldNames{i}).SALES;
   cCOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cSGA = currentCountryStructure.(cFieldNames{i}).SG_A;
   cIE=currentCountryStructure.(cFieldNames{i}).INTEREST_EXPENSES;
   cBookEquity= currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY;
   %hier weiter
   cOpProfitff=[cOpProfitff; cSales-cCOGS-cSGA-cIE./cBookEquity] ; 
end
[vOpProfitff] = fConclude(cOpProfitff)
end


