function [vConclude] = fConclude(cACompanyData)
if class(cACompanyData)=="cell"
    dMean = mean(cell2mat(cACompanyData),'omitnan');
    dSD = std(cell2mat(cACompanyData),'omitnan');
    d1stQ = quantile(cell2mat(cACompanyData),0.01);
    d25stQ = quantile(cell2mat(cACompanyData),0.25);
    d50stQ = quantile(cell2mat(cACompanyData),0.50);
    d75stQ = quantile(cell2mat(cACompanyData),0.75);
    d99stQ= quantile(cell2mat(cACompanyData),0.99);
    vConclude= [dMean;dSD;d1stQ;d25stQ;d50stQ;d75stQ;d99stQ];
else
    dMean = mean(cACompanyData,'omitnan');
    dSD = std(cACompanyData,'omitnan');
    d1stQ = quantile(cACompanyData,0.01);
    d25stQ = quantile(cACompanyData,0.25);
    d50stQ = quantile(cACompanyData,0.50);
    d75stQ = quantile(cACompanyData,0.75);
    d99stQ= quantile(cACompanyData,0.99);
    vConclude= [dMean;dSD;d1stQ;d25stQ;d50stQ;d75stQ;d99stQ];
end
