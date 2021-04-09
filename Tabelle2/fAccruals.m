%function [dMeanAccruals,dSDAccruals,d1stQAccruals,d25stQAccruals,d50stQAccruals,d75stQAccruals,d99stQAccruals] = fAccruals(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAAccruals = {};
    for i=1:2
        rCurrentCompany = currentCountryStructure.(cFieldNames{i});
        cATotal_Assets= rCurrentCompany.TOTAL_ASSETS;
        %nun zähler ausrechnen
        for k=13:312
            cADel_CurrentAssets = rCurrentCompany.CURRENT_ASSETS(k)-rCurrentCompany.CURRENT_ASSETS(k-12);
            cADel_Cash = rCurrentCompany.CASH_SHORT_TERM_INVESTMENTS(k)-rCurrentCompany.CASH_SHORT_TERM_INVESTMENTS(k-12);
            cADel_CurrentLiabilities= rCurrentCompany.CURRENT_LIABILITIES(k)-rCurrentCompany.CURRENT_LIABILITIES(k-12);
            cADel_DebtCurrentLiabilities= rCurrentCompany.SHORT_TERM_DEBTS(k)-rCurrentCompany.SHORT_TERM_DEBTS(k-12);
            cADel_IncomeTaxPayable= rCurrentCompany.INCOME_TAX_PAYABLE(k)-rCurrentCompany.INCOME_TAX_PAYABLE(k-12);
            cADel_Depreciation= rCurrentCompany.DEPRECIATION(k)-rCurrentCompany.DEPRECIATION(k-12);
            cAZaehler = cADel_CurrentAssets-cADel_Cash-cADel_CurrentLiabilities+cADel_DebtCurrentLiabilities+cADel_IncomeTaxPayable-cADel_Depreciation;
        end
        %accruals=zähler/assets
        cAAccruals=[cAAccruals,cAZaehler/cATotal_Assets]
        
    end
[dMeanAccruals,dSDAccruals,d1stQAccruals,d25stQAccruals,d50stQAccruals,d75stQAccruals,d99stQAccruals] = fConclude(cAAccruals);
%end

