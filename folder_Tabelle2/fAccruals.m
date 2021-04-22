%function [vAccruals] = fAccruals(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAccruals = {};
    for i=1:numel(cFieldNames)
        rCurrentCompany = currentCountryStructure.(cFieldNames{i});
        sKeys = ["CURRENT_ASSETS","CASH_SHORT_TERM_INVESTMENTS","CURRENT_LIABILITIES","SHORT_TERM_DEBTS","INCOME_TAX_PAYABLE","DEPRECIATION"];
        %nun zähler ausrechnen

       if length(rCurrentCompany.TOTAL_ASSETS) >1 
        vTotal_Assets= rCurrentCompany.TOTAL_ASSETS;
        for p = 1:length(sKeys)
            vToChange = rCurrentCompany.(sKeys(p));
            if length(vToChange) ==1
                vToChange = zeros(312,1);
            else 
                vToChange(isnan(vToChange))=0;
            end
             rCurrentCompany.(sKeys(p))= vToChange;
        end        
        
        
        cDel_CurrentAssets = rCurrentCompany.CURRENT_ASSETS(13:end,:)-rCurrentCompany.CURRENT_ASSETS(1:300,:);                
        cDel_Cash = rCurrentCompany.CASH_SHORT_TERM_INVESTMENTS(13:end,:)-rCurrentCompany.CASH_SHORT_TERM_INVESTMENTS(1:300,:);
        cDel_CurrentLiabilities= rCurrentCompany.CURRENT_LIABILITIES(13:end,:)-rCurrentCompany.CURRENT_LIABILITIES(1:300,:);
        cDel_DebtCurrentLiabilities= rCurrentCompany.SHORT_TERM_DEBTS(13:end,:)-rCurrentCompany.SHORT_TERM_DEBTS(1:300,:);
        cDel_IncomeTaxPayable= rCurrentCompany.INCOME_TAX_PAYABLE(13:end,:)-rCurrentCompany.INCOME_TAX_PAYABLE(1:300,:);
        cDel_Depreciation= rCurrentCompany.DEPRECIATION(13:end,:)-rCurrentCompany.DEPRECIATION(1:300,:);
        cZaehler = cDel_CurrentAssets-cDel_Cash-cDel_CurrentLiabilities+cDel_DebtCurrentLiabilities+cDel_IncomeTaxPayable-cDel_Depreciation;

        %accruals=zähler/assets
        cAccruals=[cAccruals,cZaehler./vTotal_Assets(13:312)] ;  
       end
        end              
    
[vAccruals] = fConclude(cAccruals);
%end

