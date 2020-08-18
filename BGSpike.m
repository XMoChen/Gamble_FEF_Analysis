%function TargetSpike(Spikefile)
%%%% dock the figures
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'BackgroundRate','BackgroundHist','l_ts')
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

DPrefer_V_trial=D1_V_trial ;
PreferD=4;


SingleGI=(InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0);
ChoiceGI=(InfoTrial.TrialType==1);
DI=InfoTrial.TrialType==2;

Contrast_Color={'k','b','r'};

GS_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0;
GC_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt~=0;
D_I=InfoTrial.TrialType==2 ;
%%% Receptive field in the preferred direction 
PreferIn=(InfoTrial.PreferD==4);
PreferOut=(InfoTrial.PreferD==3);
PreferNeu=(InfoTrial.PreferD==1 | (InfoTrial.PreferD==2));

PreferV=D4_V_trial;


Value_Color={'b:','b','r','r:'};
t=-100:501;
unit_all=0;
% for ch=1:Ch_num
%     for unit=2:length(l_ts(ch,:)-1)
% if l_ts(ch,unit)>1000 
%   unit_all=unit_all+1;  
%   eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
%   Spike0=Spike;
%   II=~isnan(Spike(:));Spike0(II)=zscore(Spike(II));
%   Spike_All(unit_all,:,:)=reshape(Spike0,size(Spike,1),size(Spike,2));
%   figure(unit_all)
%   I_s=InfoTrial.TargetOn>500 ;
% 
%   a=nanmean(Spike(ContrastBG'==3 & GS_I==1 & PreferV==4 & PreferIn & InfoTrial.TargetOn>500,:),1);
%   clim=[-100 500 min(a)*0.8 max(a)*1.5];
%   
% u=0;  
% for v=V_all'
%   u=u+1;
%   subplot(4,4,u)        
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GS_I==1 & PreferV==v & PreferIn & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
% if u==1
%  legend({'Blank','C_M','C_H'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit),' ',num2str(v)]);            
% 
% else
% title(num2str(v));
% end
%   axis(clim);  
% end
% 
% u=0;  
% for v=V_all'
%   u=u+1;
%   subplot(4,4,u+4)         
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GS_I==1 & PreferV==v & PreferOut & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
% %  legend({'Blanck','Mid C','High C'});
% %  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
%   axis(clim); 
% end
%   
%   
% u=0;  
% for v=V_all'
%   u=u+1;
%   subplot(4,4,u+8)        
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GC_I==1 & PreferV==v & PreferIn & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
% %  legend({'Blanck','Texture'});
% %  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
%   axis(clim);  
% end
%   
% u=0;  
% for v=V_all'
%   u=u+1;
%   subplot(4,4,u+12)         
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GC_I==1 & PreferV==v & PreferOut & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
% %  legend({'Blank','Texture'});
% %  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
%   axis(clim);
%   
% end
% end
%     end
% end

%%
Value_Color={'k','b:','b','r','r:'};
 V_all=[0;V_all];
t=-100:501;
unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:)-1)
if l_ts(ch,unit)>1000 
  unit_all=unit_all+1;  
  eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike0=Spike;
  II=~isnan(Spike(:));Spike0(II)=zscore(Spike(II));
  Spike_All(unit_all,:,:)=reshape(Spike0,size(Spike,1),size(Spike,2));
  figure(unit_all)
  I_s=InfoTrial.TargetOn>500 ;

  a=nanmean(Spike(ContrastBG'==3 & GS_I==1 & PreferV==4 & PreferIn & InfoTrial.TargetOn>500,:),1);
  clim=[-100 500 min(a)*0.8 max(a)*1.5];
  
  subplot(231)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(Spike(ContrastBG'==1 & GS_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);
subplot(232)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(Spike(ContrastBG'==2  & GS_I==1 & PreferV==c0 & InfoTrial.TargetOn>500,:));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);
%   axis([-inf inf -0.5 1])

 subplot(233)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(Spike(ContrastBG'==3  & GS_I==1 & PreferV==c0 & InfoTrial.TargetOn>500,:));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);
 
    subplot(234)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(Spike(ContrastBG'==1 & GC_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);
subplot(235)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(Spike(ContrastBG'==2 & GC_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:));
    plotstd(t,a,char(Value_Color(c)));hold on;
end         
  axis(clim);

 subplot(236)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze((Spike(ContrastBG'==3 & GC_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:)));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);
  
  
  
%   subplot(2,3,1)        
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GS_I==1  & PreferIn & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
%  legend({'Blank','C_M','C_H'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit),' ',num2str(v)]);            
%   axis(clim);  
% 
% 
% 
%   subplot(2,3,2)         
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GS_I==1  & PreferOut & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
%            
%   axis(clim); 
% 
% 
%   subplot(2,3,3)         
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GS_I==1  & PreferNeu & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end          
%   axis(clim);   
% 
%   subplot(2,3,4)        
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GC_I==1  & PreferIn & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
%   axis(clim);  
% 
%   subplot(2,3,5)         
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GC_I==1  & PreferOut & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
%   axis(clim);  
%   
%     subplot(2,3,6)         
% for c=1:3
%     plot(t,nanmean(Spike(ContrastBG'==c & GC_I==1  & PreferNeu & InfoTrial.TargetOn>500,:),1),char(Contrast_Color(c)));hold on;
% end
%   axis(clim);

%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            

end
    end
end
%%
Spike=squeeze(nanmean(Spike_All,1));
clim=[ min(t) 500 mean(nanmean(Spike,1))-5*std(nanmean(Spike,1))   mean(nanmean(Spike,1))+10*std(nanmean(Spike,1))];
figure()
 subplot(231)      
for c=1:3
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GS_I==1  & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end

 legend({'Blanck','Texture'});
 title(['Ch',num2str(ch),'Unit',num2str(unit),' Prefer']);            

  axis(clim);  



subplot(232)         
for c=1:3
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c  & GS_I==1 & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blanck','Mid C','High C'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);   
title('NonPrefer');
axis(clim); 
  
subplot(233)         
for c=1:3
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c  & GS_I==1 & PreferNeu & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blanck','Mid C','High C'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);   
title('Ortho');
axis(clim);   

  subplot(234)        
for c=1:3
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1  & PreferIn & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blanck','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);  

   
  subplot(235)         
for c=1:3
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1  & PreferOut & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);
  
    subplot(236)         
for c=1:3
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==c & GC_I==1  & PreferNeu & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Contrast_Color(c)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);

%%  

 
  figure()
  subplot(231)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==1 & GS_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);
subplot(232)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==2  & GS_I==1 & PreferV==c0 & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);
%   axis([-inf inf -0.5 1])

 subplot(233)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==3  & GS_I==1 & PreferV==c0 & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);
 
    subplot(234)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==1 & GC_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);
subplot(235)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==2 & GC_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
%  legend({'Blank','Texture'});
%  title(['Ch',num2str(ch),'Unit',num2str(unit)]);            
  axis(clim);
%   axis([-inf inf -0.5 1])

 subplot(236)
for c=1:5
    c0=V_all(c);
    clear a
    a=squeeze(nanmean(Spike_All(:,ContrastBG'==3 & GC_I==1  & PreferV==c0 & InfoTrial.TargetOn>500,:),2));
    plotstd(t,a,char(Value_Color(c)));hold on;
end
  axis(clim);