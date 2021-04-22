function [vOpProfitff] = fOpProfitff(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cOpProfitff={};
%start iteration over all firms of a country
for i =1:numel(cFieldNames)
   
   cSales = currentCountryStructure.(cFieldNames{i}).SALES;
   cCOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cSGA = currentCountryStructure.(cFieldNames{i}).SG_A;
   cIE=currentCountryStructure.(cFieldNames{i}).INTEREST_EXPENSES;
   cBookEquity= currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY;
   
   cZerosInBE = cBookEquity == 0;
   cBookEquity(cZerosInBE)=NaN;
   cOpProfitff=[cOpProfitff; (cSales-cCOGS-cSGA-cIE)./cBookEquity] ; %append new value to existing values
end
[vOpProfitff] = fConclude(cOpProfitff)%call conclude function to summarize
end


