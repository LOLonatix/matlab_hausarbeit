function returnCountryStructure = fFilter25Companies(rCountryStructure)
    
    % get all companies
    cAllCompanies = fieldnames(rCountryStructure);
    cCompaniesToRemove = {};
    vActiveCompanies = zeros(312,1);
    for i=1: length(cAllCompanies)
        vMarketValue = rCountryStructure.(cell2mat(cAllCompanies(i))).MARKET_VALUE;
        % should not be necessary because of the previous filters, but
        % better be safe then sorry
        if length(vMarketValue) > 1
            lActiveCompany = ~isnan(vMarketValue);
            vActiveCompanies = vActiveCompanies+lActiveCompany;
        end
    end
    % create logical matrix for more then 25 companies active at given time
    lActiveCompanies = vActiveCompanies >= 25;
    
    % use this matrix on all values for each company
    for i=1: length(cAllCompanies)
        % take all companies
        rCurrentCompany = rCountryStructure.(cell2mat(cAllCompanies(i)));
        cItemsCompany = fieldnames(rCurrentCompany);
        dLength = length(cItemsCompany);
        for p=17:dLength
            % get current field
            vCurrentField = rCountryStructure.(cell2mat(cAllCompanies(i))).(cell2mat(cItemsCompany(p)));
            % if it is not nan
            if length(vCurrentField) > 1
                % if field is not tri or return
                if p < dLength-2
                    % use lActive on the item-vector
                    vCurrentField(~lActiveCompanies) = NaN;
               
                    % it it only contains NaNs afterwards, delete it (set to NaN), otherwise
                    % append it normally
                    if sum(~isnan(vCurrentField)) > 1
                        rCountryStructure.(cell2mat(cAllCompanies(i))).(cell2mat(cItemsCompany(p))) = vCurrentField;
                    else
                        rCountryStructure.(cell2mat(cAllCompanies(i))).(cell2mat(cItemsCompany(p))) = NaN;
                    end
                % if field is tri or return  
                else
                    % append logical, to shift it to one year prior
                    lActiveCompaniesAppended = lActiveCompanies;
                    lActiveCompaniesAppended(end+1:end+12) = zeros(12,1);
                    % do the same thing as previously
                    vCurrentField(~lActiveCompaniesAppended) = NaN;
                    if sum(~isnan(vCurrentField)) > 1
                        rCountryStructure.(cell2mat(cAllCompanies(i))).(cell2mat(cItemsCompany(p))) = vCurrentField;
                    else
                        rCountryStructure.(cell2mat(cAllCompanies(i))).(cell2mat(cItemsCompany(p))) = NaN;
                    end
                end
            end
        end
        
        % run static filter to remove companies with not sufficient data 
        lReturn = fCheckDataAvailability(rCurrentCompany);
        
        % if not given, add this company to companies to be removed
        if lReturn == true
            cCompaniesToRemove(end+1) = cAllCompanies(i);
        end
    end
    
    % remove those companies
    for t=1:length(cCompaniesToRemove)
       rCountryStructure = rmfield(rCountryStructure, cell2mat(cCompaniesToRemove(t)));
    end
    
    returnCountryStructure = rCountryStructure;
end
