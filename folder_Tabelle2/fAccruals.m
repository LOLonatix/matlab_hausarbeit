function [dMeanAccruals,dSDAccruals,d1stQAccruals,d25stQAccruals,d50stQAccruals,d75stQAccruals,d99stQAccruals] = fAccruals(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAccruals = {};
    for i=1:2
        rCurrentCompany = currentCountryStructure.(cFieldNames{i});
        cTotal_Assets= rCurrentCompany.TOTAL_ASSETS;
        %nun zähler ausrechnen
        for k=13:312
            cDel_CurrentAssets = rCurrentCompany.CURRENT_ASSETS(k)-rCurrentCompany.CURRENT_ASSETS(k-12);
            cDel_Cash = rCurrentCompany.CASH_SHORT_TERM_INVESTMENTS(k)-rCurrentCompany.CASH_SHORT_TERM_INVESTMENTS(k-12);
            cDel_CurrentLiabilities= rCurrentCompany.CURRENT_LIABILITIES(k)-rCurrentCompany.CURRENT_LIABILITIES(k-12);
            cDel_DebtCurrentLiabilities= rCurrentCompany.SHORT_TERM_DEBTS(k)-rCurrentCompany.SHORT_TERM_DEBTS(k-12);
            cDel_IncomeTaxPayable= rCurrentCompany.INCOME_TAX_PAYABLE(k)-rCurrentCompany.INCOME_TAX_PAYABLE(k-12);
            cDel_Depreciation= rCurrentCompany.DEPRECIATION(k)-rCurrentCompany.DEPRECIATION(k-12);
            cZaehler = cDel_CurrentAssets-cDel_Cash-cDel_CurrentLiabilities+cDel_DebtCurrentLiabilities+cDel_IncomeTaxPayable-cDel_Depreciation;
        end
        %accruals=zähler/assets
        cAccruals=[cAccruals,cZaehler/cTotal_Assets]
        
    end
[vAccruals] = fConclude(cAccruals);
end

