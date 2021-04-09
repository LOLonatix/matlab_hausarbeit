function [dMeanSize,dMedianSize] = fMeanMedSize(mMVall)
%% AVERAGE FIRM SIZE
% Calculate the mean and median monthly average size of firms of a country
% as per market value. The NANs are omitted to get the correct mean values
% and not too low values.
%% REQUIRES
% matrix with all market value data of each company of a country
%% RETURNS
% - mean size of firms as double
% - median size of firms as double
%% FUNCTION
% mean of market value of all firms per month
vMonthlyMean = mean(mMVall,2,'omitnan');
% median of market value of all firms per month
vMonthlyMedian = median(mMVall,2,'omitnan');
% mean of mean market value of all firms per month
dMeanSize = round(mean(vMonthlyMean));
% mean of median market value of all firms per month
dMedianSize = round(mean(vMonthlyMedian));
end

