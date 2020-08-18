function SpikeOrgRigB(filename,Spikefile,Eventfile,Ch_num)
%filename=plx_filename;
%      [n, Time5, Code5] = plx_event_ts(filename, 5);
%      [n, Time7, Code7] = plx_event_ts(filename, 7);
%      Event01 =Time5;
%      Event02 =Time7;

% trialstart=Time5;
% trialsend=Time7;

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
    ts_all=[];
    %%%%% no unsorted neurons
    for unit=1:max(find(l_ts(n,:)>0))
        if l_ts(n,unit)>5000
            %             l_ts
            clear a trial ts substract AvWave
            
            %             [n,spike_ts]=plx_ts(filename,ch,unit-1);
            %             a=spike_ts;
            %            a=PL2Ts(filename,ch,unit-1);
            %%%% PL2Waves seems count start from the effective channels
            %%%% (dif from tcounts)
            a0=PL2Waves(filename,n,unit-1);
            a=a0.Ts;
            AvWave=nanmean(a0.Waves,1);
            %             size(AvWave)
            AverageWave(ch,unit,:)=AvWave;
            for trial=1:length(trialstart)
                clear substract currentspike
                currentspike=a(a>=trialstart(trial) & a<=trialsend(trial));
                % align on trial start ms
                substract=(currentspike-trialstart(trial));
                if isempty(substract)~=1
                    ts(trial,1:length(substract))=substract;
                else
                    ts(trial,:)=0;
                end
            end
            if size(ts,2)<20
                l_ts(n,unit)=0;
            end
            eval(['SPK_',num2str(n),num2str(unit),'=ts;']);
            ts_all=cat(2,ts_all,ts);
        end
        eval(['SPK_',num2str(ch),'_all=ts_all;']);
        %             end
        
    end
end
%%
if exist(Spikefile)~=0
    save(Spikefile,'SPK*','l_ts','trialstart','trialsend','AverageWave','-append');
else
    save(Spikefile,'SPK*','l_ts','trialstart','trialsend','AverageWave');
end
save(Eventfile,'trialstart','trialsend','TargetOn','ResultOn','RewardOn','-append');



% for ch=1:Ch_num
%     for unit=2:size(AverageWave,2)
%         if nanmean(AverageWave(ch,unit,:))~=0
%             plot(squeeze(AverageWave(ch,unit,:)));hold on;
%         end
%     end
% end
% ExampleWave=squeeze(AverageWave(:,2,:));
%
% ExampleWave0=ExampleWave(nanmean(ExampleWave,2)~=0,:);
% delta_t=1000/(40);
% t0=(1:56)*delta_t;
% plot(t0,ExampleWave0'*1000);
% xlabel('time (us)');
% ylabel('mV');
% box off;set(gca,'TickDir','out')
% save('SpikeTemplate.mat','ExampleWave0','delta_t');