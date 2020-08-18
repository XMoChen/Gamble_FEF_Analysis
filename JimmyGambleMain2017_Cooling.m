clear all
close all
RootDir='D:\Projects\GambleMIB';

% table content
% 1.
%%% behavior test
% Date={'J100217','J100317','J100417','J040218','J040418'};
% Files={'G100217','G100317','G100417','J040218','J040418'};
%
%%% V4 Recording 'J0430182'
Date={'J042218','J042418','J043018','J050718','J051818'};
Files={'J0422182','J042418','J043018','J050718','J051818'};
ChNum=[24,24,24,24,24,24];

% % %%% V4 dynamic
% Date={'J052018'};
% Files={'J052018'};
% ChNum=[24];




%%%%%FEF recordings
%%%% no sustained visual activity for the recordings above, switch to FEF recording
%%%% 600 trials, not the full conditions
% Date={'J061918'};
% Files={'J061918'};
% ChNum=[24];
%
Date={'J062118','J062318','J062618','J062818','J070118','J070418'};
Files={'J062118','J062318','J062618','J062818','J0701182','J070418'};
ChNum=[24,24,24,24,24,32];


%Prob and magintude
% Date={'J070618','J070618','J070818','J070818'};
% Files={'J070618','J070618','J070818','J070818'};
% ChNum=[32,32,32,32];
% BgLable=[1,0,1,0];
% addpath('Z:\data\RigB\GDGamble');
% 
%Prob and magintude
Date={'J071118','J071118','J071118','J071318','J071318','J072018','J072018','J073118','J073118','J080318','J080318','J080718','J080718'};
Files={'J071118','J0711182','J0711183','J071318','J0713182','J072018','J0720182','J073118','J0731182','J080318','J0803182','J080718','J0807182'};
RFFiles={'RF1','RF1','RF1','RF2','RF2','RF1','RF1','RF1','RF1','RF1','RF1','RF1','RF1'};
ChNum=[32,32,32,32,32,32,32,32,32,32,32,32,32];
BgLable=[1,0,1,1,0,0,1,1,0,0,1,1,0];
addpath('Z:\data\RigB\GDGamble');



%Prob and magintude   cooling
Date={'J081418'};
Files={'J081418'};
edfFiles={'J08148'};

RFFiles={'RF1'};
ChNum=[32];
BgLable=[1];
addpath('Z:\data\RigB\GDGamble');

for record=1%:13%9%1:7%6:7%:5%2%:4%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\JimmyRecordings\',char(Date(record)),'\'];
    %   Dir=[RootDir,'\GDRecordings\OzzyTraining\',char(Date(record)),'\'];
    
    DirMat=[RootDir,'\Mat\',char(Date(record)),'\'];
    DirFig=[RootDir,'\figures\',char(Date(record)),'\'];
    Ch_num=ChNum(record);
    
    
    %%%% make folders if not exist
    if exist(DirMat)==0
        mkdir(DirMat);
    end
    if exist(DirFig)==0
        mkdir(DirFig);
    end
    
    
    
    % %     %%%%%%   RF mapping
%         plx_filenameRF=[Dir,char(RFFiles(record)),'.pl2'];
%         Eventfile=[Dir,char(RFFiles(record)),'.mat'];
%          SpikeOrgRigBRF(plx_filenameRF,Eventfile,Ch_num,DirFig,char(Date(record)),DirFig)
    % %    SpikeOrgRigBRFV4(plx_filenameRF,Eventfile,Ch_num,DirFig,char(Date(record)),DirFig)
    % %
    % %
    %     %%%% Original recording files
    plx_filename=[Dir,char(Files(record)),'.pl2'];
    %   plx_filename=[Dir,char(Files(record)),'.pl2'];
    asc_filename=[Dir,char(Files(record)),'.asc'];
    tablefile=[Dir,char(edfFiles(record)),'.mat'];
    EDF_file=[Dir,char(edfFiles(record)),'.asc'];
    %
    %%%% mat files with orgnized events and activities
    Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
    Eventfile=[DirMat,char(Files(record)),'Event.mat'];
    LFPfile=[DirMat,char(Files(record)),'LFP.mat'];
    %Dirfigure=[Dirfigure0,char(Files(record)),'\'];
    if exist(Eventfile)==0
        save(Eventfile,'Files');save(Spikefile,'Files');save(LFPfile,'Files');
    end
    %     name=  char(Files(record));
    % %
    % %
    % %
    % %
    

    if 1==1
        %     %========== export Spikes and LFPs and event times from plexon=============
        %%%% for plx file, export plx file to mat file%%%%%%%%%%%%%%%%%%%%%%%
        %%%   SpikeOrgRigB_PLX(plx_filename,Spikefile,Eventfile);
        
        % %     % % %     %%%% for pl2 file, , export pl2 file to mat file%%%%%%%%%%%%%%%%%%%%%%
 %      SpikeOrgRigB(plx_filename,Spikefile,Eventfile,Ch_num);
        % % % %     %
        % % % %     % %========== export event from mat file during recording and edf files======
        % % % %     % %%%% organize event from mat file: read from the mat file during
        % % % %     % % recordiing
       InfoTrial=EventOrgGambleCooling(tablefile,Eventfile);
%         % % % %     % % % %%%% organize event from mat file: read from the edf file saccade related
         table_eye=LoadGamble_Cooling(EDF_file,Eventfile);
  
        %     % % %
        % % %
        % % %
        % % %     %
        % % %     % %===========behaviro analysis==============================================
        % % %     % %%%%%% behavior result   Prob
        % % %     %  %  BehaviorAnalysis2017(Eventfile,DirFig)
        % %       BehaviorAnalysis2017_3Risk(Eventfile,DirFig)
%         %%BehaviorAnalysis2018Risk(Eventfile,DirFig)
%         BehaviorAnalysis2018ProbV_Cooling(Eventfile,DirFig)
%         
%         % %     %
%         % %     % % % %     %
%         % %     % % % %     % % BehaviorAnalysis(Eventfile)
%         % %     % % % %     % % load(Eventfile,'DitectionRate','NumberCorrect','NumberAll');
%         % %     % % % %     % % NumberCorrectAll=NumberCorrectAll+NumberCorrect;
%         % %     % % % %     % % NumberAllAll=NumberAllAll+NumberAll;
%         % %     % % % %     % %===========Align spikes to different events===============================
 %       AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Background',[100,500]);
        AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Target',[1000,500]);
        %     AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Saccade',[500,500]);
        
        AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Saccade',[500,1000]);
        AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Result',[500,500]);
        AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'SaccadeEnd',[500,1000]);
%         %
    end
    
%      BehaviorAnalysis2018ProbV(Eventfile,DirFig)
    if BgLable(record)==1
        DirectionValueSpike17_BGProbV_AllControl(Spikefile,Eventfile,DirFig,Ch_num);
 
        DirectionValueSpike17_BGProbV_AllCool(Spikefile,Eventfile,DirFig,Ch_num);

%         DirectionValueSpike17_BGProbV_Cooling(Spikefile,Eventfile,DirFig,Ch_num);
    else
      %  DirectionValueSpike17_NBGProbV(Spikefile,Eventfile,DirFig,Ch_num);
    end  
%    Target_ProbV(Spikefile,Eventfile,DirFig,Ch_num,char(Files(record)),BgLable(record))
%    Reward_ProbV(Spikefile,Eventfile,DirFig,Ch_num,char(Files(record)),BgLable(record))
%    SaccadeEnd_ProbV(Spikefile,Eventfile,DirFig,Ch_num,char(Files(record)),BgLable(record))
    
    
%     Reward_Ozzy_V(Spikefile,Eventfile,DirFig,Ch_num,char(Files(record)))   

    % %     %
    % %     % % %
    % %     %
    % %     % %==========Basic plotting==================================================
    % %     %%% direction and value by reward probability
    % %     %%% DirectionValueSpike17_2(Spikefile,Eventfile,DirFig,Ch_num)
    % %
    % %        DirectionValueSpike17_BG(Spikefile,Eventfile,DirFig,Ch_num)
%     
%     if BgLable(record)==1
%             DirectionValueSpike17_BGProbV(Spikefile,Eventfile,DirFig,Ch_num)
%     else
%             DirectionValueSpike17_NBGProbV(Spikefile,Eventfile,DirFig,Ch_num)
%     end
            %        DirectionValueSpike17_AllProbV(Spikefile,Eventfile,DirFig,Ch_num)
    
    %     DirectionValueSpike17_BG(Spikefile,Eventfile,DirFig,Ch_num)
    %     DirectionValueSpike17_NBG(Spikefile,Eventfile,DirFig,Ch_num)
    
    %%%%% For Prob
    %%% direction and choice probability
    % DirectionValueSpike17_SG_Prob
    %%% direction by different trial type and choice type
    % DirectionValueSpike17_SG
    
    %    DirectionSpike(Spikefile,Eventfile,DirFig,Ch_num)
    % ValueSpike(Spikefile,Eventfile,DirFig,Ch_num)
    %%%%% for early recordings
    % PreferedSpikeTarg_early(Spikefile,Eventfile,DirFig,Ch_num)
    % PreferedSpikeBG_early(Spikefile,Eventfile,DirFig,Ch_num)
    %%%%%%
    % PreferedSpikeTarg(Spikefile,Eventfile,DirFig,Ch_num)
    % PreferedSpikeBG(Spikefile,Eventfile,DirFig,Ch_num)
    
    % %==========Basic plotting Mean spreading gamble==
    
end
% CorrectRate=NumberCorrectAll./NumberAllAll;