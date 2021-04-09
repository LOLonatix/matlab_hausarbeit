function [dMean,dSD,d1stQ,d25stQ,d50stQ,d75stQ,d99stQ] = fConclude(cACompanyData)
dMean = mean(cell2mat(cACompanyData),'omitnan');
dSD = std(cell2mat(cACompanyData),'omitnan');
d1stQ = quantile(cell2mat(cACompanyData),0.01);
d25stQ = quantile(cell2mat(cACompanyData),0.25);
d50stQ = quantile(cell2mat(cACompanyData),0.50);
d75stQ = quantile(cell2mat(cACompanyData),0.75);
d99stQ= quantile(cell2mat(cACompanyData),0.99);
end

