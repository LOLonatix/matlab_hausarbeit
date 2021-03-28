function [dMeanSize,dMedianSize] = fMeanMedSize(mMVall)
%AVERAGE FIRM SIZE mean and median monthly average size of firms of a
%country as per market value
%requires: matrix with all market value data of each company of a country
%returns: mean and median size of firms

    %mean of market value of all firms per month
    vMonthlyMean=mean(mMVall,2,'omitnan');
    %median of market value of all firms per month
    vMonthlyMedian=median(mMVall,2,'omitnan');
    %mean of mean market value of all firms per month
    dMeanSize=round(mean(vMonthlyMean));
    %mean of median market value of all firms per month
    dMedianSize=round(mean(vMonthlyMedian));
end

