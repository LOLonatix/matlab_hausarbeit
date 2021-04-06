function [dAverageTotalSize] = fAverageTotalSize(mMVall)
%% AVERAGE TOTAL SIZE
% Calculating the average total size of a country using the market value.
% All market values of the firms of a country per month are added to a
% total size and the mean is calculated.
%% REQUIRES
% struct with the full data of the current country
%% RETURNS
% double with the average total size of the country
%% FUNCTION
% turning NANs of mMVall into zeros
mMVall(isnan(mMVall))=0;
% adding the market value of each firm to the countries total market value
% per month
vTotalMV = sum(mMVall,2);
% calculating the mean of the total market values and rounding to a full
% number
dAverageTotalSize = round(mean(vTotalMV));
end

