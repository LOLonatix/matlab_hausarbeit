function[vLogBM] = fLogBM(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cLogBM=[];
for i =1:numel(cFieldNames)%start iteration für alle länder
   
   cBookValue = currentCountryStructure.(cFieldNames{i}).COMMON_EQUITY;
   cMarketValue = currentCountryStructure.(cFieldNames{i}).MARKET_VALUE;
   %vermeiden, dass durch 0 geteilt wird
   if cMarketValue ~= 0       
        cLogBM_CurrentCompany= log(cBookValue./cMarketValue);
   end
   cLogBM=[cLogBM; cLogBM_CurrentCompany];%aktuelle log wert den vorherigen zufügen
   cLogBM(isinf(cLogBM))=NaN;%infinities durch Nans ersetzen
   cLogBM = real(cLogBM);% nur real anteil nehmen
end
[vLogBM] = fConclude(cLogBM);%summarize 
end

