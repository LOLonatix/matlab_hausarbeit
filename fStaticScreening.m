function lReturn = fStaticScreening(rCompany, sCountry, rStringFiltersStatic)
    sCountry = sCountry(1:end-4);
    
    % set to false by function (is first filter), or to true if already
    % filtered out
    lReturn = fCheckDataAvailability(rCompany);
    
    sMajor = string(rCompany.MAJOR_FLAG);
    sType = string(rCompany.STOCK_TYPE);
    sQuote = string(rCompany.QUOTE_INDICATOR);
    sSIC = string(rCompany.SIC_CODE_);
    dSIC = str2num(sSIC);
    
    % remove financial firms via SIC-CODE between 6000-7000
    if size(dSIC) == 0
        lReturn = true;
        
    elseif dSIC >= 6000 && dSIC <= 7000
         lReturn = true;
         
    % check screening 1-3 --> major, equity and primary
    elseif sMajor ~= 'Y' || sType ~= 'EQ' || sQuote ~= 'P'
        lReturn = true;
    else
        
    % check screening 4, 5--> country code
        bGEOGRAPHIC_DESCR = contains(rStringFiltersStatic.(sCountry).GEOGN, rCompany.GEOGRAPHIC_DESCR);
        bGEOG_DESC_OF_LSTNG = contains(rStringFiltersStatic.(sCountry).GEOLN, rCompany.GEOG_DESC_OF_LSTNG);
        if bGEOGRAPHIC_DESCR == false || bGEOG_DESC_OF_LSTNG == false % boolean (b) oder logical (l) für Datentyp?
            lReturn = true;
        end
    end
    
    % check screening 6 --> currency
    cCurrency = rStringFiltersStatic.(sCountry).CURRENCY;
    sCurrency = string(rCompany.CURRENCY);
    if ismember(sCurrency,cCurrency) == false
        lReturn = true;
    end
    
    % screening 7 --> GGISN code
    cGGISN = rStringFiltersStatic.(sCountry).GGISN;
    sGGISN = string(rCompany.ISIN_ISSUER_CTRY);
    if ismember(sGGISN,cGGISN) == false
        lReturn = true;
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
end