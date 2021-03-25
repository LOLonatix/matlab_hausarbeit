function [averageTotalSize] = faverageTotalSize(currentCountryStructure)
fns =fieldnames(currentCountryStructure);
for i = 1:numel(currentCountryStructure)
   marketvalues={};
   marketvalues=[marketvalues; currentCountryStructure.(fns{i}).MARKET_VALUE];   
end    
averageTotalSize = mean(cell2mat(marketvalues),'omitnan');
end

