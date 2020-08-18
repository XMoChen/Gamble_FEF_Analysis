clear all
close all

Figurepath='F:\Projects\GambleMIB\SumFigures\';
RootDir='F:\Projects\GambleMIB';
set(0,'DefaultFigureWindowStyle','docked');
% Ozzy  FEF
Date={'G073017','G080117','G080417','G080817','G083017'};
Files={'G073017','G080117','G0804172','G080817','G083017'};
ChNum=[16,16,24,32,32];

% Jimmy  FEF
Date={'J062118','J062318','J062618','J062818','J070118','J070418'};
Files={'J062118','J062318','J062618','J062818','J0701182','J070418'};
ChNum=[24,24,24,24,24,32];


% Ozzy V4
Date={'G082017','G082617','G082817','G090117','G103017','G103117'}
Files={'G082017','G082617','G082817','G090117','G103017','G103117'};
ChNum=[16,16,16,16,16,15];

% Jimmy V4
Date={'J042218','J042418','J043018','J050718','J051818'};
Files={'J0422182','J042418','J043018','J050718','J051818'};
ChNum=[24,24,24,24,24,24];



% V4 All
Date={'G082017','G082617','G082817','G090117','G103017','G103117','J042418','J043018','J050718','J051818'}
Files={'G082017','G082617','G082817','G090117','G103017','G103117','J042418','J043018','J050718','J051818'};
ChNum=[16,16,16,16,16,15,24,24,24,24,24,24];
name='V4';


% FEF All
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
% Date={'G082017','G082617','G082817','G090117','G103017','G103117','G073017','G080117','G080417','G080817','G083017',...
%     'J042218','J042418','J043018','J050718','J051818','J062118','J062318','J062618','J062818','J070118','J070418'}
% Files={'G082017','G082617','G082817','G090117','G103017','G103117','G073017','G080117','G080417','G080817','G083017',...
%     'J0422182','J042418','J043018','J050718','J051818','J062118','J062318','J062618','J062818','J0701182','J070418'};
% ChNum=[16,16,16,16,16,15,16,16,24,32,32,24,24,24,24,24,24,24,24,24,24,24,32];

Period='Result';
addpath('D:\Projects\GambleMIB\Gamble\');
FireAll=[];ExpIndexAll=[];
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
    %   BehaviorAnalysis2018Risk(Eventfile,DirFig)
    %   Firingrate=SaccadeEndAnly (Eventfile,Spikefile,record);
    clear  Firingrate
    
        [Firingrate,~]=GambleLFPAnly (Period,Eventfile,LFPfile,record,Ch_num);

%    if strcmp(Period,'Result') ==1
%     [Firingrate,~]=ResultAnlyLFP (Eventfile,LFPfile,record,Ch_num);
%    elseif strcmp(Period,'SaccadeEnd') ==1
%     [Firingrate,Firingrate_C]=SaccadeEndAnly2 (Eventfile,Spikefile,record);
%    elseif strcmp(Period,'Target') ==1
%     [Firingrate,~]=TargetAnlyLFP (Eventfile,LFPfile,record,Ch_num);
%    elseif strcmp(Period,'Saccade') ==1
%     [Firingrate,Firingrate_C]=SaccadeAnly (Eventfile,Spikefile,record);
%    elseif strcmp(Period,'BackGround') ==1
%     Firingrate=BGAnly (Eventfile,Spikefile,record);
%    end
%     [Firingrate,~]=ResultAnlyLFP (Eventfile,LFPfile,record,Ch_num);
%     [Firingrate,~]=TargetAnlyLFP (Eventfile,LFPfile,record,Ch_num);

    %    Firingrate=BGAnly (Eventfile,Spikefile,record);
    
    %     clear ChoicePerc theta
    load(Eventfile,'ChoicePerc','theta','logi_para','SubjV');
    
    Choice_All(record,:,:)=ChoicePerc;
    Theta_All(record,:)=theta;
    Logi(record,:)=logi_para;
    SubjV_all(record,:)=SubjV;
    FireAll=cat(1,FireAll,Firingrate);
    ExpIndex=record*ones(size(Firingrate,1),1);
    ExpIndexAll=cat(1,ExpIndexAll,ExpIndex);
end

% PlotSumBehavior;

%% for result

figure(22)
FireAll0=squeeze(nanmean(FireAll,5));
FireAll1=squeeze(nanmean(FireAll0,1));

lim=[-500 300 min(FireAll1(:)) max(FireAll1(:))];
t=-500:size(FireAll,6)-501;
PlotSumCon;
suptitle (['Result N=', num2str(size(FireAll,1))]);
% save([name,'ResultSum.mat'])
%%
figure(21)
FireAll0=squeeze(nanmean(FireAll,5));
FireAll1=squeeze(nanmean(FireAll0,1));

lim=[-500 1000 min(FireAll1(:)) max(FireAll1(:))];
t=-500:size(FireAll,6)-501;
PlotSum;
suptitle (['Result N=', num2str(size(FireAll,1))]);
%save([name,'ResultSum3.mat']);%,'ExpIndexAll','SubjV_all','-append')
%% Sepctrum analysis
% [Rest300_fft(ch,contrast,d,v,trial,:)]=log(abs(((pmtm(rt,2.5,NFFT,Fs,'eigen')))))
%%% for target
% % figure(22)
% % FireAll0=squeeze(nanmean(FireAll,5));
% % FireAll1=squeeze(nanmean(FireAll0,1));
% % lim=[-600 1800 min(FireAll1(:)) max(FireAll1(:))];
% % t=-600:size(FireAll,6)-601;
% % PlotSum;
% % suptitle (['Target N=', num2str(size(FireAll,1))]);
% % save([name,'TargetSum2.mat'])
% % 
% % 
% % firingrate=downsample(permute(FireAll,[6,1,2,3,4,5]),20);
% % save([name,'TargetSum2.mat'],'firingrate','-append')


% figure(21)
% FireAll0=squeeze(nanmean(FireAll,5));
% FireAll1=squeeze(nanmean(FireAll0,1));
% lim=[-300 1000 min(FireAll1(:)) max(FireAll1(:))];
% t=-300:size(FireAll,6)-301;
% PlotSum;
% suptitle (['Result N=', num2str(size(FireAll,1))]);
