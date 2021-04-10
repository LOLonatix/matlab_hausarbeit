clc;clear;

%create arrays that are later being filled?
% vMeanGrossProfits = [];%leerer vektor
% vSDGrossProfits = [];
% v1stQGrossProfits = [];
% v25stQGrossProfits= [];
% v50stQGrossProfits= [];
% v75stQGrossProfits= [];
% v99stQGrossProfits= [];
%hier startet for schleife
%load data
load('ARGENTINA.mat');
%call function to check 
%replace NaNs with 0s
cFieldNames = fieldnames(rCountryStructure);
vItem = {'TRI'};
for i = 1:numel(cFieldNames)
    for j = 1:numel(vItem)
        mTemp = rCountryStructure.(cFieldNames{i}).(vItem{j});
        mTemp(isnan(mTemp))=0;        
        rCountryStructure.(cFieldNames{i}).(vItem{j}) = mTemp;
    end
end

%calculate gross profits
[vGrossProfit,cGrossProfit] = fGrossProfits(rCountryStructure);
%calculate Operating profitability ball 2016
[vOpProfitt,cOpProfit] = fOpProfit(rCountryStructure);
%calculate operating profitability fama 
[vOpProfitff] = fOpProfitff(rCountryStructure);
%Calculate Cash based operating profitability
[vCbOpProfit] = fCbOpProfit(rCountryStructure,cOpProfit);
%Calculate Cash based gross profit
[vCbGrossProfit] = fCbOpProfit(rCountryStructure,cGrossProfit);
%calculate other stuff



%Add all means, sd and quantiles into an array
%gross profit arrays
% vMeanGrossProfits = [vMeanGrossProfits, dMeanGrossProfits];
% vSDGrossProfits = [vSDGrossProfits, dSDGrossProfits];
% v1stQGrossProfits = [v1stQGrossProfits,d1stQGrossProfits];
% v25stQGrossProfits= [v25stQGrossProfits,d25stQGrossProfits];
% v50stQGrossProfits= [v50stQGrossProfits,d50stQGrossProfits];
% v75stQGrossProfits= [v75stQGrossProfits,d75stQGrossProfits];
% v99stQGrossProfits= [v99stQGrossProfits,d99stQGrossProfits];
%operating profitability arrays

%repeat with all countries
%end of for schleife
%calculate mean of the arrays










