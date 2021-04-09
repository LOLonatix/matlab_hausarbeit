function lReturn = fStaticScreening(rCompany, sCountry, rStringFiltersStatic)
    sCountry = sCountry(1:end-4);
    % set to false, set to true to remove
    lReturn = false;
    
    % remove financial firms via SIC-CODE between 6000-7000
    if rCompany.SIC_CODE_ >=6000 && rCompany.SIC_CODE_ <=7000
         lReturn = true;
         
    % check screening 1-3 --> major, equity and primary
    elseif rCompany.MAJOR_FLAG ~= 'Y' | rCompany.STOCK_TYPE ~= 'EQ' | rCompany.QUOTE_INDICATOR ~= 'P'
        lReturn = true;
    else
        
    % check screening 4, 5--> country code
        bGEOGRAPHIC_DESCR = contains(sCountry, rCompany.GEOGRAPHIC_DESCR);
        bGEOG_DESC_OF_LSTNG = contains(sCountry, rCompany.GEOG_DESC_OF_LSTNG);
        if bGEOGRAPHIC_DESCR == false | bGEOG_DESC_OF_LSTNG == false
            lReturn = true;
        end
    end
    
    % check screening 6 --> currency (needs iteration, since some have 2
    % values
    if lReturn ~= true
        dLengthCurrency = length(rStringFiltersStatic.(sCountry).CURRENCY);
        lFoundCurrency = false;
        for i=1:dLengthCurrency
            sString = rStringFiltersStatic.(sCountry).CURRENCY(i);
            if contains(rCompany.CURRENCY, sString) == true
                lFoundCurrency = true;
            end
        end
        if lFoundCurrency ~= true
            lReturn = true;  
        end
    end
    
    % screening 7 --> GGISN code (needs iteration, since some have 2
    % values
    if lReturn ~=true
        dLengthGGISN = length(rStringFiltersStatic.(sCountry).GGISN);
        lFoundGGISN = false;
        for i=1:dLengthGGISN
            sString = rStringFiltersStatic.(sCountry).GGISN(i);
            if contains(rCompany.ISIN_ISSUER_CTRY, sString) == true
                lFoundGGISN = true;
            end
        end
        if lFoundGGISN ~= true
            lReturn = true;  
        end
    end
    
    % check screening 8 --> names with non-common stock affiliations
    if lReturn ~=true
        vKeywordsToFilter = rStringFiltersStatic.GenericKeywords;    
        if class(rStringFiltersStatic.(sCountry).COUNTRY_SPECIFIC_FILTER) == "string"
            vKeywordsToFilter = [vKeywordsToFilter, rStringFiltersStatic.(sCountry).COUNTRY_SPECIFIC_FILTER];
        end
        % iterate over all keywords
        for p=1:numel(vKeywordsToFilter)
            sCurrentKeyword = append(' ', vKeywordsToFilter(p));
            if contains(rCompany.NAME, append(sCurrentKeyword, ' ')) == true | contains(rCompany.NAME, append(sCurrentKeyword, '.')) == true | endsWith(rCompany.NAME, sCurrentKeyword) == true 
                lReturn = true;
                break;
            elseif contains(rCompany.FULL_NAME, append(sCurrentKeyword, ' ')) == true | contains(rCompany.FULL_NAME, append(sCurrentKeyword, '.')) == true | endsWith(rCompany.FULL_NAME, sCurrentKeyword) == true
                lReturn = true;
                break;
            elseif contains(rCompany.COMPANY_NAME, append(sCurrentKeyword, ' ')) == true | contains(rCompany.COMPANY_NAME, append(sCurrentKeyword, '.')) == true | endsWith(rCompany.COMPANY_NAME, sCurrentKeyword) == true 
                lReturn = true;
                break;
            end
        end
    end
    
    
    % now filter if values are missing (caption of table 1)
    % citation Ball 2016: sample consists of firms with non-missing market value of equity (COMMON EQUITY), 
    % book-to-market (Book equity/market equity --> seen as Common Equity+Deferred Taxes/ MV) 
    % gross profit (Sales-COGS/Total Assets), book value of total assets (Total Assets),
    % current month returns and returns for the prior one-year (calc. via TRI)
    
    % since TRI data was loaded seperately, it could occur that no TRI data
    % was received for a company --> remove
    if isfield(rCompany, 'TRI') == true
        if length(rCompany.MARKET_VALUE) == 1 | length(rCompany.UNADJUSTED_PRICE) == 1 | length(rCompany.SALES) == 1  
            lReturn = true;
        elseif length(rCompany.TOTAL_ASSETS) == 1 | length(rCompany.COMMON_EQUITY) == 1 
            lReturn = true;
        elseif length(rCompany.COGS) == 1 | length(rCompany.DEFERRED_TAXES) == 1 | length(rCompany.TRI) == 1
           lReturn = true;
        end
    else
        lReturn = true;
    end 
end