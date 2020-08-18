function SpikeOrgTsRFV4(filename,Eventfile,Ch_num,EventOutfile,SpikeOutfile,BasicInfo)
close all
%  filename=plx_filenameRF;
load('D:\Projects\GambleMIB\Gamble\ProbList.mat');
load(Eventfile,'table','Stim_list');
%RF_location=reshape(Stim_list,1,[]);

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
Event05=PL2EventTs(filename, 'EVT04');

Event01 = Event01.Ts;
Event02 = Event02.Ts;
Event03 = Event03.Ts;
Event04 = Event04.Ts;
Event05 = Event05.Ts;

trialstart=Event01;
trialsend=Event02;

Probestart=[];Probeend=[];

trialN=0;
for trial=1:size(Stim_list,2)
    if find(Event04>Event01(trial) & Event04<Event02(trial))>0
        trialN=trialN+1;
        clear ProbTime ProbEndTime
        ProbTime=Event03((Event03<Event04(2*trialN)));
        ProbEndTime=Event05((Event05<Event04(2*trialN)));
        
        table(trialN,2:4)=ProbTime((end-2):end);
        Probestart=[Probestart;ProbTime((end-2):end)];
        RF_location_trial(trialN,:)=Stim_list(:,trial);
        
    end
end
RF_location=reshape(RF_location_trial',1,[])';


TrialInfo.ProbLocation=RF_location;
TrialInfo.ProbTime=Probestart;

%
Probeend=Probestart+0.3;

Flag={'a','b','c','d','e','f'};
ContourColor=cool(Ch_num);

%%%%% number of spikes per channel
tcounts=plx_info(filename,1);
l_ts=zeros(Ch_num,5);
for ch=1:Ch_num
    maxn=max(find((tcounts(:,ch+1))>0));
    l_ts(ch,1:maxn)=tcounts(1:maxn,ch+1);
end
%%
for ch=1:Ch_num
    for unit=1:max(find(l_ts(ch,:)>0))
        if l_ts(ch,unit)>0
            %             l_ts
            clear a trial ts substract AvWave
            
            [n,spike_ts]=plx_ts(filename,ch,unit-1);
            a=spike_ts;
            a=PL2Ts(filename,ch,unit-1);
            eval(['chan',num2str(ch),'_unit',num2str(unit-1),'=a;']);
            %             end
        end
    end
    
    
    %         xaxis=-15:5:5;
    %         yaxis=-15:5:5;
    
%     ProbLocations.xaxis=-30:10:10;
%     ProbLocations.yaxis=-20:10:20;
clear ProbLocations
    [ProbLocations.xaxis,ProbLocations.yaxis]=(meshgrid(-15:5:5,-15:5:5));
    ProbLocations.xaxis=reshape(ProbLocations.xaxis,1,[]);
    ProbLocations.yaxis=reshape(ProbLocations.yaxis,1,[]);
    
end
if exist(SpikeOutfile)~=0
    save(EventOutfile,'ProbLocations','BasicInfo','TrialInfo','-append');
    save(SpikeOutfile,'chan*','-append');
else
    save(EventOutfile,'ProbLocations','BasicInfo','TrialInfo');
    save(SpikeOutfile,'chan*');
end
