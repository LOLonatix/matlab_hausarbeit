function [AOpProfit] = fOpProfit(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
AOpProfit=[];
for i =1:numel(cFieldNames)
    
   cASales = currentCountryStructure.(cFieldNames{i}).SALES;
   cACOGS = currentCountryStructure.(cFieldNames{i}).COGS;
   cARepSGA = currentCountryStructure.(cFieldNames{i}).SG_A-currentCountryStructure.(cFieldNames{i}).RESEARCH_AND_DEVELOPMENT_COSTS;
   cATotal_Assets= currentCountryStructure.(cFieldNames{i}).TOTAL_ASSETS;
   
   AOpProfit=[AOpProfit; cASales-cACOGS-cARepSGA./cATotal_Assets];  
   
end

end