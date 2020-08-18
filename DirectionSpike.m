%function DirectionSpike(Spikefile,Eventfile,DirFig,Ch_num)
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

  for d=1:2%4
  tt(d,:)=nanmean(Spike_TG(InfoTrial.ChoiceD==d ,:),1);
  ss(d,:)=nanmean(Spike_SC(InfoTrial.ChoiceD==d ,:),1);
  bb(d,:)=nanmean(Spike_BG(InfoTrial.ChoiceD==d ,:),1);
  end
  Spike_max=nanmax([tt(:);ss(:);bb(:)]);
  Spike_min=nanmin([tt(:);ss(:);bb(:)]);
 


%%%% Align on target onset  
Spike=Spike_TG;
clim=[-200 500 Spike_min*0.4 Spike_max*1.4]; 

subplot(2,4,2)     
t=-500:501;
clear TargMean
for d=1:2%4      
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
Targ_prefer(unit_all,1)=dmax;
Targ_nprefer(unit_all,1)=dmin; 

dmax=find(TargMean==sTarg(end-1));
if dmax<3
    dmin=3-dmax;
else
    dmin=7-dmax;
end
eval(['UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.TargPreferD2=dmax;']);   
eval(['UnitInf0.Ch',num2str(ch),'Unit',num2str(unit),'.TargNPreferD2=dmin;']);
Targ_prefer(unit_all,2)=dmax;
Targ_nprefer(unit_all,2)=dmin;


subplot(2,4,6)        
for d=1:2%4      
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
for d=1:2%4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
    SaccadeMean(d)=nanmean(nanmean(Spike(I,550:750),2),1);

% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
sSaccade=sort(SaccadeMean);
dmax=find(SaccadeMean==max(SaccadeMean));
if dmax<3
    dmin=3-dmax;
else
    dmin=7-dmax;
end
eval(['UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.SaccadePreferD=dmax;']);   
eval(['UnitInf0.Ch',num2str(ch),'Unit',num2str(unit),'.SaccadeNPreferD=dmin;']);  
Sac_prefer(unit_all,1)=dmax;
Sac_nprefer(unit_all,1)=dmin;   

dmax=find(SaccadeMean==sSaccade(end-1));
if dmax<3
    dmin=3-dmax;
else
    dmin=7-dmax;
end
eval(['UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.SaccadePreferD2=dmax;']);   
eval(['UnitInf0.Ch',num2str(ch),'Unit',num2str(unit),'.SaccadeNPreferD2=dmin;']);
Sac_prefer(unit_all,2)=dmax;
Sac_nprefer(unit_all,2)=dmin; 
     
     subplot(2,4,7)        
for d=1:2%4      
        u=0;

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Aling on Backgroun onset
if mean(InfoTrial.BackGroundOn)~=0
 Spike=Spike_BG;

  clim=[-100 500 Spike_min*0.4 Spike_max*1.4]; 

  t=-100:501;
subplot(2,4,1)        
for d=1:2%4      
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
for d=1:2%4      
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
t=-500:501;
for d=1:2%4      
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
for d=1:2%4      
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
for d=1:2%4      
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
for d=1:2%4      
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

%%
%%%% Align on target onset  


for n=1:unit_all      
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_S_BG(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    TargNPrefer_S_BG(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;    
    clear I
    I= InfoTrial.FixationOff>500 & ContrastBG' >1 & GC_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_G_BG(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.FixationOff>500  & ContrastBG' >1 & GC_I==1 & InfoTrial.PreferD==Targ_nprefer(n,1);
    TargNPrefer_G_BG(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;    
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_S_Bk(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    TargNPrefer_S_Bk(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;    
    clear I
    I=  InfoTrial.FixationOff>500 & ContrastBG' ==1 & GC_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_G_Bk(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I=  InfoTrial.FixationOff>500  & ContrastBG' ==1 & GC_I==1 & InfoTrial.PreferD==Targ_nprefer(n,1);
    TargNPrefer_G_Bk(n,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;        
end

for n=1:unit_all      
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_S_BG(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    BGNPrefer_S_BG(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;   
    clear I
    I= InfoTrial.TargetOn>500 & ContrastBG' >1 & GC_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_G_BG(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.TargetOn>500  & ContrastBG' >1 & GC_I==1 & InfoTrial.PreferD==Targ_nprefer(n,1);
    BGNPrefer_G_BG(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;    
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_S_Bk(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    BGNPrefer_S_Bk(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I=  InfoTrial.TargetOn>500 & ContrastBG' ==1 & GC_I==1 & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_G_Bk(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I=  InfoTrial.TargetOn>500  & ContrastBG' ==1 & GC_I==1 & InfoTrial.PreferD==Targ_nprefer(n,1);
    BGNPrefer_G_Bk(n,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;    
end


figure(unit_all+2)
t=-100:501;
clim=[-100 500 0 1.2]; 
subplot(2,2,1) 
plotstd(t,BGPrefer_S_Bk,'k');hold on;
plotstd(t,BGNPrefer_S_Bk,'k:');hold on;
axis(clim);     
title('FC Blank');
xlabel('From target onset');
subplot(2,2,3) 
plotstd(t,BGPrefer_G_Bk,'k');hold on;
plotstd(t,BGNPrefer_G_Bk,'k:');hold on;
axis(clim);     
title('2AFC Blank');
subplot(2,2,2) 
plotstd(t,BGPrefer_S_BG,'k');hold on;
plotstd(t,BGNPrefer_S_BG,'k:');hold on;
axis(clim);     
title('FC BG');
subplot(2,2,4) 
plotstd(t,BGPrefer_G_BG,'k');hold on;
plotstd(t,BGNPrefer_G_BG,'k:');hold on;
axis(clim);     
title('2AFC BG');
FigHandle = figure(unit_all+2);   
print( FigHandle, '-djpeg', [DirFig,'BG_Dirction']);



figure(unit_all+3)
t=-500:501;
clim=[-100 500 0 1.2]; 
subplot(2,2,1) 
plotstd(t,TargPrefer_S_Bk,'k');hold on;
plotstd(t,TargNPrefer_S_Bk,'k:');hold on;
axis(clim);     
title('FC Blank');
xlabel('From target onset');
subplot(2,2,3) 
plotstd(t,TargPrefer_G_Bk,'k');hold on;
plotstd(t,TargNPrefer_G_Bk,'k:');hold on;
axis(clim);     
title('2AFC Blank');
subplot(2,2,2) 
plotstd(t,TargPrefer_S_BG,'k');hold on;
plotstd(t,TargNPrefer_S_BG,'k:');hold on;
axis(clim);     
title('FC BG');
subplot(2,2,4) 
plotstd(t,TargPrefer_G_BG,'k');hold on;
plotstd(t,TargNPrefer_G_BG,'k:');hold on;
axis(clim);     
title('2AFC BG');
FigHandle = figure(unit_all+3);   
print( FigHandle, '-djpeg', [DirFig,'Targ_Dirction']);
%%
for n=1:unit_all 
    vv=0;
    for v=V_all'
        vv=vv+1;
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_S_BG_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v &  InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    TargNPrefer_S_BG_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;    
    clear I
    I= InfoTrial.FixationOff>500 & ContrastBG' >1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_G_BG_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.FixationOff>500  & ContrastBG' >1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_nprefer(n,1);
    TargNPrefer_G_BG_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;    
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_S_Bk_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.FixationOff>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    TargNPrefer_S_Bk_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;    
    clear I
    I=  InfoTrial.FixationOff>500 & ContrastBG' ==1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    TargPrefer_G_Bk_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;
    clear I
    I=  InfoTrial.FixationOff>500  & ContrastBG' ==1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_nprefer(n,1);
    TargNPrefer_G_Bk_V(n,vv,:)=squeeze(nanmean(Spike_TG_All(n,I,:),2));hold on;    
    end
end

for n=1:unit_all 
    vv=0;
    for v=V_all([2,3,5,4])'
        vv=vv+1;
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_S_BG_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' >1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    BGNPrefer_S_BG_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.TargetOn>500 & ContrastBG' >1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_G_BG_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.TargetOn>500  & ContrastBG' >1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_nprefer(n,1);
    BGNPrefer_G_BG_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_S_Bk_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & ContrastBG' ==1 & GS_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.DChoice(:,Targ_nprefer(n,1))==1;
    BGNPrefer_S_Bk_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I=  InfoTrial.TargetOn>500 & ContrastBG' ==1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_prefer(n,1);
    BGPrefer_G_Bk_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    clear I
    I=  InfoTrial.TargetOn>500  & ContrastBG' ==1 & GC_I==1 & InfoTrial.DOpt(:,Targ_prefer(n,1))==v & InfoTrial.PreferD==Targ_nprefer(n,1);
    BGNPrefer_G_Bk_V(n,vv,:)=squeeze(nanmean(Spike_BG_All(n,I,:),2));hold on;
    end
end

%%
figure(unit_all+4)
t=-100:501;
clim=[-100 500 0 1.2]; 
u=0;
for vv=[2,3,5,4]
u=u+1;
Opt{u}=num2str(V_all(vv));
if V_all(vv)==11
  Opt{u}='0/6';
elseif V_all(vv)==13
  Opt{u}='2/4';
end
end
for vv=1:4
subplot(4,4,vv) 
plotstd(t,squeeze(BGPrefer_S_Bk_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(BGNPrefer_S_Bk_V(:,vv,:)),'k:');hold on;
axis(clim);     
if vv==1
title(['FC Blank Opt=',char(Opt(vv))]);
else
title(['Opt=',char(Opt(vv))]);
end
xlabel('From backgrounds onset');
subplot(4,4,4+vv) 
plotstd(t,squeeze(BGPrefer_S_BG_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(BGNPrefer_S_BG_V(:,vv,:)),'k:');hold on;
axis(clim); 
if vv==1
title('FC BG');
end
subplot(4,4,8+vv) 
plotstd(t,squeeze(BGPrefer_G_Bk_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(BGNPrefer_G_Bk_V(:,vv,:)),'k:');hold on;
axis(clim);  
if vv==1
title('2AFC Blank');
end
subplot(4,4,12+vv) 
plotstd(t,squeeze(BGPrefer_G_BG_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(BGNPrefer_G_BG_V(:,vv,:)),'k:');hold on;
axis(clim); 
if vv==1
title('2AFC Blank');
end
end
FigHandle = figure(unit_all+4);   
print( FigHandle, '-djpeg', [DirFig,'BG_Opt']);
%%
figure(unit_all+5)
t=-500:501;
clim=[-100 500 0 1.2]; 
for vv=1:4
subplot(4,4,vv) 
plotstd(t,squeeze(TargPrefer_S_Bk_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(TargNPrefer_S_Bk_V(:,vv,:)),'k:');hold on;
axis(clim);     
if vv==1
title(['FC Blank Opt=',char(Opt(vv))]);
else
title(['Opt=',char(Opt(vv))]);
end
xlabel('From target onset');
subplot(4,4,4+vv) 
plotstd(t,squeeze(TargPrefer_S_BG_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(TargNPrefer_S_BG_V(:,vv,:)),'k:');hold on;
axis(clim);    
if vv==1
title('FC BG');
end
xlabel('From target onset');
subplot(4,4,8+vv) 
plotstd(t,squeeze(TargPrefer_G_Bk_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(TargNPrefer_G_Bk_V(:,vv,:)),'k:');hold on;
axis(clim);    
if vv==1
title('2AFC Blank');
end
subplot(4,4,12+vv) 
plotstd(t,squeeze(TargPrefer_G_BG_V(:,vv,:)),'k');hold on;
plotstd(t,squeeze(TargNPrefer_G_BG_V(:,vv,:)),'k:');hold on;
axis(clim); 
if vv==1
title('2AFC BG');
end
end
FigHandle = figure(unit_all+5);   
print( FigHandle, '-djpeg', [DirFig,'Targ_Opt']);