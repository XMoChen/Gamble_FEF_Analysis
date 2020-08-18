clear all
% close all
addpath('C:\Users\Xiaomo\Dropbox\SFN presentations\SNF2018\')

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



% % V4 All
% Date={'G082017','G082617','G082817','G090117','G103017','G103117','J042418','J043018','J050718','J051818'}
% Files={'G082017','G082617','G082817','G090117','G103017','G103117','J042418','J043018','J050718','J051818'};
% ChNum=[16,16,16,16,16,15,24,24,24,24,24,24];
% name='V4'; G_num=6;


% FEF All
Date={'G073017','G080117','G080417','G080817','G083017','J062118','J062318','J062618','J062818','J070118','J070418'};
Files={'G073017','G080117','G0804172','G080817','G083017','J062118','J062318','J062618','J062818','J0701182','J070418'};
ChNum=[16,16,24,32,32,24,24,24,24,24,32];
name='FEF'; G_num=5;

% Date={'G080817','G083017','J062118','J062318','J062618','J062818','J070118','J070418'};
% Files={'G080817','G083017','J062118','J062318','J062618','J062818','J0701182','J070418'};
% ChNum=[32,32,24,24,24,24,24,32];
%
%
% %  All
%
% Date={'G082017','G082617','G082817','G090117','G103017','G103117','G073017','G080117','G080417','G080817','G083017',...
%     'J042218','J042418','J043018','J050718','J051818','J062118','J062318','J062618','J062818','J070118','J070418'}
% Files={'G082017','G082617','G082817','G090117','G103017','G103117','G073017','G080117','G080417','G080817','G083017',...
%     'J0422182','J042418','J043018','J050718','J051818','J062118','J062318','J062618','J062818','J0701182','J070418'};
% ChNum=[16,16,16,16,16,15,16,16,24,32,32,24,24,24,24,24,24,24,24,24,24,24,32];

Period='Result';
addpath('F:\Projects\GambleMIB\Gamble\');
FireAll=[];FireAll_C=[];
FireAll=[];ExpIndexAll=[];

for record=1:length(Date)
    
    if record >G_num
        Dir=[RootDir,'\mat\',char(Date(record)),'\'];
    else
        Dir=[RootDir,'\mat\',char(Date(record)),'\'];
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
     
%    TargAnly (Eventfile,Spikefile,record);

  % [Firingrate,Firingrate_C]=GambleSpikeAnly_WinLoss('Result',Eventfile,Spikefile,record);
    [Firingrate,Firingrate_C]=EventAnly('Result',Eventfile,Spikefile,record);

    %     clear ChoicePerc theta
    load(Eventfile,'ChoicePerc','theta','logi_para','SubjV','BehaviorAlys','RewardHis');
%     
    Choice_All(record,:,:)=ChoicePerc;
    Theta_All(record,:)=theta;
    Logi(record,:)=logi_para;
    SubjV_all(record,:)=SubjV;
    FireAll=cat(1,FireAll,Firingrate);
    FireAll_C=cat(1,FireAll_C,Firingrate_C);
    Behavior(record,:)=BehaviorAlys.HistoryWL;
    RewardHisAll(record,:)=RewardHis';
    ExpIndex=record*ones(size(Firingrate,1),1);
    ExpIndexAll=cat(1,ExpIndexAll,ExpIndex);

end
%save('BehaviorSum.mat');
% PlotSumBehavior;
%[h,p]=ttest(Theta_All(12:22,2))

%%
figure(21)
FireAll0=squeeze(nanmean(FireAll,5));
FireAll1=squeeze(nanmean(FireAll0,1));
FireAll0_C=squeeze(nanmean(FireAll_C,5));

if strcmp(Period,'Result')==1
    lim=[-500 200 min(FireAll1(:)) max(FireAll1(:))];
    t=-500:size(FireAll,6)-501;
elseif strcmp(Period,'SaccadeEnd')==1
    lim=[-500 800 min(FireAll1(:)) max(FireAll1(:))];
    t=-500:size(FireAll,6)-801;
elseif strcmp(Period,'Target')==1
    lim=[-600 1800 min(FireAll1(:)) max(FireAll1(:))];
    t=-600:size(FireAll,6)-601;   
end
PlotSumWinLoss;
suptitle ([Period,' N=', num2str(size(FireAll,1))]);
firingrate=downsample(permute(FireAll,[6,1,2,3,4,5]),20);
FireAll=permute(firingrate,[2,3,4,5,6,1]);
save(['D:\Projects\GambleMIB\Gamble\',name,Period,'Sum.mat'])


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
