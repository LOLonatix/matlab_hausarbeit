function [vTotalNumberFirms] = fCountTotalFirms(currentCountryStructure)
fields = fieldnames(currentCountryStructure);
vTotalNumberFirms = numel(fields);
end

 