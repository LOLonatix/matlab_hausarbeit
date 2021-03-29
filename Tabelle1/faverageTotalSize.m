function [dAverageTotalSize] = fAverageTotalSize(currentCountryStructure)
%% AVERAGE TOTAL SIZE
% Calculating the average total size of a country using the market value.
% All market values of a country are added to a total size and the mean of
% all firms of a country is calculated.
%% REQUIRES
% struct with the full data of the current country
%% RETURNS
% double with the average total size of the country
%% FUNCTION
% determining the country firm names
fns = fieldnames(currentCountryStructure);
% for loop iterating through each firm
for i = 1:numel(currentCountryStructure)
% creating an empty cell array
   marketvalues = {};
% adding the market values to the cell array
   marketvalues = [marketvalues; currentCountryStructure.(fns{i}).MARKET_VALUE];   
end
% convert cell array into matrix, calculating means while omitting NANs and
% rounding result to a whole number
dAverageTotalSize = round(mean(cell2mat(marketvalues),'omitnan'));
end

