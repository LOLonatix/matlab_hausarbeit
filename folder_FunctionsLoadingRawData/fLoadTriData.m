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
     
        % calculate the amount of companies
        dAmountCompaniesStatic = size(cTextStatic);
        %dAmountCompaniesStatic = dAmountCompaniesStatic(1);
        
        % delete last rows if totally empty
        counter = 0;
        for p=1:dAmountCompaniesStatic(1)
            lOnlyFoundNaN = true;
            cLastRow = cTextStatic(end-p,:);
            for c=1:dAmountCompaniesStatic(2)
                value = cell2mat(cLastRow(c));
                if isnan(value) == false
                    lOnlyFoundNaN = false;
                    break;
                end
            end
            if lOnlyFoundNaN == true
                counter = counter +1;
            else
                break;
            end
        end
        while counter > 0
            cTextStatic(end) = [];
            counter = counter - 1;
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