 function SpikeOrgTs(filename,eventfile,SaveEventfile,Outfile,Ch_num)
%      filename=plx_filename;
%      eventfile=Eventfile;
%      Outfile=SaveSpikefile;
%      [n, Time5, Code5] = plx_event_ts(filename, 5);
%      [n, Time7, Code7] = plx_event_ts(filename, 7);
%      Event01 =Time5;
%      Event02 =Time7;

% trialstart=Time5;
% trialsend=Time7;
load(eventfile);
%%
Event01=PL2EventTs(filename, 'EVT05');
Event02=PL2EventTs(filename, 'EVT07');
Event03=PL2EventTs(filename, 'EVT06');
Event04=PL2EventTs(filename, 'EVT01');


Event01 = Event01.Ts;
Event02 = Event02.Ts;
Event03 = Event03.Ts;
Event04 = Event04.Ts;

trialstart=Event01;
trialsend=Event02;

%
%%%% adjust the probeonset time and result onset time relative to the trial start
RewardOn=zeros(1,length(Event01));
ResultOn=zeros(1,length(Event01));
TargetOn=zeros(1,length(Event01));

for i=1:(length(Event01))
    
    %%% find event within each trial
    if i<=length(Event01)-1
   ii=find(Event03>Event01(i) & Event03<Event02(i));
   ii2=find(Event04>Event01(i) & Event04<Event02(i));
    else
   ii=find(Event03>Event01(i)) ;
   ii2=find(Event04>Event01(i)) ;
    end
    

   if ~isempty(ii2)
   RewardOn(i)=Event04(ii2(1))-Event01(i);
   end
   
   if ~isempty(ii)
   iii=ii(1);
   % first event 03 for targeton
   TargetOn(i)=Event03(iii);%-Event01(i);  
   if length(ii)==2
   % second event 03 for targeton
   ResultOn(i)=Event03(ii(2));%-Event01(i);
   end
   end
end
%%

if length(Event02)<length(Event01)
trialsend(length(Event01))=Event01(length(Event01));
end
%  TargetOn0= TargetOn(SelectI);


Flag={'a','b','c','d','e','f'};


%%%%% number of spikes per channel
tcounts=plx_info(filename,1);
n=0;
%%% get rid of the zero channels at the begining
ch_min=min(find(sum(tcounts,1)>1));
for ch=ch_min:(ch_min+Ch_num-1)
        n=n+1;
        maxn=max(find((tcounts(:,ch))>0));
        l_ts(n,1:maxn)=tcounts(1:maxn,ch);  
end
%%
n=0;
for ch=ch_min:(ch_min+Ch_num-1)
    n=n+1;
    for unit=2:max(find(l_ts(n,:)>0))
        if l_ts(n,unit)>10
%             l_ts
            clear a trial ts substract AvWave

%             [n,spike_ts]=plx_ts(filename,ch,unit-1);
%             a=spike_ts;
%            a=PL2Ts(filename,ch,unit-1);
            a0=PL2Waves(filename,n,unit-1);
            a=a0.Ts;
            eval(['chan',num2str(n),'_unit',num2str(unit-1),'=a;']);
%             end
        end
    end
end
%%
if exist(Outfile)~=0
save(Outfile,'chan*','-append');
else
save(Outfile,'chan*');
end

SelectI=RewardOn>0;
sum(SelectI)
TrialInfo.SelectI=SelectI;
TrialInfo.BGOnPlx=TargetOn;
a00=(TrialInfo.BGOff-TrialInfo.BGOn);
size(a00)
size(TargetOn)
TrialInfo.BGOffPlx=TargetOn+a00';

save(SaveEventfile,'TrialInfo','-append');