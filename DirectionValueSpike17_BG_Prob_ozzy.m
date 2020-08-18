function DirectionValueSpike17_BG_Prob_ozzy(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
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
V_Color={'k','b','m','r'};


%%
close all
unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
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
            

          %%%%   test no-choice trial, there should be no difference
          %%%%   between chosen direction before target onest
          I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1;
          I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==2;
          [hSig(unit_all,1),p1]=ttest2(nanmean(Spike_TG(I1,600:700),2),nanmean(Spike_TG(I2,600:700),2))

          
          %%%%   test choice trial, find the type of neurons which show
          %%%%   choice difference before the target onset (memory?)
          I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 ;
          I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==2;
          [hSig(unit_all,2),p2]=ttest2(nanmean(Spike_TG(I1,600:700),2),nanmean(Spike_TG(I2,700:800),2))
          
          %%%%   test no-choice trial, there should be no difference
          %%%%   between different values before BG onest. If signifcant
          %%%%   difference, detected as drifting
          clear I1 I2 
          I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==16;
          I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==17;
          I3= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==18;

          [hSig(unit_all,3),p3]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I2,1:100),2));
          [hSig(unit_all,4),p4]=ttest2(nanmean(Spike_BG(I2,1:100),2),nanmean(Spike_BG(I3,1:100),2));
          [hSig(unit_all,5),p5]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I3,1:100),2));

          
          
          %%%%   Quite strict here: test choice trial, there should be no difference
          %%%%   between different values before BG onest. If signifcant
          %%%%   difference, detected as drifting
          clear I1 I2 
          I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==16;
          I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==17;
          I3= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==1 & InfoTrial.DOpt(:,1)==18;

          [hSig(unit_all,6),p3]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I2,1:100),2));
          [hSig(unit_all,7),p4]=ttest2(nanmean(Spike_BG(I2,1:100),2),nanmean(Spike_BG(I3,1:100),2));
          [hSig(unit_all,8),p5]=ttest2(nanmean(Spike_BG(I1,1:100),2),nanmean(Spike_BG(I3,1:100),2));

          
          %%%  target response bigger than baseline
          I1= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==1 ;
          I2= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==2;
          [hSig(unit_all,9),p2]=ttest2(nanmean(Spike_TG(I1,600:700),2),nanmean(Spike_TG(I2,700:1000),2))
          [hSig(unit_all,10),p2]=ttest2(nanmean(Spike_TG(I1,600:700),2),nanmean(Spike_TG(I1,700:1000),2))
          
          h0=ttest(nanmean(Spike_TG(I1,700:1000),2),nanmean(Spike_TG(I1,700:1000),2));
          if h0==1 &  nanmean(nanmean(Spike_TG(I2,700:1000),2),1)>nanmean(nanmean(Spike_TG(I1,700:1000),2),1)
          PreferD(ch,unit,1)=2;
          else
          PreferD(ch,unit,1)=1;
          end
    
          
          SelectSig(ch,unit,:)=hSig(unit_all,:);
          
          if hSig(unit_all,1)==0 & hSig(unit_all,3)==0 & hSig(unit_all,4)==0 & hSig(unit_all,5)==0 ...
             & ( hSig(unit_all,9)>0 | hSig(unit_all,10)>0) &  hSig(unit_all,7)==0
             %  hSig(unit_all,6)==0 & hSig(unit_all,7)==0 & hSig(unit_all,8)==0 ...
            figure(unit_all) 
            Epoch={'BG','TG','SC','RT'};
            %%%% Align on target onset
            for ep=1:4
                clear Spike tt Spike_max Spike_min
                eval(['Spike=Spike_',char(Epoch(ep)),';']);
                
                for d=1:2%4
                    tt(d,:)=nanmean(Spike(InfoTrial.ChoiceD==d ,:),1);
                end
                Spike_max=nanmax(tt(:));
                Spike_min=nanmin(tt(:));
                
                clear t clim
                if ep==1
                    t=-100:501;
                    clim=[-100 500 Spike_min*0.8 Spike_max*1.2];
                elseif ep==2
                    t=-700:501;
                    clim=[-700 500 Spike_min*0.8 Spike_max*1.2];
                elseif ep==3
                    t=-500:801;
                    clim=[-500 600 Spike_min*0.8 Spike_max*1.2];
                else
                    t=-500:501;
                    clim=[-300 400 Spike_min*0.8 Spike_max*1.2];
                end
                
                subplot(4,6,ep*6-5)
                for d=1:2%4
                    u=0;
                    I= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
                    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
                    axis(clim);
                end
                xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
                if ep==1
                    title(['Ch',num2str(ch),'Unit',num2str(unit)]);
                end
                box off;
                
                subplot(4,6,ep*6-4)
                for d=1:2%4
                    u=0;
                    I=  ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
                    plotstd(t,Spike(I,:),char(Direction_Color(d)));hold on;
                    axis(clim);
                end
                xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
                box off;
                
                for d=1:2%4
                    u=0;
                    subplot(4,6,ep*6-4+d)
                    I=  ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
                    
                    for v=[2,12,11]
                        u=u+1;
                        clear I
                        I=  ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),char(V_Color(u)));hold on;
                    end
                    axis(clim);
                    box off;
                end
                xlabel(['From ',char(Epoch(ep)),' onset']); %title('Choice');
            
            
                    for d=1:2%4
                    u=0;
                    subplot(4,6,ep*6-2+d)
                    I= ContrastBG>1 &  InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
                    
                    for v=[2,16,17,18]
                        u=u+1;
                        clear I
                        I= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
                        plotstd(t,Spike(I,:),char(V_Color(u)));hold on;
                    end
                    axis(clim);
                    box off;
                end
                xlabel(['From ',char(Epoch(ep)),' onset']); %title('Choice');
                
            end
            FigHandle = figure(unit_all);
            print( FigHandle, '-djpeg', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_DV']);

          
            Spike_TG_All(unit_all,:,:)=(Spike_TG-Spike_min)/(Spike_max-Spike_min);
            Spike_BG_All(unit_all,:,:)=(Spike_BG-Spike_min)/(Spike_max-Spike_min);
            Spike_SC_All(unit_all,:,:)=(Spike_SC-Spike_min)/(Spike_max-Spike_min);
            Spike_RT_All(unit_all,:,:)=(Spike_RT-Spike_min)/(Spike_max-Spike_min);
            
            % print( FigHandle, '-depsc', [DirFig,'Ch',num2str(ch),'Unit',num2str(unit),'_Dirction']);
          end   
        end
    end
end



%%
%===============================================
%%%%%% Average across all recordings
%===================================================

%%%% Align on target onset
figure(unit_all+1)
clear I;
I_n=hSig(:,1)==0 & hSig(:,3)==0 & hSig(:,4)==0 & hSig(:,5)==0 ...
             & ( hSig(:,9)>0 | hSig(:,10)>0) & hSig(:,7)==0 ;
            % &  hSig(:,6)==0 & hSig(:,7)==0 & hSig(:,8)==0 ...
         
%  I_n=hSig(unit_all,1)==0 & hSig(unit_all,3)==0 &  hSig(:,2)==1 & hSig(unit_all,4)==0 & hSig(unit_all,5)==0 &  hSig(unit_all,6)==0 & hSig(unit_all,7)==0 & hSig(unit_all,8)==0 ...
%              & ( hSig(unit_all,9)>0 | hSig(unit_all,10)>0) ;

%I_n=hSig(:,1)==0 &  hSig(:,2)==1 & hSig(:,3)==0 & hSig(:,4)==0 & hSig(:,5)==0;

Epoch={'BG','TG','SC','RT'};
%%%% Align on target onset
clim_min=0;%min([min(Spike_BG_All(:)),min(Spike_TG_All(:)),min(Spike_SC_All(:)),min(Spike_RT_All(:))]);
clim_max=1.5;
for ep=1:4
    clear Spike
    eval(['Spike=Spike_',char(Epoch(ep)),'_All(I_n,:,:);']);
    clear t clim
    if ep==1
        t=-100:501;
        clim=[-100 500 clim_min clim_max];
    elseif ep==2
        t=-700:501;
        clim=[-700 500 clim_min clim_max];
    elseif ep==3
        t=-500:801;
        clim=[-500 600 clim_min clim_max];
    else
        t=-500:501;
        clim=[-300 400 clim_min clim_max];
    end
    
    subplot(4,6,ep*6-5)
    for d=1:2%4
        u=0;
        I= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
        plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(Direction_Color(d)));hold on;
        axis(clim);
    end
    xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
    if ep==1
        title('All')
    end
    subplot(4,6,ep*6-4)
    for d=1:2%4
        u=0;
        I= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
        plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(Direction_Color(d)));hold on;
        axis(clim);
    end
    xlabel(['From ',char(Epoch(ep)),' onset']);% title('Single');
  
    
        for d=1:2%4
        u=0;
        subplot(4,6,ep*6-4+d)
        I= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d;
        
        for v=[2,12,11]
            u=u+1;
            clear I
            I= ContrastBG>1 &  InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GS_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
            plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(V_Color(u)));hold on;
        end
        axis(clim);
    end
    xlabel(['From ',char(Epoch(ep)),' onset']); %title('Choice');

    
    
    for d=1:2%4
        u=0;
        subplot(4,6,ep*6-2+d)
        I= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d;
        
        for v=[2,12,11]
            u=u+1;
            clear I
            I= ContrastBG>1 & InfoTrial.Repeat==0 & InfoTrial.SaccadeStart>500 & GC_I==1 & InfoTrial.ChoiceD==d & InfoTrial.ChoiceOpt==v;
            plotstd(t,squeeze(nanmean(Spike(:,I,:),2)),char(V_Color(u)));hold on;
        end
        axis(clim);
    end
    xlabel(['From ',char(Epoch(ep)),' onset']); %title('Choice');
end
FigHandle = figure(unit_all+1);
print( FigHandle, '-djpeg', [DirFig,'All_DV']);
save(Spikefile,'SelectSig','PreferD','-append');
