function [dMeanCbOpProfit,dSDCbOpProfit,d1stQCbOpProfit,d25stQCbOpProfit,d50stQCbOpProfit,d75stQCbOpProfit,d99stQCbOpProfit] = fCbOpProfit(currentCountryStructure,cAOpProfit)
cFieldNames = fieldnames(currentCountryStructure);
cACbOpProfit=[];
cACashBasedAdj=[];
for i =1:10
 rCurrentCompany = currentCountryStructure.(cFieldNames{i});
    cATotal_Assets= rCurrentCompany.TOTAL_ASSETS;
    
%    %nun cash-based adjustments ausrechnen
   if length(rCurrentCompany.ACCOUNTS_RECEIVABLE) >1 && length(rCurrentCompany.INVENTORY) >1 && length(rCurrentCompany.PREPAID_EXPENSES) >1 && length(rCurrentCompany.DEFERRED_REVENUE) >1 && length(rCurrentCompany.TRADE_ACCOUNTS_PAYABLE) >1
        for k=13:312   
            cADel_AccountsRec = rCurrentCompany.ACCOUNTS_RECEIVABLE(k)-rCurrentCompany.ACCOUNTS_RECEIVABLE(k-12);
            cADel_Inventory = rCurrentCompany.INVENTORY(k)-rCurrentCompany.INVENTORY(k-12);
            cADel_PrepExp = rCurrentCompany.PREPAID_EXPENSES(k)-rCurrentCompany.PREPAID_EXPENSES(k-12);
            cADel_DefRevenue = rCurrentCompany.DEFERRED_REVENUE(k)-rCurrentCompany.DEFERRED_REVENUE(k-12);%Deferred 
            cADel_TraAccPay = rCurrentCompany.TRADE_ACCOUNTS_PAYABLE(k)-rCurrentCompany.TRADE_ACCOUNTS_PAYABLE(k-12);
            cADel_AccruedExp = rCurrentCompany.ACCRUED_PAYROLL(k)+rCurrentCompany.OTHER_ACCRUED_EXPENSES(k)-rCurrentCompany.ACCRUED_PAYROLL(k)-rCurrentCompany.OTHER_ACCRUED_EXPENSES(k-12);
            cACashBasedAdj =-cADel_AccountsRec-cADel_Inventory-cADel_PrepExp+cADel_DefRevenue+cADel_TraAccPay+cADel_AccruedExp; 
        end
   end
   
   
   cACbOpProfit_CurrentCompany=cell2mat(cAOpProfit(i))+cACashBasedAdj./rCurrentCompany.TOTAL_ASSETS;
   
end
dMeanCbOpProfit = mean(cell2mat(cACbOpProfit),'omitnan');
dSDCbOpProfit = std(cell2mat(cACbOpProfit),'omitnan');
d1stQCbOpProfit = quantile(cell2mat(cACbOpProfit),0.01);
d25stQCbOpProfit = quantile(cell2mat(cACbOpProfit),0.25);
d50stQCbOpProfit = quantile(cell2mat(cACbOpProfit),0.50);
d75stQCbOpProfit = quantile(cell2mat(cACbOpProfit),0.75);
d99stQCbOpProfit = quantile(cell2mat(cACbOpProfit),0.99);
end