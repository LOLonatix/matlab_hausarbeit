function [vCbGrossProfit] = fCbGrossProfit(currentCountryStructure,cGrossProfit)
cFieldNames = fieldnames(currentCountryStructure);
vCbGrossProfit=[];
vCbGrossProfit_CurrentCompany={};
vCashBasedAdj=[];
for i =1:numel(cGrossProfit)%start iteration aller länder
   rCurrentCompany = currentCountryStructure.(cFieldNames{i});
        sKeys = ["ACCOUNTS_RECEIVABLE","INVENTORY","PREPAID_EXPENSES","DEFERRED_REVENUE","TRADE_ACCOUNTS_PAYABLE","OTHER_ACCRUED_EXPENSES"...
            "ACCRUED_PAYROLL"];%alle skeys checken ob sie evtl nur aus einem Nan bestehen. ggf durch0-vektor ersetzen
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
%    %nun cash-based adjustments ausrechnen 
          
            cDel_AccountsRec = rCurrentCompany.ACCOUNTS_RECEIVABLE(13:312,1)-rCurrentCompany.ACCOUNTS_RECEIVABLE(1:300,:);
            cDel_Inventory = rCurrentCompany.INVENTORY(13:312,1)-rCurrentCompany.INVENTORY(1:300,:);
            cDel_PrepExp = rCurrentCompany.PREPAID_EXPENSES(13:312,1)-rCurrentCompany.PREPAID_EXPENSES(1:300,:);
            cDel_DefRevenue = rCurrentCompany.DEFERRED_REVENUE(13:312,1)-rCurrentCompany.DEFERRED_REVENUE(1:300,:);%Deferred 
            cDel_TraAccPay = rCurrentCompany.TRADE_ACCOUNTS_PAYABLE(13:312,1)-rCurrentCompany.TRADE_ACCOUNTS_PAYABLE(1:300,:);
            cDel_AccruedExp = rCurrentCompany.ACCRUED_PAYROLL(13:312,1)+rCurrentCompany.OTHER_ACCRUED_EXPENSES(13:312,1)-rCurrentCompany.ACCRUED_PAYROLL(1:300,1)-rCurrentCompany.OTHER_ACCRUED_EXPENSES(1:300,:);
            vCashBasedAdj =-cDel_AccountsRec-cDel_Inventory-cDel_PrepExp+cDel_DefRevenue+cDel_TraAccPay+cDel_AccruedExp; 
        
        cTotal_Assets = rCurrentCompany.TOTAL_ASSETS;
        cTotal_Assets = cTotal_Assets(25:end);%delete first 24 months
        vOpProfit = cGrossProfit{i};
        vOpProfit = vOpProfit(13:end);
        cZerosInTA = cTotal_Assets == 0;
        cTotal_Assets(cZerosInTA)=NaN;        
        vCbGrossProfit_CurrentCompany=(vOpProfit+vCashBasedAdj)./cTotal_Assets;  
   
    vCbGrossProfit = [vCbGrossProfit; vCbGrossProfit_CurrentCompany];%bestehende werte + neue werte
   
end
[vCbGrossProfit] = fConclude(vCbGrossProfit);
end
end