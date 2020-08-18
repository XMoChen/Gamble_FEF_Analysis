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

GS_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0;
GC_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt~=0;
D_I=InfoTrial.TrialType==2 ;
%%% Receptive field in the preferred direction 
PreferIn=(InfoTrial.PreferD==4);
PreferOut=( InfoTrial.PreferD==3);
PreferNeu=( InfoTrial.PreferD==2) | ( InfoTrial.PreferD==1);

PreferV=D4_V_trial+D1_V_trial;


Value_Color={'b:','b','r','r:'};
%  V_all=[0;V_all];


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

  for c=1:3
  v=V_all(u);
  tt(u,:)=nanmean(Spike_TG(ContrastBG'==c ,:),1);
  ss(u,:)=nanmean(Spike_SC(ContrastBG'==c ,:),1);
  bb(u,:)=nanmean(Spike_BG(ContrastBG'==c ,:),1);
  end
  Spike_max=nanmax([tt(:);ss(:);bb(:)]);
  Spike_min=nanmin([tt(:);ss(:);bb(:)]);
 


%%%% Align on target onset  
Spike=Spike_TG;
clim=[-200 500 Spike_min*0.4 Spike_max*1.4]; 

subplot(2,4,2)     
t=-500:501;
for c=1:3     
   v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GS_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(2,4,6)        
for c=1:3      
   v=V_all(u);

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
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
for c=1:3      
   v=V_all(u);

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(2,4,7)        
for c=1:3     
    v=V_all(u);

    I= InfoTrial.SaccadeStart>500 & GC_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Aling on Backgroun onset
 Spike=Spike_BG;

  clim=[-100 500 Spike_min*0.4 Spike_max*1.4]; 

  t=-100:501;
subplot(2,4,1)        
for c=1:3      
   v=V_all(u);

    I= InfoTrial.SaccadeStart>500 & GS_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title({['Ch',num2str(ch),'Unit',num2str(unit)],'Forced choice'});  
     xlabel('From Background onset');    

subplot(2,4,5)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GC_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('Choice');  
     xlabel('From Background onset');   
     

%%%%%% Aling on Result onset
 Spike=Spike_RT;

  clim=[-300 300 Spike_min*0.4 Spike_max*1.4]; 

  t=-500:501;
subplot(2,4,4)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.ResultOn>1000 & GS_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end

subplot(2,4,8)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.ResultOn>1000 & GC_I==1 & ContrastBG'==c;
    plotstd(t,Spike(I,:),char(Contrast_Color(c)));hold on;
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

subplot(2,4,2)     
t=-500:501;
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GS_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(2,4,6)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GC_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
     
%%%%%%%% Align on saccdae onset     

  clim=[-500 200 0 0.9]; 

 t=-500:501;
    
     
     subplot(2,4,3)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GS_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(2,4,7)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GC_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Align on Background onset
 t=-100:501;
  clim=[-100 500 0 0.9]; 

subplot(2,4,1)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GS_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  
     xlabel('From Background onset');    

subplot(2,4,5)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.SaccadeStart>500 & GC_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From background onset');



%%%%%%%%%%%% Align on Result
t=-500:501;
clim=[-300 300 0 0.9]; 

subplot(2,4,4)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.ResultOn>1000 & GS_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  

subplot(2,4,8)        
for c=1:3      
   
    v=V_all(u);
    I= InfoTrial.ResultOn>1000 & GC_I==1 & ContrastBG'==c;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Contrast_Color(c)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From Result onset');

