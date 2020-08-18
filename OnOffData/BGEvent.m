function BGEvent(Eventfile,outputfile,BasicInfo)
save(Eventfile,'BasicInfo','-append');

load(Eventfile);

%%

clear InfoTrial0
TrialInfo.Contrast=table(:,1);
TrialInfo.Fixation=table(:,6);
TrialInfo.BGOn=table(:,3);
TrialInfo.BGOff=table(:,10);
%TrialInfo.Reward=table(:,10);
SelectI=table(:,10)>table(:,6);

%%
save(Eventfile,'TrialInfo','BasicInfo','-append');
save(outputfile,'TrialInfo','BasicInfo');

