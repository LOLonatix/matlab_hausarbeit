clear; clc;
% first of all, load the raw data from datastream excel sheets and save
% each countries data as a .mat file under "folder_ImportedData"
% --> runtime optimization, since Excel-Imports are quite slow
% .mat contains a variable named "rCountryStructure" with country data

% the other two functions in the latter part have to be "optimized"
% (for example, even substructs starts with rÜpselGrüpsel
% one last check whether it is working with more then 1 part is necessary

fLoadRawData();

% the next step is to filter the data for each country
fFilterData();