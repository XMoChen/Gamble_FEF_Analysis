%function BackgroundSpike(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
%%%% do not analyze the unsorted ones
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial_valid','InfoExp','InfoTrial');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
clear ContrastBG
C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;



BG_Color={'k','b','g'};





%%
I_valid=InfoTrial.Reward>0;

for trial=2:size(InfoTrial_valid,1)
    InfoTrial_valid.LastLReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,1)==1);
    InfoTrial_valid.LastRReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,2)==1);
end   

sigma=10;
kernel=HalfGaussian(sigma);
LeftSaccade_Index=convn(InfoTrial_valid.DChoice(:,1)',kernel,'same')';
RightSaccade_Index=convn(InfoTrial_valid.DChoice(:,2)',kernel,'same')';
sigma=5;
kernel=HalfGaussian(sigma);
LeftReward_Index=convn(InfoTrial_valid.LastLReward',kernel,'same')';
RightReward_Index=convn(InfoTrial_valid.LastRReward',kernel,'same')';
FChoice_Index(InfoTrial_valid.Targ2Opt==0,1)=1;
FChoice_Index(InfoTrial_valid.Targ2Opt~=0,1)=0;
LeftRisk_Index(InfoTrial_valid.DOpt(:,1)==2,1)=0;
LeftRisk_Index(InfoTrial_valid.DOpt(:,1)==11,1)=2;
LeftRisk_Index(InfoTrial_valid.DOpt(:,1)==12,1)=1;
RightRisk_Index(InfoTrial_valid.DOpt(:,2)==2,1)=0;
RightRisk_Index(InfoTrial_valid.DOpt(:,2)==11,1)=2;
RightRisk_Index(InfoTrial_valid.DOpt(:,2)==12,1)=1;
InfoTrial_valid.ContrastBG=InfoTrial.ContrastBG(I_valid);





%close all
t_bg=-100:501;

unit_all=0;
for ch=1%:Ch_num
    for unit=2%:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            
            
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike=Spike(I_valid,:);
            SpikeTrialMean.BG(unit_all,:)=nanmean(Spike(:,100:600),2);
          %  convn(InfoTrial_valid.LastRReward',kernel,'same')';
     %       a=convn(nanmean(Spike(:,550:1050),2)',kernel,'same')';
             a=Scale(nanmean(Spike(:,150:250),2));
             
             X1=[InfoTrial_valid.DRate(:,1),LeftReward_Index,LeftRisk_Index,InfoTrial_valid.ContrastBG];        
             b = regress(a(FChoice_Index~=0),X1(FChoice_Index~=0,:));
             stats=regstats(a(FChoice_Index~=0),X1(FChoice_Index~=0,:));
             FC_stats=stats.tstat.pval;
             FC_b=stats.beta;
            
             X1=[InfoTrial_valid.DRate(:,1),LeftReward_Index,LeftRisk_Index,InfoTrial_valid.ContrastBG];        
             stats=regstats(a(FChoice_Index==0 & InfoTrial_valid.DChoice(:,1)==1),X1(FChoice_Index==0 & InfoTrial_valid.DChoice(:,1)==1,:));
             C_PF_stats=stats.tstat.pval;
             C_PF_b=stats.beta;
             
             stats=regstats(a(FChoice_Index==0 & InfoTrial_valid.DChoice(:,2)==1),X1(FChoice_Index==0 & InfoTrial_valid.DChoice(:,2)==1,:));
             C_NPF_stats=stats.tstat.pval;
             C_NPF_b=stats.beta;
   
             clear stats
 for rr=1:3            
             stats=regstats(a(LeftRisk_Index==(rr-1) & FChoice_Index==0 & InfoTrial_valid.DChoice(:,1)==1),X1(LeftRisk_Index==(rr-1) & FChoice_Index==0 & InfoTrial_valid.DChoice(:,1)==1,:));
             C_PF_stats_risk(rr,:)=stats.tstat.pval;
             C_PF_b_risk(rr,:)=stats.beta;
            
        if sum(LeftRisk_Index==(rr-1) & FChoice_Index==0 & InfoTrial_valid.DChoice(:,2)==1)>1     
             stats=regstats(a(LeftRisk_Index==(rr-1) & FChoice_Index==0 & InfoTrial_valid.DChoice(:,2)==1),X1(LeftRisk_Index==(rr-1) & FChoice_Index==0 & InfoTrial_valid.DChoice(:,2)==1,:));
             C_NPF_stats_risk(rr,:)=stats.tstat.pval;
             C_NPF_b_risk(rr,:)=stats.beta;
        else
             C_NPF_stats_risk(rr,:)=nan;
             C_NPF_b_risk(rr,:)=nan;
        end
 end
             
             
             
             
figure(unit_all)

subplot(444)
bar([FC_b(2),C_PF_b(2),C_NPF_b(2)]);
title(['p=',num2str(FC_stats(2)),' ',num2str(C_PF_stats(2)),' ',num2str(C_NPF_stats(2))]);
box off;set(gca,'TickDir','out'); 

subplot(448)
bar([FC_b(3),C_PF_b(3),C_NPF_b(3)]);
title(['p=',num2str(FC_stats(3)),' ',num2str(C_PF_stats(3)),' ',num2str(C_NPF_stats(3))]);
box off;set(gca,'TickDir','out'); 

subplot(4,4,12)
bar([FC_b(4),C_PF_b(4),C_NPF_b(4)]);
title(['p=',num2str(FC_stats(4)),' ',num2str(C_PF_stats(4)),' ',num2str(C_NPF_stats(4))]);
box off;set(gca,'TickDir','out'); 

subplot(4,4,16)
bar([FC_b(5),C_PF_b(5),C_NPF_b(5)]);
title(['p=',num2str(FC_stats(5)),' ',num2str(C_PF_stats(5)),' ',num2str(C_NPF_stats(5))]);
box off;set(gca,'TickDir','out'); 

%%
subplot(441)
plot(InfoTrial_valid.DRate(FChoice_Index~=0,1),a(FChoice_Index~=0 ),'.');hold on; %plot(FChoice_Index*1.2,'k');
axis([0 inf min(a) max(a) ]);
box off;set(gca,'TickDir','out'); title(['Ch',num2str(ch),'Unit',num2str(unit-1),'  Left Saccade Prob']);
axis square


subplot(445)
plot(LeftReward_Index(FChoice_Index==1  ),a(FChoice_Index~=0 ),'.');hold on;% plot(FChoice_Index*4.5,'k');
axis([0 inf min(a) max(a)]); title('Left Saccade Reward');
box off;set(gca,'TickDir','out'); axis square

subplot(449)
%plot(LeftRisk_Index(FChoice_Index~=0 & InfoTrial_valid.DChoice(:,1)==1),'k','LineWidth',1);hold on; plot(RightRisk_Index(FChoice_Index~=0),'b:','LineWidth',0.05);
plot(LeftRisk_Index(FChoice_Index==1  ),a(FChoice_Index~=0 ),'.');hold on;% plot(FChoice_Index*4.5,'k');
axis([-0.5 2.5 min(a) max(a)]); title('Left Risk');
box off;set(gca,'TickDir','out'); axis square

subplot(4,4,13)
plot(InfoTrial_valid.ContrastBG(FChoice_Index==1  ),a(FChoice_Index~=0 ),'.');hold on;% plot(FChoice_Index*4.5,'k');
%plot(InfoTrial_valid.ContrastBG(FChoice_Index~=0),'k','LineWidth',1);hold on; %plot(RightRisk_Index,'b:','LineWidth',0.05);
axis([ 0 3.5 min(a) max(a)]); title('Contrast');
box off;set(gca,'TickDir','out');  axis square


Opt=[2,12,11];

             
subplot(442)
%plot(InfoTrial_valid.DRate(FChoice_Index==0 ,1),a(FChoice_Index==0 ),'.');hold on; %plot(FChoice_Index*1.2,'k');
plot(LeftSaccade_Index(FChoice_Index==0 ),a(FChoice_Index==0 ),'.');hold on; %plot(FChoice_Index*1.2,'k');

axis([0 inf min(a) max(a) ]);
box off;set(gca,'TickDir','out'); title('Left Saccade Prob');
axis square


subplot(446)
plot(LeftReward_Index(FChoice_Index==0  ),a(FChoice_Index==0 ),'.');hold on;% plot(FChoice_Index*4.5,'k');
axis([0 inf min(a) max(a)]); title('Left Saccade Reward');
box off;set(gca,'TickDir','out'); axis square

subplot(4,4,10)
%plot(LeftRisk_Index(FChoice_Index~=0 & InfoTrial_valid.DChoice(:,1)==1),'k','LineWidth',1);hold on; plot(RightRisk_Index(FChoice_Index~=0),'b:','LineWidth',0.05);
plot(LeftRisk_Index(FChoice_Index==0  & InfoTrial_valid.DChoice(:,1)==1),a(FChoice_Index==0 & InfoTrial_valid.DChoice(:,1)==1),'.');hold on;% plot(FChoice_Index*4.5,'k');
axis([-0.5 2.5 min(a) max(a)]); title('Left Risk');
box off;set(gca,'TickDir','out'); axis square

subplot(4,4,14)
plot(InfoTrial_valid.ContrastBG(FChoice_Index==0  & InfoTrial_valid.DChoice(:,1)==1),a(FChoice_Index==0 & InfoTrial_valid.DChoice(:,1)==1),'.');hold on;% plot(FChoice_Index*4.5,'k');
%plot(InfoTrial_valid.ContrastBG(FChoice_Index~=0),'k','LineWidth',1);hold on; %plot(RightRisk_Index,'b:','LineWidth',0.05);
axis([ 0 3.5 min(a) max(a)]); title('Contrast');
box off;set(gca,'TickDir','out');  axis square



subplot(443)
plot(RightSaccade_Index(FChoice_Index==0 ),a(FChoice_Index==0 ),'.');hold on; %plot(FChoice_Index*1.2,'k');
axis([0 inf min(a) max(a) ]);
box off;set(gca,'TickDir','out'); title('Left Saccade Prob');
axis square


subplot(4,4,7)
plot(RightReward_Index(FChoice_Index==0  ),a(FChoice_Index==0 ),'.');hold on;% plot(FChoice_Index*4.5,'k');
axis([0 inf min(a) max(a)]); title('Left Saccade Reward');
box off;set(gca,'TickDir','out'); axis square

subplot(4,4,11)
%plot(LeftRisk_Index(FChoice_Index~=0 & InfoTrial_valid.DChoice(:,1)==1),'k','LineWidth',1);hold on; plot(RightRisk_Index(FChoice_Index~=0),'b:','LineWidth',0.05);
plot(RightRisk_Index(FChoice_Index==0  ),a(FChoice_Index==0 ),'.');hold on;% plot(FChoice_Index*4.5,'k');
axis([-0.5 2.5 min(a) max(a)]); title('Left Risk');
box off;set(gca,'TickDir','out'); axis square

subplot(4,4,15)
plot(InfoTrial_valid.ContrastBG(FChoice_Index==0  & InfoTrial_valid.DChoice(:,2)==1),a(FChoice_Index==0 & InfoTrial_valid.DChoice(:,2)==1),'.');hold on;% plot(FChoice_Index*4.5,'k');
%plot(InfoTrial_valid.ContrastBG(FChoice_Index~=0),'k','LineWidth',1);hold on; %plot(RightRisk_Index,'b:','LineWidth',0.05);
axis([ 0 3.5 min(a) max(a)]); title('Contrast');
box off;set(gca,'TickDir','out');  axis square




        end
    end
end


