function rCountryStructure = fLoadTriData(sPath2Country, rCountryStructure)
    % create path to tri-folder
    sPathToTriData = append(sPath2Country, '\', 'TRI_DATA');
    % find all parts/data in this folder
    rFilesInTriFolder = dir(sPathToTriData);
        
    % now take only the true files, removing the github folders 
    lFilesToLoad = ~[rFilesInTriFolder.isdir];
    rFilesInTriFolder = extractfield(rFilesInTriFolder, 'name');
    rFilesInTriFolder = rFilesInTriFolder(lFilesToLoad);

    dAmountParts = length(rFilesInTriFolder)/2;
    for i=1:dAmountParts
        % load the static order of companies and their key
        % create string "PART_NAME"
        sCurrentPartString = append('PART', int2str(i),'_');
        
        % find files only containing "PART_NAME"
        lCurrentPartFiles = contains(rFilesInTriFolder, sCurrentPartString);
        
        % create bools for static/ts parts
        lAllStaticParts = contains(rFilesInTriFolder,'STATIC');
        lAllTsParts = contains(rFilesInTriFolder,'TS');

        % start the loading process with the static files for each part,
        % which is a bool-matrix
        lCurrentStaticFile = lCurrentPartFiles & lAllStaticParts;
        lCurrentTsFile =  lCurrentPartFiles & lAllTsParts;

        % find loading path via previous bool-matrix
   
        sLoadStringStatic = append(sPathToTriData, '\', cell2mat(rFilesInTriFolder(lCurrentStaticFile)));
        sLoadStringTs = append(sPathToTriData, '\', cell2mat(rFilesInTriFolder(lCurrentTsFile)));
        
        % load ts and static data
        [~,~,cTextStatic]=xlsread(sLoadStringStatic);
        [cNumTS,~,cTextTS]=xlsread(sLoadStringTs);
     
        % delete last rows if totally empty
        % check for empty rows at the end, happening for JAPAN_PART2
        % somehow an error in excel leads to this
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
        
        dAmountCompaniesStatic = size(cTextStatic);
       
        dAmountCompaniesTs = size(cNumTS);
        dAmountCompaniesTs = dAmountCompaniesTs(2);
    
        for p=2:dAmountCompaniesStatic(1)
            % use same function for creating struct.key string
            
            sKey1 = cell2mat(cTextStatic(p,1));
            sKey2 = cell2mat(cTextStatic(p,2));
            
            sKey1 = fStringToStructKey(sKey1);
           
            if ischar(sKey2) == true 
                if matches(sKey2, 'NA') == true | matches(sKey2, '#NA')== true
                    sKey2 = NaN;
                    lHelper = false;
                else
                    sKey2 = fStringToStructKey(sKey2);
                    lHelper = true;
                end
            else
                sKey2 = fStringToStructKey(sKey2);
                lHelper = true;
            end
            
            % check if last tri-data-sets were 'ERROR' message, otherwise
            % get tri-data
            if p <= dAmountCompaniesTs
                vTriData = cTextTS(2:325,p);
                vTriData(cellfun(@ischar, vTriData)) = {nan};
                vTriData = cell2mat(vTriData);

            else
                vTriData = NaN;
            end
           
            
            % save vTriData under tri key for sCompanyKey
            if isfield(rCountryStructure, sKey1) == true
                rCountryStructure.(sKey1).TRI = vTriData;
            elseif lHelper == true && isfield(rCountryStructure, sKey2) == true
                rCountryStructure.(sKey2).TRI = vTriData;
            end
        end
    end

end