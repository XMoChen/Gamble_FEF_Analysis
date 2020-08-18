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
InfoTrial.BackGroundLevel=ContrastBG';

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
ChosenPercScale=zeros(size(InfoTrial,1),1);
ChosenPercScale(InfoTrial.ChosenPerc>0 & InfoTrial.ChosenPerc<=30)=1;
ChosenPercScale(InfoTrial.ChosenPerc>30 & InfoTrial.ChosenPerc<=60)=2;
ChosenPercScale(InfoTrial.ChosenPerc>60 & InfoTrial.ChosenPerc<=90)=3;
ChosenPercScale(InfoTrial.ChosenPerc>100 & InfoTrial.ChosenPerc<=130)=4;
ChosenPercScale(InfoTrial.ChosenPerc>130 & InfoTrial.ChosenPerc<=160)=5;
ChosenPercScale(InfoTrial.ChosenPerc>160 & InfoTrial.ChosenPerc<=190)=6;
InfoTrial.ChosenPercScale=ChosenPercScale;

PreferD=1;

GS_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0 & InfoTrial.Reward==2  ;
GC_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt~=0 & InfoTrial.Reward>0;
D_I=InfoTrial.TrialType==2 ;
Gamble_I=InfoTrial.ChosenPerc>=100;
Sure_I=InfoTrial.ChosenPerc<100;
GambleChoicePerc=(InfoTrial.ChosenPerc-100).*Gamble_I;
SureChoicePerc=InfoTrial.ChosenPerc.*Sure_I;

%%% Receptive field in the preferred direction 
PreferIn=(InfoTrial.PreferD==1);
PreferOut=( InfoTrial.PreferD==2);

PreferV=D4_V_trial+D1_V_trial;


Direction_Color={'k','k:'};
 V_all=[0;V_all];
V_Color={'g','b','r'};


%%  
close all
 unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
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
clear Spike tt Spike_max Spike_min b_S p_S b_CS p_CS b_CR p_CR
eval(['Spike=Spike_',char(Epoch(ep)),';']);

  
clear t clim
if ep==1
      t=-100:501;
      clim=[-100 500 -inf inf]; 
elseif ep==2
      t=-500:501;
      clim=[-200 500 -inf inf]; 
elseif ep==3
     t=-500:501;
     clim=[-500 200 -inf inf]; 
else
      t=-500:501;
      clim=[-300 400 -inf inf]; 
end

SpikeS=Spike(GS_I,:);
% XS=[ones(sum(GS_I),1),InfoTrial.BackGroundLevel(GS_I)/3,InfoTrial.ChoiceD(GS_I)/2];
XS=[InfoTrial.BackGroundLevel(GS_I)/3,InfoTrial.ChoiceD(GS_I)/2];

SpikeCSure=Spike(GC_I & Sure_I,:);
SureChoicePerc1=(SureChoicePerc(GC_I & Sure_I)/90).*(InfoTrial.ChoiceD(GC_I & Sure_I)==1);
SureChoicePerc2=(SureChoicePerc(GC_I & Sure_I)/90).*(InfoTrial.ChoiceD(GC_I & Sure_I)==2);
% XCSure=[ones(sum(GC_I & Sure_I),1),InfoTrial.BackGroundLevel(GC_I & Sure_I)/3,InfoTrial.ChoiceD(GC_I & Sure_I)/2,SureChoicePerc1,SureChoicePerc2];
XCSure=[InfoTrial.BackGroundLevel(GC_I & Sure_I)/3,InfoTrial.ChoiceD(GC_I & Sure_I)/2,SureChoicePerc1,SureChoicePerc2];

SpikeCRisk=Spike(GC_I & Gamble_I,:);
GambleChoicePerc1=(GambleChoicePerc(GC_I & Gamble_I)/90).*(InfoTrial.ChoiceD(GC_I & Gamble_I)==1);
GambleChoicePerc2=(GambleChoicePerc(GC_I & Gamble_I)/90).*(InfoTrial.ChoiceD(GC_I & Gamble_I)==2);
% XCRisk=[ones(sum(GC_I & Gamble_I),1),InfoTrial.BackGroundLevel(GC_I & Gamble_I)/3,InfoTrial.ChoiceD(GC_I & Gamble_I)/2,GambleChoicePerc1,GambleChoicePerc2];
XCRisk=[InfoTrial.BackGroundLevel(GC_I & Gamble_I)/3,InfoTrial.ChoiceD(GC_I & Gamble_I)/2,GambleChoicePerc1,GambleChoicePerc2];


u=0;
t_d=t(1:20:(size(Spike,2)-20));
for t0=1:20:(size(Spike,2)-20)
 u=u+1;   
    %%% regression for no-choice trial
    clear lm
    SpikeS0=mean(SpikeS(:,t0:t0+19),2);
    lm=fitlm(XS,SpikeS0);
    b_S(u,:)=lm.Coefficients.Estimate;  
    p_S(u,:)=lm.Coefficients.pValue; 
     
    %%% regression for choice trial when chose sure target
    clear lm
    SpikeC1=mean(SpikeCSure(:,t0:t0+19),2);
    lm=fitlm(XCSure,SpikeC1);
    b_CS(u,:)=lm.Coefficients.Estimate;  
    p_CS(u,:)=lm.Coefficients.pValue; 

    %%% regression for choice trial when chose risk target
    clear lm
    SpikeC2=mean(SpikeCRisk(:,t0:t0+19),2);
    lm=fitlm(XCRisk,SpikeC2);
    b_CR(u,:)=lm.Coefficients.Estimate;  
    p_CR(u,:)=lm.Coefficients.pValue;  
     
end
 eval([ char(Epoch(ep)),'_b_S( unit_all,:,:) =b_S;']);
 eval([ char(Epoch(ep)),'_p_S( unit_all,:,:) =p_S;']);
 eval([ char(Epoch(ep)),'_b_CS( unit_all,:,:) =b_CS;']);
 eval([ char(Epoch(ep)),'_p_CS( unit_all,:,:) =p_CS;']);
 eval([ char(Epoch(ep)),'_b_CR( unit_all,:,:) =b_CR;']);
 eval([ char(Epoch(ep)),'_p_CR( unit_all,:,:) =p_CR;']);
 
%  b_S=b_S(2:end,:);
%  b_CS=b_CS(2:end,:);
%  b_CR=b_CR(2:end,:);

 clim(1)=clim(1);
 clim(2)=clim(2);
 b_CR0=b_CR(:,2:end);
 b_CS0=b_CS(:,2:end);
 b_S0=b_S(:,2:end);

 clim(3)= min([b_CR0(:);b_S0(:);b_CS0(:)])*1.1;
 clim(4)= max([b_CR0(:);b_S0(:);b_CS0(:)])*1.1;

 
figure(unit_all)
subplot(4,3,ep*3-2)
h=plot(t_d,b_S(:,2:3),'LineWidth',1.5);
cc=num2cell(jet(4),2);
set(h,{'Color'},cc(1:2));
axis(clim);box off;set(gca,'TickDir','out')
legend({'c','d'},'Location','EastOutside')

if ep==1
    title(['Ch',num2str(ch),'Unit',num2str(unit)]);
end



subplot(4,3,ep*3-1)
h=plot(t_d,b_CS(:,2:5),'LineWidth',1.5);
set(h,{'Color'},cc);
axis(clim);box off;set(gca,'TickDir','out')
legend({'c','d','p1','p2'},'Location','EastOutside')


subplot(4,3,ep*3)
h=plot(t_d,b_CR(:,2:5),'LineWidth',1.5)
set(h,{'Color'},cc);
axis(clim);box off;set(gca,'TickDir','out')
legend({'c','d','p1','p2'},'Location','EastOutside')


end 





FigHandle = figure(unit_all);   
print( FigHandle, '-djpeg', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Regression']);
% print( FigHandle, '-depsc', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Dirction']);   

end
    end
end

%%
%===============================================
%%%%%% Average across all recordings
%===================================================


 Epoch={'BG','TG','SC','RT'};
 cc=num2cell(jet(4),2);
 figure(unit_all+1)
  for ep=1:4
 clear b_S b_CS b_CR
 eval(['b_S=',char(Epoch(ep)),'_b_S;']);
 eval(['p_S=',char(Epoch(ep)),'_p_S;']);
 b_S=b_S.*(p_S<0.05);
 b_S(:,:,3)=abs(b_S(:,:,3));
 eval(['b_CS=',char(Epoch(ep)),'_b_CS;']);
 eval(['p_CS=',char(Epoch(ep)),'_p_CS;']);
 b_CS=b_CS.*(p_CS<0.05);
 b_CS(:,:,3)=abs(b_CS(:,:,3));
 b_CS(:,:,4)=abs(b_CS(:,:,4))+abs(b_CS(:,:,5));


 eval(['b_CR=',char(Epoch(ep)),'_b_CR;']);
 eval(['p_CR=',char(Epoch(ep)),'_p_CR;']);
 b_CR=b_CR.*(p_CR<=0.05);
 b_CR(:,:,3)=abs(b_CR(:,:,3));
 b_CR(:,:,4)=abs(b_CR(:,:,4))+abs(b_CR(:,:,5));


  clear t clim t_d
 if ep==1
       t=-100:501;
      clim=[-100 500 -inf inf]; 
elseif ep==2
      t=-500:501;
      clim=[-200 500 -inf inf]; 
elseif ep==3
     t=-500:501;
     clim=[-500 200 -inf inf];
else
      t=-500:501;
      clim=[-300 400 -inf inf]; 
 end
t_d=t(1:20:(length(t)-20));
clim(3)=-10;clim(4)=35;
subplot(4,3,ep*3-2)
for vv=2:size(b_S,3)
    plot(t_d,nanmean(squeeze(b_S(:,:,vv)),1),'Color',cc{vv});hold on;
end
legend({'c','d'},'Location','EastOutside')
for vv=2:size(b_S,3)
    plotstd(t_d,(squeeze(b_S(:,:,vv))),cc{vv});hold on;
end
axis(clim);box off;set(gca,'TickDir','out')


subplot(4,3,ep*3-1)
for vv=2:4
    plot(t_d,nanmean(squeeze(b_CS(:,:,vv)),1),'Color',cc{vv});hold on;
end
legend({'c','d','p'},'Location','EastOutside')
for vv=2:4
    plotstd(t_d,squeeze(b_CS(:,:,vv)),cc{vv});hold on;
end
axis(clim);box off;set(gca,'TickDir','out')

subplot(4,3,ep*3)
for vv=2:4
    plot(t_d,nanmean(squeeze(b_CR(:,:,vv)),1),'Color',cc{vv});hold on;
end
for vv=2:4
    plotstd(t_d,squeeze(b_CR(:,:,vv)),cc{vv});hold on;
end
axis(clim);box off;set(gca,'TickDir','out')
legend({'c','d','p'},'Location','EastOutside')
  end
 
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
