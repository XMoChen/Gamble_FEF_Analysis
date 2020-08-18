 function  BehaviorAnalysis2017_3Risk(Eventfile,DirFig)
close all;
 load(Eventfile,'InfoTrial','InfoExp');

GOpt=unique(InfoExp.Gamble_block);
SOpt=unique(InfoExp.Sure_block);
C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;
save(Eventfile,'InfoTrial','-append');

%%
%%% instananeous choice
InfoTrial.HighRisk=zeros(size(InfoTrial.Targ2Opt));
for trial=1:size(InfoTrial,1)
    if  InfoTrial.Targ2Opt(trial)>0 & (InfoTrial.Targ1Opt(trial)+InfoTrial.Targ2Opt(trial))>20 & InfoTrial.ChoiceOpt(trial)==11
    InfoTrial.HighRisk(trial)=1;
    end
    if  InfoTrial.Targ2Opt(trial)>0 & (InfoTrial.Targ1Opt(trial)+InfoTrial.Targ2Opt(trial))>20 & InfoTrial.ChoiceOpt(trial)==12
    InfoTrial.HighRisk(trial)=-1;
    end
    
        
    if InfoTrial.Targ2Opt(trial)>0 & (InfoTrial.Targ1Opt(trial)+InfoTrial.Targ2Opt(trial))<20 &  (InfoTrial.Targ1Opt(trial)+InfoTrial.Targ2Opt(trial))>10 & InfoTrial.ChoiceOpt(trial)>10
    InfoTrial.HighRisk(trial)=1;
    end
    if InfoTrial.Targ2Opt(trial)>0 & (InfoTrial.Targ1Opt(trial)+InfoTrial.Targ2Opt(trial))<20 &  (InfoTrial.Targ1Opt(trial)+InfoTrial.Targ2Opt(trial))>10 & InfoTrial.ChoiceOpt(trial)==2
    InfoTrial.HighRisk(trial)=-1;
    end

end

for block=1:18
    Num_all=sum(InfoTrial.HighRisk~=0 & InfoTrial.Block==block);
    Num_Risk=sum(InfoTrial.HighRisk==1 & InfoTrial.Block==block);
    
    %%% chose percentage
    RiskPerc(block,3)=Num_Risk/Num_all;  
    %%% right option 
    RiskPerc(block,2)=median(InfoTrial.Targ2Opt(InfoTrial.Block==block & InfoTrial.Targ2Opt~=0));
    %%% left option 
    RiskPerc(block,1)=median(InfoTrial.Targ1Opt(InfoTrial.Block==block & InfoTrial.Targ2Opt~=0));
    %%% total number of trial
    RiskPerc(block,4)=Num_all;
    RiskPerc(block,5)=median(InfoTrial.ContrastBG(InfoTrial.Block==block & InfoTrial.Targ2Opt~=0));;
end

RiskChoicePerc(1,1)=nanmean(RiskPerc(RiskPerc(:,1)==11 & RiskPerc(:,2)==2,3));
RiskChoicePerc(1,2)=nanmean(RiskPerc(RiskPerc(:,1)==12 & RiskPerc(:,2)==2,3));
RiskChoicePerc(1,3)=nanmean(RiskPerc(RiskPerc(:,1)==11 & RiskPerc(:,2)==12,3));
 
RiskChoicePerc(2,1)=nanmean(RiskPerc(RiskPerc(:,2)==11 & RiskPerc(:,1)==2,3));
RiskChoicePerc(2,2)=nanmean(RiskPerc(RiskPerc(:,2)==12 & RiskPerc(:,1)==2,3));
RiskChoicePerc(2,3)=nanmean(RiskPerc(RiskPerc(:,2)==11 & RiskPerc(:,1)==12,3));


RiskChoicePerc(3,1)=nanmean(RiskPerc((RiskPerc(:,2)==11 & RiskPerc(:,1)==2) | (RiskPerc(:,1)==11 & RiskPerc(:,2)==2),3));
RiskChoicePerc(3,2)=nanmean(RiskPerc((RiskPerc(:,2)==12 & RiskPerc(:,1)==2) | (RiskPerc(:,1)==12 & RiskPerc(:,2)==2),3));
RiskChoicePerc(3,3)=nanmean(RiskPerc((RiskPerc(:,2)==11 & RiskPerc(:,1)==12) | (RiskPerc(:,1)==11 & RiskPerc(:,2)==12),3));


ChoicePerc(1,1)=1-nanmean([RiskPerc(RiskPerc(:,1)==2 & RiskPerc(:,2)==12,3);RiskPerc(RiskPerc(:,1)==2 & RiskPerc(:,2)==11,3)]);
ChoicePerc(1,2)=nanmean([RiskPerc(RiskPerc(:,1)==12 & RiskPerc(:,2)==2,3);1-RiskPerc(RiskPerc(:,1)==12 & RiskPerc(:,2)==11,3)]);
ChoicePerc(1,3)=nanmean([RiskPerc(RiskPerc(:,1)==11 & RiskPerc(:,2)==2,3);RiskPerc(RiskPerc(:,1)==11 & RiskPerc(:,2)==12,3)]);
ChoicePerc(2,1)=1-nanmean([RiskPerc(RiskPerc(:,2)==2 & RiskPerc(:,1)==12,3);RiskPerc(RiskPerc(:,2)==2 & RiskPerc(:,1)==11,3)]);
ChoicePerc(2,2)=nanmean([RiskPerc(RiskPerc(:,2)==12 & RiskPerc(:,1)==2,3);1-RiskPerc(RiskPerc(:,2)==12 & RiskPerc(:,1)==11,3)]);
ChoicePerc(2,3)=nanmean([RiskPerc(RiskPerc(:,2)==11 & RiskPerc(:,1)==2,3);RiskPerc(RiskPerc(:,2)==11 & RiskPerc(:,1)==12,3)]);

figure(3)
subplot(221);
bar(RiskChoicePerc(1,:)); axis([ 0 4 0 1.2]);
set(gca,'XTickLabel',{'0/4 vs 2','1/3 vs 2','0/4 vs 1/3'});
title('Left vs Right');
ylabel('Choice Probability');
box off; set(gca,'TickDir','out');

subplot(222);
bar(RiskChoicePerc(2,:));axis([ 0 4 0 1.2]);
set(gca,'XTickLabel',{'0/4 vs 2','1/3 vs 2','0/4 vs 1/3'});
ylabel('Choice Probability');
title('Right vs Left');
box off; set(gca,'TickDir','out');

subplot(223);
bar(ChoicePerc');axis([ 0 4 0 1.2]);
set(gca,'XTickLabel',{'2','1/3 ','0/4 '});
ylabel('Choice Probability');



subplot(224);
bar(RiskChoicePerc(3,:));axis([ 0 4 0 1.2]);
set(gca,'XTickLabel',{'0/4 vs 2','1/3 vs 2','0/4 vs 1/3'});
legend({'left','right'});
ylabel('Choice Probability');
title('Combined');
box off; set(gca,'TickDir','out');
ID_Choice=InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt>0 & InfoTrial.ResultOn>0;
I_Choice=InfoTrial.HighRisk(ID_Choice);

HighRisk_Index=I_Choice==1;
LowRisk=I_Choice==-1;
sigma=6;
kernel=HalfGaussian(sigma);
HighRisk_Index_Ins=convn(HighRisk_Index',kernel,'same')';
LowRisk_Ins=convn(LowRisk',kernel,'same')';
HighRisk_Perc=HighRisk_Index_Ins./(LowRisk_Ins);
LowRisk_Perc=LowRisk_Ins./(HighRisk_Index_Ins);

HighRiskPerc=zeros(size(InfoTrial,1),1);
HighRiskPerc(ID_Choice,1)=atan(HighRisk_Perc')*180/pi;
InfoTrial.HighRiskPerc=HighRiskPerc;

LowRiskPerc=zeros(size(InfoTrial,1),1);
LowRiskPerc(ID_Choice,1)=atan(LowRisk_Perc')*180/pi;
InfoTrial.LowRiskPerc=LowRiskPerc;


%%% instananeous reward ratio
LowRisk_Result=InfoTrial.Result(ID_Choice);
LowRisk_Result(HighRisk_Index)=0;
HighRisk_Result=InfoTrial.Result(ID_Choice);
HighRisk_Result(LowRisk)=0;

RHighRisk_Ins=convn(HighRisk_Result',kernel,'same')';
RLowRisk_Ins=convn(LowRisk_Result',kernel,'same')';
%%%% instant reward on choice trial with no-choice trial
RHighRisk_Perc=RHighRisk_Ins./(RLowRisk_Ins);
RLowRisk_Perc=RLowRisk_Ins./RHighRisk_Ins;

RHighRiskPerc=zeros(size(InfoTrial,1),1);
RHighRiskPerc(ID_Choice,1)=atan(RHighRisk_Perc')*180/pi;
InfoTrial.RHighRiskPerc=RHighRiskPerc;

RLowRiskPerc=zeros(size(InfoTrial,1),1);
RLowRiskPerc(ID_Choice,1)=atan(RLowRisk_Perc')*180/pi;
InfoTrial.RLowRiskPerc=RLowRiskPerc;

for trial=1:size(InfoTrial,1)
    if InfoTrial.ChoiceOpt(trial)>10
        ChosenPerc(trial)=InfoTrial.HighRiskPerc(trial)+100;
        RewardPerc(trial)=InfoTrial.RHighRiskPerc(trial)+100;

    else
        ChosenPerc(trial)=InfoTrial.LowRiskPerc(trial);
        RewardPerc(trial)=InfoTrial.RLowRiskPerc(trial);

    end   
end
InfoTrial.ChosenPerc=ChosenPerc';
InfoTrial.RewardPerc=RewardPerc';
save(Eventfile,'InfoTrial','-append');
        

Reward_Perc=zeros(size(InfoTrial,1),4);
Reward_Perc(InfoTrial.DOpt>10)=InfoTrial.DOpt(InfoTrial.DOpt>10);
Reward_Perc(Reward_Perc==18)=0.75;
Reward_Perc(Reward_Perc==17)=0.5;
Reward_Perc(Reward_Perc==16)=0.25;
% Reward_Perc(Reward_Perc==18)=0.8;
% Reward_Perc(Reward_Perc==17)=0.4;
% Reward_Perc(Reward_Perc==16)=0.2;
RGamble_Perc_block=Reward_Perc*4/2;
RGamble_Perc_block=RGamble_Perc_block(ID_Choice,:);

R=InfoTrial.DRate';
Choice_Perc=R((InfoTrial.DOpt'>10));
Choice_Perc=Choice_Perc(ID_Choice)./(1-Choice_Perc(ID_Choice));

figure(1)
subplot(211)
plot((atan(HighRisk_Perc)*180/pi),'k','linewidth',2);hold on;
plot((atan(RHighRisk_Perc)*180/pi),'b','linewidth',2);hold on;
box off; set(gca,'TickDir','out');
legend({'HighRisk ratio','HighRisk Income ratio '},'Location','eastoutside')
axis([0 length(HighRisk_Perc) 0 100])
[h,p]=ttest(HighRisk_Perc,RHighRisk_Perc);
title(['Risk Seeking',' dif=',num2str(nanmean(atan(HighRisk_Perc)-atan(RHighRisk_Perc))*180/pi,3),' p=',num2str(p,3)]);
%yyaxis right
subplot(212)
plot((atan(LowRisk_Perc)*180/pi),'k','linewidth',2);hold on;
plot((atan(RLowRisk_Perc)*180/pi),'b','linewidth',2);hold on;
box off; set(gca,'TickDir','out');
legend({'LowRisk ratio','LowRisk income ratio '},'Location','eastoutside')
axis([0 length(HighRisk_Perc) 0 100])
[h,p]=ttest(HighRisk_Perc,RHighRisk_Perc);

% title(['Risk Seeking',' dif=',num2str(nanmean(atan(HighRisk_Perc)-atan(RHighRisk_Perc))*180/pi,3),' p=',num2str(p,3)]);
%
% subplot(313)
% RHighRisk_Perc_block=atan(RHighRisk_Perc_block)*180/pi;
% % plot(RHighRisk_Perc_block(:,1),'y','linewidth',2);hold on;
% RHighRisk_Perc_block(RHighRisk_Perc_block==0)=nan;
% plot(RHighRisk_Perc_block(:,1),'y','linewidth',2);hold on;
% plot(RHighRisk_Perc_block(:,2),'g','linewidth',2);hold on;
% plot(RHighRisk_Perc_block(:,3),'m','linewidth',2);hold on;
% plot(RHighRisk_Perc_block(:,4),'c','linewidth',2);hold on;
% plot(atan(Choice_Perc)*180/pi,'k','linewidth',2);
% legend({'D1','D2','D3','D4','HighRisk Prob'},'Location','eastoutside');
% axis([0 length(HighRisk_Perc) 0 100])
% box off; set(gca,'TickDir','out');
% title('Block Information');


%% define empity matrix
InfoTrial_valid=InfoTrial(InfoTrial.Reward>0,:);

I_LwL=zeros(1,size(InfoTrial_valid,1));
I_Lw4R=I_LwL;
I_Lw4L=I_LwL;
I_Lw3R=I_LwL;
I_Lw3L=I_LwL;
I_LwR=I_LwL;
I_LwL=I_LwR;
I_LsL=I_LwR;
I_LsR=I_LwR;
I_LlL=I_LwR;
I_LlR=I_LwR;
I_Ll1R=I_LwR;
I_Ll1L=I_LwR;
I_Ll0R=I_LwR;
I_Ll0L=I_LwR;

I_Rw4R=I_LwR;
I_Rw4L=I_LwR;
I_Rw3R=I_LwR;
I_Rw3L=I_LwR;
I_RwR=I_LwR;
I_RwL=I_LwR;
I_RsL=I_LwR;
I_RsR=I_LwR;
I_RlL=I_LwR;
I_RlR=I_LwR;
I_Rl1L=I_LwR;
I_Rl1R=I_LwR;
I_Rl0L=I_LwR;
I_Rl0R=I_LwR;

I_Lww4R=I_LwR;
I_Lww4L=I_LwR;
I_Lww3R=I_LwR;
I_Lww3L=I_LwR;
I_LwwR=I_LwR;
I_LwwL=I_LwR;
I_LssL=I_LwR;
I_LssR=I_LwR;
I_LllL=I_LwR;
I_LllR=I_LwR;
I_Lll1L=I_LwR;
I_Lll1R=I_LwR;
I_Lll0L=I_LwR;
I_Lll0R=I_LwR;

I_Rww4R=I_LwR;
I_Rww4L=I_LwR;
I_Rww3R=I_LwR;
I_Rww3L=I_LwR;
I_RwwR=I_LwR;
I_RwwL=I_LwR;
I_RssL=I_LwR;
I_RssR=I_LwR;
I_RllL=I_LwR;
I_RllR=I_LwR;
I_Rll1L=I_LwR;
I_Rll1R=I_LwR;
I_Rll0L=I_LwR;
I_Rll0R=I_LwR;

I_LwwwR=I_LwR;
I_LwwwL=I_LwR;
I_LsssL=I_LwR;
I_LsssR=I_LwR;
I_LlllL=I_LwR;
I_LlllR=I_LwR;
I_RwwwR=I_LwR;
I_RwwwL=I_LwR;
I_RsssL=I_LwR;
I_RsssR=I_LwR;
I_RlllL=I_LwR;
I_RlllR=I_LwR;


I_LwwwwR=I_LwR;
I_LwwwwL=I_LwR;
I_LssssL=I_LwR;
I_LssssR=I_LwR;
I_LllllL=I_LwR;
I_LllllR=I_LwR;
I_RwwwwR=I_LwR;
I_RwwwwL=I_LwR;
I_RssssL=I_LwR;
I_RssssR=I_LwR;
I_RllllL=I_LwR;
I_RllllR=I_LwR;

%%
I_Choice=InfoTrial_valid.Targ2Opt~=0;


for trial=4:size(InfoTrial_valid,1)
%     InfoTrial_valid.LastLReward(trial,1)=InfoTrial_valid.Reward(trial-1,1).InfoTrial_valid.DChoice(trial-1,1);
%     InfoTrial_valid.LastRReward(trial,1)=InfoTrial_valid.Reward(trial-1,1).InfoTrial_valid.DChoice(trial-1,2);
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1
        I_LwL(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1
        I_LwR(trial)=1;
    end
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==4 &  InfoTrial_valid.ChoiceD(trial-1)==1
        I_Lw4L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==4 &  InfoTrial_valid.ChoiceD(trial-1)==1
        I_Lw4R(trial)=1;
    end
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==3 &  InfoTrial_valid.ChoiceD(trial-1)==1
        I_Lw3L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==3 &  InfoTrial_valid.ChoiceD(trial-1)==1
        I_Lw3R(trial)=1;
    end
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==1
       
        I_LwwL(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==1
        I_LwwR(trial)=1;
    end
    
        if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==4 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)==4 &  InfoTrial_valid.ChoiceD(trial-2)==1
       
        I_Lww4L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==4 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)==4 &  InfoTrial_valid.ChoiceD(trial-2)==1
        I_Lww4R(trial)=1;
        end
    
     if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==3 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)==3 &  InfoTrial_valid.ChoiceD(trial-2)==1
       
        I_Lww3L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==3 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)==3 &  InfoTrial_valid.ChoiceD(trial-2)==1
        I_Lww3R(trial)=1;
    end
       
    
%         if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 &  InfoTrial_valid.ChoiceD(trial-3)==1
%       
%         I_LwwwL(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 &  InfoTrial_valid.ChoiceD(trial-3)==1
% 
%         I_LwwwR(trial)=1;
%         end
%         
%         
%      if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 &  InfoTrial_valid.ChoiceD(trial-3)==1 ...
%             &  InfoTrial_valid.Reward(trial-4)>2 &  InfoTrial_valid.ChoiceD(trial-4)==1
%       
%         I_LwwwwL(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 &  InfoTrial_valid.ChoiceD(trial-3)==1 ...
%             &  InfoTrial_valid.Reward(trial-4)>2 &  InfoTrial_valid.ChoiceD(trial-4)==1
% 
%         I_LwwwwR(trial)=1;
%         end
    
        
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_LsL(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_LsR(trial)=1;
    end
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_LssL(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_LssR(trial)=1;
    end
       
%     
%    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==1
% 
%         I_LsssL(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==1
% 
%         I_LsssR(trial)=1;    
%    end
%    
%       if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==1 ...
%             &  InfoTrial_valid.Reward(trial-4)==2 &   InfoTrial_valid.ChoiceD(trial-4)==1
% 
%         I_LssssL(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==1 ...
%             &  InfoTrial_valid.Reward(trial-4)==2 &   InfoTrial_valid.ChoiceD(trial-4)==1
% 
%         I_LssssR(trial)=1;    
%    end
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_LlL(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_LlR(trial)=1;
    end
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==1 &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_Ll1L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==1  &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_Ll1R(trial)=1;
    end
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1  ...
       &  InfoTrial_valid.Reward(trial-1)==0.001 &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_Ll0L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
       &  InfoTrial_valid.Reward(trial-1)==0.001 &   InfoTrial_valid.ChoiceD(trial-1)==1
        I_Ll0R(trial)=1;
    end
    
    
    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_LllL(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_LllR(trial)=1;
    end
    
    
   if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==1 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)==1 &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_Lll1L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)<2  &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
            &  InfoTrial_valid.Reward(trial-2)<2  &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_Lll1R(trial)=1;
    end
    
        
        
     if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==0.001 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
             &  InfoTrial_valid.Reward(trial-2)==0.001 &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_Lll0L(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
             &  InfoTrial_valid.Reward(trial-1)==0.001 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
             &  InfoTrial_valid.Reward(trial-2)==0.001 &   InfoTrial_valid.ChoiceD(trial-2)==1
        I_Lll0R(trial)=1;
    end
%     
%    if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 &   InfoTrial_valid.ChoiceD(trial-3)==1
% 
%         I_LlllL(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 &   InfoTrial_valid.ChoiceD(trial-3)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==1
%         I_LlllR(trial)=1;
%    end
%     
%       if InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 &   InfoTrial_valid.ChoiceD(trial-3)==1 ...
%             &  InfoTrial_valid.Reward(trial-4)<2 &  InfoTrial_valid.Reward(trial-4)>0 &   InfoTrial_valid.ChoiceD(trial-4)==1
% 
%         I_LllllL(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==1 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 &   InfoTrial_valid.ChoiceD(trial-3)==1 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==1 ...
%             &  InfoTrial_valid.Reward(trial-4)<2 &  InfoTrial_valid.Reward(trial-4)>0 &   InfoTrial_valid.ChoiceD(trial-4)==1
% 
%         I_LllllR(trial)=1;
%       end
    
    
    
    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==2
        I_RwR(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)>2 & InfoTrial_valid.ChoiceD(trial-1)==2
        I_RwL(trial)=1;
    end
    
   if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==4 &  InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rw4R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==4 & InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rw4L(trial)=1;
   end
    
   
   if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==3 &  InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rw3R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==3 & InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rw3L(trial)=1;
   end
   
   
   if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==2
        I_RwwR(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)>2 & InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)>2 & InfoTrial_valid.ChoiceD(trial-2)==2
        I_RwwL(trial)=1;
    end
   
   if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==4 &  InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==4 &  InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rww4R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==4 & InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==4 & InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rww4L(trial)=1;
    end
    
    
        
    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==3 &  InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==3 &  InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rww3R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==3 & InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==3 & InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rww3L(trial)=1;
    end
    
    
%    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 &  InfoTrial_valid.ChoiceD(trial-3)==2
% 
%         I_RwwwR(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 & InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 & InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 & InfoTrial_valid.ChoiceD(trial-3)==2
% 
%         I_RwwwL(trial)=1;
%    end
%     
%       if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 &  InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 &  InfoTrial_valid.ChoiceD(trial-3)==2 ...
%             &  InfoTrial_valid.Reward(trial-4)>2 &  InfoTrial_valid.ChoiceD(trial-4)==2
% 
%         I_RwwwwR(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)>2 & InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)>2 & InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)>2 & InfoTrial_valid.ChoiceD(trial-3)==2 ...
%             &  InfoTrial_valid.Reward(trial-4)>2 & InfoTrial_valid.ChoiceD(trial-4)==2
% 
%         I_RwwwwL(trial)=1;
%       end
    
    
    
    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_RsR(trial)=1;
    elseif  InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_RsL(trial)=1;
    end
    
    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ... 
            &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==2
        I_RssR(trial)=1;
    elseif  InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==2
        I_RssL(trial)=1;
    end
    
%     if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ... 
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==2
% 
%         I_RsssR(trial)=1;
%     elseif  InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==2
% 
%         I_RsssL(trial)=1;
%     end
%     
%     if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ... 
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==2 ...
%             &  InfoTrial_valid.Reward(trial-4)==2 &   InfoTrial_valid.ChoiceD(trial-4)==2
% 
%         I_RssssR(trial)=1;
%     elseif  InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)==2 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)==2 &   InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)==2 &   InfoTrial_valid.ChoiceD(trial-3)==2 ...
%             &  InfoTrial_valid.Reward(trial-4)==2 &   InfoTrial_valid.ChoiceD(trial-4)==2
% 
%         I_RssssL(trial)=1;
%      end
    
    
    
    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_RlR(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_RlL(trial)=1;
    end
    
   if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 &  InfoTrial_valid.Reward(trial-1)==1 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rl1R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1  &  InfoTrial_valid.Reward(trial-1)==1 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rl1L(trial)=1;
     end
    
     if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1  &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rl0R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1  &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2
        I_Rl0L(trial)=1;
    end
    
    
    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==2
        I_RllR(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==2
        I_RllL(trial)=1;
    end
    
   if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
             &  InfoTrial_valid.Reward(trial-1)==1 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
             &  InfoTrial_valid.Reward(trial-2)==1 & InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rll1R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==1 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==1 &   InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rll1L(trial)=1;
    end
    
     if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
            &  InfoTrial_valid.Reward(trial-1)==0.001 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
            &  InfoTrial_valid.Reward(trial-2)==0.001 & InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rll0R(trial)=1;
    elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
           &  InfoTrial_valid.Reward(trial-1)==0.001 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
           &  InfoTrial_valid.Reward(trial-2)==0.001 &   InfoTrial_valid.ChoiceD(trial-2)==2
        I_Rll0L(trial)=1;
    end
    
%    if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 & InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 & InfoTrial_valid.ChoiceD(trial-3)==2
% 
%         I_RlllR(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 &   InfoTrial_valid.ChoiceD(trial-3)==2
% 
%         I_RlllL(trial)=1;
%    end
%     
%       if InfoTrial_valid.ChoiceD(trial)==2 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 & InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 & InfoTrial_valid.ChoiceD(trial-3)==2 ...
%             &  InfoTrial_valid.Reward(trial-4)<2 &  InfoTrial_valid.Reward(trial-4)>0 & InfoTrial_valid.ChoiceD(trial-4)==2
% 
%         I_RllllR(trial)=1;
%     elseif InfoTrial_valid.ChoiceD(trial)==1 &  I_Choice(trial)==1 ...
%             &  InfoTrial_valid.Reward(trial-1)<2 &  InfoTrial_valid.Reward(trial-1)>0 &   InfoTrial_valid.ChoiceD(trial-1)==2 ...
%             &  InfoTrial_valid.Reward(trial-2)<2 &  InfoTrial_valid.Reward(trial-2)>0 &   InfoTrial_valid.ChoiceD(trial-2)==2 ...
%             &  InfoTrial_valid.Reward(trial-3)<2 &  InfoTrial_valid.Reward(trial-3)>0 &   InfoTrial_valid.ChoiceD(trial-3)==2 ...
%             &  InfoTrial_valid.Reward(trial-4)<2 &  InfoTrial_valid.Reward(trial-4)>0 &   InfoTrial_valid.ChoiceD(trial-4)==2
% 
%         I_RllllL(trial)=1;
%     end
%     
end


P_Lw4L=sum(I_Lw4L)/(sum(I_Lw4L)+sum(I_Lw4R));
P_Lw3L=sum(I_Lw3L)/(sum(I_Lw3L)+sum(I_Lw3R));
P_LwL=sum(I_LwL)/(sum(I_LwL)+sum(I_LwR));
P_LsL=sum(I_LsL)/(sum(I_LsL)+sum(I_LsR));
P_LlL=sum(I_LlL)/(sum(I_LlL)+sum(I_LlR));
P_Ll1L=sum(I_Ll1L)/(sum(I_Ll1L)+sum(I_Ll1R));
P_Ll0L=sum(I_Ll0L)/(sum(I_Ll0L)+sum(I_Ll0R));
InfoTrial_valid.P_Lw4L=I_Lw4L';
InfoTrial_valid.P_Lw3L=I_Lw3L';
InfoTrial_valid.P_LwL=I_LwL';
InfoTrial_valid.P_LsL=I_LsL';
InfoTrial_valid.P_LlL=I_LlL';
InfoTrial_valid.P_Ll1L=I_Ll1L';
InfoTrial_valid.P_Ll0L=I_Ll0L';
InfoTrial_valid.P_Lw4R=I_Lw4R';
InfoTrial_valid.P_Lw3R=I_Lw3R';
InfoTrial_valid.P_LwR=I_LwR';
InfoTrial_valid.P_LsR=I_LsR';
InfoTrial_valid.P_LlR=I_LlR';
InfoTrial_valid.P_Ll1R=I_Ll1R';
InfoTrial_valid.P_Ll0R=I_Ll0R';

P_Rw4R=sum(I_Rw4R)/(sum(I_Rw4R)+sum(I_Rw4L));
P_Rw3R=sum(I_Rw3R)/(sum(I_Rw3R)+sum(I_Rw3L));
P_RwR=sum(I_RwR)/(sum(I_RwR)+sum(I_RwL));
P_RsR=sum(I_RsR)/(sum(I_RsR)+sum(I_RsL));
P_RlR=sum(I_RlR)/(sum(I_RlR)+sum(I_RlL));
P_Rl1R=sum(I_Rl1R)/(sum(I_Rl1R)+sum(I_Rl1L));
P_Rl0R=sum(I_Rl0R)/(sum(I_Rl0R)+sum(I_Rl0L));

InfoTrial_valid.P_Rw4L=I_Rw4L';
InfoTrial_valid.P_Rw3L=I_Rw3L';
InfoTrial_valid.P_RwL=I_RwL';
InfoTrial_valid.P_RsL=I_RsL';
InfoTrial_valid.P_RlL=I_RlL';
InfoTrial_valid.P_Rl1L=I_Rl1L';
InfoTrial_valid.P_Rl0L=I_Rl0L';
InfoTrial_valid.P_Rw4R=I_Rw4R';
InfoTrial_valid.P_Rw3R=I_Rw3R';
InfoTrial_valid.P_RwR=I_RwR';
InfoTrial_valid.P_RsR=I_RsR';
InfoTrial_valid.P_RlR=I_RlR';
InfoTrial_valid.P_Rl1R=I_Rl1R';
InfoTrial_valid.P_Rl0R=I_Rl0R';



P_Lww4L=sum(I_Lww4L)/(sum(I_Lww4L)+sum(I_Lww4R));
P_Lww3L=sum(I_Lww3L)/(sum(I_Lww3L)+sum(I_Lww3R));
P_LwwL=sum(I_LwwL)/(sum(I_LwwL)+sum(I_LwwR));
P_LssL=sum(I_LssL)/(sum(I_LssL)+sum(I_LssR));
P_LllL=sum(I_LllL)/(sum(I_LllL)+sum(I_LllR));
P_Lll1L=sum(I_Lll1L)/(sum(I_Lll1L)+sum(I_Lll1R));
P_Lll0L=sum(I_Lll0L)/(sum(I_Lll0L)+sum(I_Lll0R));

InfoTrial_valid.P_Lww4L=I_Lww4L';
InfoTrial_valid.P_Lww3L=I_Lww3L';
InfoTrial_valid.P_LwwL=I_LwwL';
InfoTrial_valid.P_LssL=I_LssL';
InfoTrial_valid.P_LllL=I_LllL';
InfoTrial_valid.P_Lll1L=I_Lll1L';
InfoTrial_valid.P_Lll0L=I_Lll0L';
InfoTrial_valid.P_Lww4R=I_Lww4R';
InfoTrial_valid.P_Lww3R=I_Lww3R';
InfoTrial_valid.P_LwwR=I_LwwR';
InfoTrial_valid.P_LssR=I_LssR';
InfoTrial_valid.P_LllR=I_LllR';
InfoTrial_valid.P_Lll1R=I_Lll1R';
InfoTrial_valid.P_Lll0R=I_Lll0R';

InfoTrial_valid.P_Rww4L=I_Lww4L';
InfoTrial_valid.P_Rww3L=I_Lww3L';
InfoTrial_valid.P_RwwL=I_LwwL';
InfoTrial_valid.P_RssL=I_LssL';
InfoTrial_valid.P_RllL=I_LllL';
InfoTrial_valid.P_Rll1L=I_Lll1L';
InfoTrial_valid.P_Rll0L=I_Lll0L';
InfoTrial_valid.P_Rww4R=I_Lww4R';
InfoTrial_valid.P_Rww3R=I_Lww3R';
InfoTrial_valid.P_RwwR=I_LwwR';
InfoTrial_valid.P_RssR=I_LssR';
InfoTrial_valid.P_RllR=I_LllR';
InfoTrial_valid.P_Rll1R=I_Lll1R';
InfoTrial_valid.P_Rll0R=I_Lll0R';

P_Rww4R=sum(I_Rww4R)/(sum(I_Rww4R)+sum(I_Rww4L));
P_Rww3R=sum(I_Rww3R)/(sum(I_Rww3R)+sum(I_Rww3L));
P_RwwR=sum(I_RwwR)/(sum(I_RwwR)+sum(I_RwwL));
P_RssR=sum(I_RssR)/(sum(I_RssR)+sum(I_RssL));
P_RllR=sum(I_RllR)/(sum(I_RllR)+sum(I_RllL));
P_Rll1R=sum(I_Rll1R)/(sum(I_Rll1R)+sum(I_Rll1L));
P_Rll0R=sum(I_Rll0R)/(sum(I_Rll0R)+sum(I_Rll0L));


P_LwwwL=sum(I_LwwwL)/(sum(I_LwwwL)+sum(I_LwwwR));
P_LsssL=sum(I_LsssL)/(sum(I_LsssL)+sum(I_LsssR));
P_LlllL=sum(I_LlllL)/(sum(I_LlllL)+sum(I_LlllR));

P_RwwwR=sum(I_RwwwR)/(sum(I_RwwwR)+sum(I_RwwwL));
P_RsssR=sum(I_RsssR)/(sum(I_RsssR)+sum(I_RsssL));
P_RlllR=sum(I_RlllR)/(sum(I_RlllR)+sum(I_RlllL));


P_LwwwwL=sum(I_LwwwwL)/(sum(I_LwwwwL)+sum(I_LwwwwR));
P_LssssL=sum(I_LssssL)/(sum(I_LssssL)+sum(I_LssssR));
P_LllllL=sum(I_LllllL)/(sum(I_LllllL)+sum(I_LllllR));

P_RwwwwR=sum(I_RwwwwR)/(sum(I_RwwwwR)+sum(I_RwwwwL));
P_RssssR=sum(I_RssssR)/(sum(I_RssssR)+sum(I_RssssL));
P_RllllR=sum(I_RllllR)/(sum(I_RllllR)+sum(I_RllllL));

save(Eventfile,'InfoTrial_valid','-append');

figure(4)
subplot(221)
bar([P_LwL,P_LsL,P_LlL;P_RwR,P_RsR,P_RlR]);
title('Trial History 1 back');
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'Left stay','Right stay'});
legend({'Win','Safe','Loss'})
axis([0 3 0 1.2]);

subplot(222)
bar([P_LwwL,P_LssL,P_LllL;P_RwwR,P_RssR,P_RllR]);
title('Trial History 2 back');
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'Left stay','Right stay'});
legend({'Win','Safe','Loss'})
axis([0 3 0 1.2]);


subplot(223)
bar([P_Lw4L,P_Lw3L,P_LsL,P_Ll1L,P_Ll0L;P_Rw4R,P_Rw3R,P_RsR,P_Rl1R,P_Rl0R]);
title('Trial History 1 back');
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'Left stay','Right stay'});
legend({'Win4','Win3','Safe','Loss1','Loss0'})
axis([0 3 0 1.2]);

subplot(224)
bar([P_Lww4L,P_Lww3L,P_LssL,P_Lll1L,P_Lll0L;P_Rww4R,P_Rww3R,P_RssR,P_Rll1R,P_Rll0R]);
title('Trial History 2 back');
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'Left stay','Right stay'});
legend({'Win4','Win3','Safe','Loss1','Loss0'})
axis([0 3 0 1.2]);

BehaviorAlys.HistoryWL=[P_Lw4L,P_Lw3L,P_LsL,P_Ll1L,P_Ll0L,P_Rw4R,P_Rw3R,P_RsR,P_Rl1R,P_Rl0R];
BehaviorAlys.HistoryWL2=[P_Lww4L,P_Lww3L,P_LssL,P_Lll1L,P_Lll0L,P_Rww4R,P_Rww3R,P_RssR,P_Rll1R,P_Rll0R];

% subplot(223)
% bar([P_LwwwL,P_LsssL,P_LlllL;P_RwwwR,P_RsssR,P_RlllR]);
% title('Trial History 3 back');
% subplot(224)
% bar([P_LwwwwL,P_LssssL,P_LllllL;P_RwwwwR,P_RssssR,P_RllllR]);
% title('Trial History 4 back');

% X(X(:,11:20)>0)=1;
% X(X(:,11:20)==0)=-1;


%%     logistic regression
% prepare data


G_Direct=InfoTrial_valid.ChoiceD;  % gamble direction
G_Direct=InfoTrial_valid.ChoiceD;
G_Direct(G_Direct==2)=0;


clear X
u=0;
for trial=11:size(InfoTrial_valid,1)
    
    if I_Choice(trial)==1
    u=u+1;
    clear a0 a1
    y(u,1)=G_Direct(trial);
%    X(trial-10,11:20)=Gamble_Result((trial-1):-1:(trial-10))==-1 & LowRisk_Result((trial-1):-1:(trial-10))==-1 ;
  
   a0=InfoTrial_valid.Reward((trial-1):-1:(trial-10)).*(InfoTrial_valid.ChoiceD((trial-1):-1:(trial-10))==1);
   a1=InfoTrial_valid.Reward((trial-1):-1:(trial-10)).*(InfoTrial_valid.ChoiceD((trial-1):-1:(trial-10))==2);

   X(u,1:10)=a0/4;
   X(u,11:20)=a1/4; 
   
   
   if InfoTrial_valid.Targ1Opt(trial)==11
   X(u,21)=1;
   elseif InfoTrial_valid.Targ1Opt(trial)==12
   X(u,21)=0.5;
   else
    X(u,21)=0;
   end
   
   if InfoTrial_valid.Targ2Opt(trial)==11
   X(u,22)=1;
   elseif InfoTrial_valid.Targ2Opt(trial)==12
   X(u,22)=0.5;
   else
   X(u,22)=0;
   end

 
  
%    X(u,21:30)=(a0>2)-(a0<2);
%    X(u,31:40)=(a1>2)-(a1<2); 
   end
end
X2=X(:,21:22);


% Initialize parameters
fprintf('Initializing parameters');
m = size(X, 1); % number of examples
lambda = 0; % regularization parameter 0.1
numLabels = length(unique(y))-1; % number of labels
fprintf('...done\n');

% % Split data into training and testing
% fprintf('Splitting Data into training and testing sets');
% [XTrain XTest yTrain yTest] = splitData(X, y);

theta = LRClassifier(X, y, numLabels, lambda);
theta2 = LRClassifier(X2, y, numLabels, lambda);

figure(2)
subplot(121)
fun=@(x,xdata) x(1)*exp(x(2)*(x(3)+xdata));
xdata1=-10:1:-1;
xdata0=-10:0.1:-1;
x0=[1 0.5 0];
b1=lsqcurvefit(fun,x0,xdata1,flip(theta(1:10)));
plot(xdata0, fun(b1,xdata0),'k');hold on;
x0=[-0.1 1 0];
% b2=lsqcurvefit(fun,x0,xdata1,flip(theta(21:30)));
% plot(xdata0, fun(b2,xdata0),'b');hold on;
x0=[-1 1 11];
b3=lsqcurvefit(fun,x0,xdata1,flip(theta(11:20)));
plot(xdata0, fun(b3,xdata0),'r');hold on;
legend({'Left result','Right result'},'Location','NorthWest');
plot(-10:1:-1,flip(theta(1:10))','ko','MarkerSize',3); hold on;
plot(-10:1:-1,flip(theta(11:20))','ro','MarkerSize',3); hold on;
% plot(-10:1:-1,flip(theta(21:30))','bo','MarkerSize',3); hold on;
plot(-10:1:-1,flip(theta(1:10))','ko','MarkerSize',2); hold on;
plot(-10:1:-1,flip(theta(11:20))','ro','MarkerSize',2); hold on;
% plot(-10:1:-1,flip(theta(21:30))','bo','MarkerSize',2); hold on;

% f = fit((-10:1:-1)',-theta(1:10)','exp1');
% plot(f,-10:1:-1,-flip(theta(1:10)))
axis([-10 0 -3 3]);
ylabel('Weight');
box off; set(gca,'TickDir','out');
title({'Logestic regression',['Theta0=',num2str(theta(21),3),' Tg=',num2str(1/b1(2),3),' Ts=',num2str(1/b3(2),3)]});

subplot(222)
bar(theta(21:23),0.5);
%bar(theta2,0.5);
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'Left Risk','Right Risk','Left Bias'});

BehaviorAlys.ResultEffect=theta;
BehaviorAlys.RiskRegress=theta2;
BehaviorAlys.ChoicePerc=ChoicePerc(:);
BehaviorAlys.RiskPerc=RiskChoicePerc(3,:);
save(Eventfile,'BehaviorAlys','-append');

subplot(224)
%bar(theta(21:23),0.5);
bar(theta2,0.5);
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'Left Risk','Right Risk','Left Bias'});

BehaviorAlys.ResultEffect=theta;
BehaviorAlys.RiskRegress=theta2;
BehaviorAlys.ChoicePerc=ChoicePerc(:);
BehaviorAlys.RiskPerc=RiskChoicePerc(3,:);
save(Eventfile,'BehaviorAlys','-append');

% subplot(122)
% fun=@(x,xdata) x(1)*exp(x(2)*(x(3)+xdata));
% xdata1=-10:1:-1;
% xdata0=-10:0.1:-1;
% x0=[1 0.5 11];
% b1=lsqcurvefit(fun,x0,xdata1,flip(theta(21:30)));
% plot(xdata0, fun(b1,xdata0),'k');hold on;
% x0=[-0.1 1 7];
% % b2=lsqcurvefit(fun,x0,xdata1,flip(theta(21:30)));
% % plot(xdata0, fun(b2,xdata0),'b');hold on;
% x0=[-1 1 11];
% 
% b3=lsqcurvefit(fun,x0,xdata1,flip(theta(31:40)));
% plot(xdata0, fun(b3,xdata0),'r');hold on;
% legend({'Left result','Right result'},'Location','NorthWest');
% plot(-10:1:-1,flip(theta(21:30))','ko','MarkerSize',3); hold on;
% plot(-10:1:-1,flip(theta(31:40))','ro','MarkerSize',3); hold on;
% % plot(-10:1:-1,flip(theta(21:30))','bo','MarkerSize',3); hold on;
% plot(-10:1:-1,flip(theta(21:30))','ko','MarkerSize',2); hold on;
% plot(-10:1:-1,flip(theta(31:40))','ro','MarkerSize',2); hold on;
% % plot(-10:1:-1,flip(theta(21:30))','bo','MarkerSize',2); hold on;
% 
% % f = fit((-10:1:-1)',-theta(1:10)','exp1');
% % plot(f,-10:1:-1,-flip(theta(1:10)))
% axis([-10 0 -2 2]);
% ylabel('Weight');
% box off; set(gca,'TickDir','out');
% title({'Logestic regression',['Theta0=',num2str(theta(21),3),' Tg=',num2str(1/b1(2),3),' Ts=',num2str(1/b3(2),3)]});


%%

h10=figure(1);
print( h10, '-djpeg', [DirFig,'BehaviorSum1']);
print( h10, '-depsc', [DirFig,'BehaviorSum1']);
h10=figure(2);
print( h10, '-djpeg', [DirFig,'BehaviorSum2']);
print( h10, '-depsc', [DirFig,'BehaviorSum2']);
h10=figure(3);
print( h10, '-djpeg', [DirFig,'BehaviorSum3']);
print( h10, '-depsc', [DirFig,'BehaviorSum3']);
h10=figure(4);
print( h10, '-djpeg', [DirFig,'BehaviorSum4']);
print( h10, '-depsc', [DirFig,'BehaviorSum4']);
% for trial=1:size(