% function PreferedSpikeTarg(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts','UnitInfo')
load(Eventfile,'InfoTrial','InfoExp');

clear ContrastBG
C1=(mod(InfoTrial.Background,6)==1 | mod(InfoTrial.Background,6)==2);
ContrastBG(C1)=1;
C2=(mod(InfoTrial.Background,6)==3 | mod(InfoTrial.Background,6)==4 );
ContrastBG(C2)=2;
C3=(mod(InfoTrial.Background,6)==5 | mod(InfoTrial.Background,6)==0);
ContrastBG(C3)=3;
ContrastBG= ContrastBG';

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
%     plot(t,nanmean(Spike(ContrastBG'==c & InfoTrial.SaccadeStart>500,:),1),char(Contrast_Color(c)));hold on;
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


Value_Color={'b:','b','r','r:'};
 V_all=[V_all]';


%%  
close all
 unit_all=0;
for ch=13%1:Ch_num
    for unit=4%2:length(l_ts(ch,:)-1)
if l_ts(ch,unit)>1000
  unit_all=unit_all+1;   
  figure(unit_all)
  
  
  
  eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike_TG=Spike;
  eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike_BG=Spike;

 eval(['Targ_dmax=UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.TargPreferD;']);   

  I1= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & GC_I==1 &  ContrastBG>1 & InfoTrial.DOpt(:,Targ_dmax)==4;
  I2= InfoTrial.Repeat==0 & InfoTrial.TargetOn>500 & GC_I==1 &  ContrastBG>1 & InfoTrial.DOpt(:,Targ_dmax)==11;

  bb1=nanmean(Spike_BG(I1 ,:),1);
  bb2=nanmean(Spike_BG(I2 ,:),1);
  tt1=nanmean(Spike_TG(I1 ,:),1);
  tt2=nanmean(Spike_TG(I2 ,:),1);
  Spike_max=nanmax([tt1,tt2,bb1,bb2]);
  Spike_min=nanmin([tt1,tt2,bb1,bb2]);
  
  
  
  %%%%%% Aling on Target onset
 Spike=Spike_TG;

  clim=[-500 500 Spike_min*0.4 Spike_max*1.4]; 

t=-500:501;
u=0;
for v= V_all      
        u=u+1;
subplot(2,2,1) 

 I= InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1  & InfoTrial.DOpt(:,Targ_dmax)==v;
 AllTarg.FC_ProV(unit_all,u,:)=nan(1,1002);
 if sum(I)>5
 plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
 title({['Ch',num2str(ch),'Unit',num2str(unit)],'FC  Chosen'});  
 xlabel('From Target onset');
 axis(clim);  
 AllTarg.FC_ProV(unit_all,u,:)=(nanmean(Spike(I,:),1)-Spike_min)/(Spike_max-Spike_min);
end

 
  subplot(2,2,2) 
  clear I
  I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500  & GC_I==1 & InfoTrial.PreferD==Targ_dmax & InfoTrial.DOpt(:,Targ_dmax)==v;
  Rate(u)=nanmean(InfoTrial.DRate(I,Targ_dmax));
  AllTarg.C_ProV(unit_all,u,:)=nan(1,1002);
if sum(I)
  plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.SaccadeStart>500)
  axis(clim);     
  title('2AFC  Chosen');  
  xlabel('From Target onset'); 
  AllTarg.C_ProV(unit_all,u,:)=(nanmean(Spike(I,:),1)-Spike_min)/(Spike_max-Spike_min);
end
  
  subplot(2,2,4) 
  clear I
   AllTarg.C_AwyV(unit_all,u,:)=nan(1,1002);
  I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500  & GC_I==1 & InfoTrial.PreferD~=Targ_dmax & InfoTrial.DOpt(:,Targ_dmax)==v;
  if sum(I)>5
  plotstd(t,Spike(I,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.SaccadeStart>500)
  axis(clim);     
  title('2AFC  NChosen');  
  xlabel('From Target onset'); 
  AllTarg.C_AwyV(unit_all,u,:)=(nanmean(Spike(I,:),1)-Spike_min)/(Spike_max-Spike_min);
  end
  
  

FigHandle = figure(unit_all);   
print( FigHandle, '-djpeg', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_TargPrefer']);
  
end

     
end
    end
end

%%
%%%%% Summary
figure(unit_all+1)
clim=[-200 500 0.1 0.9];
for u=1:4
subplot(2,2,1) 
  clear r
  r=squeeze(AllTarg.FC_ProV(:,u,:));
  plotstd(t,r,char(Value_Color(u)));hold on;
 title('All FC  Chosen');  
 xlabel('From Target onset');
 axis(clim);  
 
 
  subplot(2,2,2) 
  clear r
  r=squeeze(AllTarg.C_ProV(:,u,:));
  plotstd(t,r,char(Value_Color(u)));hold on;
  axis(clim);     
  title('2AFC  Chosen');  
  xlabel('From Target onset'); 

  
  subplot(2,2,4) 
  clear r
  r=squeeze(AllTarg.C_AwyV(:,u,:));
  plotstd(t,r,char(Value_Color(u)));hold on;
  axis(clim);     
  title('2AFC  NChosen');  
  xlabel('From Target onset'); 
  
  
  
end
FigHandle = figure(unit_all+1);   
print( FigHandle, '-djpeg', [DirFig,'All_TargPrefer']);