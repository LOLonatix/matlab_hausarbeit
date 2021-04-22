function fSaveCountryStructure(sPath2Save, sCountryName, rInputCountryStructure)
%% this function was deemed unneccesary after finishing the project, but not switched
    %% generate path to country folder in sPath2Save
    sSavePath = append(pwd,'\', sPath2Save,'\', sCountryName);
    if isfolder(sSavePath) == false
        mkdir(sSavePath)
    end
    sSavePath = append(sSavePath, '\');
  
    %% split rCountryStructure in smaller sub-parts to not go over 2GB, by max. amount companies
    dMaxAmountCompanies = 10000;
    cCompanies = fieldnames(rInputCountryStructure);
    dAmountCompanies = length(cCompanies);
    dParts = floor(dAmountCompanies/dMaxAmountCompanies)+1;
    dLastIndex = 0;
    for i=1:dParts
        % create sub struct
        rCountryStructure = struct;
        % if this is the last part
        if dLastIndex+dMaxAmountCompanies >= dAmountCompanies
            for t=dLastIndex+1:dAmountCompanies
                sCurrentCompany = cell2mat(cCompanies(t));
                rCountryStructure.(sCurrentCompany) = rInputCountryStructure.(sCurrentCompany);
            end
        % otherwise load the next 10.000 companies
        else
            for t=dLastIndex+1:dLastIndex+dMaxAmountCompanies
                sCurrentCompany = cell2mat(cCompanies(t));
                rCountryStructure.(sCurrentCompany) = rInputCountryStructure.(sCurrentCompany);
            end
            % move the last index forward
            dLastIndex = dLastIndex+dMaxAmountCompanies;
        end
       %% for splits save them as a part in generated saving path  
       sCompleteSavePath = append(sSavePath, sCountryName, '_PART', int2str(i),'.mat');
       save(sCompleteSavePath, 'rCountryStructure');
    end
end