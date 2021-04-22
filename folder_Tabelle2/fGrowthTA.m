function[vGrowthTA] = fGrowthTA(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAGrowthTA={};
cAGrowthTA_CurrentCompany = {};
for i =1:numel(cFieldNames)
    
   rCurrentCompany = currentCountryStructure.(cFieldNames{i});
   if length(rCurrentCompany.TOTAL_ASSETS)>1
        cATotalAssets = rCurrentCompany.TOTAL_ASSETS;

       cAdA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(13:312,1)-rCurrentCompany.TOTAL_ASSETS(1:300,:);
       cAA_TotalAssets = rCurrentCompany.TOTAL_ASSETS(13:312,1);
       cAGrowthTA_CurrentCompany = cAdA_TotalAssets/cAA_TotalAssets;      

       cAGrowthTA=[cAGrowthTA; cAGrowthTA_CurrentCompany];%add together Growth in total assets of previous firms with current firm's
   end
end

[vGrowthTA] = fConclude(cAGrowthTA);
vGrowthTA = mean(vGrowthTA,2);

end

