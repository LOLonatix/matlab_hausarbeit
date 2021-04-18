function [mOpProfitff] = fOpProfitff(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
mOpProfitff=[];
for i =1:numel(cFieldNames)
   
   cSales = currentCountryStructure.(cFieldNames{i}).SALES;
   cCOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cSGA = currentCountryStructure.(cFieldNames{i}).SG_A;
   cIE=currentCountryStructure.(cFieldNames{i}).INTEREST_EXPENSES;
   cBookEquity= currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY;
   
   cZerosInBE = cBookEquity == 0;
   cBookEquity(cZerosInBE)=NaN;
   mOpProfitff=[mOpProfitff; cSales-cCOGS-cSGA-cIE./cBookEquity] ; 
   
end

end