%function TargetSpike(Spikefile)
%%%% dock the figures
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'TargetRate','TargetHist','l_ts')
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


Value_Color={'k','b:','b','r','r:'};
t=-500:501;
 V_all=[0;V_all];


%%  
close all
 unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:)-1)
if l_ts(ch,unit)>1000
  unit_all=unit_all+1;   
  figure(unit_all)
  clear Spike
  eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  a=Spike(D_V_trial(:,d)==v & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.TargetOn>500,:);
%   clim=[-100 500 min(a)*0.8 max(a)*1.5]; 
  
  clim=[ -200 500 mean(nanmean(Spike,1))-5*std(nanmean(Spike,1))   mean(nanmean(Spike,1))+10*std(nanmean(Spike,1))];

for d=1:4      
subplot(2,4,d)        
        u=0;
for v=V_all'
    u=u+1;
    plotstd(t,Spike(PreferV==v & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.TargetOn>500,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
  axis(clim);     
end
if d==1
     title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
end
end





for d=1:4      
subplot(2,4,4+d)        
        u=0;
for v=V_all'
    u=u+1;
    eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
    plotstd(t,Spike(PreferV==v  & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.TargetOn>500,:),char(Value_Color(u)));hold on;
% sum(DPrefer_V_trial==v  & InfoTrial.TargetOn>500)
    %axis([-600 50 0 inf])
  axis(clim);     
end
end
title('Movement toward C')
     

end
    end
end

%%
figure()
u=0;  
Spike=squeeze(nanmean(Spike_All,1));
clim=[ min(t) 0 mean(nanmean(Spike,1))-5*std(nanmean(Spike,1))   mean(nanmean(Spike,1))+10*std(nanmean(Spike,1))];

for v=V_all'
  u=u+1;
  subplot(4,4,u)        
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GS_I==1 & PreferV==v & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
if u==1
 legend({'Blanck','Texture'});
 title(['Ch',num2str(ch),'Unit',num2str(unit),' ',num2str(v)]);            

else
title(num2str(v));
end
  axis(clim);  
end

u=0;  
for v=V_all'
  u=u+1;
  subplot(4,4,u+4)         
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GS_I==1 & PreferV==v & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blanck','Mid C','High C'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim); 
end
  
  
u=0;  
for v=V_all'
  u=u+1;
  subplot(4,4,u+8)        
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1 & PreferV==v & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blanck','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);  
end
  
u=0;  
for v=V_all'
  u=u+1;
  subplot(4,4,u+12)         
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1 & PreferV==v & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);
end


%%
figure()
Spike=squeeze(nanmean(Spike_All,1));
clim=[ min(t) 700 mean(nanmean(Spike,1))-5*std(nanmean(Spike,1))   mean(nanmean(Spike,1))+10*std(nanmean(Spike,1))];


for c=1:2
  subplot(2,4,c) 
  u=0;
for v=V_all'
  u=u+1;
       
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GS_I==1 & PreferV==v & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(u)));hold on;
end
if u==1
 legend({'Blanck','Texture'});
 title(['Ch',num2str(ch),'Unit',num2str(unit),' ',num2str(v)]);            

else
title(num2str(v));
end
  axis(clim);  
end

for c=1:2
  subplot(2,4,c+2)         
u=0;
for v=V_all'
  u=u+1;
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GS_I==1 & PreferV==v & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(u)));hold on;
end
%  legend({'Blanck','Mid C','High C'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim); 
end
  
  
for c=1:2
  subplot(2,4,c+4) 
  u=0;
for v=V_all'
  u=u+1;
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1 & PreferV==v & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(u)));hold on;
end
%  legend({'Blanck','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);  
end
  
  
for c=1:2
  subplot(2,4,c+6) 
  u=0;
for v=V_all'
  u=u+1;

    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1 & PreferV==v & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(u)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);
end
%%
figure()
 subplot(221)      
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GS_I==1  & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end

 legend({'Blanck','Texture'});
 title(['Ch',num2str(ch),'Unit',num2str(unit),' Prefer']);            

  axis(clim);  



subplot(222)         
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c  & GS_I==1 & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blanck','Mid C','High C'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);   
title('NonPrefer');
axis(clim); 
  
  

  subplot(223)        
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1  & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blanck','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);  

   
  subplot(224)         
for c=1:2
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1  & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);
