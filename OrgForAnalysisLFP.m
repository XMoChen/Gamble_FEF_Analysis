function OrgForAnalysisLFP(Eventfile,LFPfile,record,Ch_num,LFPOrgFile)
[BG_FireAll,BG_FireAll_C]=EventAnlyLFP (Eventfile,LFPfile,record,Ch_num,'Background',[500,500]);      %  %
[Targ_FireAll,Targ_FireAll_C]=EventAnlyLFP (Eventfile,LFPfile,record,Ch_num,'Target',[1000,800]);      %  %
[Move_FireAll,Move_FireAll_C]=EventAnlyLFP (Eventfile,LFPfile,record,Ch_num,'Saccade',[1000,800]);      %  %
[Result_FireAll,Result_FireAll_C]=EventAnlyLFP (Eventfile,LFPfile,record,Ch_num,'Result',[1000,800]);      %  %
save(LFPOrgFile,'*FireAll');


