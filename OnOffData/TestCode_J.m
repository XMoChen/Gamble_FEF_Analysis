%%%%%%%%%%%%%%%%%%% test version for RF mapping
% close all
% clear all

% Date={'J050718','J051818','J052018'};
% Files={'BG7','BG1','BG1'};
% RFFiles={'RF2','RF3','RF3'};
% ChNum=[24,24,24];
% Area='V4';


Date={'J062818','J073118'};
Files={'BG1','BG1'}
Area='FEF';
ChNum=[24,32];
% %Date={'J062118','J062318','J062618','J062818','J070118','J070418','J070618','J070818','J071318','J072018'};
% Date={'J062118','J062618','J062818','J070118','J070418','J070618','J070818','J071318','J072018','J073118'};
% Files={'BG1','BG2','BG1','BG1','BG1','BG1','BG1','BG1','BG1','BG1','BG1','BG1'};
% ChNum=[24,24,24,24,32,32,32,32,32,32];
% Area='FEF';
sumfig=['D:\Projects\GambleMIB\OnOffData\PhaseII\',Area,'\figures\'];
% date1='072018';
% date='072018';
for date_i=1%1:9%1:10
    date1=char(Date(date_i));
 load(['D:\Projects\GambleMIB\OnOffData\PhaseII\',Area,'\',date1,'\BG\',char(Files(date_i)),'Event.mat']);
% load(['D:\Projects\GambleMIB\OnOffData\PhaseII\',Area,'\',date1,'\BG\',char(Files(date_i)),'Spike2.mat']);

close all
for contrast=1:5
subtrial=find(TrialInfo.Contrast'==contrast & TrialInfo.SelectI==1);
u=0;
for trial=subtrial(1:9)
    u=u+1;u0=0;
for ch=1:ChNum(date_i)
    clear a
    bgON=TrialInfo.BGOnPlx(1,trial);
    a=[];
    for unit=2:6
    clear a0
    if exist(['chan',num2str(ch),'_unit',num2str(unit-1)])==1
    eval(['a0=chan',num2str(ch),'_unit',num2str(unit-1),';']);
    a=[a;a0];
    u0=u0+1;
    end
    end
    clear a0
    a0=a(a>bgON-0.5 & a<bgON+1)'-bgON;
    spikeTimes{ch} = a0*1000;
    SpikeCount(u,ch,:)=hist(a0,-0.5:0.001:1)*1000;
end  

h1=figure(contrast);    
subplot(3,3,u)   % Plot
LineFormat.Color = 'b';
plotSpikeRaster(spikeTimes,'PlotType','scatter','XLimForCell',[-100 600]);
% title('Dots (Scatterplot)');
%set(gca,'XTick',[]);
if u==9
xlabel('time from BG onset (ms)');
end

end

suptitle([date1,' Contrast',num2str(contrast-1)]);
print( h1, '-djpeg', [sumfig,date1,'_Contrast',num2str(contrast-1)]);

SpikeCountContrast(contrast,:)=nanmean(nanmean(SpikeCount,1),2);
% print( h2, '-djpeg', [sumfig,'2_',name0]);
end
h1=figure()
plot(-0.5:0.001:1,SpikeCountContrast');
legend({'0','1','2','3','4'});
xlabel('time from BG onest (ms)');
ylabel('Hz');
title(date1);
box off;set(gca,'TickDir','out')
print( h1, '-djpeg', [sumfig,date1,'_Contrast_all']);

end

% figure
% plot(squeeze(nanmean((nanmean(SpikeCount(:,:,:),1)),2)));

