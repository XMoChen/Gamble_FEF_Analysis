function ContrastRiskRegress(Spikefile,Eventfile,Ch_num)
%%%% dock the figures
%%%% do not analyze the unsorted ones
%close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'BG','SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
% clear ContrastBG BG TG Sac
C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;

RiskPD(InfoTrial.DOpt(:,1)==2)=0;
RiskPD(InfoTrial.DOpt(:,1)==12)=1;
RiskPD(InfoTrial.DOpt(:,1)==11)=2;

RiskNPD(InfoTrial.DOpt(:,2)==2)=0;
RiskNPD(InfoTrial.DOpt(:,2)==12)=1;
RiskNPD(InfoTrial.DOpt(:,2)==11)=2;

for sec=1:max(InfoTrial.Block)
RewardFCPD(InfoTrial.Block==sec)=nanmean(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt==0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,1)==1));
RewardCPD(InfoTrial.Block==sec)=nanmean(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt~=0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,1)==1));
RewardVarFCPD(InfoTrial.Block==sec)=nanstd(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt==0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,1)==1));
RewardVarCPD(InfoTrial.Block==sec)=nanstd(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt~=0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,1)==1));

RewardFCNPD(InfoTrial.Block==sec)=nanmean(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt==0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,2)==1));
RewardCNPD(InfoTrial.Block==sec)=nanmean(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt~=0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,2)==1));
RewardVarFCNPD(InfoTrial.Block==sec)=nanstd(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt==0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,2)==1));
RewardVarCNPD(InfoTrial.Block==sec)=nanstd(InfoTrial.Reward(InfoTrial.Reward>0 & InfoTrial.Targ2Opt~=0 & InfoTrial.Block==sec & InfoTrial.DChoice(:,2)==1));

end


%%
I_valid=InfoTrial.Reward>0 ;
InfoTrial_valid=InfoTrial(I_valid,:);
for trial=2:size(InfoTrial_valid,1)
    InfoTrial_valid.LastLReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,1)==1);
    InfoTrial_valid.LastRReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,2)==1);
end   

sigma=5;
kernel=HalfGaussian(sigma);
r=InfoTrial_valid.DChoice(:,1)==1;
LeftSaccade_Index=convn(r',kernel,'same')';
r=InfoTrial_valid.DChoice(:,2)==1;
RightSaccade_Index=convn(r',kernel,'same')';

sigma=5;
kernel=HalfGaussian(sigma);
LeftReward_Index=convn(InfoTrial_valid.LastLReward',kernel,'same')';
RightReward_Index=convn(InfoTrial_valid.LastRReward',kernel,'same')';



LeftSaccade_Perc=LeftSaccade_Index./(RightSaccade_Index+LeftSaccade_Index);
LeftReward_Perc=LeftReward_Index./(RightReward_Index+LeftReward_Index);
RightSaccade_Perc=1-LeftSaccade_Index./(RightSaccade_Index+LeftSaccade_Index);
RightReward_Perc=1-LeftReward_Index./(RightReward_Index+LeftReward_Index);

figure()
subplot(221)
plot(LeftSaccade_Index,'r');hold on;
plot(RightSaccade_Index,'b');
box off; set(gca,'TickDir','out');legend({'Left saccade','Right saccade'});
axis([0 length(LeftSaccade_Index) 0 1.2]);
title('G103117 Saccade');
subplot(222)
plot(LeftReward_Index,'r');hold on;
plot(RightReward_Index,'b');
box off; set(gca,'TickDir','out');legend({'Left reward','Right reward'});
axis([0 length(LeftSaccade_Index) 0 4]);
title('Reward');
subplot(223)
plot(LeftSaccade_Perc,'k');hold on;
plot(LeftReward_Perc,'b');
axis([0 length(LeftSaccade_Index) 0 1.2]);
title('Left'); legend({'SaccadePerc','RewardPerc'})
box off; set(gca,'TickDir','out');
subplot(224)
plot(RightSaccade_Perc,'k');hold on;
plot(RightReward_Perc,'b');
title('Right')
axis([0 length(LeftSaccade_Index) 0 1.2]);
 legend({'SaccadePerc','RewardPerc'});
 box off; set(gca,'TickDir','out');



%%


InfoTrial.LeftSaccade_Index(I_valid,1)=LeftSaccade_Index;
InfoTrial.RightSaccade_Index(I_valid,1)=RightSaccade_Index;
InfoTrial.LeftReward_Index(I_valid,1)=LeftReward_Index;
InfoTrial.RightReward_Index(I_valid,1)=RightReward_Index;



BG_Color={'k','b','g'};
risk_l=[2,12,11];


%%
BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
% close all

unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            Unit_channel(unit_all,1)=ch;
            % figure(unit_all)
            
            
            clear Spike Spike_BG
            for period=1:3
                
                if period<=2
                    t_bg=-100:501;
                    eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='BG';
                    T_s=150:600;
                    BG0=nanmean(Spike(:,1:50),2);
                    Spike_BG=bsxfun(@minus,Spike,BG0); % Spike;%

                elseif period==3
                    t_bg=-500:1001;
                    eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='TG';
                    T_s=550:1000;
                    Spike_BG=bsxfun(@minus,Spike,BG0); % Spike;%

                end
                
                mr0=0;
                nr0=1000;
                
                clear r0 mdl1 mdl2
                if period==1
                [h,p]=ttest(nanmean(Spike,2),BG0);
                    if h>0
                      Unit_channel(unit_all,2)= 1;
                    else
                      Unit_channel(unit_all,2)= 0;
                    end
                r0=Scale(BG0);
               else
%                 Spike_BG=bsxfun(@minus,Spike,BG0); % Spike;%
                Spike_BG=zscorematrix(Spike_BG);
                r0=nanmean(Spike_BG( :,T_s ),2);
               end
                
                
                %%% Forced choice
                clear X I_s r T mdl1
                if period<=2
                I_s=InfoTrial.Targ2Opt==0  & InfoTrial.Reward>0;
                else
                I_s=InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0;
                end   
                X(1,:)=InfoTrial.ContrastBG(I_s);
                X(2,:)=InfoTrial.DRate(I_s,1);
                X(3,:)=RewardFCPD(I_s);
                X(4,:)=RewardVarFCPD(I_s)';
               
%                 r=r0( I_s,: );
%                 statsx1 =regstats(r,X','interaction');
%                 T=[0 0 0 0 0;1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; ...
%                    1 1 0 0 0; 1 0 1 0 0; 1 0 0 1 0]; 
                r=r0(I_s,: );
%                 T=[0 0 0 0 0;0 1 0 0 0];
%                 tbl=table(X(1,:)',X(2,:)',X(3,:)',X(4,:)','VariableNames',{'Contrast';'ChoiceRate';'Reward';'Risk'});                
%                mdl1=fitlm(X',r,T)
                [Coefficient_aic1,Coefficient_bic1,fitness1]=RegressModelSelect(X',r);
%                 T=[0 0 0 0 0; 1 0 0 0 0; 0 1 0 0 0; 0 0 1 0  0; 0 0 0 1 0 ; ...
%                    1 1 0 0 0;  1 0 1 0 0; 1 0 0 1 0]; 
%                mdl = stepwiselm(X',r,[0 0 0 0 ],'upper',T)
                
                %%% Choice
               clear X I_s r T mdl2
                I_s=InfoTrial.Targ2Opt~=0  & InfoTrial.Reward>0;
                X(1,:)=InfoTrial.ContrastBG(I_s);
%                 X(2,:)=InfoTrial.LeftSaccade_Index(I_s);
%                 X(3,:)=InfoTrial.LeftReward_Index(I_s)';
                X(2,:)=InfoTrial.DRate(I_s,1);
                X(3,:)=RewardCPD(I_s)';
                X(4,:)=RewardVarFCPD(I_s)';%RiskPD(I_s)';
                X(5,:)=InfoTrial.DChoice(I_s,1);
%                 T=[0 0 0 0 0 0; 1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; ...
%                    1 1 0 0 0 0;  1 0 1 0 0 0; 1 0 0 1 0 0; 1 0 0 0 1 0]; 
                r=r0( I_s,: );
                
                [Coefficient_aic2,Coefficient_bic2,fitness2]=RegressModelSelect(X',r);

                
                %%%% FC: contrast choicefrequency reward risk
                %%%%  C: contrast choicetemp rewardtemp risk choice

                if period==1
                Fix_regression.FC.beta(unit_all,:)=Coefficient_aic1(:,1);%statsx1.tstat.beta;
                Fix_regression.FC.sig(unit_all,:)=Coefficient_aic1(:,4);
                Fix_regression.FC.beta2(unit_all,:)=Coefficient_bic1(:,1);%statsx1.tstat.beta;
                Fix_regression.FC.sig2(unit_all,:)=Coefficient_bic1(:,4);
                Fix_regression.FC.fit(unit_all,:)=fitness1;

                Fix_regression.Choice.beta(unit_all,:)=Coefficient_aic2(:,1);
                Fix_regression.Choice.sig(unit_all,:)=Coefficient_aic2(:,4);
                Fix_regression.Choice.beta2(unit_all,:)=Coefficient_bic2(:,1);
                Fix_regression.Choice.sig2(unit_all,:)=Coefficient_bic2(:,4);
                Fix_regression.Choice.fit(unit_all,:)=fitness2;

                elseif period==2
                BGRateAll(unit_all,:,:)=Spike_BG;
                BG_regression.FC.beta(unit_all,:)=Coefficient_aic1(:,1);
                BG_regression.FC.sig(unit_all,:)=Coefficient_aic1(:,4);
                BG_regression.FC.beta2(unit_all,:)=Coefficient_bic1(:,1);
                BG_regression.FC.sig2(unit_all,:)=Coefficient_bic1(:,4);
                BG_regression.FC.fit(unit_all,:)=fitness1;
                
                BG_regression.Choice.beta(unit_all,:)=Coefficient_aic2(:,1);
                BG_regression.Choice.sig(unit_all,:)=Coefficient_aic2(:,4);
                BG_regression.Choice.beta2(unit_all,:)=Coefficient_bic2(:,1);
                BG_regression.Choice.sig2(unit_all,:)=Coefficient_bic2(:,4);
                BG_regression.Choice.fit(unit_all,:)=fitness2;

                else
                TGRateAll(unit_all,:,:)=Spike_BG;
                TG_regression.FC.beta(unit_all,:)=Coefficient_aic1(:,1);
                TG_regression.FC.sig(unit_all,:)=Coefficient_aic1(:,4);
                 TG_regression.FC.beta2(unit_all,:)=Coefficient_bic1(:,1);
                TG_regression.FC.sig2(unit_all,:)=Coefficient_bic1(:,4);
                TG_regression.FC.fit(unit_all,:)=fitness1;

                TG_regression.Choice.beta(unit_all,:)=Coefficient_aic2(:,1);
                TG_regression.Choice.sig(unit_all,:)=Coefficient_aic2(:,4);
                TG_regression.Choice.beta2(unit_all,:)=Coefficient_bic2(:,1);
                TG_regression.Choice.sig2(unit_all,:)=Coefficient_bic2(:,4);
                TG_regression.Choice.fit(unit_all,:)=fitness2;

                end
                           
            end
        end
    end
end
 save(Spikefile,'Fix_regression','BG_regression','TG_regression','Unit_channel','-append');
%FC: contrast choiceprob reward risk
%%

% Color={'k--','k:','k','b--','b:','b','r--','r:','r'};
% figure(10)
% for ii=1:9
%     if ii<=3
%     plot(squeeze(BG.FC.ContrastRisk(unit_all,ii,:)),char(Color(ii)));hold on;
%     elseif ii<=6
%     plot(squeeze(BG.FC.ContrastRisk(unit_all,ii,:)),char(Color(ii)));hold on;
%     else
%     plot(squeeze(BG.FC.ContrastRisk(unit_all,ii,:)),char(Color(ii)));hold on;
%     end        
% end
% %%
% titleflag={'contrast', 'choiceprob', 'reward', 'risk','c*choiceprob', 'c*reward', 'c*risk'};
% figure(1)
% for ii=1:7
% if ii<=4
% subplot(6,4,ii)
% else
% subplot(6,4,ii+1)
% end
% bound=round(max(abs(Fix_regression.FC.beta(:,ii+1)))*1000)/1000;
% xx=linspace(-bound,bound,10);
% h=hist(Fix_regression.FC.beta(:,ii+1),xx);
% h2=hist(Fix_regression.FC.beta(Fix_regression.FC.sig(:,ii+1)<0.05,ii+1),xx);
% bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
% bar (xx,h2,'FaceColor',[0 .5 .5])
% title(char(titleflag(ii)));
% 
% if ii<=4
% subplot(6,4,ii+8)
% else
% subplot(6,4,ii+9)
% end
% bound=round(max(abs(BG_regression.FC.beta(:,ii+1)))*1000)/1000;
% xx=linspace(-bound,bound,10);
% h=hist(BG_regression.FC.beta(:,ii+1),xx);
% h2=hist(BG_regression.FC.beta(BG_regression.FC.sig(:,ii+1)<0.05,ii+1),xx);
% bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
% bar (xx,h2,'FaceColor',[0 .5 .5])
% title(char(titleflag(ii)));
% 
% if ii<=4
% subplot(6,4,ii+16)
% else
% subplot(6,4,ii+17)
% end
% bound=round(max(abs(TG_regression.FC.beta(:,ii+1)))*1000)/1000;
% xx=linspace(-bound,bound,10);
% h=hist(TG_regression.FC.beta(:,ii+1),xx);
% h2=hist(TG_regression.FC.beta(TG_regression.FC.sig(:,ii+1)<0.05,ii+1),xx);
% bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
% bar (xx,h2,'FaceColor',[0 .5 .5])
% title(char(titleflag(ii)));
% 
% end
% %%
% titleflag={'contrast', 'choiceprob', 'reward', 'risk','choice', 'c*choiceprob', 'c*reward', 'c*risk','c*choice'};
% figure(2)
% for ii=1:9
% 
% if ii<=5
% subplot(6,5,ii)
% else
% subplot(6,5,ii+1)
% end
% bound=round(max((Fix_regression.Choice.beta(:,ii+1)))*1000)/1000;
% xx=linspace(-bound,bound,10);
% h=hist(Fix_regression.Choice.beta(:,ii+1),xx);
% h2=hist(Fix_regression.Choice.beta(Fix_regression.Choice.sig(:,ii+1)<0.05,ii+1),xx);
% bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
% bar (xx,h2,'FaceColor',[0 .5 .5])
% title(char(titleflag(ii)));
% 
% if ii<=5
% subplot(6,5,ii+10)
% else
% subplot(6,5,ii+11)
% end
% bound=round(max(abs(BG_regression.Choice.beta(:,ii+1)))*1000)/1000;
% xx=linspace(-bound,bound,10);
% h=hist(BG_regression.Choice.beta(:,ii+1),xx);
% h2=hist(BG_regression.Choice.beta(BG_regression.Choice.sig(:,ii+1)<0.05,ii+1),xx);
% bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
% bar (xx,h2,'FaceColor',[0 .5 .5])
% title(char(titleflag(ii)));
% 
% if ii<=5
% subplot(6,5,ii+20)
% else
% subplot(6,5,ii+21)
% end
% bound=round(max(abs(TG_regression.Choice.beta(:,ii+1)))*1000)/1000;
% xx=linspace(-bound,bound,10);
% h=hist(TG_regression.Choice.beta(:,ii+1),xx);
% h2=hist(TG_regression.Choice.beta(TG_regression.Choice.sig(:,ii+1)<0.05,ii+1),xx);
% bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
% bar (xx,h2,'FaceColor',[0 .5 .5])
% title(char(titleflag(ii)));
% end