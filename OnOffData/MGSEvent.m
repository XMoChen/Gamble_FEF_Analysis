function MGSEvent(Eventfile,outputfile,BasicInfo)
save(Eventfile,'BasicInfo','-append');

load(Eventfile);

%%

clear InfoTrial0
Start=table(:,2);
TargetOn=table(:,3)-Start;
TargetOff=table(:,4)-Start;
FixationOff=table(:,5)-Start;
ChoiceIn=table(:,6)-Start;
Blank=table(:,7)-Start;



Directions=para.angles;
Directions(Directions>2*pi)=Directions(Directions>2*pi)-2*pi;

TrialInfo.Direction=Directions(table(:,1))';
TrialInfo.TargetOn=TargetOn;
TrialInfo.TargetOff=TargetOff;
TrialInfo.ChoiceIn=ChoiceIn;
TrialInfo=struct2table(TrialInfo);

TrialInfo.BGOff=table(:,10);
%TrialInfo.Reward=table(:,10);
SelectI=table(:,10)>table(:,6);

%%
save(Eventfile,'TrialInfo','BasicInfo','-append');
save(outputfile,'TrialInfo','BasicInfo');

