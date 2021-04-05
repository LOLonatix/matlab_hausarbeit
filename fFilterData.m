function fFilterData()
    clear; clc;
    
    % missing: dynamic filtering, eu currencies
    
    rStringFiltersStatic = fCreateFilterStrings;
    
    % Get a list of all files and folders in this folder.
    sPath2ImportedData = append(pwd, '\', 'folder_ImportedData\');
    rFolders = dir(sPath2ImportedData);

    % get all the names frum struct_array and remove the first two, if they
    % were created by github "." and ".."
    cCountryNames = extractfield(rFolders, 'name');
    if cell2mat(cCountryNames(1)) == '.'
        cCountryNames = cCountryNames(3:end);
    end 
    
    lKeysLoaded = false;

    % get amount all folder/countrie_names
    dNumberCountries = length(cCountryNames);
    for i=1:dNumberCountries
        sCurrentCountryName = cell2mat(cCountryNames(i));
        sPath2Country = append(sPath2ImportedData, sCurrentCountryName);  
        load(sPath2Country, 'rCountryStructure')
      
        
        if lKeysLoaded ~= true
            load(sPath2Country, 'cListKeys');
            lKeysLoaded = true;
        end
        
        % get a list with all company-keys 
        % struct-array could have been advantageous, although this way
        % makes deleting substructs easier, since iterating over chaning
        % lenght can lead to out of bounds exceptions
        cAllCompanyKeys = fieldnames(rCountryStructure);
        dAmountCompanies = length(cAllCompanyKeys);
        
        %% Calculate new parameters
        % Take functions from table2 and use them to calculate the
        % variables that have to be filtered for table one.
        % They are added to the country struct as vector (double array)
        
        %% New function to check if parameters have missing values
        % NANs within the values after the begin and before the end of
        % data availability flag the firm for deleting
        
        %% New function checking whether all the data start at the same time
        % If the variables do not start and end at the same time, it has to
        % be assumed that there are missing values, therefore the company
        % is flagged for deleting - also the start and end date of data
        % availability are recorded for table1 (save in a separate struct
        % element)
        
        %% cells with company keys to be removed after the filtering process
        cCompanyKeysToBeRemoved = {};
        
        % iterate over companies
        for p=1:dAmountCompanies
            % get current key and the respective structure
            sCurrentCompanyKey = cell2mat(cAllCompanyKeys(p));
            rCurrentCompany = rCountryStructure.(sCurrentCompanyKey);
            
            % this function calls the real filtering-function
            bRemoveCompany = fStaticScreening(rCurrentCompany, sCurrentCountryName, rStringFiltersStatic);
           
            % if the company has to be removed, add it to the cell-list
            if bRemoveCompany == true
              cCompanyKeysToBeRemoved{end+1} = sCurrentCompanyKey;
            end     
        end
        
        % delete the companies via their key
        dAmountDeletableCompanies = length(cCompanyKeysToBeRemoved);
        for x=1:dAmountDeletableCompanies
            sCompanyKeyToRemove = cell2mat(cCompanyKeysToBeRemoved(x));
            rCountryStructure = rmfield(rCountryStructure, sCompanyKeyToRemove);   
        end
        
        % save the filtered Data under "folder_FilteredData"
        sSavePath = append(pwd, '\folder_FilteredData\', sCurrentCountryName);
        save(sSavePath, 'rCountryStructure', 'cListKeys');
    end
end

%% the real filter process is written as an extra function for more clarity in the code
% write functions into own file?
function bReturn = fStaticScreening(rCompany, sCountry, rStringFiltersStatic)
    sCountry = sCountry(1:end-4);
    % set to false, set to true to remove
    bReturn = false;
   
    % remove financial firms via SIC-CODE between 6000-7000
    if rCompany.SIC_CODE_ >=6000 && rCompany.SIC_CODE_ <=7000
         bReturn = true;
         
    % check screening 1-3 --> major, equity and primary
    elseif rCompany.MAJOR_FLAG ~= 'Y' | rCompany.STOCK_TYPE ~= 'EQ' | rCompany.QUOTE_INDICATOR ~= 'P'
        bReturn = true;
    else
        
    % check screening 4, 5--> country code
        bGEOGRAPHIC_DESCR = contains(sCountry, rCompany.GEOGRAPHIC_DESCR);
        bGEOG_DESC_OF_LSTNG = contains(sCountry, rCompany.GEOG_DESC_OF_LSTNG);
        if bGEOGRAPHIC_DESCR == false | bGEOG_DESC_OF_LSTNG == false
            bReturn = true;
        end
    end
    
    % check screening 6 --> currency (needs iteration, since some have 2
    % values
    if bReturn ~= true
        dLengthCurrency = length(rStringFiltersStatic.(sCountry).CURRENCY);
        lFoundCurrency = false;
        for i=1:dLengthCurrency
            sString = rStringFiltersStatic.(sCountry).CURRENCY(i);
            if contains(rCompany.CURRENCY, sString) == true
                lFoundCurrency = true;
            end
        end
        if lFoundCurrency ~= true
            bReturn = true;  
        end
    end
    
    % screening 7 --> GGISN code (needs iteration, since some have 2
    % values
    if bReturn ~=true
        dLengthGGISN = length(rStringFiltersStatic.(sCountry).GGISN);
        lFoundGGISN = false;
        for i=1:dLengthGGISN
            sString = rStringFiltersStatic.(sCountry).GGISN(i);
            if contains(rCompany.ISIN_ISSUER_CTRY, sString) == true
                lFoundGGISN = true;
            end
        end
        if lFoundGGISN ~= true
            bReturn = true;  
        end
    end
    
    % check screening 8 --> names with non-common stock affiliations
    if bReturn ~=true
        vKeywordsToFilter = rStringFiltersStatic.GenericKeywords;    
        if class(rStringFiltersStatic.(sCountry).COUNTRY_SPECIFIC_FILTER) == "string"
            vKeywordsToFilter = [vKeywordsToFilter, rStringFiltersStatic.(sCountry).COUNTRY_SPECIFIC_FILTER];
        end
        % iterate over all keywords
        for p=1:numel(vKeywordsToFilter)
            sCurrentKeyword = append(' ', vKeywordsToFilter(p));
            if contains(rCompany.NAME, append(sCurrentKeyword, ' ')) == true | contains(rCompany.NAME, append(sCurrentKeyword, '.')) == true | endsWith(rCompany.NAME, sCurrentKeyword) == true 
                bReturn = true;
                break;
            elseif contains(rCompany.FULL_NAME, append(sCurrentKeyword, ' ')) == true | contains(rCompany.FULL_NAME, append(sCurrentKeyword, '.')) == true | endsWith(rCompany.FULL_NAME, sCurrentKeyword) == true
                bReturn = true;
                break;
            elseif contains(rCompany.COMPANY_NAME, append(sCurrentKeyword, ' ')) == true | contains(rCompany.COMPANY_NAME, append(sCurrentKeyword, '.')) == true | endsWith(rCompany.COMPANY_NAME, sCurrentKeyword) == true 
                bReturn = true;
                break;
            end
        end
    end
end

function lReturn = fDynamicScreening(rCompany, sCountry)
end

function rStringFiltersStatic = fCreateFilterStrings()
    rStringFiltersStatic = struct;
    vCountryNames = ["ARGENTINA", "PHILIPPINES"];
    vCountryGGISN = ["AR", "PH"];
    vCountryCurrency = ["AP", "PP"];

    dAmountCountries = length(vCountryNames);
    for i=1:dAmountCountries
        rStringFiltersStatic.(vCountryNames(i)).GGISN = [vCountryGGISN(i)];
        rStringFiltersStatic.(vCountryNames(i)).CURRENCY = [vCountryCurrency(i)];
        rStringFiltersStatic.(vCountryNames(i)).COUNTRY_SPECIFIC_FILTER = NaN;
    end
    % add further values with more then one currency/GGISN 
    lAllRawData = false;
    if lAllRawData == true
    % currencies for european countries other then euro are still missing
    rStringFiltersStatic.HONG_KONG.GGISN = [rStringFiltersStatic.HONG_KONG.GGISN, "BM", "KY"];
    rStringFiltersStatic.CZECH.GGISN = [rStringFiltersStatic.CZECH.GGISN, "CS"];
    rStringFiltersStatic.RUSSIA.CURRENCY = [rStringFiltersStatic.RUSSIA.CURRENCY, "USD"];
    end
    
    % create a list with the generic keywords for filtering
    rStringFiltersStatic.GenericKeywords = ["1000DUPL", "DULP", "DUP", "DUPE", "DUPL", "DUPLI","DUPLICATE", "XSQ", "XETa", "ADR", "GDR", "PF", "’PF’", "PFD", "PREF", "PREFERRED", "PRF", "WARR", "WARRANT", "WARRANTS", "WARRT", "WT", "WTS","WTS2", "%", "DB", "DCB", "DEB", "DEBENTURE", "DEBENTURES", "DEBT", ".IT", ".ITb", "INV", "INV TST", "INVESTMENT TRUST","RLST IT", "TRUST", "TRUST UNIT", "TRUST UNITS", "TST","TST UNIT", "TST UNITS", "UNIT", "UNIT TRUST", "UNITS","UNT", "UNT TST", "UT", "AMUNDI", "ETF", "INAV", "ISHARES", "JUNGE", "LYXOR", "X-TR", "EXPD", "EXPIRED", "EXPIRY", "EXPY", "ADS", "BOND", "CAP.SHS", "CONV", "CV", "CVT", "DEFER","DEP", "DEPY", "ELKS", "FD", "FUND", "GW.FD", "HI.YIELD","HIGH INCOME", "IDX", "INC.&GROWTH", "INC.&GW","INDEX", "LP", "MIPS", "MITS", "MITT, MPS", "NIKKEI", "NOTE","OPCVM", "ORTF", "PARTNER", "PERQS", "PFC", "PFCL", "PINES", "PRTF", "PTNS", "PTSHP", "QUIBS", "QUIDS", "RATE", "RCPTS", "REAL EST", "RECEIPTS", "REIT", "RESPT", "RETUR", "RIGHTS", "RST", "RTN.INC", "RTS", "SBVTG", "SCORE", "SPDR", "STRYPES", "TOPRS", "UTS", "VCT", "VTG.SAS", "XXXXX", "YIELD", "YLD"];
    
    % add a list with country specific keywords for filtering
    rStringFiltersStatic.AUSTRALIA.COUNTRY_SPECIFIC_FILTER = ["PART PAID", "RTS DEF", "DEF SETT", "CDI"];
    rStringFiltersStatic.AUSTRIA.COUNTRY_SPECIFIC_FILTER = ["PC", "PARTICIPATION CERTIFICATE", "GENUSSSCHEINE", "GENUSSCHEINE"];
    rStringFiltersStatic.BELGIUM.COUNTRY_SPECIFIC_FILTER = ["VVPR", "CONVERSION", "STRIP"];
    rStringFiltersStatic.BRAZIL.COUNTRY_SPECIFIC_FILTER = ["PN", "PNA", "PNB", "PNC", "PND", "PNE", "PNF", "PNG","RCSA","RCTB"];
    rStringFiltersStatic.CANADA.COUNTRY_SPECIFIC_FILTER = ["EXCHANGEABLE", "SPLIT", "SPLITSHARE", "VTG\\.", "SBVTG\\.", "VOTING", "SUB VTG", "SERIES"];
    rStringFiltersStatic.DENMARK.COUNTRY_SPECIFIC_FILTER = ["\\)CSE\\)"];
    rStringFiltersStatic.FINLAND.COUNTRY_SPECIFIC_FILTER = ["USE"];
    rStringFiltersStatic.FRANCE.COUNTRY_SPECIFIC_FILTER = ["ADP", "CI", "SICAV", "\\)SICAV\\)", "SICAV-"];
    rStringFiltersStatic.GERMANY.COUNTRY_SPECIFIC_FILTER = ["GENUSSCHEINE"];
    rStringFiltersStatic.GREAT_BRITAIN.COUNTRY_SPECIFIC_FILTER = ["PAID", "CONVERSION TO", "NON VOTING","CONVERSION ’A’"];
    rStringFiltersStatic.GREECE.COUNTRY_SPECIFIC_FILTER = ["PR"];
    rStringFiltersStatic.INDIA.COUNTRY_SPECIFIC_FILTER = ["FB DEAD", "FOREIGN BOARD"];
    rStringFiltersStatic.ISRAEL.COUNTRY_SPECIFIC_FILTER = ["P1", "1", "5"];
    rStringFiltersStatic.ITALY.COUNTRY_SPECIFIC_FILTER = ["RNC", "RP", "PRIVILEGIES"];
    rStringFiltersStatic.KOREA.COUNTRY_SPECIFIC_FILTER = ["1P"];
    rStringFiltersStatic.MEXICO.COUNTRY_SPECIFIC_FILTER = ["CPO", "’L’", "’C’"];
    rStringFiltersStatic.MALAYSIA.COUNTRY_SPECIFIC_FILTER = ["’A’"];
    rStringFiltersStatic.NETHERLANDS.COUNTRY_SPECIFIC_FILTER = ["CERTIFICATE", "CERTIFICATES", "CERTIFICATES\\)", "CERT", "CERTS", "STK\\."];
    rStringFiltersStatic.NEW_ZEALAND.COUNTRY_SPECIFIC_FILTER = ["RTS", "RIGHTS"];
    rStringFiltersStatic.PERU.COUNTRY_SPECIFIC_FILTER = ["INVERSION", "INVN", "INV"];
    rStringFiltersStatic.PHILIPPINES.COUNTRY_SPECIFIC_FILTER = ["PDR"];
    rStringFiltersStatic.SOUTH_AFRICA.COUNTRY_SPECIFIC_FILTER = ["N’", "OPTS\\.", "CPF\\.", "CUMULATIVE PREFERENCE"];
    rStringFiltersStatic.SWEDEN.COUNTRY_SPECIFIC_FILTER = ["CONVERTED INTO", "USE", "CONVERTED-","CONVERTED - SEE"];
    rStringFiltersStatic.SWITZERLAND.COUNTRY_SPECIFIC_FILTER = ["CONVERTED INTO", "CONVERSION", "CONVERSION SEE"];
end