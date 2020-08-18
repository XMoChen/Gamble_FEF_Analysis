%function BackgroundSpike(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
%%%% do not analyze the unsorted ones
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial_valid','InfoExp');
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
for trial=2:size(InfoTrial_valid,1)
    InfoTrial_valid.LastLReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,1)==1);
    InfoTrial_valid.LastRReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,2)==1);
end   

sigma=6;
kernel=HalfGaussian(sigma);
LeftSaccade_Index=convn(InfoTrial_valid.DChoice(:,1)',kernel,'same')';
RightSaccade_Index=convn(InfoTrial_valid.DChoice(:,2)',kernel,'same')';
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
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            
figure(unit_all)
subplot(531)
plot(LeftSaccade_Index(FChoice_Index~=0));hold on; %plot(FChoice_Index*1.2,'k');
axis([0 sum(FChoice_Index~=0) -2 2]);
box off;set(gca,'TickDir','out'); title('Left Saccade Prob');

subplot(534)
plot(LeftReward_Index(FChoice_Index~=0)-RightReward_Index(FChoice_Index~=0));hold on;% plot(FChoice_Index*4.5,'k');
axis([0 sum(FChoice_Index~=0) -5 5]); title('Left Saccade Reward');
box off;set(gca,'TickDir','out'); 

subplot(537)
plot(LeftRisk_Index(FChoice_Index~=0),'k','LineWidth',1);hold on; plot(RightRisk_Index(FChoice_Index~=0),'b:','LineWidth',0.05);
axis([0 sum(FChoice_Index~=0) -0.5 2.5]); title('Left Risk');
box off;set(gca,'TickDir','out'); 

subplot(5,3,10)
plot(InfoTrial_valid.ContrastBG(FChoice_Index~=0),'k','LineWidth',1);hold on; %plot(RightRisk_Index,'b:','LineWidth',0.05);
axis([0 sum(FChoice_Index~=0) 0 3.5]); title('Contrast');
box off;set(gca,'TickDir','out'); 
Opt=[2,12,11];


subplot(532)
plot(LeftSaccade_Index(FChoice_Index==0));hold on; %plot(FChoice_Index*1.2,'k');
axis([0 sum(FChoice_Index==0) -2 2]);
box off;set(gca,'TickDir','out'); title('Left Saccade Prob');

subplot(535)
plot(LeftReward_Index(FChoice_Index==0)-RightReward_Index(FChoice_Index==0));hold on;% plot(FChoice_Index*4.5,'k');
axis([0 sum(FChoice_Index==0) -5 5]); title('Left Saccade Reward');
box off;set(gca,'TickDir','out'); 

subplot(538)
plot(LeftRisk_Index(FChoice_Index==0),'k','LineWidth',1);hold on; plot(RightRisk_Index(FChoice_Index~=0),'b:','LineWidth',0.05);
axis([0 sum(FChoice_Index==0) -0.5 2.5]); title('Left Risk');
box off;set(gca,'TickDir','out'); 

subplot(5,3,11)
plot(InfoTrial_valid.ContrastBG(FChoice_Index==0),'k','LineWidth',1);hold on; %plot(RightRisk_Index,'b:','LineWidth',0.05);
axis([0 sum(FChoice_Index==0) 0 3.5]); title('Contrast');
box off;set(gca,'TickDir','out'); 
Opt=[2,12,11];


subplot(533)
plot(LeftSaccade_Index);hold on; %plot(FChoice_Index*1.2,'k');
axis([0 length(FChoice_Index) -2 2]);
box off;set(gca,'TickDir','out'); title('Left Saccade Prob');

subplot(536)
plot(LeftReward_Index-RightReward_Index);hold on;% plot(FChoice_Index*4.5,'k');
axis([0 length(FChoice_Index) -5 5]); title('Left Saccade Reward');
box off;set(gca,'TickDir','out'); 

subplot(539)
plot(LeftRisk_Index,'k','LineWidth',1);hold on; plot(RightRisk_Index(FChoice_Index~=0),'b:','LineWidth',0.05);
axis([0 length(FChoice_Index) -0.5 2.5]); title('Left Risk');
box off;set(gca,'TickDir','out'); 

subplot(5,3,12)
plot(InfoTrial_valid.ContrastBG,'k','LineWidth',1);hold on; %plot(RightRisk_Index,'b:','LineWidth',0.05);
axis([0 length(FChoice_Index) 0 3.5]); title('Contrast');
box off;set(gca,'TickDir','out'); 
Opt=[2,12,11];


            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike=Spike(I_valid,:);
            SpikeTrialMean.Targ(unit_all,:)=nanmean(Spike(:,150:600),2);
          %  convn(InfoTrial_valid.LastRReward',kernel,'same')';
     %       a=convn(nanmean(Spike(:,550:1050),2)',kernel,'same')';
             a=nanmean(Spike(:,550:600),2);

            subplot(5,3,13)

            %subplot(6,7,unit_all+4);
            plot(a(FChoice_Index~=0));
            axis([0 sum(FChoice_Index~=0), 0 inf]);
            box off;set(gca,'TickDir','out'); 
            grid minor
            set(gca,'xtick',[0:20:20*18])
            
            
            subplot(5,3,14)
            %subplot(6,7,unit_all+4);
            plot(a(FChoice_Index==0));
            axis([0 sum(FChoice_Index==0), 0 inf]);
            box off;set(gca,'TickDir','out'); 
            grid minor
            set(gca,'xtick',[0:30:30*18])
            
            
            subplot(5,3,15)
            %subplot(6,7,unit_all+4);
            plot(a);
            axis([0 length(FChoice_Index), 0 inf]);
            box off;set(gca,'TickDir','out'); 
            grid on
            grid minor
            set(gca,'xtick',[0:50:900])
        end
    end
end


