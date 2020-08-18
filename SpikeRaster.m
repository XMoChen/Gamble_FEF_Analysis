%function BackgroundSpike(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
%%%% do not analyze the unsorted ones
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeHist','TargetHist','BackgroundHist','ResultHist','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
clear ContrastBG
C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;
Valid_ID=InfoTrial.Reward>0;
InfoTrial_Valid=InfoTrial(Valid_ID,:);

BG_Color={'k','b','g'};



%%
BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
close all
t_bg=-100:501;



%%
c_risk=[0,0,0; 1, 0, 1; 1,0,0];

Opt=[2,12,11];
unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=BackgroundHist.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_Valid=Spike(Valid_ID,:);

          %  Spike_BG=Spike;
            [x_spike,y_spike]=find(Spike_Valid(:,:)==1);
            subplot(321)
            for o=1:3
                Con_valid=zeros(size(Spike_Valid));
                Con_valid(InfoTrial_Valid.DOpt(:,1)==Opt(o) & InfoTrial_Valid.DChoice(:,1)==1,:)=1;
                [x_spike,y_spike]=find(Spike_Valid(:,:)==1 & Con_valid(:,:)==1);
                plot(y_spike-100,x_spike,'.','Color',c_risk(o,:),'MarkerSize',0.03); hold on;

            end
            axis tight
            title(['Ch',num2str(ch),'Unit',num2str(unit)]);
            
            
            subplot(322)
            for o=1:3
                Con_valid=zeros(size(Spike_Valid));
                Con_valid(InfoTrial_Valid.DOpt(:,2)==Opt(o) & InfoTrial_Valid.DChoice(:,2)==1,:)=1;
                [x_spike,y_spike]=find(Spike_Valid(:,:)==1 & Con_valid(:,:)==1);
                plot(y_spike-100,x_spike,'.','Color',c_risk(o,:),'MarkerSize',0.03); hold on;

            end
            axis tight
            title(['Ch',num2str(ch),'Unit',num2str(unit-1)]);
            
            
            
        end
    end
end

%%
%close all
t_targ=-500:501;
unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=TargetHist.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_Valid=Spike(Valid_ID,:);

          %  Spike_BG=Spike;
            [x_spike,y_spike]=find(Spike_Valid(:,:)==1);
            subplot(323)
            for o=1:3
                Con_valid=zeros(size(Spike_Valid));
                Con_valid(InfoTrial_Valid.DOpt(:,1)==Opt(o) & InfoTrial_Valid.DChoice(:,1)==1,:)=1;
                [x_spike,y_spike]=find(Spike_Valid(:,:)==1 & Con_valid(:,:)==1);
                plot(y_spike-500,x_spike,'.','Color',c_risk(o,:),'MarkerSize',0.03); hold on;

            end
            axis([-200 500 0 inf]);    

            subplot(324)
            for o=1:3
                Con_valid=zeros(size(Spike_Valid));
                Con_valid(InfoTrial_Valid.DOpt(:,2)==Opt(o) & InfoTrial_Valid.DChoice(:,2)==1,:)=1;
                [x_spike,y_spike]=find(Spike_Valid(:,:)==1 & Con_valid(:,:)==1);
                plot(y_spike-500,x_spike,'.','Color',c_risk(o,:),'MarkerSize',0.03); hold on;

            end
            axis([-200 500 0 inf]);  
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

            eval(['Spike=SaccadeHist.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_Valid=Spike(Valid_ID,:);

          %  Spike_BG=Spike;
            [x_spike,y_spike]=find(Spike_Valid(:,:)==1);
            subplot(325)
            for o=1:3
                Con_valid=zeros(size(Spike_Valid));
                Con_valid(InfoTrial_Valid.DOpt(:,1)==Opt(o) & InfoTrial_Valid.DChoice(:,1)==1,:)=1;
                [x_spike,y_spike]=find(Spike_Valid(:,:)==1 & Con_valid(:,:)==1);
                plot(y_spike-500,x_spike,'.','Color',c_risk(o,:),'MarkerSize',0.03); hold on;

            end
            axis([-500 200 0 inf]);   
            
             subplot(326)
            for o=1:3
                Con_valid=zeros(size(Spike_Valid));
                Con_valid(InfoTrial_Valid.DOpt(:,2)==Opt(o) & InfoTrial_Valid.DChoice(:,2)==1,:)=1;
                [x_spike,y_spike]=find(Spike_Valid(:,:)==1 & Con_valid(:,:)==1);
                plot(y_spike-500,x_spike,'.','Color',c_risk(o,:),'MarkerSize',0.03); hold on;

            end
            axis([-500 200 0 inf]);   
            
            
        end
    end
end

