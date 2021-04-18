function [sName] = fOrthography(sName)
%% ORTHOGRAPHY
% Function corrects the all-upper-case-without-spaces country names to
% their correct spelling.
%% REQUIRES
% character array containing the name of the country
%% RETURNS
% name of the country with the correct spelling as a string
%% FUNCTION
% If-clause checking for the four countries that consist of two names,
% otherwise simply changing letters, except the first, in lower case.
% hard-coding for countries with combined names to change their name to the
% correct string
if isequal(sName, 'GREAT_BRITAIN')
    sName = "Great Britain";
elseif isequal(sName, 'HONGKONG')
    sName = "Hong Kong";
elseif isequal(sName, 'NEW_ZEALAND')
    sName = "New Zealand";
elseif isequal(sName, 'SOUTH_AFRICA')
    sName = "South Africa";
else
    sName(2:end) = lower(sName(2:end));
    % turning sName character into string
    sName = string(sName);
end
end

