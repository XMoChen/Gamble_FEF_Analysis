function SpikeOrgRigBRF(filename,Eventfile,Ch_num,DirFig,recordname,RFFigs)
close all
%filename=plx_filenameRF;
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
        Probeend=[Probeend;ProbEndTime((end-2):end)];
        RF_location_trial(trialN,:)=Stim_list(:,trial);
        
    end
end
RF_location=reshape(RF_location_trial',1,[])';
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
    clear ts0 RF_loc
    tsNum_Ch=zeros(201,1);
    for unit=1:max(find(l_ts(ch,:)>0))
        tsNum=zeros(201,1);
        if l_ts(ch,unit)>0
            %             l_ts
            clear a trial ts substract AvWave
            
            [n,spike_ts]=plx_ts(filename,ch,unit-1);
            a=spike_ts;
            a=PL2Ts(filename,ch,unit-1);
            %             a0=PL2Waves(filename,ch,unit-1);
            %             a=a0.Ts;
            %             AvWave=nanmean(a0.Waves,1);
            % AverageWave(ch,unit,:)=AvWave;
            for trial=1:length(Probestart)
                clear substract currentspike
                currentspike=a(a>=Probestart(trial) & a<=Probeend(trial));
                % align on trial start ms
                substract=(currentspike-Probestart(trial));
                if isempty(substract)~=1
                    ts(trial,1:length(substract))=substract;
                else
                    ts(trial,:)=0;
                end
                tsNum(trial,1)=length(substract);
                eval(['SPK_',num2str(ch),num2str(unit),'RF=ts;']);
            end
            %             end
        end
        tsNum_Ch=tsNum_Ch+tsNum;
    end
    
    for loc=1:25
        RF_loc(loc)=nanmean(tsNum_Ch(RF_location==loc));
    end
    eval(['RF_',num2str(ch),'=reshape(RF_loc,5,5);']);
    [Inf_RS,Sig0]=MutualInfo_NMS(tsNum_Ch,RF_location,5,25);
    RF_all_Info(ch,:)=[Inf_RS,Sig0];
    %
    %             xaxis=-15:5:5;
    %             yaxis=-15:5:5;
    
    xaxis=-30:10:10;
    yaxis=-20:10:20;
    
    %     figure(1)
    %     subplot(4,ceil(Ch_num/4),ch)
    %     if nanmax(RF_loc)*1.2>nanmin(RF_loc)*1.2
    %         RF_plot(reshape(RF_loc,5,5)',[nanmin(RF_loc)*1.2 nanmax(RF_loc)*1.2], xaxis, yaxis)
    %     else
    %         RF_plot(reshape(RF_loc,5,5)',[nanmin(RF_loc)*1.2 nanmin(RF_loc)+5], xaxis, yaxis)
    %     end
    %colorbar
    
    figure(1)
    subplot(221)
    if Sig0<=0.05
        plotcontour3(reshape(zscorematrix(RF_loc),5,5)', xaxis, yaxis,ContourColor(ch,:),1,ch,Ch_num);hold on;
    end
    axis([-30 10 -20 20 -inf inf])
    title('Sig RFs');

    subplot(223)
    if Sig0<=0.05
        plotcontour(reshape(zscorematrix(RF_loc),5,5)', xaxis, yaxis,ContourColor(ch,:),1);hold on;
    end
    
    %figure(2)
    subplot(222)
    plotcontour3(reshape(zscorematrix(RF_loc),5,5)', xaxis, yaxis,ContourColor(ch,:),1,ch,Ch_num);hold on;
    title('RFs');

    %     axis off
    %     subplot(222)
    %     if Sig0<=0.05
    %         plotcontour3(reshape(zscorematrix(RF_loc),5,5)', xaxis, yaxis,ContourColor(ch,:),1,ch,Ch_num);hold on;
    %     end
    axis([-30 10 -20 20 -inf inf])
    %figure(3)
    subplot(224)
    plotcontour(reshape(zscorematrix(RF_loc),5,5)', xaxis, yaxis,ContourColor(ch,:),1);hold on;
    %     subplot(222)
    %     if Sig0<=0.05
    %         plotcontour(reshape(zscorematrix(RF_loc),5,5)', xaxis, yaxis,ContourColor(ch,:),1);hold on;
    %     end
end
    suptitle(char(recordname));


h10=figure(1);
print( h10, '-djpeg', [DirFig,'RFMap']);
print( h10, '-depsc', [DirFig,'RFMap']);
print( h10, '-djpeg', [RFFigs,'FEF',char(recordname)]);
print( h10, '-depsc', [RFFigs,'FEF',char(recordname)]);
save(Eventfile,'RF_all_Info','-append');
% h10=figure(2);
% print( h10, '-djpeg', [DirFig,'RFContour']);
% print( h10, '-depsc', [DirFig,'RFContour']);
% print( h10, '-djpeg', [RFFigs,'FEF',char(recordname),'1']);
% print( h10, '-depsc', [RFFigs,'FEF',char(recordname),'1']);
% h10=figure(3);
% print( h10, '-djpeg', [DirFig,'RF2D']);
% print( h10, '-depsc', [DirFig,'RF2D']);
% print( h10, '-djpeg', [RFFigs,'FEF',char(recordname),'2']);
% print( h10, '-depsc', [RFFigs,'FEF',char(recordname),'2']);
%%
% if exist(Spikefile)~=0
% save(Spikefile,'SPK*','l_ts','trialstart','trialsend','AverageWave','-append');
% else
% save(Spikefile,'SPK*','l_ts','trialstart','trialsend','AverageWave');
% end
% save(Eventfile,'trialstart','trialsend','TargetOn','ResultOn','RewardOn','-append');
%
%
%
% for ch=1:Ch_num
%         for unit=2:size(AverageWave,2)
%         if nanmean(AverageWave(ch,unit,:))~=0
%             plot(squeeze(AverageWave(ch,unit,:)));hold on;
%         end
%         end
% end
% ExampleWave=squeeze(AverageWave(:,2,:));
% %%
% ExampleWave0=ExampleWave(nanmean(ExampleWave,2)~=0,:);
% delta_t=1000/(40);
% t0=(1:56)*deta_t;
% plot(t0,ExampleWave0'*1000);
% xlabel('time (us)');
% ylabel('mV');
% box off;set(gca,'TickDir','out')
% save('SpikeTemplate.mat','ExampleWave0','delta_t');