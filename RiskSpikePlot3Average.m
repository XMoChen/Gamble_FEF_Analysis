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
                for risk=1:3
                    
                    if period==1
                        ax1=subplot(3,4,1+(period-1)*4);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.Targ2Opt==0  &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.ChoiceD>0),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.ChoiceD>0),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.ChoiceD>0),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title(['Ch',num2str(ch),'Unit',num2str(unit-1),'FC P risk'])

                        
                    elseif period==2
                        ax1=subplot(3,4,1+(period-1)*4);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.DChoice(:,1)>0),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.DChoice(:,1)>0),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.DChoice(:,1)>0),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                         title('FC TgIn P risk')
                         
                        ax3=subplot(3,4,2+(period-1)*4);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.DChoice(:,2)>0),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.DChoice(:,2)>0),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)  &  InfoTrial.DChoice(:,2)>0),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                         title('FC TgIn P risk')
                         
                    else 
                        ax1=subplot(3,4,1+(period-1)*4);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)   &  InfoTrial.DChoice(:,1)>0),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)   &  InfoTrial.DChoice(:,1)>0),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,1)==Opt(risk)   &  InfoTrial.DChoice(:,1)>0),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                         title('FC TgIn P risk')

                        ax3=subplot(3,4,2+(period-1)*4);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==Opt(risk)   &  InfoTrial.DChoice(:,2)>0),:));
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==Opt(risk)   &  InfoTrial.DChoice(:,2)>0),:));
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DOpt(:,2)==Opt(risk)   &  InfoTrial.DChoice(:,2)>0),:));
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                         title('FC TgOut Np risk')

                        
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
                legend({'L risk','M risk','H risk'},'Position',[0.03 0.82 0.03 0.1]);
                
                
                     
                
                
                ax2=subplot(3,4,3+(period-1)*4);
                for risk=1:3
                    if period<=2
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceD>0),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceD>0),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceD>0),:),1);
                    r=nanmean([r1;r2;r3],1);
                    [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                    title('C P risk')

                    else
                        ax2=subplot(3,4,3+(period-1)*4);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,1)>0),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,1)>0),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,1)>0),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:));
                        title('C ChoiceIn P risk')

                        ax4=subplot(3,4,4+(period-1)*4);
                        r1=nanmean(Spike_BG((InfoTrial.ContrastBG==1 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)>0),:),1);
                        r2=nanmean(Spike_BG((InfoTrial.ContrastBG==2 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)>0),:),1);
                        r3=nanmean(Spike_BG((InfoTrial.ContrastBG==3 &  InfoTrial.DOpt(:,1)==Opt(risk) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)>0),:),1);
                        r=nanmean([r1;r2;r3],1);
                        [mr0,nr0]=plotminmax(t_bg,r,mr0,nr0,c_risk(risk,:)); 
                        title('C ChoiceOut P risk')
                    end
                    
                end
                box off;set(gca,'TickDir','out')
                
                
  
                maxrate=mr0*1.1;
                minrate=nr0*0.9;
                if period==1
                axis([ax1 ax2  ],[min(t_bg) max(t_bg) minrate maxrate]);
                elseif period==2
                axis([ax1 ax2  ax3],[min(t_bg) max(t_bg) minrate maxrate]);
                else
                axis([ax1 ax2 ax3 ax4  ],[min(t_bg) max(t_bg) minrate maxrate]);
                end                    
                end
            
        end
    end
    
    h10=figure(unit_all);
    print( h10, '-djpeg', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1),'RiskAverage']);
%     print( h10, '-depsc', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1),'RiskAverage']);
    
end


