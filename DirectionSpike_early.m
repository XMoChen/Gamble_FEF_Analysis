%function DirectionSpike(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial','InfoExp');

clear ContrastBG
C1=(mod(InfoTrial.Background,6)==1 | mod(InfoTrial.Background,6)==2);
ContrastBG(C1)=1;
C2=(mod(InfoTrial.Background,6)==3 | mod(InfoTrial.Background,6)==4 );
ContrastBG(C2)=2;
C3=(mod(InfoTrial.Background,6)==5 | mod(InfoTrial.Background,6)==0);
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
V_all=V_all(2:length(V_all));

PreferD=4;


Contrast_Color={'k','b','r'};
% t=-600:901;
% unit_all=0;
% for ch=1:Ch_num
%     for unit=1:length(l_ts(ch,:)-1)
%         if l_ts(ch,unit)>0
%         unit_all=unit_all+1;
%         figure(unit_all)
%         subplot(2,2,1)
% for c=1:3
%     eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
%     plot(t,nanmean(Spike(ContrastBG'==c & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
%         end
%     end
% end
GS_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0;
GC_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt~=0;
D_I=InfoTrial.TrialType==2 ;
%%% Receptive field in the preferred direction 
PreferIn=(InfoTrial.PreferD==4);
PreferOut=( InfoTrial.PreferD==3);
PreferNeu=( InfoTrial.PreferD==2) | ( InfoTrial.PreferD==1);

PreferV=D4_V_trial+D1_V_trial;


Direction_Color={'b','b:','r:','r'};
 V_all=[0;V_all];


%%  
close all
 unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:)-1)
if l_ts(ch,unit)>1000
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

  for d=1:4
  tt(d,:)=nanmean(Spike_TG(InfoTrial.ChoiceD==d ,:),1);
  ss(d,:)=nanmean(Spike_SC(InfoTrial.ChoiceD==d ,:),1);
  bb(d,:)=nanmean(Spike_BG(InfoTrial.ChoiceD==d ,:),1);
  end
  Spike_max=nanmax([tt(:);ss(:);bb(:)]);
  Spike_min=nanmin([tt(:);ss(:);bb(:)]);
 


%%%% Align on target onset  
Spike=Spike_TG;
clim=[-800 500 Spike_min*0.4 Spike_max*1.4]; 

subplot(2,4,2)     
t=-700:501;
clear TargMean
for d=1:4      
        u=0;

    I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
    TargMean(d)=nanmean(nanmean(Spike(I,550:750),2),1);
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
xlabel('From target onset');
%%%% preferred visual direction in FC trials
sTarg=sort(TargMean);
dmax=find(TargMean==sTarg(end));
if dmax<3
    dmin=3-dmax;
else
    dmin=7-dmax;
end
eval(['UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.TargPreferD=dmax;']);   
eval(['UnitInf0.Ch',num2str(ch),'Unit',num2str(unit),'.TargNPreferD=dmin;']);   
 

dmax=find(TargMean==sTarg(end-1));
if dmax<3
    dmin=3-dmax;
else
    dmin=7-dmax;
end
eval(['UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.TargPreferD2=dmax;']);   
eval(['UnitInf0.Ch',num2str(ch),'Unit',num2str(unit),'.TargNPreferD2=dmin;']);

subplot(2,4,6)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
    
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
     
%%%%%%%% Align on saccdae onset     
  clear Spike
  Spike=Spike_SC;

  clim=[-500 200 Spike_min*0.4 Spike_max*1.4]; 

 t=-500:501;
    
     
 subplot(2,4,3)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
    SaccadeMean(d)=nanmean(nanmean(Spike(I,550:750),2),1);

% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     dmax=find(SaccadeMean==max(SaccadeMean));
if dmax<3
    dmin=3-dmax;
else
    dmin=7-dmax;
end
eval(['UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.SaccadePreferD=dmax;']);   
eval(['UnitInf0.Ch',num2str(ch),'Unit',num2str(unit),'.SaccadeNPreferD=dmin;']);  
     
     
     subplot(2,4,7)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Aling on Backgroun onset
if mean(InfoTrial.BackGroundOn)>500
 Spike=Spike_BG;

  clim=[-100 500 Spike_min*0.4 Spike_max*1.4]; 

  t=-100:501;
subplot(2,4,1)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title({['Ch',num2str(ch),'Unit',num2str(unit)],'Forced choice   Direction'});  
     xlabel('From Background onset');    

subplot(2,4,5)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('Choice');  
     xlabel('From Background onset');   
end   

%%%%%% Aling on Result onset
 Spike=Spike_RT;

  clim=[-300 400 Spike_min*0.4 Spike_max*1.4]; 

  t=-500:501;
subplot(2,4,4)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.ResultOn>1000 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end

subplot(2,4,8)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.ResultOn>1000 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('Choice');  
     xlabel('From Result onset');      
     

  Spike_TG_All(unit_all,:,:)=(Spike_TG-Spike_min)/(Spike_max-Spike_min);
  Spike_BG_All(unit_all,:,:)=(Spike_BG-Spike_min)/(Spike_max-Spike_min);
  Spike_SC_All(unit_all,:,:)=(Spike_SC-Spike_min)/(Spike_max-Spike_min);
  Spike_RT_All(unit_all,:,:)=(Spike_RT-Spike_min)/(Spike_max-Spike_min);

FigHandle = figure(unit_all);   
print( FigHandle, '-djpeg', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Dirction']);
% print( FigHandle, '-depsc', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Dirction']);   

end
    end
end

%%
%===============================================
%%%%%% Average across all recordings
%===================================================

%%%% Align on target onset  
figure(unit_all+1)
clim=[-200 500 0 0.9]; 

subplot(2,4,2)     
t=-700:501;
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(2,4,6)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
     
%%%%%%%% Align on saccdae onset     

  clim=[-500 200 0 0.9]; 

 t=-500:501;
    
     
     subplot(2,4,3)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(2,4,7)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Align on Background onset
 t=-100:501;
  clim=[-100 500 0 0.9]; 
if mean(InfoTrial.BackGroundOn)~=0

subplot(2,4,1)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice    Direction');  
     xlabel('From Background onset');    


subplot(2,4,5)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From background onset');

end

%%%%%%%%%%%% Align on Result
t=-500:501;
clim=[-300 300 0 0.9]; 

subplot(2,4,4)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.ResultOn>1000 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  

subplot(2,4,8)        
for d=1:4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.ResultOn>1000 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From Result onset');

FigHandle = figure(unit_all+1);   
print( FigHandle, '-djpeg', [DirFig,'All_Dirction']);
% print( FigHandle, '-depsc', [DirFig,'All_Dirction']);   
save(Spikefile,'UnitInfo','-append');
% for p=1:unit