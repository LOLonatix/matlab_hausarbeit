%% Main script, starting all other scripts and functions, add folder_MainFiles
clear; clc;
addpath(genpath('folder_MainFiles'));

%% First of all, load all raw data from excel files
% It takes the excel files from folder 'folder_RawData' and saves them as a
% .mat-file under 'folder_ImportedData'. Since the excel read takes quite
% long, we handed the imported data in, too. The script is calling other
% functions being saved in 'folder_FunctionsLoadingRawData'.
b_LoadRawData;

%% The next step is to filter all the data 
% It loads the .mat files from 'folder_ImportedData' and filters each
% countries data separatedly by using functions from
% 'folder_FunctionsFilteringData'. Afterwards, it saves them in
% 'folder_FilteredData'.
b_FilterData;

%% Afterwards the function fCreateTable1 reproduces table 1 from the given paper
% Likewise, more functions from 'folder_Tabelle1' are used. The table is
% saved as a xlsx.
tTable1 = fCreateTable1();
writetable(tTable1, 'Tabelle1.xlsx');


%% The second table is created like the first one..
% Likewise, more functions from 'folder_Tabelle2' are used. The table is
% saved as a xlsx.
<<<<<<< HEAD
%tTable2 = fCreateTable2();
%writetable(tTable2, 'Tabelle2.xlsx');
=======
tTable2 = fCreateTable2();
writetable(tTable2, 'Tabelle2.xlsx');
>>>>>>> 21cca03f386a835da69dbd51dead3b7b507ea04f


%% Finally, a regression is created by the function fCreateRegression
[tTable_Regression1, tTable_Regression2, tTable_Regression3] = fCreateRegression();
