function rReturnCompany = fDynamicDataAvailabilityFilter(rCompany)
    %% First of all, get all values necessary for filters explained on page 10
    vLaggedMV = rCompany.MARKET_VALUE(2:end);

    if vLaggedMV(1) > 0
        vLaggedMV = [1; vLaggedMV];
    else
        vLaggedMV = [NaN; vLaggedMV];
    end
    
    vBook2Market = (rCompany.COMMON_EQUITY+rCompany.DEFERRED_TAXES)./rCompany.MARKET_VALUE;
    rCompany.BOOK_TO_MARKET = vBook2Market;
    
    vTotalAssets = rCompany.TOTAL_ASSETS(13:end);
    vLaggedTotalAssets = rCompany.TOTAL_ASSETS(1:end-12);
    
    %% Now transform them into their logical value for > 0
    lLaggedMV = vLaggedMV>0;
    lBook2Market = vBook2Market>0;
    lTotalAssets = vTotalAssets>0;
    lLaggedTotalAssets = vLaggedTotalAssets>0;
    
    %% Create complete logical vector, only if each logical is true
    lLogicalFilter = lLaggedMV & lBook2Market & lTotalAssets & lLaggedTotalAssets;
    
    %% Apply this vector on all TS-Items of company
    cAllFields = fieldnames(rCompany);
    for i=17:length(cAllFields)
        sFieldName = cell2mat(cAllFields(i));
        vField = rCompany.(sFieldName);
        if length(vField) == 312
            vField(~lLogicalFilter) = NaN;
        else
            lFilter2Use = [zeros(12,1); lLogicalFilter];
            vField(~lFilter2Use) = NaN;
        end
        rCompany.(sFieldName) = vField;
    end
    
    %% Return the filtered company to the function fDynamicScreening, iterating over each company
    rReturnCompany = rCompany;
end