%function DirectionValueSpike17(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
clear ContrastBG
C1=(InfoTrial.Background<=6);
ContrastBG(C1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
ContrastBG(C2)=2;
C3=(InfoTrial.Background>12 );
ContrastBG(C3)=3;

D1_V=InfoExp.RewardLeft'.*(InfoExp.Orientation==1);
D2_V=InfoExp.RewardRight'.*(InfoExp.Orientation==1);
D4_V=InfoExp.RewardLeft'.*(InfoExp.Orientation==2);
D3_V=InfoExp.RewardRight'.*(InfoExp.Orientation==2);
D1_V_trial=D1_V(InfoTrial.Block);
D2_V_trial=D2_V(InfoTrial.Block);
D3_V_trial=D3_V(InfoTrial.Block);
D4_V_trial=D4_V(InfoTrial.Block);
D_V_trial=[D1_V_trial,D2_V_trial,D3_V_trial,D4_V_trial];
V_all=unique(D2_V_trial);
% V_all=V_all(2:length(V_all));
% ChosenPercScale=zeros(size(InfoTrial,1),1);
% ChosenPercScale(InfoTrial.ChosenPerc>0 & InfoTrial.ChosenPerc<=30)=1;
% ChosenPercScale(InfoTrial.ChosenPerc>30 & InfoTrial.ChosenPerc<=60)=2;
% ChosenPercScale(InfoTrial.ChosenPerc>60 & InfoTrial.ChosenPerc<=90)=3;
% ChosenPercScale(InfoTrial.ChosenPerc>100 & InfoTrial.ChosenPerc<=130)=4;
% ChosenPercScale(InfoTrial.ChosenPerc>130 & InfoTrial.ChosenPerc<=160)=5;
% ChosenPercScale(InfoTrial.ChosenPerc>160 & InfoTrial.ChosenPerc<=190)=6;
% InfoTrial.ChosenPercScale=ChosenPercScale;

PreferD=1;

GS_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0;
GC_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt~=0;
D_I=InfoTrial.TrialType==2 ;
%%% Receptive field in the preferred direction 
PreferIn=(InfoTrial.PreferD==1);
PreferOut=( InfoTrial.PreferD==2);

PreferV=D4_V_trial+D1_V_trial;


Direction_Color={'k','k:'};
 V_all=[0;V_all];
V_Color={'k','b','r'};


%%  
close all
 unit_all=0;
for ch=1:Ch_num
    for unit=1:length(l_ts(ch,:))
if l_ts(ch,unit)>5000
  unit_all=unit_all+1;   
  figure(unit_all)
  
  
  
  eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike_TG=Spike;
  eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike_SC=Spike;
  eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike_BG=Spike;
  eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike_RT=Spike;


 

Epoch={'BG','TG','SC','RT'};
%%%% Align on target onset  
for ep=1:4
clear Spike tt Spike_max Spike_min
eval(['Spike=Spike_',char(Epoch(ep)),';']);

  for d=1:2%4
  tt(d,:)=nanmean(Spike(InfoTrial.ChoiceD==d ,:),1);
  end
  Spike_max=nanmax(tt(:));
  Spike_min=nanmin(tt(:));

  if Spike_min>0 & Spike_max>0
clear t clim
if ep==1
      t=-300:501;
      clim=[-100 500 Spike_min*0.8 Spike_max*1.4]; 
elseif ep==2
      t=-500:1001;
      clim=[-200 500 Spike_min*0.4 Spike_max*1.4]; 
elseif ep==3
     t=-500:501;
     clim=[-500 200 Spike_min*0.4 Spike_max*1.4]; 
else
      t=-500:501;
      clim=[-300 400 Spike_min*0.4 Spike_max*1.4]; 
end

subplot(4,3,ep*3-2)     
for d=1:2%4      
        u=0;
    I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;    
  axis(clim);     
end
xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
if ep==1
    title(['Ch',num2str(ch),'Unit',num2str(unit)]);
end

subplot(4,3,ep*3-1)     
for d=1:2%4      
        u=0;
    I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d ;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;    
  axis(clim);     
end
xlabel(['From ',char(Epoch(ep)),' onset']);
if ep==1
     title('Sure')
end

subplot(4,3,ep*3)     
for d=1:2%4      
        u=0;
    I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;    
  axis(clim);     
end
xlabel(['From ',char(Epoch(ep)),' onset']);
if ep==1
     title('Risky')
end% title('Single');
end     


  Spike_TG_All(unit_all,:,:)=(Spike_TG-Spike_min)/(Spike_max-Spike_min);
  Spike_BG_All(unit_all,:,:)=(Spike_BG-Spike_min)/(Spike_max-Spike_min);
  Spike_SC_All(unit_all,:,:)=(Spike_SC-Spike_min)/(Spike_max-Spike_min);
  Spike_RT_All(unit_all,:,:)=(Spike_RT-Spike_min)/(Spike_max-Spike_min);

FigHandle = figure(unit_all);   
print( FigHandle, '-djpeg', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_DV_GS']);
% print( FigHandle, '-depsc', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Dirction']);   

end
end
    end
end

%%
%===============================================
%%%%%% Average across all recordings
%===================================================

% %%%% Align on target onset  
% figure(unit_all+1)
% Epoch={'BG','TG','SC','RT'};
% %%%% Align on target onset  
% for ep=1:4
% clear Spike
% eval(['Spike=Spike_',char(Epoch(ep)),'_All;']);
% clear t clim
% if ep==1
%       t=-100:501;
%       clim=[-100 500 0 1]; 
% elseif ep==2
%       t=-500:501;
%       clim=[-200 500 0 1]; 
% elseif ep==3
%      t=-500:501;
%      clim=[-500 200 0 1];
% else
%       t=-500:501;
%       clim=[-300 400 0 1]; 
% end
% 
% subplot(4,4,ep*4-3)     
% for d=1:2%4      
%         u=0;
%     I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
%     plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(Direction_Color(d)));hold on;    
%   axis(clim);     
% end
% xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
% if ep==1
%     title('All')
% end
% subplot(4,4,ep*4-2)     
% for d=1:2%4      
%         u=0;
%     I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
%     plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(Direction_Color(d)));hold on;    
%   axis(clim);     
% end
% xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
% 
% for d=1:2%4      
%         u=0;
% subplot(4,4,ep*4-2+d)     
%     I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
%     
%     for v=[2,16,17,18]
%         u=u+1;
%         clear I
%            I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
%            plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(V_Color(u)));hold on;
%     end
%   axis(clim);     
% end
% xlabel(['From ',char(Epoch(ep)),' onset']); %title('Choice');
% end  
% FigHandle = figure(unit_all+1);   
% print( FigHandle, '-djpeg', [DirFig,'All_DV']);
