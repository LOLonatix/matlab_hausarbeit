function [dMeanCbGrossProfit,dSDCbGrossProfit,d1stQCbGrossProfit,d25stQCbGrossProfit,d50stQCbGrossProfit,d75stQCbGrossProfit,d99stQCbGrossProfit] = fCbOpProfit(currentCountryStructure,cGrossProfit)
cFieldNames = fieldnames(currentCountryStructure);
vCbGrossProfit=[];
vCashBasedAdj=[];
for i =1:10
    rCurrentCompany = currentCountryStructure.(cFieldNames{i});
    cTotal_Assets= rCurrentCompany.TOTAL_ASSETS;
    
%    %nun cash-based adjustments ausrechnen
   if length(rCurrentCompany.ACCOUNTS_RECEIVABLE) >1 && length(rCurrentCompany.INVENTORY) >1 && length(rCurrentCompany.PREPAID_EXPENSES) >1 && length(rCurrentCompany.DEFERRED_REVENUE) >1 && length(rCurrentCompany.TRADE_ACCOUNTS_PAYABLE) >1
        for k=13:312   
            cDel_AccountsRec = rCurrentCompany.ACCOUNTS_RECEIVABLE(k)-rCurrentCompany.ACCOUNTS_RECEIVABLE(k-12);
            cDel_Inventory = rCurrentCompany.INVENTORY(k)-rCurrentCompany.INVENTORY(k-12);
            cDel_PrepExp = rCurrentCompany.PREPAID_EXPENSES(k)-rCurrentCompany.PREPAID_EXPENSES(k-12);
            cDel_DefRevenue = rCurrentCompany.DEFERRED_REVENUE(k)-rCurrentCompany.DEFERRED_REVENUE(k-12);%Deferred 
            cDel_TraAccPay = rCurrentCompany.TRADE_ACCOUNTS_PAYABLE(k)-rCurrentCompany.TRADE_ACCOUNTS_PAYABLE(k-12);
            cDel_AccruedExp = rCurrentCompany.ACCRUED_PAYROLL(k)+rCurrentCompany.OTHER_ACCRUED_EXPENSES(k)-rCurrentCompany.ACCRUED_PAYROLL(k)-rCurrentCompany.OTHER_ACCRUED_EXPENSES(k-12);
            vCashBasedAdj =-cDel_AccountsRec-cDel_Inventory-cDel_PrepExp+cDel_DefRevenue+cDel_TraAccPay+cDel_AccruedExp; 
        end
   end
   
   
   cCbOpProfit_CurrentCompany=cell2mat(cGrossProfit(i))+vCashBasedAdj./rCurrentCompany.TOTAL_ASSETS; %hier nochmal checken!
   
end
[vCbOpProfit] = fConclude(cGrowthTA);
end