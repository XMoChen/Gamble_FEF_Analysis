function Reward_ProbV(Spikefile,Eventfile,DirFig,Ch_num,name0,Bg_Lable)
%%%% dock the figures
%name0=char(Files(record));
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeEndRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
clear ContrastBG
C1=(InfoTrial.Background<=6);
ContrastBG(C1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
ContrastBG(C2)=2;
C3=(InfoTrial.Background>12 );
ContrastBG(C3)=3;
ContrastBG=ContrastBG';

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

PreferD=1;

GS_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0;
GC_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt~=0;
D_I=InfoTrial.TrialType==2 ;
%%% Receptive field in the preferred direction
PreferIn=(InfoTrial.PreferD==1);
PreferOut=( InfoTrial.PreferD==2);

PreferV=D4_V_trial+D1_V_trial;


Direction_Color={'k','k:'};
V_all=[0;V_all];
V_Color={'m','g','k','c','b','r'};


%%
close all
unit_all=0;
for ch=1:Ch_num %15
    for unit=2:length(l_ts(ch,:)) %3
        if l_ts(ch,unit)>5000
            unit_all=unit_all+1;
            
            
            
            
            eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_TG=Spike;
            eval(['Spike=SaccadeEndRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_SC=Spike;
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_BG=Spike;
            eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_RT=Spike;
            
            
            
            clear Spike_BG_base*
            Spike_BG_base=nanmean(Spike_BG(:,1:100),2);
            base_I=InfoTrial.TargetOn~=0 & isnan(Spike_BG_base)==0;
            Spike_BG_base=[nanmean(Spike_BG_base(1:100))*ones(50,1);Spike_BG_base(base_I)];
            windowSize = 50;
            b = (1/windowSize)*ones(1,windowSize);
            a = 1;
            Spike_BG_base00=filter(b,a,Spike_BG_base);
            Spike_BG_base00=Spike_BG_base00(51:end);
            Spike_BG_base0=zeros(size(Spike_BG,1),1);
            Spike_BG_base0(base_I)=Spike_BG_base00;
            
            
            Spike_BG=Spike_BG-repmat(Spike_BG_base0,1,size(Spike_BG,2));
            Spike_TG=Spike_TG-repmat(Spike_BG_base0,1,size(Spike_TG,2));
            Spike_SC=Spike_SC-repmat(Spike_BG_base0,1,size(Spike_SC,2));
            Spike_RT=Spike_RT-repmat(Spike_BG_base0,1,size(Spike_RT,2));
            
            
            
            %           %%%%   test no-choice trial, there should be no difference
            %           %%%%   between chosen direction before target onest
            %           I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1;
            %           I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==2;
            %           [hSig(unit_all,1),p1]=ttest2(nanmean(Spike_TG(I1,900:1000),2),nanmean(Spike_TG(I2,900:1000),2))
            %
            %
            %           %%%%   test choice trial, find the type of neurons which show
            %           %%%%   choice difference before the target onset (memory?)
            %           I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 ;
            %           I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==2;
            %           [hSig(unit_all,2),p2]=ttest2(nanmean(Spike_TG(I1,900:1000),2),nanmean(Spike_TG(I2,900:1000),2))
            %
            %           %%%%   test no-choice trial, there should be no difference
            %           %%%%   between different values before BG onest. If signifcant
            %           %%%%   difference, detected as drifting
            %           clear I1 I2
            %           I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==2;
            %           I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==11;
            %           I3= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==12;
            %
            %           [hSig(unit_all,3),p3]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I2,1:100),2));
            %           [hSig(unit_all,4),p4]=ttest2(nanmean(Spike_BG(I2,1:100),2),nanmean(Spike_BG(I3,1:100),2));
            %           [hSig(unit_all,5),p5]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I3,1:100),2));
            %
            %
            %
            %           %%%%   Quite strict here: test choice trial, there should be no difference
            %           %%%%   between different values before BG onest. If signifcant
            %           %%%%   difference, detected as drifting
            %           clear I1 I2
            %           I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==2;
            %           I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==11;
            %           I3= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==12;
            %
            %           [hSig(unit_all,6),p3]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I2,1:100),2));
            %           [hSig(unit_all,7),p4]=ttest2(nanmean(Spike_BG(I2,1:100),2),nanmean(Spike_BG(I3,1:100),2));
            %           [hSig(unit_all,8),p5]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I3,1:100),2));
            %
            %
            %           %%%  target response bigger than baseline
                      I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 ;
                      I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==2;
                      [hSig(unit_all,9),p2]=ttest2(nanmean(Spike_TG(I1,900:1000),2),nanmean(Spike_TG(I2,1000:1300),2))
                      [hSig(unit_all,10),p2]=ttest2(nanmean(Spike_TG(I1,900:1000),2),nanmean(Spike_TG(I1,1000:1300),2))
                      if (hSig(unit_all,9)==1 | hSig(unit_all,10)==1) & nanmean(nanmean(Spike_TG(I2,1000:1300),2),1)>1.2*nanmean(nanmean(Spike_TG(I1,1000:1300),2),1)
                      PreferD(ch,unit)=2;
                      else
                      PreferD(ch,unit)=1;
                      end
            %
            %           SelectSig(ch,unit,:)=hSig(unit_all,:);
            
            if 1==1%hSig(unit_all,1)==0 & hSig(unit_all,3)==0 & hSig(unit_all,4)==0 & hSig(unit_all,5)==0% ...
                % & ( hSig(unit_all,9)>0 | hSig(unit_all,10)>0) &  hSig(unit_all,7)==0
                %  hSig(unit_all,6)==0 & hSig(unit_all,7)==0 & hSig(unit_all,8)==0 ...
                figure(unit_all)
                Epoch={'BG','TG','SC','RT'};
                Spike_max=max(nanmean(Spike_RT,2));
                Spike_min=min(nanmean(Spike_RT,2));
                
                if Spike_min>-0.7*Spike_max
                    Spike_min=-0.7*Spike_max;
                else
                    Spike_min=Spike_min*2;
                end
                
                %%%% Align on target onset
                clear Spike tt
                eval(['Spike=(Spike_RT-Spike_min)/(Spike_max-Spike_min);']);
                %                 Spike_max=1;
                %                 Spike_min=0.5;
                I= InfoTrial.Reward==6 & InfoTrial.Repeat==0 & GS_I==1 & InfoTrial.ChoiceD>0 & InfoTrial.ChoiceOpt==25;
                
                Spike_max=max(nanmean(Spike(I,:),1));
                Spike_min=min(nanmean(Spike(I,:),1));
                t=-500:501;
                clim=[-300 400 Spike_min*0.8 Spike_max*2];
                
                
                
                
                for d=1:2%4
                    u=0;
                    for v=[4,21,22,23,24,25]
                        u=u+1;
                        subplot(4,6,u+(d-1)*6)
                        
                        clear I
                        I= InfoTrial.Repeat==0 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        SpikeResultExp(unit_all,d,u,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                        
                        clear I
                        I= InfoTrial.Reward==6 & InfoTrial.Repeat==0 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),char(V_Color(u)));hold on;
                        SpikeResult(unit_all,d,u,1,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                        clear I
                        I= InfoTrial.Reward==4 & InfoTrial.Repeat==0 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),'k');hold on;
                        SpikeResult(unit_all,d,u,2,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                        
                        clear I
                        I= InfoTrial.Reward==2  & InfoTrial.Repeat==0 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),[char(V_Color(u)),':']);hold on;
                        SpikeResult(unit_all,d,u,3,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                        axis(clim);
                        if u==1 & d==1
                            xlabel(['From Result onset']); %title('Choice');
                            if Bg_Lable==1
                                title(['BG Ch',num2str(ch),'Unit',num2str(unit)]);
                            else
                                title(['NBG Ch',num2str(ch),'Unit',num2str(unit)]);
                                
                            end
                        end
                        
                    end
                    box off;
                end
                
                
                for d=1:2%4
                    u=0;
                    for v=[4,21,22,23,24,25]
                        u=u+1;
                        subplot(4,6,u+(d+1)*6)
                        clear I
                        I=  InfoTrial.Repeat==0 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        SpikeResultExp(unit_all,d+2,u,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                        clear I
                        %I=  ContrastBG>1 & InfoTrial.Reward>0 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        I= InfoTrial.Reward==6  & InfoTrial.Repeat==0 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),char(V_Color(u)));hold on;
                        SpikeResult(unit_all,d+2,u,1,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                        clear I
                        I= InfoTrial.Reward==4  & InfoTrial.Repeat==0 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),'k');hold on;
                        SpikeResult(unit_all,d+2,u,2,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                        clear I
                        I= InfoTrial.Reward==2  & InfoTrial.Repeat==0 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),[char(V_Color(u)),':']);hold on;
                        axis(clim);
                        SpikeResult(unit_all,d+2,u,3,:)=nanmean(Spike(I,:),1);
                        box off;set(gca,'TickDir','out')
                        
                    end
                    box off;
                end
                xlabel(['From Result onset']); %title('Choice');
                
                
                FigHandle = figure(unit_all);
                print( FigHandle, '-djpeg', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Reward']);
                %
                %
                %             Spike_TG_All(unit_all,:,:)=(Spike_TG-Spike_min)/(Spike_max-Spike_min);
                %             Spike_BG_All(unit_all,:,:)=(Spike_BG-Spike_min)/(Spike_max-Spike_min);
                %             Spike_SC_All(unit_all,:,:)=(Spike_SC-Spike_min)/(Spike_max-Spike_min);
                %             Spike_RT_All(unit_all,:,:)=(Spike_RT-Spike_min)/(Spike_max-Spike_min);
                
                % print( FigHandle, '-depsc', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Dirction']);
            end
        end
    end
end


%%
aclim=nanmean(SpikeResult,1);
clim=[-400 400 min(aclim(:)), max(aclim(:))];
h1=figure
for d=1:2%4
    for v=1:6
        subplot(4,6,v+d*6-6)
        plotstd(t,squeeze(SpikeResult(:,d,v,1,:)),[char(V_Color(v))]);hold on;
        plotstd(t,squeeze(SpikeResult(:,d,v,2,:)),'k');hold on;
        plotstd(t,squeeze(SpikeResult(:,d,v,3,:)),[char(V_Color(v)),':']);
        axis(clim);
        if d==1 & v==1
            title('FC')
        end
        
        box off;set(gca,'TickDir','out')
        subplot(4,6,v+12+d*6-6)
        plotstd(t,squeeze(SpikeResult(:,d+2,v,1,:)),[char(V_Color(v))]);hold on;
        plotstd(t,squeeze(SpikeResult(:,d+2,v,2,:)),'k');hold on;
        plotstd(t,squeeze(SpikeResult(:,d+2,v,3,:)),[char(V_Color(v)),':']);
        axis(clim);
        if d==2 & v==1
            xlabel('Time from result onset (ms)')
        end
        if d==1 & v==1
            title('Choice')
        end
        box off;set(gca,'TickDir','out')
    end
end
suptitle(char(name0));

h2=figure
for d=1:2
    subplot(2,6,d)
    
    plotstd(t,squeeze(SpikeResult(:,d,2,3,:)),'g');
    plotstd(t,squeeze(SpikeResult(:,d,1,2,:)),'m');
    plotstd(t,squeeze(SpikeResult(:,d,6,1,:)),'r');
    axis(clim);
    box off;set(gca,'TickDir','out')
    title(['FC D',num2str(d)])
    
    subplot(2,6,d+2)
    plotstd(t,squeeze(SpikeResult(:,d,3,3,:)),'k');
    plotstd(t,squeeze(SpikeResult(:,d,4,3,:)),'c');
    plotstd(t,squeeze(SpikeResult(:,d,5,3,:)),'b');
    axis(clim);
    box off;set(gca,'TickDir','out')
    title(['FC Loss D',num2str(d)])
    
    subplot(2,6,d+4)
    plotstd(t,squeeze(SpikeResult(:,d,3,1,:)),'k');
    plotstd(t,squeeze(SpikeResult(:,d,4,1,:)),'c');
    plotstd(t,squeeze(SpikeResult(:,d,5,1,:)),'b');
    axis(clim);
    box off;set(gca,'TickDir','out')
    title(['FC Win D',num2str(d)])
    
    
    
    subplot(2,6,d+6)
    plotstd(t,squeeze(SpikeResult(:,d+2,2,3,:)),'g');
    plotstd(t,squeeze(SpikeResult(:,d+2,1,2,:)),'m');
    plotstd(t,squeeze(SpikeResult(:,d+2,6,1,:)),'r');
    axis(clim);
    box off;set(gca,'TickDir','out')
    title(['Choice D',num2str(d)])
    
    subplot(2,6,d+8)
    plotstd(t,squeeze(SpikeResult(:,d+2,3,3,:)),'k');
    plotstd(t,squeeze(SpikeResult(:,d+2,4,3,:)),'c');
    plotstd(t,squeeze(SpikeResult(:,d+2,5,3,:)),'b');
    axis(clim);
    box off;set(gca,'TickDir','out')
    title(['Choice Loss D',num2str(d)])
    
    subplot(2,6,d+10)
    plotstd(t,squeeze(SpikeResult(:,d+2,3,1,:)),'k');
    plotstd(t,squeeze(SpikeResult(:,d+2,4,1,:)),'c');
    plotstd(t,squeeze(SpikeResult(:,d+2,5,1,:)),'b');
    axis(clim);
    box off;set(gca,'TickDir','out')
    title(['Choice Win D',num2str(d)])
end

sumfig='D:\Projects\GambleMIB\figures\RewardSum\';

if Bg_Lable==1
    suptitle(['BG ',char(name0)]);
    BG_SpikeResult=SpikeResult;
    save(Spikefile,'BG_SpikeResult','PreferD','-append');
    print( h1, '-djpeg', [DirFig,'Reward1_',name0,'_BG']);
    print( h2, '-djpeg', [DirFig,'Reward2_',name0,'_BG']);
    print( h1, '-djpeg', [sumfig,'Reward1_',name0,'_BG']);
    print( h2, '-djpeg', [sumfig,'Reward2_',name0,'_BG']);
    
else
    suptitle(['NBG ',char(name0)]);
    NBG_SpikeResult=SpikeResult;
    save(Spikefile,'NBG_SpikeResult','PreferD','-append');
    print( h1, '-djpeg', [DirFig,'Reward1_',name0,'_NBG']);
    print( h2, '-djpeg', [DirFig,'Reward2_',name0,'_NBG']);
    print( h1, '-djpeg', [sumfig,'Reward1_',name0,'_NBG']);
    print( h2, '-djpeg', [sumfig,'Reward2_',name0,'_NBG']);
    
end
% %%
% %===============================================
% %%%%%% Average across all recordings
% %===================================================
%
% %%%% Align on target onset
% figure(unit_all+1)
% clear I;
% I_n=ones(1,unit_all)';%hSig(:,1)==0 & hSig(:,3)==0 & hSig(:,4)==0 & hSig(:,5)==0 ...
%            %  & ( hSig(:,9)>0 | hSig(:,10)>0) & hSig(:,7)==0 ;
%             % &  hSig(:,6)==0 & hSig(:,7)==0 & hSig(:,8)==0 ...
%
% %  I_n=hSig(unit_all,1)==0 & hSig(unit_all,3)==0 &  hSig(:,2)==1 & hSig(unit_all,4)==0 & hSig(unit_all,5)==0 &  hSig(unit_all,6)==0 & hSig(unit_all,7)==0 & hSig(unit_all,8)==0 ...
% %              & ( hSig(unit_all,9)>0 | hSig(unit_all,10)>0) ;
%
% %I_n=hSig(:,1)==0 &  hSig(:,2)==1 & hSig(:,3)==0 & hSig(:,4)==0 & hSig(:,5)==0;
%
% Epoch={'BG','TG','SC','RT'};
% %%%% Align on target onset
% clim_min=0;%min([min(Spike_BG_All(:)),min(Spike_TG_All(:)),min(Spike_SC_All(:)),min(Spike_RT_All(:))]);
% clim_max=0.4;
%
%
%     clear Spike
%     eval(['Spike=Spike_RT_All(:,:,:);']);
%     clear t clim
%
%         t=-500:501;
%         clim=[-300 400 clim_min/2 clim_max*2];
%
%
%     subplot(4,6,ep*6-5)
%     for d=1:2%4
%         u=0;
%         I= ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
%         plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(Direction_Color(d)));hold on;
%         axis(clim);
%     end
%     xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
%     if ep==1
%         title('All')
%     end
%     subplot(4,6,ep*6-4)
%     for d=1:2%4
%         u=0;
%         I= ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
%         plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(Direction_Color(d)));hold on;
%         axis(clim);
%     end
%     xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
%
%
%         for d=1:2%4
%         u=0;
%         subplot(4,6,ep*6-4+d)
%         I= ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
%
%         for v=[4,21,22,23,24,25]
%             u=u+1;
%             clear I
%             I= ContrastBG==1 &  InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
%             plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(V_Color(u)));hold on;
%         end
%         axis(clim);
%     end
%     xlabel(['From ',char(Epoch(ep)),' onset']); %title('Choice');
%
%
%
%     for d=1:2%4
%         u=0;
%         subplot(4,6,ep*6-2+d)
%         I= ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
%
%         for v=[4,21,22,23,24,25]
%             u=u+1;
%             clear I
%             I= ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
%             plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(V_Color(u)));hold on;
%         end
%         axis(clim);
%     end
%     xlabel(['From ',char(Epoch(ep)),' onset']); %title('Choice');
%
% FigHandle = figure(unit_all+1);
% print( FigHandle, '-djpeg', [DirFig,'All_NBG']);
% save(Spikefile,'SelectSig','PreferD','-append');
