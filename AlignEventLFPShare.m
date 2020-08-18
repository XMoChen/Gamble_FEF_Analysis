   function AlignEventLFPShare(LFPfile,Eventfile,Ch_num,event,t_interval)
% 
LFPfile0=LFPfile;
load(LFPfile,'LFP*');
load(Eventfile,'InfoTrial');
LFPfile=LFPfile0;


if strcmp(event,'Target')==1
PopOn=round(InfoTrial.TargetOn);
elseif strcmp(event,'Saccade')==1
PopOn=round(InfoTrial.SaccadeStart);
elseif strcmp(event,'Result')==1
PopOn=round(InfoTrial.ResultOn);
elseif strcmp(event,'Background')==1
PopOn=round(InfoTrial.BackGroundOn);
end


tpre=t_interval(1);%+100;
tafter=t_interval(2);%+100;

for ch=1:Ch_num
        clear LFP
            eval(['LFP=','LFP_',num2str(ch),';']);
            
            for trial=1:size(InfoTrial,1)
            clear lfp trial_s
            if (PopOn(trial)-tpre)>0 && PopOn(trial)+tafter< size(LFP,2)        
            trial_s=LFP(trial,:);
            lfp=trial_s((PopOn(trial)-tpre):(PopOn(trial)+tafter));
            LFP_Prob(trial,1:length(lfp))=lfp;
            else
            LFP_Prob(trial,:)=0; 
            end
            end
            eval(['LFP_',event,'_',num2str(ch),'=LFP_Prob;']);
  

end

save(LFPfile,'LFP_*','-append')
 