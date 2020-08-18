function [Drop,PostSaccadeDrop,PostResultDrop]=DropRate(Eventfile)
load(Eventfile,'InfoTrial');

for type=1:2
    if type==1
        ID=InfoTrial.Targ2Opt==0;
    else
        ID=InfoTrial.Targ2Opt>0;
    end
clear TrialAll TrialDrop
TrialAll=sum( ID & InfoTrial.FixationIn>0 );
TrialDrop=sum( ID & InfoTrial.FixationIn>0 & InfoTrial.TargetOn==0 );
Drop(type,1)=sum(TrialDrop)/sum(TrialAll);
clear TrialAll TrialDrop

TrialAll=sum( ID & InfoTrial.TargetOn>0 );
TrialDrop=sum( ID & InfoTrial.TargetOn>0 & InfoTrial.FixationOff==0 );
Drop(type,2)=sum(TrialDrop)/sum(TrialAll);
clear TrialAll TrialDrop

TrialAll=sum( ID & InfoTrial.ChoiceIn>0 );
TrialDrop=sum( ID & InfoTrial.ChoiceIn>0 & InfoTrial.ResultOn==0 );
Drop(type,3)=sum(TrialDrop)/sum(TrialAll);
clear TrialAll TrialDrop

TrialAll=sum( ID & InfoTrial.ResultOn>0 );
TrialDrop=sum( ID & InfoTrial.ResultOn>0 & InfoTrial.Reward==0 );
Drop(type,4)=sum(TrialDrop)/sum(TrialAll);
end

for d=1:2
    u=0;
    for v=[2,12,11]
     u=u+1;  
clear TrialAll TrialDrop
TrialAll=sum(InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceIn>0 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v);
TrialDrop=sum(InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceIn>0 & InfoTrial.ResultOn==0 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v);
PostSaccadeDrop(1,d,u)= TrialDrop/TrialAll;
    end
end


for d=1:2
    u=0;
    for v=[0,1,2,3,4]
     u=u+1; 
clear TrialAll TrialDrop
TrialAll=sum(InfoTrial.Targ2Opt==0 & InfoTrial.ResultOn>0 & InfoTrial.ChoiceD==d & InfoTrial.Result==v);
TrialDrop=sum(InfoTrial.Targ2Opt==0 & InfoTrial.Reward==0 &  InfoTrial.ResultOn>0 & InfoTrial.ChoiceD==d & InfoTrial.Result==v);
PostResultDrop(1,d,u)= TrialDrop/TrialAll;

    end
end

for d=1:2
    u=0;
    for v=[2,12,11]
     u=u+1;  
clear TrialAll TrialDrop
TrialAll=sum(InfoTrial.Targ2Opt>0 & InfoTrial.ChoiceIn>0 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v);
TrialDrop=sum(InfoTrial.Targ2Opt>0 & InfoTrial.ChoiceIn>0 & InfoTrial.ResultOn==0 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v);
PostSaccadeDrop(2,d,u)= TrialDrop/TrialAll;
    end
end

for d=1:2
    u=0;
    for v=[0,1,2,3,4]
     u=u+1; 

clear TrialAll TrialDrop
TrialAll=sum(InfoTrial.Targ2Opt>0 & InfoTrial.ResultOn>0 & InfoTrial.ChoiceD==d & InfoTrial.Result==v);
TrialDrop=sum(InfoTrial.Targ2Opt>0 & InfoTrial.Reward==0 &  InfoTrial.ResultOn>0 & InfoTrial.ChoiceD==d & InfoTrial.Result==v);
PostResultDrop(2,d,u)= TrialDrop/TrialAll;
    end
end
