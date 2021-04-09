%function[dMeanMomentum,dSDMomentum,d1stQMomentum,d25stQMomentum,d50stQMomentum,d75stQMomentum,d99stQMomentum] = fMomentum(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cAMomentum={};
for i =1:numel(cFieldNames)
   rCurrentCompany = currentCountryStructure.(cFieldNames{i});
   %tri daten einlesen
   mPrice = rCurrentCompany.TRI;
   %rendite berechnen
   mReturn=mPrice(2:end,:)./mPrice(1:end-1,:) -1;
   %Momentum berechnen, summe der returns der letzten 12 Monate
   mMomentum = movsum(mReturn,[12 0],'omitnan');
   %die ersten 12 Monate löschen weils gegen die definition spricht. 
   mMomentum = mMomentum(13:end);
   % an bestehenden cell Array appenden, array wird zu cell array (bessere
   % übersichtlichkeit)
   cAMomentum = [cAMomentum; mMomentum];
     
end
[dMeanMomentum,dSDMomentum,d1stQMomentum,d25stQMomentum,d50stQMomentum,d75stQMomentum,d99stQMomentum] = fConclude(cAMomentum);

%end



