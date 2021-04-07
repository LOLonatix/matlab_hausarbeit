clc;clear;

%create arrays that are later being filled?
vMeanGrossProfits = [];%leerer vektor
vSDGrossProfits = [];
v1stQGrossProfits = [];
v25stQGrossProfits= [];
v50stQGrossProfits= [];
v75stQGrossProfits= [];
v99stQGrossProfits= [];
%hier startet for schleife
%load data
load('ARGENTINIA.mat')
%replace NaNs with 0s
cFieldNames = fieldnames(vCountryStructure);
vCountryStructure(isnan(cFieldNames(1))=0; %cellfun(@isnan,cFieldNames,'UniformOutput',false)
%calculate gross profits
[dMeanGrossProfits,dSDGrossProfits,d1stQGrossProfits,d25stQGrossProfits,d50stQGrossProfits,d75stQGrossProfits,d99stQGrossProfits,cAGrossProfit] = fGrossProfits(vCountryStructure);
%calculate Operating profitability ball 2016
[dMeanOpProfit,dSDOpProfit,d1stQOpProfit,d25stQOpProfit,d50stQOpProfit,d75stQOpProfit,d99stQOpProfit,cAOpProfit] = fOpProfit(vCountryStructure);
%calculate operating profitability fama 
[dMeanOpProfitff,dSDOpProfitff,d1stQOpProfitff,d25stQOpProfitff,d50stQOpProfitff,d75stQOpProfitff,d99stQOpProfitff] = fOpProfitff(vCountryStructure);
%Calculate Cash based operating profitability
[dMeanCbOpProfit,dSDCbOpProfit,d1stQCbOpProfit,d25stQCbOpProfit,d50stQCbOpProfit,d75stQCbOpProfit,d99stQCbOpProfit] = fCbOpProfit(vCountryStructure,cAOpProfit);
%Calculate Cash based gross profit
[dMeanCbGrossProfit,dSDCbGrossProfit,d1stQCbGrossProfit,d25stQCbGrossProfit,d50stQCbGrossProfit,d75stQCbGrossProfit,d99stQCbGrossProfit] = fCbOpProfit(vCountryStructure,cAGrossProfit);
%calculate other stuff



%Add all means, sd and quantiles into an array
%gross profit arrays
vMeanGrossProfits = [vMeanGrossProfits, dMeanGrossProfits];
vSDGrossProfits = [vSDGrossProfits, dSDGrossProfits];
v1stQGrossProfits = [v1stQGrossProfits,d1stQGrossProfits];
v25stQGrossProfits= [v25stQGrossProfits,d25stQGrossProfits];
v50stQGrossProfits= [v50stQGrossProfits,d50stQGrossProfits];
v75stQGrossProfits= [v75stQGrossProfits,d75stQGrossProfits];
v99stQGrossProfits= [v99stQGrossProfits,d99stQGrossProfits];
%operating profitability arrays

%repeat with all countries
%end of for schleife
%calculate mean, sd and quantiles of the arrays










