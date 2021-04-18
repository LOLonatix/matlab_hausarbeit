function rReturnCountryStructure = fLoad12MonthsTA(sPath2Country,rCountryStructure)
    %% This struct will be filled for one country, and then added to the given rCountryStructure
    rFillingCountryStructure = struct;
    %% Create path to total asset data
    sPath2Assets = append(sPath2Country, '\', 'TOTAL_ASSETS');
    % find all parts/data in this folder
    rFilesInAssets = dir(sPath2Assets);
        
    %% Remove github folders
    lFilesToLoad = ~[rFilesInAssets.isdir];
    rFilesInAssets = extractfield(rFilesInAssets, 'name');
    rFilesInAssets = rFilesInAssets(lFilesToLoad);

    %% Iterate over each part
    dAmountParts = length(rFilesInAssets)/2;
    for i=1:dAmountParts
        %% Find static and "TA" parts
        sCurrentPartString = append('PART', int2str(i),'_');
        
        % find files only containing "PART_NAME"
        lCurrentPartFiles = contains(rFilesInAssets, sCurrentPartString);
        
        % create bools for static/ts parts
        lAllStaticParts = contains(rFilesInAssets,'STATIC');
        lAllTAParts = contains(rFilesInAssets,'TA_TS');

        % start the loading process with the static files for each part,
        % which is a bool-matrix
        lCurrentStaticFile = lCurrentPartFiles & lAllStaticParts;
        lCurrentTsFile =  lCurrentPartFiles & lAllTAParts;
        

        % find loading path via previous bool-matrix
        sLoadStringStatic = append(sPath2Assets, '\', cell2mat(rFilesInAssets(lCurrentStaticFile)));
        sLoadStringTs = append(sPath2Assets, '\', cell2mat(rFilesInAssets(lCurrentTsFile)));
        
        %% Load both parts
        [~,~,cTextStatic]=xlsread(sLoadStringStatic);
        [cNumTS,~,cTextTS]=xlsread(sLoadStringTs);
       
        %% Start with static part, delete empty rows at the end, if any
        lFoundNonEmptyRow = false;
            while lFoundNonEmptyRow == false
                dFirstVal = cell2mat(cTextStatic(end,1));
                dSecondVal = cell2mat(cTextStatic(end,2));
                dThirdVal = cell2mat(cTextStatic(end,3));
                if isa(dFirstVal, 'double') == true && isa(dSecondVal, 'double') == true && ...
                        isa(dThirdVal, 'double') == true && isnan(dFirstVal) == true && ...
                        isnan(dSecondVal) == true && isnan(dThirdVal) == true 
                       
                    cTextStatic(end,:) = [];      
                else
                    lFoundNonEmptyRow = true;
                end
            end
    
        %% Now get TA data for each companie in static, and save it in a single struct for this country
        dAmountCompaniesStatic = size(cTextStatic);
        dAmountCompaniesTs = size(cNumTS);
        dAmountCompaniesTs = dAmountCompaniesTs(2);
      
        for p=2:dAmountCompaniesStatic(1)
            % use same function for creating struct.key string
            cCurrentRow = cTextStatic(p,:);
            sFieldToUse = cell2mat(cCurrentRow(2));
           
            % otherwise use the datastream-code
            if isa(sFieldToUse, 'char') == true | isa(sFieldToUse, 'string') == true
                    if matches(sFieldToUse, 'NA') == true |...
                       matches(sFieldToUse, '#N/A')== true | matches(sFieldToUse, '#NA')== true
                        
                        sFieldToUse = cell2mat(cCurrentRow(1));
                    end    
            elseif isa(sFieldToUse, 'double') == true && isnan(sFieldToUse) == true
                sFieldToUse = cell2mat(cCurrentRow(1));
            end

            % make it to an usable string, use the same function as in
            % fLoadRawData
            sCompanyString = fStringToStructKey(sFieldToUse);
            
            %% Get TA data, and add it to rFillingCountryStructure as .(sCompanyString)
            if p <= dAmountCompaniesTs
                vTAData = cTextTS(2:13,p);
                vTAData(cellfun(@ischar, vTAData)) = {nan};
                vTAData = cell2mat(vTAData);
            else
                vTAData = nan(12,1);
            end
            rFillingCountryStructure.(sCompanyString) = vTAData;
        end
    end
    %% after each part was loaded, compare the rFillingCountryStructure with the input rCountryStructure
    % iterate over all companies in input struct
    cCompaniesInInputStruct = fieldnames(rCountryStructure);
    for i=1:length(cCompaniesInInputStruct)
        sCurrentCompany = cell2mat(cCompaniesInInputStruct(i));
        % if TA data was found in given TA data, get it
        if isfield(rFillingCountryStructure, sCurrentCompany) == true
            vTA2Append = rFillingCountryStructure.(sCurrentCompany);
        else
            vTA2Append = nan(12,1);
        end
        % get old TA data to be appended
        vOldTA = rCountryStructure.(sCurrentCompany).TOTAL_ASSETS;
        % if it is not only nan, append it at the beginning and save it in
        % rCountryStructure
        if length(vOldTA) > 1
            vNewTA = [vTA2Append; vOldTA];
            rCountryStructure.(sCurrentCompany).TOTAL_ASSETS = vNewTA;
        end
    end
    %% finally, return the new rCountryStructure
    rReturnCountryStructure = rCountryStructure;
end