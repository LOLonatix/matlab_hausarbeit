function[vMomentum] = fMomentum(currentCountryStructure)
cFieldNames = fieldnames(currentCountryStructure);
cMomentum=[];
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
   cMomentum = [cMomentum; mMomentum];
   cMomentum(isinf(cMomentum))=NaN;  %infinities ersetzen durch Nans
end
[vMomentum] = fConclude(cMomentum);

end



