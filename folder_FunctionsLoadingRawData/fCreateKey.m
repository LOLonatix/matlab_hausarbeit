function string = fCreateKey(input_cell)
  string = cell2mat(input_cell);
    string = regexprep(string, ' +', '_');
    string = regexprep(string, '&+', '');
    string = regexprep(string, '[.]','');
    string = regexprep(string, '[/]','');
    string = regexprep(string, '[£]','');
    string = regexprep(string, '[:]','');
    string = regexprep(string, '[(]','');
    string = regexprep(string, '[)]','');
    string = regexprep(string, '['']','');
    string = regexprep(string, '[-]','');
    string = regexprep(string, '[0-9]', '');
    string = regexprep(string, '[@]', '');
    string = regexprep(string, '[+]', '');
    string = regexprep(string, '[$]', '');
    string = regexprep(string, '[,]', '');
    string = regexprep(string, '[%]', '');
    string = regexprep(string, '[#]', '');
    % this one removes underscores from the beginning
    string = regexprep(string,'^_','','emptymatch');
    string = regexprep(string,'^_','','emptymatch');
   
end