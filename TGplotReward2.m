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
for trial=3:size(InfoTrial_valid,1)
    InfoTrial_valid.LastLReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,1)==1);
    InfoTrial_valid.LastRReward(trial,1)=InfoTrial_valid.Reward(trial-1,1)*(InfoTrial_valid.DChoice(trial-1,2)==1);
    InfoTrial_valid.Last2LReward(trial,1)=InfoTrial_valid.Reward(trial-2,1)*(InfoTrial_valid.DChoice(trial-2,1)==1);
    InfoTrial_valid.Last2RReward(trial,1)=InfoTrial_valid.Reward(trial-2,1)*(InfoTrial_valid.DChoice(trial-2,2)==1);

end    
I_valid=InfoTrial.Reward>0;
InfoTrial_valid.ContrastBG=InfoTrial.ContrastBG(I_valid);
BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
c_risk=[0,0,0; 1, 0, 1; 1,0,0];
r_color=[1,1,0;0,0,1;0,1,0;0,0,0;1,0,1;1,0,0];
Rewd=[0,0.001,1,2,3,4];



Opt=[2,12,11];

close all
t_bg=-500:1001;

unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike=Spike(I_valid,:);
            SpikeTrialMean.Targ(unit_all,:)=nanmean(Spike(550:1550));
            mr0=0;
            nr0=1000;
            
            Spike_BG=Spike;
            for contrast=1:3
               ax1=subplot(3,5,contrast*5-5+1);
               for r=1:6
               r0=nanmean(Spike_BG((InfoTrial_valid.ContrastBG==contrast & InfoTrial_valid.LastLReward==Rewd(r) & InfoTrial_valid.Last2LReward==Rewd(r) &  InfoTrial_valid.Targ2Opt==0 &  InfoTrial_valid.ChoiceD==1)',:),1);
               [mr0,nr0]=plotminmax(t_bg,r0,mr0,nr0,r_color(r,:));
               end
            box off;set(gca,'TickDir','out')
            title(['Ch',num2str(ch),'Unit',num2str(unit-1),'FC P'])
            xlabel('Target onset (ms)');
            ylabel('Spikes/s');
            legend({'switch','0','1','2','3','4'},'Position',[0.03 0.13 0.03 0.1]);
        
                ax2=subplot(3,5,contrast*5-5+2);
               for r=1:6
                r0=nanmean(Spike_BG((InfoTrial_valid.ContrastBG==contrast & InfoTrial_valid.LastLReward==Rewd(r) & InfoTrial_valid.Last2LReward==Rewd(r) &  InfoTrial_valid.Targ2Opt==0 &  InfoTrial_valid.ChoiceD==2),:));
                [mr0,nr0]=plotminmax(t_bg,r0,mr0,nr0,r_color(r,:));
                end
            title('FC NP')
            

                ax3=subplot(3,5,contrast*5-5+3);  
                for r=1:6
                r0=nanmean(Spike_BG((InfoTrial_valid.ContrastBG==contrast  & InfoTrial_valid.LastLReward==Rewd(r) & InfoTrial_valid.Last2LReward==Rewd(r)  &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.ChoiceD==1)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r0,mr0,nr0,r_color(r,:));
                end
            title('2AC chose P')
            

                ax4=subplot(3,5,contrast*5-5+4);
                for r=1:6
                r0=nanmean(Spike_BG((InfoTrial_valid.ContrastBG==contrast  & InfoTrial_valid.LastLReward==Rewd(r) & InfoTrial_valid.Last2LReward==Rewd(r) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.ChoiceD==2)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r0,mr0,nr0,r_color(r,:));
                end
            box off;set(gca,'TickDir','out')
            title('2AC chose NP')
            
                ax5=subplot(3,5,contrast*5);
                for r=1:6
                r0=nanmean(Spike_BG((InfoTrial_valid.ContrastBG==contrast  & InfoTrial_valid.LastLReward==Rewd(r) & InfoTrial_valid.Last2LReward==Rewd(r) &  InfoTrial_valid.Targ2Opt~=0 )',:),1);
                [mr0,nr0]=plotminmax(t_bg,r0,mr0,nr0,r_color(r,:));
                end
            box off;set(gca,'TickDir','out')
            title('2AC Combined')
            
        if contrast==1    
            maxrate=mr0*1.1;
            minrate=nr0*0.9;
        end
            axis([ax1 ax2 ax3 ax4 ax5],[-100 1000 minrate maxrate]);
        end
        end
    end
end


