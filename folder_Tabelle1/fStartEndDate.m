function [sStartDate,sEndDate]=fStartEndDate(vFirms,tDates)
%% START AND END DATE
% Start and end date of data availability are determined as first and
% last date with non-zero active firms in the market values.
%% REQUIRES
% - Vector with the amount of active firms in the 312 recorded months
% - Table with the exact dates of each data point/TS item/month
%% RETURNS
% - character array with the start date
% - character array with the end date
%% FUNCTION
% setting the date format as in the paper
sDateFormat = 'yyyy-mm-dd';
% finding the positions of the active firms within the "time series of
% active firms"
if sum(vFirms) ~= 0
    vActive=find(vFirms);
% defining the the position of the first active firm as start date

dStartDate=vActive(1);
% extracting start date from the date table at the position of the start date
dtStart=tDates{dStartDate,1};
% converting the start date into a string with the correct format
sStartDate=datestr(dtStart,sDateFormat);
%measuring the length of the "active firms vector" to be able to adress the
%last value of the vector
dEnd=length(vActive);
% defining the the position of the last active firm as end date
dEndDate=vActive(dEnd);
% extracting end date from the date table at the position of the end date
dtEnd=tDates{dEndDate,(1)};
% converting the end date into a string with the correct format
sEndDate=datestr(dtEnd,sDateFormat);
else
    sStartDate = "not available"
    sEndDate = "not available"
end