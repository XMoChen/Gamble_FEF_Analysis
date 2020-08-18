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
close all
t_bg=-100:501;

unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            mr0=0;
            nr0=1000;
            
            Spike_BG=Spike;
            ax1=subplot(551);
            for contrast=1:3
               r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==1)',:),1);
               [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,BG_Color(contrast,:));

            end
            box off;set(gca,'TickDir','out')
            title(['Ch',num2str(ch),'Unit',num2str(unit-1),'FC P'])
            xlabel('BG onset (ms)');
            ylabel('Spikes/s');
            legend({'L contr','M contr','H contr'},'Position',[0.03 0.82 0.03 0.1]);
        
            ax2=subplot(552);
            for contrast=1:3
                r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==2),:));
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,BG_Color(contrast,:));
            end
            title('FC NP')
            
            ax3=subplot(553);
            for contrast=1:3
                r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt~=0 &  InfoTrial.ChoiceD==1)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,BG_Color(contrast,:));
            end
            title('2AC P')
            
            ax4=subplot(554);
            for contrast=1:3
                r=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt~=0 &  InfoTrial.ChoiceD==2)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,BG_Color(contrast,:));
            end
            box off;set(gca,'TickDir','out')
            title('2AC NP')
            
            
            maxrate=mr0*1.1;
            minrate=nr0*0.9;
            axis([ax1 ax2 ax3 ax4],[-100 500 minrate maxrate]);
            
        end
    end
end


%%
c_risk=[0,0,0; 1, 0, 1; 1,0,0];

Opt=[2,12,11];
unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            mr0=0;
            nr0=1000;
            
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_BG=Spike;
            
         
            ax1=subplot(556);
            for o=1:3
               r=nanmean(Spike_BG((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)>0)',:),1);
               [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
            end
            xlabel('BG onset (ms)');
            ylabel('Spikes/s');
            
           ax2=subplot(557);
            for o=1:3
               r=nanmean(Spike_BG((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)>0 )',:),1);
               [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
            end
            legend({'risk 0','risk 1','risk 2'},'Position',[0.03 0.65 0.03 0.1]);
            title('NP Risk')

            ax3=subplot(558);
            for o=1:3
                r=nanmean(Spike_BG((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
            end
            title('P Risk')
  
            ax4=subplot(559);
            for o=1:3
                r=nanmean(Spike_BG((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1);
               [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));
            end
            title('P Risk')
            
            ax5=subplot(5,5,10);
            for o=1:3
                r=nanmean(Spike_BG((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(o,:));

            end
            title('NP Risk')
            
            maxrate=mr0*1.1;
            minrate=nr0*0.9;
            axis([ax1 ax2 ax3 ax4 ax5],[-100 500 minrate maxrate]);            
            
        end
    end
end

%%
%close all
t_targ=-500:1001;
unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            
            mr0=0;
            nr0=1000;       

            
            ax1=subplot(5,5,11);
            mr0=0;
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));
            end
            xlabel('Targ onset (ms)');
            ylabel('Spikes/s');
            
            
            ax2=subplot(5,5,12);
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));
            end
            
            ax3=subplot(5,5,13);
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));
            end
            
            
            ax4=subplot(5,5,14);
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));

            end
            
            ax5= subplot(5,5,15);
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));

            end
            
            maxrate=mr0*1.1;
            minrate=nr0*0.9;
            axis([ax1 ax2 ax3 ax4 ax5],[-100 1000 minrate maxrate]);                      
        end
    end
end

%%
%%%  saccade
%close all
t_targ=-500:501;
unit_all=0;
Opt=[2,12,11];
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            mr0=0;
            nr0=1000;
            
            
            ax1= subplot(5,5,18);
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));
                
            end

            
            ax2= subplot(5,5,16);
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));
            end
            xlabel('Saccade onset (ms)');
            ylabel('Spikes/s');
            
            ax3=subplot(5,5,17);
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                 [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));
            end
            

            ax4=subplot(5,5,19)
            for o=1:3
               r=nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1);
               [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));
            end
            
            
            ax5=subplot(5,5,20)
            for o=1:3
                r=nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                [mr0,nr0]=plotminmax(t_targ,r,mr0,nr0,c_risk(o,:));

            end
            
             maxrate=mr0*1.1;
            minrate=nr0*0.9;
            axis([ax1 ax2 ax3 ax4 ax5],[-500 300 minrate maxrate]);     
        end
    end
end

%%
%%%  result
%close all
r_color=[0,0,1;0,1,0;0,0,0;1,0,1;1,0,0];
t_result=-500:501;
unit_all=0;
Rewd=[0.001,1,2,3,4];
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            mr0=0;
            nr0=1000;
            
       
            ax1=subplot(5,5,21);
            for rr=1:5
                r=nanmean(Spike((InfoTrial.Reward==Rewd(rr) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1);
                [mr0,nr0]=plotminmax(t_result,r,mr0,nr0,r_color(rr,:));

            end
            xlabel('Result onset (ms)');
            ylabel('Spikes/s');
            
            
            
            ax2=subplot(5,5,22);
            for rr=1:5
                r=nanmean(Spike((InfoTrial.Reward==Rewd(rr) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                [mr0,nr0]=plotminmax(t_result,r,mr0,nr0,r_color(rr,:));

            end
            
            axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
            legend({'0','1','2','3','4'},'Position',[0.03 0.13 0.03 0.1]);
            
            
            ax3=subplot(5,5,23);
            for rr=1:5
                r=nanmean(Spike((InfoTrial.Reward==Rewd(rr) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1);
                [mr0,nr0]=plotminmax(t_result,r,mr0,nr0,r_color(rr,:));

            end
            
            ax4=subplot(5,5,24);
            for rr=1:5
                r=nanmean(Spike((InfoTrial.Reward==Rewd(rr) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1);
                [mr0,nr0]=plotminmax(t_result,r,mr0,nr0,r_color(rr,:));

            end
            legend

            
            maxrate=mr0*1.1;
            minrate=nr0*0.9;
            axis([ax1 ax2 ax3 ax4 ax5],[-500 500 minrate maxrate]);     
            
            
            h10=figure(unit_all);
            print( h10, '-djpeg', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1)]);
            print( h10, '-depsc', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1)]);
        end
        
        
        
    end
end



