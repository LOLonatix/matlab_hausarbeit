function rStringFiltersStatic = fCreateFilterStrings(vCountryNames)
    rStringFiltersStatic = struct;
    rID = ISINCurrencyStruct(); % as the ISIN and the currency are written in cell array, use the function 'ismember' to see if the item corresponds

    dAmountCountries = length(vCountryNames);
    for i=1:dAmountCountries
        sCountryName = vCountryNames(i);
        rStringFiltersStatic.sCountryName.GGISN = rID.sCountryName.ISIN;
        rStringFiltersStatic.sCountryName.CURRENCY = rID.sCountryName.CURRENCY;
        rStringFiltersStatic.sCountryName.GEOGN = rID.sCountryName.GEOGN;
        rStringFiltersStatic.sCountryName.GEOLN = rID.sCountryName.GEOLN;
        rStringFiltersStatic.sCountryName.COUNTRY_SPECIFIC_FILTER = NaN;
    end
    % BLOCK MAY BE USELESS DUE TO rID
    % add further values with more then one currency/GGISN 
    % lAllRawData = false;
    % if lAllRawData == true
    % currencies for european countries other then euro are still missing
    % --> still needed? As everything is added in the ISINCurrency-function
    % rStringFiltersStatic.HONG_KONG.GGISN = [rStringFiltersStatic.HONG_KONG.GGISN, "BM", "KY"];
    % rStringFiltersStatic.CZECH.GGISN = [rStringFiltersStatic.CZECH.GGISN, "CS"];
    % rStringFiltersStatic.RUSSIA.CURRENCY = [rStringFiltersStatic.RUSSIA.CURRENCY, "USD"];
    % end
    
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