%%%%%%%%%%%%%%%%%%% test version for RF mapping
close all
clear all
% load('D:\Projects\GambleMIB\OnOffData\G042017\RF\0420172Event.mat');
% load('D:\Projects\GambleMIB\OnOffData\G042017\RF\0420172Spike.mat');

load('D:\Projects\GambleMIB\OnOffData\G082617\RF\G082617Event.mat');
load('D:\Projects\GambleMIB\OnOffData\G082617\RF\G082617Spike.mat');
subtrial=find(TrialInfo.ProbLocation==18);
u=0;
for trial=subtrial'
    u=u+1;
for ch=1:16
    clear a
    bgON=TrialInfo.ProbTime(trial,1);
    eval(['a=chan',num2str(ch),'_unit0;']);
    a0=a(a>bgON-0.1 & a<bgON+0.5)'-bgON;
    spikeTimes{ch} = a0;
    SpikeCount(trial,ch,:)=hist(a0,-0.1:0.001:0.5)*1000;
end  

 figure(1);    
subplot(3,3,u)   % Plot
LineFormat.Color = 'b';
plotSpikeRaster(spikeTimes,'PlotType','scatter','XLimForCell',[-0.1 0.5]);
% title('Dots (Scatterplot)');
set(gca,'XTick',[]);


end

figure(2)
plot(squeeze(nanmean((nanmean(SpikeCount(:,:,:),2)),1)));

%%
clear all
load('D:\Projects\GambleMIB\OnOffData\G082617\Gamble\G082617Event.mat');
load('D:\Projects\GambleMIB\OnOffData\G082617\Gamble\G082617Spike.mat');
%%%%%%%%%%%%%%%%%%% test version for RF mapping
subtrial=find(TrialInfo.BackgroundLevel==3);
u=0;
for trial=subtrial(1:9)'
    u=u+1;
for ch=1:16
    clear a
   bgON=TrialInfo.BackgroundOn(trial,1);
   %bgON=TrialInfo.TargetOn(trial,1);

    eval(['a=chan',num2str(ch),'_unit1;']);
    a0=a(a>bgON-0.4 & a<bgON+0.5)'-bgON;
    spikeTimes{ch} = a0;
    SpikeCount(trial,ch,:)=hist(a0,-0.4:0.001:0.5)*1000;
end  

 figure(3);    
subplot(3,3,u)   % Plot
LineFormat.Color = 'b';
plotSpikeRaster(spikeTimes,'PlotType','scatter','XLimForCell',[-0.4 0.5]);
% title('Dots (Scatterplot)');
set(gca,'XTick',[]);


end

figure(4)
plot(-400:500,squeeze(nanmean((nanmean(SpikeCount(:,:,:),2)),1)));
