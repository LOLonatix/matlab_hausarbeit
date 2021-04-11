function [mMVall] = fAllMV(dAmountCompanies,cAllCompanyKeys,rCountryStructure)
%% ALL MARKET VALUES
% Function adds all the market values of the firms of a country to one
% matrix.
%% REQUIRES
% - amount of firms in this country as double
% - keys of each firm in a cell array
% - struct of the current country containing all data
%% RETURNS
% matrix containing all market value data of each firms of the country
%% FUNCTION
% Creating a matrix of ones with the size of the final matrix for all
% firms. The rows are as many as the recorded months (312), the columns as
% many as the firms in this country.
mMVall=ones(312, dAmountCompanies);
% for-loop adding the market value of a firm to the complete matrix
for i=1:dAmountCompanies
    % reading market values from the struct of the firm
    vMV = rCountryStructure.(cAllCompanyKeys{i}).MARKET_VALUE;
    % adding market values to the matrix
    %if length(vMV) == 312
    mMVall(:,i) = vMV(:);
end
end