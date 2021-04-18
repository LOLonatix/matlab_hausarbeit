function[vLogBM] = fLogBM(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cLogBM={};
for i =1:numel(cFieldNames)
   
   cBookValue = currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY;
   cMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   if cMarketValue ~= 0       
        cLogBM_CurrentCompany= log(cBookValue./cMarketValue);
   end
   cLogBM=[cLogBM; cLogBM_CurrentCompany];
end
[vLogBM] = fConclude(cLogBM);
end

