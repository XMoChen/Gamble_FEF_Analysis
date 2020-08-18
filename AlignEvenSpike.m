% t_interval is the exactly time bin for investigation (converlution is
% done with 100 more extra data on both end
  function AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,event,t_interval)
% 
%EventRate is the firing rate align on the event
%EventHist is the histgram align on the event with 1ms time bins
% PopOn(trial);

% event='Background';
% event='Target';
% 
% t_interval=[500,500];
load(Eventfile,'InfoTrial','TrialInfo');
if exist('InfoTrial')~=1
InfoTrial=TrialInfo;
end
load(Spikefile,'SPK*','l_ts','tcounts','AverageWave');

if strcmp(event,'Target')==1
PopOn=InfoTrial.TargetOn;
elseif strcmp(event,'Saccade')==1
PopOn=InfoTrial.SaccadeStart;
elseif strcmp(event,'SaccadeEnd')==1
PopOn=InfoTrial.SaccadeEnd;
elseif strcmp(event,'Result')==1
PopOn=InfoTrial.ResultOn2;
elseif strcmp(event,'Background')==1
if ismember('BGOn2', InfoTrial.Properties.VariableNames)==1   
PopOn=InfoTrial.BGOn2;
else
PopOn=InfoTrial.BackGroundOn;
end
end

   
tpre=t_interval(1)+100;
tafter=t_interval(2)+100;

kernal=SpikedensityKernel('exponential');
kernal=SpikedensityKernel('gaussian');
% l_ts=zeros(Ch_num,5);
% for ch=1:Ch_num
%     maxn=max(find((l_ts(:,ch))>0));
%     l_ts(ch,1:maxn)=tcounts(1:maxn,ch+1);
% end

for ch=1:Ch_num
    Spike_all=zeros(size(InfoTrial,1),sum(t_interval)+2);
    for unit=1:(max(find(l_ts(ch,:)>0)))
        % l_ts include unsorted unit
        % SPK start from the sorted unit
        if l_ts(ch,unit)>5000
            clear spikes trial ts
            eval(['spikes=','SPK_',num2str(ch),num2str((unit)),';']);
            PopSpike=zeros(size(spikes,1),1000);
            for trial=1:size(InfoTrial,1)
            clear trial_s I s 
            if PopOn(trial)>300
            trial_s=spikes(trial,:)*1000;
            ss=trial_s;
            ssi=ss(ss>(PopOn(trial)-tpre-1) & ss<(PopOn(trial)+tafter+1));
            PopSpike(trial,1:length(ssi))=ssi-PopOn(trial);
            I=(histcounts( ssi, (PopOn(trial)-tpre-1):1:((PopOn(trial)+tafter+1))));
%           I
            s=convn(I',kernal,'same');        
            Spike(trial,1:(length(s)-200))=s(101:(length(s)-100));
            Spike0(trial,1:(length(s)-200))=I(101:(length(s)-100));
           
            else
            Spike(trial,:)=NaN;
            Spike0(trial,:)=NaN;
            end
            end
            eval([event,'Rate.Ch',num2str(ch),'Unit',num2str(unit),'=single(Spike);']);
            eval([event,'Hist.Ch',num2str(ch),'Unit',num2str(unit),'=single(Spike0);']);
            eval(['SpikeWave.Ch',num2str(ch),'Unit',num2str(unit),'=squeeze(AverageWave(ch,unit,:));']);

            Spike_all=Spike_all+Spike;
   
        end
%         size(Spike)
%         size(Spike_all)
    end
    
   eval([event,'RateAll.Ch',num2str(ch),'=single(Spike_all);']);

end
save(Spikefile,[event,'*'],'SpikeWave','-append')
 