function rReturnCountryStructure = fLoadCountryStructure(sPath2Data, sCountryName)
    %% the return value waiting to be filled
    rReturnCountryStructure = struct;
    %% find all splitted subfiles in country folder
    sPath2Data = append(pwd, '\', sPath2Data, '\', sCountryName, '\');
    rFiles = dir(sPath2Data);

    % get all the names frum struct_array and remove the first two, if they
    % were created by github "." and ".."
    cCountryNames = extractfield(rFiles, 'name');
    if cell2mat(cCountryNames(1)) == '.'
        cCountryNames = cCountryNames(3:end);
    end 
   
    % get amount all folder/countrie_names
    dParts = length(cCountryNames);
    
    %% iterate over each part, load it, and add its content to the return value
    for i=1:dParts
        sCompletePath2Data = append(sPath2Data, sCountryName, '_PART', int2str(i));
        load(sCompletePath2Data, 'rCountryStructure');
        cCompanies = fieldnames(rCountryStructure);
        dAmount = length(cCompanies);
        for p=1:dAmount
            sCurrentCompany = cell2mat(cCompanies(p));
            rReturnCountryStructure.(sCurrentCompany) = rCountryStructure.(sCurrentCompany);
        end
    end
    %% function returns the rReturnCountryStructure, being filled after looping
end