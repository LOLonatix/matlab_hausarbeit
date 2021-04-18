function [mOpProfit] = fOpProfit(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
mOpProfit=[];
for i =1:numel(cFieldNames)
    
   cSales = currentCountryStructure.(cFieldNames{i}).SALES;
   cCOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cRepSGA = currentCountryStructure.(cFieldNames{i}).SG_A-currentCountryStructure.(cFieldNames{i}).RESEARCH_AND_DEVELOPMENT_COSTS;
   cTotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   cTotal_Assets = cTotal_Assets(13:end);%delete first 12 months
   cZerosInTA = cTotal_Assets == 0;
   cTotal_Assets(cZerosInTA)=NaN;
   mOpProfit=[mOpProfit; (cSales-cCOGS-cRepSGA)./cTotal_Assets];
   
end

end