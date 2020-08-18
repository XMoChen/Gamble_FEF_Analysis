clear all
close all

Figurepath='F:\Projects\GambleMIB\SumFigures\';
RootDir='F:\Projects\GambleMIB';
set(0,'DefaultFigureWindowStyle','docked');
% Ozzy  FEF
Date={'G073017','G080117','G080417','G080817','G083017'};
Files={'G073017','G080117','G0804172','G080817','G083017'};
ChNum=[16,16,24,32,32];
name='OzzyFEF';

% Jimmy  FEF
Date={'J062118','J062318','J062618','J062818','J070118','J070418'};
Files={'J062118','J062318','J062618','J062818','J0701182','J070418'};
ChNum=[24,24,24,24,24,32];
name='JimmyFEF';


% Ozzy V4
% Date={'G082017','G082617','G082817','G090117','G103017','G103117'}
% Files={'G082017','G082617','G082817','G090117','G103017','G103117'};
% ChNum=[16,16,16,16,16,15];
% 
% % Jimmy V4
% Date={'J042218','J042418','J043018','J050718','J051818'};
% Files={'J0422182','J042418','J043018','J050718','J051818'};
% ChNum=[24,24,24,24,24,24];
% name='V4';



% V4 All
Date={'G082017','G082617','G082817','G090117','G103017','G103117','J042418','J043018','J050718','J051818'}
Files={'G082017','G082617','G082817','G090117','G103017','G103117','J042418','J043018','J050718','J051818'};
ChNum=[16,16,16,16,16,15,24,24,24,24,24,24];
name='V4';


% % % FEF All
Date={'G073017','G080117','G080417','G080817','G083017','J062118','J062318','J062618','J062818','J070118','J070418'};
Files={'G073017','G080117','G0804172','G080817','G083017','J062118','J062318','J062618','J062818','J0701182','J070418'};
ChNum=[16,16,24,32,32,24,24,24,24,24,32];
name='FEF';

% Date={'G080817','G083017','J062118','J062318','J062618','J062818','J070118','J070418'};
% Files={'G080817','G083017','J062118','J062318','J062618','J062818','J0701182','J070418'};
% ChNum=[32,32,24,24,24,24,24,32];
%
%
% %  All
%
Date={'G082017','G082617','G082817','G090117','G103017','G103117','G073017','G080117','G080417','G080817','G083017',...
    'J042218','J042418','J043018','J050718','J051818','J062118','J062318','J062618','J062818','J070118','J070418'}
Files={'G082017','G082617','G082817','G090117','G103017','G103117','G073017','G080117','G080417','G080817','G083017',...
    'J0422182','J042418','J043018','J050718','J051818','J062118','J062318','J062618','J062818','J0701182','J070418'};
ChNum=[16,16,16,16,16,15,16,16,24,32,32,24,24,24,24,24,24,24,24,24,24,24,32];

Period='Result';
addpath('F:\Projects\GambleMIB\Gamble\');
FireAll=[];FireAll_C=[];
for record=1:length(Date)
    
    if record >=5
        Dir=[RootDir,'\GDRecordings\JimmyRecordings\',char(Date(record)),'\'];
    else
        Dir=[RootDir,'\GDRecordings\',char(Date(record)),'\'];
    end
    
    Ch_num=ChNum(record);
    DirMat=[RootDir,'\Mat\',char(Date(record)),'\'];
    DirFig=[RootDir,'\figures\',char(Date(record)),'\'];
    plx_filename=[Dir,char(Files(record)),'-01.pl2'];
    asc_filename=[Dir,char(Files(record)),'.asc'];
    tablefile=[Dir,char(Files(record)),'.mat'];
    EDF_file=[Dir,char(Files(record)),'.asc'];
    Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
    Eventfile=[DirMat,char(Files(record)),'Event.mat'];
    LFPfile=[DirMat,char(Files(record)),'LFP.mat'];
 %     BehaviorAnalysis2018Risk(Eventfile,DirFig)
     clear  Firingrate

 %    [Firingrate,Firingrate_C]=SaccadeEndAnly2 (Eventfile,Spikefile,record);
   % [Firingrate,Firingrate_C]=TargAnly (Eventfile,Spikefile,record);
  %  [Firingrate,Firingrate_C]=ResultAnly (Eventfile,Spikefile,record);
  %  [Firingrate,Firingrate_C]=SaccadeAnly (Eventfile,Spikefile,record);
    
    % Firingrate=BGAnly (Eventfile,Spikefile,record);
    
    %     clear ChoicePerc theta
    load(Eventfile,'ChoicePerc','theta','logi_para','SubjV','BehaviorAlys','RewardHis');
    
    [Drop,PostSaccadeDrop,PostResultDrop]=DropRate(Eventfile);
    
    Drop_All(record,:,:)=Drop;
    F_PostSaccadeDrop(record,:,:)=squeeze(PostSaccadeDrop(1,:,:));
    C_PostSaccadeDrop(record,:,:)=squeeze(PostSaccadeDrop(2,:,:));
    F_PostResultDrop(record,:,:)=squeeze(PostResultDrop(1,:,:));
    C_PostResultDrop(record,:,:)=squeeze(PostResultDrop(2,:,:));
    
    Choice_All(record,:,:)=ChoicePerc;
    Theta_All(record,:)=theta;
    Logi(record,:)=logi_para;
    SubjV_all(record,:)=SubjV;
%     FireAll=cat(1,FireAll,Firingrate);
%     FireAll_C=cat(1,FireAll_C,Firingrate_C);
    Behavior(record,:)=BehaviorAlys.HistoryWL;
    RewardHisAll(record,:)=RewardHis';

end
%save('BehaviorSum.mat');
%%
MonkeyO=1:11;
MonkeyJ=12:22;
% MonkeyO=1:5;%:4;%1:11;
% MonkeyJ=6:11;%20:22;%12:22;
figure(1)
subplot(221)
bar(squeeze(nanmean( F_PostSaccadeDrop,1)))
subplot(222)
bar(squeeze(nanmean( C_PostSaccadeDrop,1)))
subplot(223)
a0=squeeze(nanmean(nanmean( Drop_All(MonkeyO,1,:),1),2));
a0_std=squeeze(nanmean(nanstd( Drop_All(MonkeyO,1,:),1),2))/sqrt(length(MonkeyO)-1);
errorbarplot(a0,a0_std,0.5)
axis square; box off; set(gca,'TickDir','out');
axis([0.5 4.5 0 0.5]);
subplot(224)
a0=squeeze(nanmean(nanmean( Drop_All(MonkeyJ,1,:),1),2));
a0_std=squeeze(nanmean(nanstd( Drop_All(MonkeyJ,1,:),1),2))/sqrt(length(MonkeyO)-1);
errorbarplot(a0,a0_std,0.5)
axis square; box off; set(gca,'TickDir','out');
axis([0.5 4.5 0 0.5]);

figure(2)
subplot(221)
a0=squeeze(nanmean(nanmean( F_PostResultDrop(MonkeyO,:,:),1),2));
a0_std=squeeze(nanmean(nanstd( F_PostResultDrop(MonkeyO,:,:),1),2))/sqrt(length(MonkeyO)-1);
errorbarplot(a0,a0_std,0.5)
axis square; box off; set(gca,'TickDir','out');
axis([-inf inf 0 0.1]);
subplot(222)
a0=squeeze(nanmean(nanmean( C_PostResultDrop(MonkeyO,:,:),1),2));
a0_std=squeeze(nanmean(nanstd( C_PostResultDrop(MonkeyO,:,:),1),2))/sqrt(length(MonkeyO)-1);
errorbarplot(a0,a0_std,0.5)
axis square; box off; set(gca,'TickDir','out');
axis([-inf inf 0 0.1]);
subplot(223)
a0=squeeze(nanmean(nanmean( F_PostResultDrop(MonkeyJ,:,:),1),2));
a0_std=squeeze(nanmean(nanstd( F_PostResultDrop(MonkeyJ,:,:),1),2))/sqrt(length(MonkeyJ)-1);
errorbarplot(a0,a0_std,0.5);set(gca,'TickDir','out')
axis square; box off; axis([-inf inf 0 0.1]);
subplot(224)
a0=squeeze(nanmean(nanmean( C_PostResultDrop(MonkeyJ,:,:),1),2));
a0_std=squeeze(nanmean(nanstd( C_PostResultDrop(MonkeyJ,:,:),1),2))/sqrt(length(MonkeyJ)-1);
errorbarplot(a0,a0_std,0.5);set(gca,'TickDir','out')
axis square; box off; set(gca,'TickDir','out')
axis([-inf inf 0 0.1]);

 PlotSumBehavior;
%[h,p]=ttest(Theta_All(12:22,2))
%% for result

% FireAll0=squeeze(nanmean(FireAll,5));
% FireAll1=squeeze(nanmean(FireAll0,1));
% FireAll0_C=squeeze(nanmean(FireAll_C,5));
% figure(25)
% 
% 
% lim=[-500 300 min(FireAll1(:)) max(FireAll1(:))];
% t=-500:size(FireAll,6)-501;
% PlotSum;
% suptitle (['Result N=', num2str(size(FireAll,1))]);
% save([name,'ResultSum.mat'])
%%
% figure(21)
% FireAll0=squeeze(nanmean(FireAll,5));
% FireAll1=squeeze(nanmean(FireAll0,1));
% FireAll0_C=squeeze(nanmean(FireAll_C,5));
% 
% lim=[-500 800 min(FireAll1(:)) max(FireAll1(:))];
% t=-500:size(FireAll,6)-501;
% PlotSum;
% %suptitle (['Result N=', num2str(size(FireAll,1))]);
% %save([name,'ResultSum.mat'])
% suptitle (['Saccade N=', num2str(size(FireAll,1))]);
% firingrate=downsample(permute(FireAll,[6,1,2,3,4,5]),20);
% clear FireAll*
% save([name,'ResultSum.mat'])

%%
%% for target
% figure(22)
% FireAll0=squeeze(nanmean(FireAll,5));
% FireAll1=squeeze(nanmean(FireAll0,1));
% FireAll0_C=squeeze(nanmean(FireAll_C,5));
% 
% lim=[-300 1000 min(FireAll1(:)) max(FireAll1(:))];
% t=-300:size(FireAll,6)-301;
% PlotSum;
% suptitle (['Target N=', num2str(size(FireAll,1))]);
% save([name,'TargetSum.mat'])
%%
% figure(21)
% FireAll0=squeeze(nanmean(FireAll,5));
% FireAll1=squeeze(nanmean(FireAll0,1));
% lim=[-300 1000 min(FireAll1(:)) max(FireAll1(:))];
% t=-300:size(FireAll,6)-301;
% PlotSum;
% suptitle (['Result N=', num2str(size(FireAll,1))]);
