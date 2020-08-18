function AlignEventLFP(LFPfile,Eventfile,Ch_num,event,t_interval)
% 
LFPfile0=LFPfile;
load(LFPfile,'LFP*');
clear(['LFP_',event,'*'])
load(Eventfile,'InfoTrial');
LFPfile=LFPfile0;


if strcmp(event,'Target')==1
PopOn=round(InfoTrial.TargetOn);
elseif strcmp(event,'Saccade')==1
PopOn=round(InfoTrial.SaccadeStart);
elseif strcmp(event,'Result')==1
PopOn=round(InfoTrial.ResultOn2);
elseif strcmp(event,'Background')==1
PopOn=round(InfoTrial.BackGroundOn);
elseif strcmp(event,'SaccadeEnd')==1
PopOn=InfoTrial.SaccadeEnd;
end

% PopOn=table(:,7);
% PopOff=table(:,8);
% tpre=300;
% tafter=599;
Fs=1000;
% d = designfilt('bandstopiir','FilterOrder',6, ...
%                'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
%                'DesignMethod','butter','SampleRate',Fs);
Wo=60/(1000/2);
BW=Wo/100;
[b,a]=iirnotch(Wo,BW);

tpre=t_interval(1);
tafter=t_interval(2);
% figure(1)
% kernal=SpikedensityKernel('gaussian');
for ch=1:Ch_num
        clear LFP
            eval(['LFP=','LFP_',num2str(ch),';']);

            LFP0 = filtfilt(b,a,LFP');
            clear LFP LFP_Prob
            LFP=LFP0';
            
            for trial=1:size(InfoTrial,1)
            clear lfp trial_s
            if (PopOn(trial)-tpre)>0 && PopOn(trial)+tafter< size(LFP,2)        
            trial_s=LFP(trial,:);
            lfp=trial_s((PopOn(trial)-tpre):(PopOn(trial)+tafter));
            LFP_Prob(trial,1:length(lfp))=lfp;
            else
            LFP_Prob(trial,:)=nan; 
            end
            end
            eval(['LFP_',event,'_',num2str(ch),'=LFP_Prob;']);
  
            
%             subplot(4,4,ch)
%             plot(-tpre:1:tafter,nanmean(LFP_Prob));
%             axis tight
end

save(LFPfile,'LFP_*','-append')
 