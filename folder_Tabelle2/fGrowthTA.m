function[vGrowthTA] = fGrowthTA(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cGrowthTA={};
cGrowthTA_CurrentCompany = {};%cell array bietet bessere übersichtlichkeit als normaler array, deswegen in vielen funktionen zur Tabelle 2 genutzt
for i =1:numel(cFieldNames)%start iteration für alle länder
    
   rCurrentCompany = currentCountryStructure.(cFieldNames{i});
   if length(rCurrentCompany.TOTAL_ASSETS)>1%falls total asset werte vorhanden sind
        cTotalAssets = rCurrentCompany.TOTAL_ASSETS;

       cdA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(13:312,1)-rCurrentCompany.TOTAL_ASSETS(1:300,:);%die veränderung über ein Jahr nehmen
       cA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(13:312,1);
       cGrowthTA_CurrentCompany = cdA_TotalAssets/cA_TotalAssets;      

       cGrowthTA=[cGrowthTA; cGrowthTA_CurrentCompany];%add together Growth in total assets of previous firms with current firm's
   end
end

[vGrowthTA] = fConclude(cGrowthTA);
vGrowthTA = mean(vGrowthTA,2);

end

