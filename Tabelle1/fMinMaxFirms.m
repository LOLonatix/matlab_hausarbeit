function[dMinFirms,dMaxFirms,vFirms]=fMinMaxFirms(mMVall)
%counts the firms (defined as existing market values) per month (recorded date)
%the minimum and the maximum of firms existing at a time are measured for
%the table - therefore, the NANs have to be turned into zeros (required for
%function 'find')
%also, a list of active firms in each month is returned to measure the start
%and end date (first/last month unequal to zero)
%requires: matrix with all market value data of each company of a country
%returns: minimal and maximal amount of firms active in a country and list
%of active companies

    %turning NANs of mMVall into zeros
    mMVall(isnan(mMVall))=0;
    %finding nonzero elements and replacing by 1
    vActiveCompany = find(mMVall);
    mMVall(vActiveCompany)=1;
    %adding the ones in each row, thus counting the active firms
    vFirms=sum(mMVall,2);
    %determining the minimal and maximal value (amount of firms)
    dMinFirms=min(vFirms);
    dMaxFirms=max(vFirms);
end

