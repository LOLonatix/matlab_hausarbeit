%function ExchangeTRI = fExchangeTRI(vCountryNames)
clear; clc;
rID = fIDStruct();
rExchangeTRI = struct();

vCountryNames = {'ARGENTINA', 'AUSTRALIA', 'AUSTRIA', 'BELGIUM', 'BRAZIL', 'CANADA', 'CHILE',...
    'CHINA', 'COLOMBIA', 'CZECH', 'DENMARK', 'EGYPT', 'FINLAND', 'FRANCE', 'GERMANY',...
    'GREAT_BRITAIN', 'GREECE', 'HONGKONG', 'HUNGARY', 'INDIA', 'INDONESIA', 'IRELAND',...
    'ISRAEL', 'ITALY', 'JAPAN', 'JORDAN', 'KOREA', 'MALAYSIA', 'MOROCCO', 'NETHERLANDS',...
    'NEW_ZEALAND', 'NORWAY', 'PAKISTAN', 'PERU', 'PHILIPPINES', 'POLAND', 'PORTUGAL',...
    'RUSSIA', 'SINGAPORE', 'SOUTH_AFRICA', 'SPAIN', 'SWEDEN', 'SWITZERLAND', 'TAIWAN',...
    'THAILAND', 'TURKEY'};

dAmountCountries = length(vCountryNames);

%for i = 1:dAmountCountries
    %sCountryName = vCountryNames{i};
    sCountryName = 'BELGIUM';
    sFilename = [sCountryName, '_DOLLAR.xlsx'];
    opts = detectImportOptions(sFilename);
    opts.VariableNamesRange = 'A2';
    tExchangeTRI = readtable(sFilename, opts, 'ReadVariableNames', true);
    
    vTempNumerics = varfun(@isnumeric,tExchangeTRI,'output','uniform');
    vTempNonnumerics = find(vTempNumerics < 1);
    dLengthNonnumeric = length(vTempNonnumerics);

    for j = 2:dLengthNonnumeric
        cTemp = tExchangeTRI.(vTempNonnumerics(j));
        dLengthTemp = length(cTemp);
        for k = 1:dLengthTemp
            if  string(cTemp{k}) == "NA";
                cTemp{k} = NaN;
            else
                cTemp{k} = str2num(string(cTemp{k}));
            end
        end
        tTemp = cell2table(cTemp);
        tExchangeTRI.(vTempNonnumerics(j)) = tTemp.cTemp;
    end
    
    cColumnNames = tExchangeTRI.Properties.VariableNames;
   lEmptyColumns = contains(cColumnNames, 'Var');
   lEmptyColumns(1) = 1;
   tExchangeTRI = removevars(tExchangeTRI,lEmptyColumns);
   lUnallowedCurrency = [];
   
    for h = 1:2:width(tExchangeTRI)
        cColumnNames = tExchangeTRI.Properties.VariableNames;
        if h == 1
            sCurrency = cColumnNames{2};
        else
            sCurrency = extractBefore(cColumnNames{h+1},'_');
        end
        lAllowedCurrency = ismember(sCurrency, rID.(sCountryName).CURRENCY);
        if lAllowedCurrency == false
           lUnallowedCurrency = [lUnallowedCurrency h h+1];
        end
    end  
    
    tExchangeTRI = removevars(tExchangeTRI,lUnallowedCurrency);
    
    dAmountCurrencies = length(rID.(sCountryName).CURRENCY);
    for g = 1:2:width(tExchangeTRI)    
        if dAmountCurrencies == 1
            rExchangeTRI.(sCountryName).(rID.(sCountryName).CURRENCY{1}).(['Firm', num2str(g)]) = tExchangeTRI.(g+1)./tExchangeTRI.(g);
        else
            if g == 1
                sCurrency = tExchangeTRI.Properties.VariableNames{g+1};
            else
                sCurrency = extractBefore(tExchangeTRI.Properties.VariableNames{g+1},'_');
            end
            if sCurrency == rID.(sCountryName).CURRENCY{1}
                rExchangeTRI.(sCountryName).(rID.(sCountryName).CURRENCY{1}).(['Firm', num2str(g)]) = tExchangeTRI.(g+1)./tExchangeTRI.(g);
            else
                rExchangeTRI.(sCountryName).(rID.(sCountryName).CURRENCY{2}).(['Firm', num2str(g)]) = tExchangeTRI.(g+1)./tExchangeTRI.(g);
            end
        end
    end
        
      
      
      
      