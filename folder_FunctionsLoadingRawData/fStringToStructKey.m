function sOutputString = fStringToStructKey(sInputString)
    
    if isstring(sInputString) ~= true
        sInputString = string(sInputString);
    end
    
    % starting with digit?
    digit_bools = isstrprop(sInputString,'digit');
    if length(digit_bools) > 1
        if digit_bools(1) == 1
        sInputString = strcat('rNumber_', sInputString);
        end
    end
    % replace ':' and '.' with '_'
    sInputString = regexprep(sInputString, ':', '_');
    sInputString = strrep(sInputString, '.', '');
    sInputString = strrep(sInputString, ';', '_');
    % replace '@' with 'at_'
    sInputString = regexprep(sInputString, '[@]', 'at_');
    % this one removes underscores from the beginning
    sInputString = regexprep(sInputString,'^_','','emptymatch');
    
    sInputString = regexprep(sInputString, ' +', '_');
    sInputString = regexprep(sInputString, '&+', '');
    sInputString = regexprep(sInputString, '[/]','');
    sInputString = regexprep(sInputString, '[£]','');
    sInputString = regexprep(sInputString, '[:]','');
    sInputString = regexprep(sInputString, '[(]','');
    sInputString = regexprep(sInputString, '[)]','');
    sInputString = regexprep(sInputString, '['']','');
    sInputString = regexprep(sInputString, '[-]','');
    sInputString = regexprep(sInputString, '[@]', '');
    sInputString = regexprep(sInputString, '[+]', '');
    sInputString = regexprep(sInputString, '[$]', '');
    sInputString = regexprep(sInputString, '[,]', '');
    sInputString = regexprep(sInputString, '[%]', '');
    sInputString = regexprep(sInputString, '[#]', ''); 
    sInputString = regexprep(sInputString, '[$]', '');
    sInputString = regexprep(sInputString, '[0-9]', '');

    % since struct.keys can only be as long as 63 characters, remove rest
    if strlength(sInputString) > 63
        sInputString = sInputString(1:63);
    end
    if sInputString(1) == '_'
        sInputString = sInputString(2:end);
    end
    sOutputString = sInputString;
end