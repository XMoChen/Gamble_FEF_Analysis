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

Valid_ID=InfoTrial.Reward>0;
%InfoTrial_Valid=InfoTrial(Valid_ID,:);
InfoTrial_valid.FClw=zeros(size(InfoTrial_valid,1),1);
InfoTrial_valid.FCrw=zeros(size(InfoTrial_valid,1),1);

for trial=2:(size(InfoTrial_valid,1))
    if InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.Targ2Opt(trial-1)==0 &  InfoTrial_valid.ChoiceD(trial-1)==1
        InfoTrial_valid.FClw(trial,1)=1;
    elseif InfoTrial_valid.Reward(trial-1)<2 & InfoTrial_valid.Targ2Opt(trial-1)==0 &  InfoTrial_valid.ChoiceD(trial-1)==1
        InfoTrial_valid.FClw(trial,1)=-1;
    elseif InfoTrial_valid.Reward(trial-1)>2 &  InfoTrial_valid.Targ2Opt(trial-1)==0 &  InfoTrial_valid.ChoiceD(trial-1)==2
        InfoTrial_valid.FCrw(trial,1)=1;
    elseif InfoTrial_valid.Reward(trial-1)<2 & InfoTrial_valid.Targ2Opt(trial-1)==0 &  InfoTrial_valid.ChoiceD(trial-1)==2
        InfoTrial_valid.FCrw(trial,1)=-1;
    end
end
%%
t_bg=-100:501;

c_risk=[0,0,0; 1, 0, 1; 1,0,0];

Opt=[2,12,11];
unit_all=0;
for ch=13%:Ch_num
    for unit=2%:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_Valid=Spike(Valid_ID,:);

            mr0=0;

            Spike_BG=Spike;
            subplot(341)
            plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(1) &  InfoTrial_valid.Targ2Opt==0 )',:),1),'Color',c_risk(1,:)); hold on;
            for o=2:3
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FClw==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FClw==-1)',:),1),':','Color',c_risk(o,:)); hold on;

            end
            maxrate=50;
            minrate=0;
            axis([-100 500 minrate maxrate]);box off;set(gca,'TickDir','out')
            xlabel('BG onset (ms)');
            ylabel('Spikes/s');
            
            subplot(342)
             plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(1) &  InfoTrial_valid.Targ2Opt==0 )',:),1),'Color',c_risk(1,:)); hold on;
            for o=2:3
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FCrw==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FCrw==-1)',:),1),':','Color',c_risk(o,:)); hold on;
            end
            axis([-100 500 minrate maxrate]);box off;set(gca,'TickDir','out')
            legend({'risk 0','risk 1','risk 2'},'Position',[0.03 0.65 0.03 0.1]);
            

            subplot(343)
            plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(1) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,1)==1 &   InfoTrial_valid.P_LsL==1)',:),1),'Color',c_risk(1,:)); hold on;
            for o=2:3
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,1)==1 &   InfoTrial_valid.P_LwL==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,1)==1 &   InfoTrial_valid.P_LlL==1)',:),1),':','Color',c_risk(o,:)); hold on;
            end
            axis([-100 500 minrate maxrate]);box off;set(gca,'TickDir','out')
            
            subplot(344)
            plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(1) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,2)==1 &   InfoTrial_valid.P_RsR==1)',:),1),'Color',c_risk(1,:)); hold on;
            for o=1:3
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,2)==1 &   InfoTrial_valid.P_RwR==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_bg,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,2)==1 &   InfoTrial_valid.P_RlR==1)',:),1),':','Color',c_risk(o,:)); hold on;
            end
            axis([-100 500 minrate maxrate]);box off;set(gca,'TickDir','out')
            
        end
    end
end
%%
% %%
% %close all
 t_targ=-500:501;
unit_all=0;
for ch=13%:Ch_num
    for unit=2%:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            figure(unit_all)
            
            eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_Valid=Spike(Valid_ID,:);

            mr0=0;

            Spike_BG=Spike;
            subplot(345)
            plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(1) &  InfoTrial_valid.Targ2Opt==0 )',:),1),'Color',c_risk(1,:)); hold on;
            for o=2:3
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FClw==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FClw==-1)',:),1),':','Color',c_risk(o,:)); hold on;

            end
     %       maxrate=100;
     %       minrate=0;
            axis([-200 500 minrate maxrate]);box off;set(gca,'TickDir','out')
            xlabel('Target onset (ms)');
            ylabel('Spikes/s');
            
            subplot(346)
             plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(1) &  InfoTrial_valid.Targ2Opt==0 )',:),1),'Color',c_risk(1,:)); hold on;
            for o=2:3
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FCrw==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt==0 & InfoTrial_valid.FCrw==-1)',:),1),':','Color',c_risk(o,:)); hold on;
            end
            axis([-200 500 minrate maxrate]);box off;set(gca,'TickDir','out')
          %  legend({'risk 0','risk 1','risk 2'},'Position',[0.03 0.65 0.03 0.1]);
            

            subplot(347)
            plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(1) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,1)==1 &   InfoTrial_valid.P_LsL==1)',:),1),'Color',c_risk(1,:)); hold on;
            for o=2:3
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,1)==1 &   InfoTrial_valid.P_LwL==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,1)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,1)==1 &   InfoTrial_valid.P_LlL==1)',:),1),':','Color',c_risk(o,:)); hold on;
            end
            axis([-200 500 minrate maxrate]);box off;set(gca,'TickDir','out')
            
            subplot(348)
            plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(1) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,2)==1 &   InfoTrial_valid.P_RsR==1)',:),1),'Color',c_risk(1,:)); hold on;
            for o=1:3
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,2)==1 &   InfoTrial_valid.P_RwR==1)',:),1),'Color',c_risk(o,:)); hold on;
                plot(t_targ,nanmean(Spike_Valid((InfoTrial_valid.DOpt(:,2)==Opt(o) &  InfoTrial_valid.Targ2Opt~=0 &  InfoTrial_valid.DChoice(:,2)==1 &   InfoTrial_valid.P_RlR==1)',:),1),':','Color',c_risk(o,:)); hold on;
            end
            axis([-200 500 minrate maxrate]);box off;set(gca,'TickDir','out')
            
        end
    end
end
% 
% %%
% %%%  saccade
% %close all
% t_targ=-500:501;
% unit_all=0;
% Opt=[2,12,11];
% for ch=1:Ch_num
%     for unit=2:length(l_ts(ch,:))
%         if l_ts(ch,unit)>10000
%             unit_all=unit_all+1;
%             figure(unit_all)
%             
%             eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
%             mr0=0;
% 
%             subplot(5,4,13)
%             for o=1:3
%                 plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1),'Color',c_risk(o,:)); hold on;
%                 mr=max(nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1));
%                 nr=min(nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1));
% 
%                 if mr>mr0
%                     mr0=mr;
%                 end
%             end
%             maxrate=mr0*1.3;
%             minrate=nr*0.8;
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             xlabel('Saccade onset (ms)');
%             ylabel('Spikes/s');
%             
%             subplot(5,4,14)
%             for o=1:3
%                 plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,2)==1)',:),1),'Color',c_risk(o,:)); hold on;
%             end
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             
%             subplot(5,4,15)
%             for o=1:3
%                 plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,1)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1),'Color',c_risk(o,:)); hold on;
%             end
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             
%             subplot(5,4,16)
%             for o=1:3
%                 plot(t_targ,nanmean(Spike((InfoTrial.DOpt(:,2)==Opt(o) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1),'Color',c_risk(o,:)); hold on;
%             end
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             
%         end
%     end
% end
% 
% %%
% %%%  result
% %close all
% r_color=[0,0,1;0,1,0;0,0,0;1,0,1;1,0,0];
% t_targ=-500:501;
% unit_all=0;
% Rewd=[0.001,1,2,3,4];
% for ch=1:Ch_num
%     for unit=2:length(l_ts(ch,:))
%         if l_ts(ch,unit)>10000
%             unit_all=unit_all+1;
%             figure(unit_all)
%             
%             eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
%             mr0=0;
%             
%             subplot(5,4,17)
%             for r=1:5
%                 plot(t_targ,nanmean(Spike((InfoTrial.Reward==Rewd(r) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1),'Color',r_color(r,:)); hold on;
%                 mr=max(nanmean(Spike((InfoTrial.Reward==Rewd(r) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1));
%                 nr=min(nanmean(Spike((InfoTrial.Reward==Rewd(r) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1)',:),1));
% 
%                 if mr>mr0
%                     mr0=mr;
%                 end
%             end
%             maxrate=mr0*1.5;
%             minrate=nr*0.8;
% 
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             xlabel('Result onset (ms)');
%             ylabel('Spikes/s');
%             
%             subplot(5,4,18)
%             for r=1:5
%                 plot(t_targ,nanmean(Spike((InfoTrial.Reward==Rewd(r) &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,2)==1)',:),1),'Color',r_color(r,:)); hold on;
%             end
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             legend({'0','1','2','3','4'},'Position',[0.03 0.13 0.03 0.1]);
% 
% 
%             subplot(5,4,19)
%             for r=1:5
%                 plot(t_targ,nanmean(Spike((InfoTrial.Reward==Rewd(r) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1)',:),1),'Color',r_color(r,:)); hold on;
%             end
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             
%             subplot(5,4,20)
%             for r=1:5
%                 plot(t_targ,nanmean(Spike((InfoTrial.Reward==Rewd(r) &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1)',:),1),'Color',r_color(r,:)); hold on;
%             end
%             legend
%             axis([-500 300 minrate maxrate]);box off;set(gca,'TickDir','out')
%             h10=figure(unit_all);
%             print( h10, '-djpeg', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1)]);
%             print( h10, '-depsc', [DirFig,'Neuron','Ch',num2str(ch),'Unit',num2str(unit-1)]);
%         end
%         
%         
%         
%     end
% end
% 
% 

