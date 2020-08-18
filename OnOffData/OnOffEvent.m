function OnOffEvent(Eventfile,outputfile,BasicInfo)

load(Eventfile,'InfoTrial','trialstart','trialsend');

%%

clear InfoTrial0
InfoTrial0.Block=InfoTrial.Block;
InfoTrial0.Background=InfoTrial.Background;
InfoTrial0.BackgroundLevel(InfoTrial0.Background<=6,1)=1;
InfoTrial0.BackgroundLevel(InfoTrial0.Background>12,1)=3;
InfoTrial0.BackgroundLevel(InfoTrial0.Background>6 & InfoTrial0.Background<=12,1)=2;

InfoTrial0.Targ1Direction=InfoTrial.Targ1Direction;
InfoTrial0.Targ2Direction=InfoTrial.Targ2Direction;
InfoTrial0.Targ1Opt=InfoTrial.Targ1Opt;
InfoTrial0.Targ2Opt=InfoTrial.Targ2Opt;
InfoTrial0.ChoiceDirection=InfoTrial.ChoiceD;
InfoTrial0.ChoiceOption=InfoTrial.ChoiceOpt;
InfoTrial0.Result=InfoTrial.Result;
InfoTrial0.Reward=InfoTrial.Reward;

trialstart=trialstart(1:size(InfoTrial,1));
InfoTrial0.FixationIn=(InfoTrial.FixationIn/1000)+trialstart;
InfoTrial0.BackgroundOn=(InfoTrial.BackGroundOn/1000)+trialstart;
InfoTrial0.TargetOn=(InfoTrial.TargetOn/1000)+trialstart;
InfoTrial0.Saccade=(InfoTrial.SaccadeStart/1000)+trialstart;
InfoTrial0.SaccadeOff=(InfoTrial.SaccadeEnd/1000)+trialstart;

InfoTrial0.ResultOn=(InfoTrial.ResultOn2/1000)+trialstart;
InfoTrial0=struct2table(InfoTrial0);

SelectI=InfoTrial0.Reward>0;% & InfoTrial.Repeat==0;
TrialInfo=InfoTrial0(SelectI,:);
%%
save(Eventfile,'SelectI','TrialInfo','BasicInfo','-append');
save(outputfile,'TrialInfo','BasicInfo');

