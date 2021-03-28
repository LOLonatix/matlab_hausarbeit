function [mMVall] = fAllMV(dAmountCompanies,cAllCompanyKeys,rCountryStructure)
%ALL MARKET VALUES function adds all the market values of the firms of a
%country to one matrix
%   creating a matrix of ones with the size of the final matrix for all
%   firms - the rows are as many as the recorded months, the columns as
%   many as the firms in this country
mMVall=ones(312, dAmountCompanies);
%for-loop adding the market value of a firm to the complete matrix
for i=1:dAmountCompanies
    %reading market values from the struct of the firm
    vMV = rCountryStructure.(cAllCompanyKeys{i}).MARKET_VALUE;
    %adding market values to the matrix
    mMVall(:,i) = vMV(:);
end
end