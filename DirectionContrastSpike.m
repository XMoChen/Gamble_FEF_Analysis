%function TargetSpike(Spikefile)
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
 

%================================ High contrast
%%%% Align on target onset  
Spike=Spike_TG;
clim=[-200 500 Spike_min*0.4 Spike_max*1.4]; 

subplot(4,4,2)     
t=-500:501;
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(4,4,6)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
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
    
     
     subplot(4,4,3)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(4,4,7)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Aling on Backgroun onset
 Spike=Spike_BG;

  clim=[-100 500 Spike_min*0.4 Spike_max*1.4]; 

  t=-100:501;
subplot(4,4,1)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title({['Ch',num2str(ch),'Unit',num2str(unit)],'Forced choice'});  
     xlabel('From Background onset');    

subplot(4,4,5)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('Choice');  
     xlabel('From Background onset');   
     

%%%%%% Aling on Result onset
 Spike=Spike_RT;

  clim=[-300 300 Spike_min*0.4 Spike_max*1.4]; 

  t=-500:501;
subplot(4,4,4)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end

subplot(4,4,8)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('Choice');  
     xlabel('From Result onset');      
 
     
 %================== only blank background
 %%%% Align on target onset  
Spike=Spike_TG;
clim=[-200 500 Spike_min*0.4 Spike_max*1.4]; 

subplot(4,4,10)     
t=-500:501;
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(4,4,14)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
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
    
     
     subplot(4,4,11)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(4,4,15)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Aling on Backgroun onset
 Spike=Spike_BG;

  clim=[-100 500 Spike_min*0.4 Spike_max*1.4]; 

  t=-100:501;
subplot(4,4,9)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title({['Ch',num2str(ch),'Unit',num2str(unit)],'Forced choice'});  
     xlabel('From Background onset');    

subplot(4,4,13)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('Choice');  
     xlabel('From Background onset');   
     

%%%%%% Aling on Result onset
 Spike=Spike_RT;

  clim=[-300 300 Spike_min*0.4 Spike_max*1.4]; 

  t=-500:501;
subplot(4,4,12)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end

subplot(4,4,16)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
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

end
    end
end


%%
%===============================================
%%%%%% Average across all recordings
%===================================================

%%%% Align on target onset  
figure()
clim=[-200 500 0 0.9]; 

subplot(4,4,2)     
t=-500:501;
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(4,4,6)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
     
%%%%%%%% Align on saccdae onset     

  clim=[-500 200 0 0.9]; 

 t=-500:501;
    
     
     subplot(4,4,3)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(4,4,7)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Align on Background onset
 t=-100:501;
  clim=[-100 500 0 0.9]; 

subplot(4,4,1)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  
     xlabel('From Background onset');    

subplot(4,4,5)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From background onset');



%%%%%%%%%%%% Align on Result
t=-500:501;
clim=[-300 300 0 0.9]; 

subplot(4,4,4)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GS_I==1 & InfoTrial.ChoiceD==d &  ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  

subplot(4,4,8)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'>1;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From Result onset');

%======== Background

subplot(4,4,10)     
t=-500:501;
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(4,4,14)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
     
%%%%%%%% Align on saccdae onset     

  clim=[-500 200 0 0.9]; 

 t=-500:501;
    
     
     subplot(4,4,11)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(4,4,15)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Align on Background onset
 t=-100:501;
  clim=[-100 500 0 0.9]; 

subplot(4,4,9)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  
     xlabel('From Background onset');    

subplot(4,4,13)        
for d=1:4      
        u=0;

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From background onset');



%%%%%%%%%%%% Align on Result
t=-500:501;
clim=[-300 300 0 0.9]; 

subplot(4,4,12)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GS_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  

subplot(4,4,16)        
for d=1:4      
        u=0;

    I= InfoTrial.ResultOn>1000 & GC_I==1 & InfoTrial.ChoiceD==d & ContrastBG'==1;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Direction_Color(d)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From Result onset');