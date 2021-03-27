function [dMinFirms,dMaxFirms] = fMinMaxFirms(dAmountCompanies,cAllCompanyKeys,rCountryStructure)
%MIN & MAX FIRMS function adds all the market values of the firms of a
%country to one matrix and counts the firms (defined as existing market values) per month (recorded date) - the
%minimum and the maximum of firms existing at a time are measured
%   creating a matrix of ones with the size of the final matrix for all
%   firms - the rows are as many as the recorded months, the columns as
%   many as the firms in this country
mMVall=ones(312, dAmountCompanies)
%for-loop adding the market value of a firm to the complete matrix
for i=1:dAmountCompanies
    %reading market values from the struc of the firm
    vMV = rCountryStructure.(cAllCompanyKeys{i}).MARKET_VALUE;
    %adding market values to the matrix
    mMVall(:,i) = vMV(:);
    %turning NANs into zeros
    mMVall(isnan(mMVall))=0;
    %finding nonzero elements and replacing by 1
    vActiveCompany = find(mMVall);
    mMVall(vActiveCompany)=1;
    %adding the ones in each row, thus counting the active firms
    vFirms=sum(mMVall,2);
    %determining the minimal and maximal value
    dMinFirms=min(vFirms);
    dMaxFirms=max(vFirms);
end
end

