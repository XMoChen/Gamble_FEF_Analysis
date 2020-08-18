clear all
close all
RootDir='F:\Projects\GambleMIB\';
addpath('F:\Projects\GambleMIB\Gamble\');
%
% % table content
% % 1.
% %%% behavior test
% Date={'G041917','G041817','G041317','G032917','G032817','G032717','G032617'};
% Files={'G041917','G041817','G041317','G032917','G032817','G032717','G032617'};
%
% %%% records
% %20, 24, 26, 27
Date={'G042417','G042317','G042117','G042017'};
Files={'G042417','G042317','0421172','0420172'};
ChNum=[24,24,24,24,24,24];
%
%
% % % %%% records Prob
Date={'G050717','G050417','G050217','G042817','G042717','G042617'};
Files={'G050717','G050417','G050217','G042817','G042717','G042617'};
ChNum=[24,24,24,24,24,24];
%
%
% %%% records V
Date={'G051017'};
Files={'G051017'};
ChNum=[24];
NumberCorrectAll=zeros(3,2,2);
NumberAllAll=zeros(3,2,2);
% %
% % %%% new training
% % Date={'G071817','G072117','G072417','G072617','G072717','G072917'};
% % Files={'Otrain4','Otrain6','Otrain7','Otrain9','Otrain10','Otrain12'};
% % ChNum=[24,24,24,24,24,24];
% % NumberCorrectAll=zeros(3,2,2);
% % NumberAllAll=zeros(3,2,2);
%

%%% new recording  FEF
% Date={'G073017','G080117','G080417','G080817','G083017'};
% Files={'G073017','G080117','G0804172','G080817','G083017'};
% ChNum=[16,16,24,32,32];


% % % % new V4 recording
% Date={'G082017','G082617','G082817','G090117','G103017','G103117'}
% Files={'G082017','G082617','G082817','G090117','G103017','G103117'};
% ChNum=[16,16,16,16,16,15];


addpath('F:\Projects\GambleMIB\Gamble\');
addpath(genpath('F:\Projects\Core\'))
addpath('F:\Projects\LIPCooling\Quito Cooling\matlab\');
for record=1:length(Date)%1:4%1:4%[1:6]%1:4%1:length(Date)%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\',char(Date(record)),'\'];
    %   Dir=[RootDir,'\GDRec5%ordings\OzzyTraining\',char(Date(record)),'\'];
    
    DirMat=[RootDir,'\Mat\',char(Date(record)),'\'];
    DirFig=[RootDir,'\figures\',char(Date(record)),'\'];
    RFFig=[RootDir,'\figures\RFFigs\'];
    Ch_num=ChNum(record);
    
    
    %%%% make folders if not exist
    if exist(DirMat)==0
        mkdir(DirMat);
    end
    if exist(DirFig)==0
        mkdir(DirFig);
    end
    
    
    %%%%%%   RF mapping
    plx_filenameRF=[Dir,'RF1.pl2'];
    Eventfile=[Dir,'RF1.mat'];
    %     SpikeOrgRigBRF(plx_filenameRF,Eventfile,Ch_num,DirFig,char(Date(record)),RFFig)
    %     SpikeOrgRigBRFV4(plx_filenameRF,Eventfile,Ch_num,DirFig,char(Date(record)),RFFig)
    
    %     %%%% Original recording files
    plx_filename=[Dir,char(Files(record)),'-sort1.pl2'];
    %   plx_filename=[Dir,char(Files(record)),'.pl2'];
    asc_filename=[Dir,char(Files(record)),'.asc'];
    tablefile=[Dir,char(Files(record)),'.mat'];
    EDF_file=[Dir,char(Files(record)),'.asc'];
    
    %%%% mat files with orgnized events and activities
    Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
    Spikefile_L=[DirMat,char(Files(record)),'Spike_L.mat'];
    Eventfile=[DirMat,char(Files(record)),'Event.mat'];
    LFPfile=[DirMat,char(Files(record)),'LFP.mat'];
    %Dirfigure=[Dirfigure0,char(Files(record)),'\'];
    if exist(Spikefile_L)==0
        load(Spikefile,'l_ts');
        save(Spikefile_L,'Files','l_ts');
    end
    
    % if exist(Eventfile)==0
    %  save(Eventfile,'Files');save(Spikefile,'Files');save(LFPfile,'Files');
    % end
    %  name=  char(Files(record));
    %
    
    %========== export Spikes and LFPs and event times from plexon=============
    %%%% for plx file, export plx file to mat file%%%%%%%%%%%%%%%%%%%%%%%
    %%%   SpikeOrgRigB_PLX(plx_filename,Spikefile,Eventfile);
    
    %     %%%% for pl2 file, , export pl2 file to mat file%%%%%%%%%%%%%%%%%%%%%%
%            SpikeOrgRigB(plx_filename,Spikefile,Eventfile,Ch_num);
    %     % %
    %     % % %========== export event from mat file during recording and edf files======
    %     % % %%%% organize event from mat file: read from the mat file during
    %     %     % % % recordiing
%             InfoTrial=EventOrgGamble(tablefile,Eventfile);
    %         %     % % %%%% organize event from mat file: read from the edf file saccade related
     table_eye=LoadGamble(EDF_file,Eventfile);
    %
    %
    %
    %     %
    %     % %===========behavior analysis==============================================
    %     % %%%%%% behavior result   Prob
    %     %  BehaviorAnalysis2017(Eventfile,DirFig)
    %     %        BehaviorAnalysis2017_3Risk(Eventfile,DirFig)
    %     BehaviorAnalysis2018Risk(Eventfile,DirFig)
    %     % % BehaviorAnalysis(Eventfile)
    %     % % load(Eventfile,'DitectionRate','NumberCorrect','NumberAll');
    %     % % NumberCorrectAll=NumberCorrectAll+NumberCorrect;
    %     % % NumberAllAll=NumberAllAll+NumberAll;
    %     % % %===========Align spikes to different events===============================
%     tcounts=plx_info(plx_filename,1);
%     save(Spikefile,'tcounts','-append');
    %       AlignEvenSpikeLong(Spikefile,Spikefile_L,Eventfile,record,Ch_num,'Background',[300,2500]);
    AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Background',[200,500]);
    %     %         AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Target',[1000,500]);
    AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Target',[600,1800]);
    AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Saccade',[500,500]);
    %%AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'SaccadeEnd',[500,1000]);
    AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Result',[500,800]);
    
    
%     % % %===========LFP organization
%     addpath('F:\Projects\LIPCooling\Quito Cooling\matlab\')
         LFPOrg_Jimmy(plx_filename,LFPfile,Ch_num,Spikefile);
         AlignEventLFP(LFPfile,Eventfile,Ch_num,'Background',[500,500]);
         AlignEventLFP(LFPfile,Eventfile,Ch_num,'Target',[1000,800]);
    %     %Reward_Ozzy(Spikefile,Eventfile,DirFig,Ch_num,char(Files(record)))
    %     %  Reward_Ozzy_V(Spikefile,Eventfile,DirFig,Ch_num,char(Files(record)))
         AlignEventLFP(LFPfile,Eventfile,Ch_num,'Result',[1000,800]);
         AlignEventLFP(LFPfile,Eventfile,Ch_num,'Saccade',[1000,800]);
%     
%      DirMat='F:\Projects\GambleMIB\FEFLFPDataOrg\';
%      LFPOrgFile=[DirMat,char(Files(record)),'LFP.mat'];
    % %LFPOrgFigure='D:\Projects\GambleMIB\FEFLFPDataOrg\figure\';
    % DirMat2='D:\Projects\GambleMIB\FEFLFPDataOrg\data\';
    % LFPOrgFile2=[DirMat2,char(Files(record)),'LFP.mat'];
    % load(LFPOrgFile,'*FireAll');
    % save(LFPOrgFile2,'*FireAll');
%     OrgForAnalysisLFP(Eventfile,LFPfile,record,Ch_num,LFPOrgFile)
    % %SpectraLFP(LFPOrgFile,LFPOrgFigure,char(Files(record)))
    %
    
    % %==========Basicq plotting==================================================
    %%% direction and value by reward probability
    %     DirectionValueSpike17(Spikefile,Eventfile,DirFig,Ch_num)
    %   DirectionValueSpike17_BG_Prob_ozzy(Spikefile,Eventfile,DirFig,Ch_num)
    %      DirectionValueSpike17_BG_ozzy(Spikefile,Eventfile,DirFig,Ch_num)
    %     DirectionValueSpike17_BG_Prob(Spikefile,Eventfile,DirFig,Ch_num);
    %%%%% For Prob
    %%% direction and choice probability
    % DirectionValueSpike17_SG_Prob
    %%% direction by different trial type and choice type
    %      DirectionValueSpike17_SG
    
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