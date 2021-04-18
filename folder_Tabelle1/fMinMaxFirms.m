function[dMinFirms,dMaxFirms,vFirms]=fMinMaxFirms(mMVall)
%% MINIMAL AND MAXIMAL AMOUNT OF FIRMS
% Counts the firms (defined as existing market values) per month (recorded
% date). The minimum and the maximum of firms existing at a time are
% measured for the table. Therefore, the NANs have to be turned into zeros
%(required for function 'find')
% Also, a list of active firms in each month is returned to measure the
% start and end date (first/last month unequal to zero)
%% REQUIRES
% matrix with all market value data of each company of a country
%% RETURNS
% - minimal amount of firms active in a country
% - maximal amount of firms active in a country
% - vector with the active companies per month
%% FUNCTION
% turning NANs of mMVall into zeros
mMVall(isnan(mMVall)) = 0;
% finding nonzero elements and replacing by 1
vActiveCompany = find(mMVall);
mMVall(vActiveCompany)=1;
% adding the ones in each row, thus counting the active firms per month
vFirms = sum(mMVall,2);
% determining the minimal and maximal value (amount of firms)
dMinFirms=min(vFirms(vFirms >= 25));
dMaxFirms=max(vFirms);
end

