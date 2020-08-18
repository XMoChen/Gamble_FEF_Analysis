%function BackgroundSpike(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
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



BG_Color={'k','b','g'}
    


%%  
close all
t_bg=-100:501;

unit_all=0;
for ch=1:Ch_num
    for unit=1:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_BG=Spike;
            subplot(441)
            for contrast=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==1)',:),1),char(BG_Color(contrast))); hold on;
            end
            axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')
            title('FC P')

            subplot(442)
            for contrast=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD==2)',:),1),char(BG_Color(contrast))); hold on;
            end
            axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')
            title('FC NP')

            subplot(443)
            for contrast=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt~=0 &  InfoTrial.ChoiceD==1)',:),1),char(BG_Color(contrast))); hold on;
            end
            axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')
            title('2AC P')

            subplot(444)
            for contrast=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.Targ2Opt~=0 &  InfoTrial.ChoiceD==2)',:),1),char(BG_Color(contrast))); hold on;
            end
             axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')
            title('2AC NP')

        end
    end
end



BG_Color={'k','m','r'}

Opt=[2,12,11];
unit_all=0;
for ch=1:Ch_num
    for unit=1:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_BG=Spike;
            subplot(445)
            for o=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1),char(BG_Color(o))); hold on;
            end
             axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')

            subplot(446)
            for o=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==2)',:),1),char(BG_Color(o))); hold on;
            end
             axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')

            subplot(447)
            for o=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')

            subplot(448)
            for o=1:3
                plot(t_bg,nanmean(Spike_BG((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==2)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-100 500 -inf inf]);box off;set(gca,'TickDir','out')

        end
    end
end

%%  
%close all
t_targ=-500:501;
unit_all=0;
for ch=1:Ch_num
    for unit=1:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            subplot(4,4,9)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-200 500 -inf inf]);box off;set(gca,'TickDir','out')
            subplot(4,4,10)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,2)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-200 500 -inf inf]);box off;set(gca,'TickDir','out')

            subplot(4,4,11)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-200 500 -inf inf]);box off;set(gca,'TickDir','out')

            subplot(4,4,12)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-200 500 -inf inf]);box off;set(gca,'TickDir','out')

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
    for unit=1:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            subplot(4,4,13)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-500 300 -inf inf]);
            subplot(4,4,14)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,2)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-500 300 -inf inf]);

            subplot(4,4,15)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-500 300 -inf inf]);

            subplot(4,4,16)
            for o=1:3
                plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1),char(BG_Color(o))); hold on;
            end
            axis([-500 300 -inf inf]);

        end
    end
end