% function ValueSpike(Spikefile,Eventfile,DirFig,Ch_num)
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
V_all=V_all;

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
V_all=V_all;


%%  
close all
 unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
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

  for u=1:4
  v=V_all(u);
  tt(u,:)=nanmean(Spike_TG(InfoTrial.ChoiceOpt==v ,:),1);
  ss(u,:)=nanmean(Spike_SC(InfoTrial.ChoiceOpt==v ,:),1);
  bb(u,:)=nanmean(Spike_BG(InfoTrial.ChoiceOpt==v ,:),1);
  end
  Spike_max=nanmax([tt(:);ss(:);bb(:)]);
  Spike_min=nanmin([tt(:);ss(:);bb(:)]);
 


%%%% Align on target onset  
Spike=Spike_TG;
clim=[-200 500 Spike_min*0.4 Spike_max*1.4]; 

subplot(2,4,2)     
t=-500:501;
for u=1:4     
   v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(2,4,6)        
for u=1:4      
   v=V_all(u);

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
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
for u=1:4      
   v=V_all(u);

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(2,4,7)        
for u=1:4     
    v=V_all(u);

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Aling on Backgroun onset
 Spike=Spike_BG;

  clim=[-100 500 Spike_min*0.4 Spike_max*1.4]; 

  t=-100:501;
subplot(2,4,1)        
for u=1:4      
   v=V_all(u);

     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title({['Ch',num2str(ch),'Unit',num2str(unit)],'Forced choice , Value'});  
     xlabel('From Background onset');    

subplot(2,4,5)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
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
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.ResultOn>1000 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end

subplot(2,4,8)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.ResultOn>1000 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
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
print( FigHandle, '-djpeg', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Value']);

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
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
subplot(2,4,6)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_TG_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From target onset');
     
     
%%%%%%%% Align on saccdae onset     

  clim=[-500 200 0 0.9]; 

 t=-500:501;
    
     
     subplot(2,4,3)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');
     
     
     
     subplot(2,4,7)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_SC_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     xlabel('From saccade onset');



%%%%%% Align on Background onset
 t=-100:501;
  clim=[-100 500 0 0.9]; 

subplot(2,4,1)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice, Value');  
     xlabel('From Background onset');    

subplot(2,4,5)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_BG_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From background onset');



%%%%%%%%%%%% Align on Result
t=-500:501;
clim=[-300 300 0 0.9]; 

subplot(2,4,4)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
     title('All Forced Choice');  

subplot(2,4,8)        
for u=1:4      
   
    v=V_all(u);
     I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceOpt==v;
    plotstd(t,squeeze(nanmean(Spike_RT_All(:,I,:),2)),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
title('Choice');
xlabel('From Result onset');

FigHandle = figure(unit_all+1);   
print( FigHandle, '-djpeg', [DirFig,'All_Value']);