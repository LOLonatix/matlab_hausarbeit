function tExchange = fFilterExcelNumeric(tExchange)
%% FILTER EXCEL NON-NUMERIC COLUMNS
% Find non-numeric columns in table with Datastream data and turn them into
% numeric columns
%% REQUIRES
% Table with Excel data
%% RETURNS
% Table with Excel data, but all columns as numeric variables
%% FUNCTION
% Find non-numeric columns in table with Datastream data and calculate
% amount of non-numeric columns
lNumerics = varfun(@isnumeric,tExchangeRates,'output','uniform');
vNonnumerics = find(lNumerics < 1);
dLengthNonnumeric = length(vNonnumerics);

% Changing non-numeric columns in numeric columns
for i = 2:dLengthNonnumeric
    % Creating a temporary cell array with the data of the current
    % non-numeric column
    cTemp = tExchangeRates.(vNonnumerics(i));
    dLengthTemp = length(cTemp);
    % Iterate through each item of the temporary data
    for j = 1:dLengthTemp
        % If item is NaN (NA) write NaN
        if  string(cTemp{j}) == "NA";
            cTemp{j} = NaN;
        % Else turn the string with the number into a double
        else
            cTemp{j} = str2num(string(cTemp{j}));
        end
    end
    % Turn cell array into table
    tTemp = cell2table(cTemp);
    % Replace non-numeric columns of table with numeric column
    tExchangeRates.(vNonnumerics(i)) = tTemp.cTemp;
end
end