function[v1MLReturn] = f1MLReturn(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
c1MLReturn={};
for i =1:numel(cFieldNames)
   cReturn = currentCountryStructure.(cFieldNames{i}).RETURN;
   cReturn=[NaN;cReturn];%add a NaN cell to the beginning --> 1 month lagged MV  
   c1MLReturn=[c1MLReturn; cReturn];%add together MV of previous firms with current firm's   
end
[v1MLReturn] = fConclude(c1MLReturn);

end

