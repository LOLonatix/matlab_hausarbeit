function lReturn = fCheckDataAvailability(rCompany)
    % now filter if values are missing (caption of table 1)
    % citation Ball 2016: sample consists of firms with non-missing market value of equity (COMMON EQUITY), 
    % book-to-market (Book equity/market equity --> seen as Common Equity+Deferred Taxes/ MV) 
    % gross profit (Sales-COGS/Total Assets), book value of total assets (Total Assets),
    % current month returns and returns for the prior one-year (calc. via TRI)
    
    % since TRI data was loaded seperately, it could occur that no TRI data
    % was received for a company --> remove

    % this filter checks for necessary data availability explained on page
    % 10 --> availability of associated stock return (calc. by tri),
    % momentum (calculated by tri), sales and cost of goods sold (cogs)
    lReturn = false;
    
    if isfield(rCompany, 'TRI') == true
        if sum(isnan(rCompany.MARKET_VALUE)) == 312 | sum(isnan(rCompany.MARKET_VALUE)) == 324
            lReturn = true;
        elseif length(rCompany.MARKET_VALUE) == 1 || length(rCompany.UNADJUSTED_PRICE) == 1 || length(rCompany.SALES) == 1 %|| length(rCompany.ACCOUNTS_RECEIVABLE) == 1 || length(rCompany.INVENTORY) == 1 || length(rCompany.PREPAID_EXPENSES) == 1|| length(rCompany.DEFERRED_REVENUE) == 1|| length(rCompany.TRADE_ACCOUNTS_PAYABLE) == 1 || length(rCompany.ACCRUED_PAYROLL) == 1 || length(rCompany.OTHER_ACCRUED_EXPENSES) == 1
            lReturn = true;
        elseif length(rCompany.TOTAL_ASSETS) == 1 || length(rCompany.COMMON_EQUITY) == 1 
            lReturn = true;
        elseif length(rCompany.COGS) == 1 || length(rCompany.DEFERRED_TAXES) == 1 || length(rCompany.TRI) == 1
               lReturn = true;
        end
    else
        lReturn = true;
    end
    
    if  sum(isnan(rCompany.CURRENCY)) == 1
        lReturn = true;
    end
end