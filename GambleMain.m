clear all 
close all
RootDir='D:\Projects\GambleMIB';

% table content
% 1.
Date={'GD1','GD112416','G120316','G120316','G120816','G121516','G122016','G122616'};
Files={'GD1','GD112416','G120316','S2120316','G120816','G121516','G122016','G122616'};
ChNum=[16,16,24,24,24,24,24,24];
NumberCorrectAll=zeros(3,2,2);
NumberAllAll=zeros(3,2,2);
for record=6%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\',char(Date(record)),'\'];
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
    
    %%%% Original recording files
plx_filename=[Dir,char(Files(record)),'-Sort1.pl2'];
%   plx_filename=[Dir,char(Files(record)),'.pl2'];
asc_filename=[Dir,char(Files(record)),'.asc'];
tablefile=[Dir,char(Files(record)),'.mat'];
EDF_file=[Dir,char(Files(record)),'.asc'];

%%%% mat files with orgnized events and activities
Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
Eventfile=[DirMat,char(Files(record)),'Event.mat'];
LFPfile=[DirMat,char(Files(record)),'LFP.mat'];
%Dirfigure=[Dirfigure0,char(Files(record)),'\'];
if exist(Eventfile)==0
 save(Eventfile,'Files');save(Spikefile,'Files');save(LFPfile,'Files');
end
 name=  char(Files(record));
 

%========== export Spikes and LFPs and event times from plexon=============
%%%% for plx file, export plx file to mat file%%%%%%%%%%%%%%%%%%%%%%%
%%%   SpikeOrgRigB_PLX(plx_filename,Spikefile,Eventfile);

%%%% for pl2 file, , export pl2 file to mat file%%%%%%%%%%%%%%%%%%%%%%
%    SpikeOrgRigB(plx_filename,Spikefile,Eventfile,Ch_num);

%========== export event from mat file during recording and edf files======
%%%% organize event from mat file: read from the mat file during
% recordiing
%         InfoTrial=EventOrgGamble(tablefile,Eventfile);
% %%%% organize event from mat file: read from the edf file saccade related
%       table_eye=LoadGamble(EDF_file,Eventfile);


%===========behaviro analysis==============================================
%%%%%% behavior result
% BehaviorAnalysis(Eventfile)
% load(Eventfile,'DitectionRate','NumberCorrect','NumberAll');
% NumberCorrectAll=NumberCorrectAll+NumberCorrect;
% NumberAllAll=NumberAllAll+NumberAll;
%===========Align spikes to different events===============================
% AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Background',[100,500]);  

%%%% for early recording version
 % AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Target',[550,500]);
%%%%%%%%%%

% AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Saccade',[500,500]);
% AlignEvenSpike(Spikefile,Eventfile,record,Ch_num,'Result',[500,500]);
%
%==========Basic plotting==================================================
% DirectionSpike(Spikefile,Eventfile,DirFig,Ch_num)
% ValueSpike(Spikefile,Eventfile,DirFig,Ch_num)
%%%%% for early recordings
% PreferedSpikeTarg_early(Spikefile,Eventfile,DirFig,Ch_num)
% PreferedSpikeBG_early(Spikefile,Eventfile,DirFig,Ch_num)
%%%%%%
% PreferedSpikeTarg(Spikefile,Eventfile,DirFig,Ch_num)
% PreferedSpikeBG(Spikefile,Eventfile,DirFig,Ch_num)
end
CorrectRate=NumberCorrectAll./NumberAllAll;