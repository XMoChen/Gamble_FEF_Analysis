% t_interval is the exactly time bin for investigation (converlution is
% done with 100 more extra data on both end
function AlignEvenSpikeLong(Spikefile,Spikefile2,Eventfile,record,Ch_num,event,t_interval)
% 
%EventRate is the firing rate align on the event
%EventHist is the histgram align on the event with 1ms time bins
% PopOn(trial);

% event='Background';
%  t_interval=[100,500];
load(Eventfile,'InfoTrial');
load(Spikefile,'SPK*','l_ts','tcounts');
if strcmp(event,'Target')==1
PopOn=InfoTrial.TargetOn;
elseif strcmp(event,'Saccade')==1
PopOn=InfoTrial.SaccadeStart;
elseif strcmp(event,'Result')==1
PopOn=InfoTrial.ResultOn;
elseif strcmp(event,'Background')==1
PopOn=InfoTrial.BackGroundOn;
end

   
tpre=t_interval(1)+100;
tafter=t_interval(2)+100;

 %kernal=SpikedensityKernel('exponential');
   kernal=SpikedensityKernel('gaussian');
%tcounts=plx_info(plx_filename,1);
l_ts=zeros(Ch_num,5);
for ch=1:Ch_num
    maxn=max(find((tcounts(:,ch+1))>0));
    l_ts(ch,1:maxn)=tcounts(1:maxn,ch+1);
end

for ch=1:Ch_num
    for unit=1:max(find(l_ts(ch,:)>0))
        if l_ts(ch,unit)>0
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
            I=(histcounts( trial_s, (PopOn(trial)-tpre-1):1:((PopOn(trial)+tafter+1))));
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
            
        end
    end
end
save(Spikefile2,[event,'*'],'-append')
 