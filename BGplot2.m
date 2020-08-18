%function BackgroundSpike(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
%%%% do not analyze the unsorted ones
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
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
BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
c_risk=[0,0,0; 1, 0, 1; 1,0,0];

Opt=[2,12,11];

close all
t_bg=-100:501;

unit_all=0;
for ch=9%1:Ch_num
    for unit=2%:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            mr0=0;
            nr0=1000;
            
            Spike_BG=Spike;
            for contrast=3:-1:1
               ax1=subplot(3,5,contrast*5-5+1);
               for o=1:3
               r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast & InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 )',:),1);
               [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
               end
            box off;set(gca,'TickDir','out')
            title(['Ch',num2str(ch),'Unit',num2str(unit-1),'FC P'])
            xlabel('BG onset (ms)');
            ylabel('Spikes/s');
            legend({'L contr','M contr','H contr'},'Position',[0.03 0.82 0.03 0.1]);
        
%                 ax2=subplot(3,5,contrast*5-5+2);
%                 for o=1:3
%                 r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast & InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==2),:));
%                 [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
%                 end
%             title('FC NP')
            

                ax3=subplot(3,5,contrast*5-5+3);  
                for o=1:3
                r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast & InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.ChoiceD==1)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
                end
            title('2AC chose P')
            

                ax4=subplot(3,5,contrast*5-5+4);
                for o=1:3
                r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast & InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.ChoiceD==2)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
                end
            box off;set(gca,'TickDir','out')
            title('2AC chose NP')
            
                ax5=subplot(3,5,contrast*5);
                for o=1:3
                r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast & InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 )',:),1);
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
                end
            box off;set(gca,'TickDir','out')
            title('2AC Combined')
            
        if contrast==3    
            maxrate=mr0*1.1;
            minrate=nr0*0.9;
        end
            axis([ax1 ax3 ax4 ax5],[-100 500 minrate maxrate]);
        end
        end
    end
end


