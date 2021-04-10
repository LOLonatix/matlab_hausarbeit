function rReturnCompany = fDynamicScreening(rCompany)
    % for clarity purpose, get the Return, the MV and UP for given company
    vReturns = rCompany.RETURN;
    vMV = rCompany.MARKET_VALUE;
    vUP = rCompany.UNADJUSTED_PRICE;
    
    % iterate backwards to use dynamic filter 1
    dLength = length(vMV)-1;
    dCounter = 1;
    for i=1:dLength
        % filter 1
        if vReturns(end-i) == 0 && dCounter == i
            dCounter = dCounter + 1;
            vMV(end-i) = NaN;
            vReturns(end-i) = NaN;
        end
        % filter 2
        if vUP(end-i) > 1000000
            vMV(end-i) = NaN;
            vReturns(end-i) = NaN;
            vUP(end-i) = NaN;
        end
        % filter 3
        if vReturns(end-i) > 9.9
            vMV(end-i) = NaN;
            vReturns(end-i) = NaN;
        end
        % filter 4
        if vReturns(end-i) >= 3.0 | vReturns(end-i-1)>= 3.0
            if ((1+vReturns(end-i-1))*(1+vReturns(end-i))-1) <0.5
                vMV(end-i) = NaN;
                vReturns(end-i) = NaN;
            end
        end
    end
    % return the filtered company
    rCompany.RETURN = vReturns;
    rCompany.MARKET_VALUE = vMV;
    rCompany.UNADJUSTED_PRICE = vUP;
    rReturnCompany = rCompany;
end