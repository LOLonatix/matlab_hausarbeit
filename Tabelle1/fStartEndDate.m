function [sStartDate,sEndDate]=fStartEndDate(vFirms,tDates)
sDateFormat = 'yyyy-mm-dd';
vActive=find(vFirms);
dStartDate=vActive(1);
dtStart=tDates{dStartDate,(1)};
sStartDate=datestr(dtStart,sDateFormat);
dEnd=length(vActive);
dEndDate=vActive(dEnd);
dtEnd=tDates{dEndDate,(1)};
sEndDate=datestr(dtEnd,sDateFormat);
end