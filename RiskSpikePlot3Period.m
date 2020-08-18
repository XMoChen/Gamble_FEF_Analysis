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
c_risk=[0,0,0; 1, 1, 0; 1,0,0];
Opt=[2,12,11];

close all

unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            
            
            for period= 1:3
                if period==1
                    t_bg=-100:501;
                    eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                elseif period==2
                    t_bg=-500:1001;
                    eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                elseif period==3
                    t_bg=-500:501;
                    eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                end
                
                mr0=0;
                nr0=1000;
                
                clear Spike_BG
                Spike_BG=Spike;
                ax1=subplot(4,6,1+(period-1)*6);
                for risk=1:3
                    
                    if period==1
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title(['Ch',num2str(ch),'Unit',num2str(unit-1),'FC NP=2'])

                        
                    elseif period==2
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                         title('FC TgIn NP=2')

                    else 
                        ax1=subplot(4,6,1+(period-1)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                         title('FC TgIn NP=2')

                        ax7=subplot(4,6,1+(period)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.ChoiceD==2),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.ChoiceD==2),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.ChoiceD==2),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                         title('FC TgOut P=2')

                        
                    end
                end
                box off;set(gca,'TickDir','out')
                if period==1
                    xlabel('BG onset (ms)');
                elseif period==2
                    xlabel('Tg onset (ms)');
                elseif period==3
                    xlabel('Saccade onset (ms)');
                end
                ylabel('Spikes/s');
                legend({'L contr','M contr','H contr'},'Position',[0.03 0.82 0.03 0.1]);
                
                
                ax2=subplot(4,6,2+(period-1)*6);
                for risk=1:3
                    
                    if period==1
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('FC TgIn NP=1/3')
     
                        
                    elseif period ==2 
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('FC TgIn NP=1/3')
                    else    
                        ax2=subplot(4,6,2+(period-1)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                         title('FC TgIn NP=1/3')

                        ax8=subplot(4,6,2+(period)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.ChoiceD==2),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.ChoiceD==2),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.ChoiceD==2),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                         title('FC TgOut P=1/3')
   
                        
                    end
                end
                box off;set(gca,'TickDir','out')
               
                
                
                ax3=subplot(4,6,3+(period-1)*6);
                for risk=1:3
                    
                    if period==1
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                         title('FC TgIn NP=0/4')

                        
                    elseif period==2 
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('FC TgIn NP=0/4')

                    else  
                        ax3=subplot(4,6,3+(period-1)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('FC TgIn NP=0/4')

                        ax9=subplot(4,6,3+(period)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.ChoiceD==2),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.ChoiceD==2),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.ChoiceD==2),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                        title('FC TgOut P=0/4')
       
                    end
                end
                box off;set(gca,'TickDir','out')
                
                
                
                ax4=subplot(4,6,4+(period-1)*6);
                for risk=1:3
                    if period<=2
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2),:),1);
                    r=nanmean([r1;r2;r3],1);
                    [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                    title('C NP=2')

                    else
                        ax4=subplot(4,6,4+(period-1)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==1),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('C ChoiceIn NP=2')

                        ax10=subplot(4,6,4+(period)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==2),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==2),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==2 &  InfoTrial.ChoiceD==2),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                        title('C ChoiceOut NP=2')
                    end
                    
                end
                box off;set(gca,'TickDir','out')
                
                
                ax5=subplot(4,6,5+(period-1)*6);
                for risk=1:3
                    if period<=2

                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12),:),1);
                    r=nanmean([r1;r2;r3],1);
                    [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                     title('C NP=1/3')

                     else
                        ax5=subplot(4,6,5+(period-1)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==1),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('C ChoiceIn NP=1/3')

                        ax11=subplot(4,6,5+(period)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==2),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==2),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==12 &  InfoTrial.ChoiceD==2),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                        title('C ChoiceOut NP=1/3')
                    end
                    
                    
                end
                box off;set(gca,'TickDir','out')
                
                
                ax6=subplot(4,6,6+(period-1)*6);
                for risk=1:3
                    if period<=2

                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11),:));
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11),:));
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11),:));
                    r=nanmean([r1;r2;r3],1);
                    [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                    title('C NP=0/4')

                    else
                        ax6=subplot(4,6,6+(period-1)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==1),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('C ChoiceIn NP=0/4')

                        ax12=subplot(4,6,6+(period)*6);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==2),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==2),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DOpt(:,2)==11 &  InfoTrial.ChoiceD==2),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                        title('C ChoiceOut NP=0/4')
                    end
                    
                end
                box off;set(gca,'TickDir','out')
                
                %             ax2=subplot(3,4,2+(period-1)*4);
                %             for risk=1:3
                %                 r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.Targ1Opt==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==2),:));
                %                 r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.Targ1Opt==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==2),:));
                %                 r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.Targ1Opt==Opt(risk) &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==2),:));
                %                 r=nanmean([r1;r2;r3],1);
                %                 [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                %             end
                %             title('FC NP')
                %
                %             ax3=subplot(3,4,3+(period-1)*4);
                %             for risk=1:3
                %                 r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 ),:));
                %                 r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 ),:));
                %                 r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 ),:));
                %                 r=nanmean([r1;r2;r3],1);
                %                 [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                %             end
                %             title('2AC P')
                %
                %             ax4=subplot(3,4,4+(period-1)*4);
                %             for risk=1:3
                %                 r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt~=0 ),:));
                %                 r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt~=0 ),:));
                %                 r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,2)==Opt(risk) &  InfoTrial.Targ2Opt~=0 ),:));
                %                 r=nanmean([r1;r2;r3],1);
                %                 [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                %             end
                %             box off;set(gca,'TickDir','out')
                %             title('2AC NP')
                %
                %
                maxrate=mr0*1.1;
                minrate=nr0*0.9;
                if period<=2
                axis([ax1 ax2 ax3 ax4 ax5 ax6 ],[min(t_bg) max(t_bg) minrate maxrate]);
                else
                axis([ax1 ax2 ax3 ax4 ax5 ax6 ax7 ax8 ax9 ax10 ax11 ax12 ],[min(t_bg) max(t_bg) minrate maxrate]);
                end                    
                end
            
        end
    end
    
    h10=figure(unit_all);
    print( h10, '-djpeg', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1),'Risk']);
    print( h10, '-depsc', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1),'Risk']);
    
end


