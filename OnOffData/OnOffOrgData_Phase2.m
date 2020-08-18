
clear all
close all
RootDir='D:\Projects\GambleMIB';





% % Prob and magintude

Date={'J050718','J051818','J052018'};
Files={'BG7','BG1','BG1'};
RFFiles={'RF2','RF3','RF3'};

ChNum=[24,24,24];
Area='V4';


% 'J062318',
% % Prob and magintude
% Date={'J062118','J062618','J062818','J070118','J070418','J070618','J070818','J071318','J072018','J073118'};
% Files={'BG1','BG2','BG1','BG1','BG1','BG1','BG1','BG1','BG1','BG1','BG1','BG1'};
% RFFiles={'RF2','RF1','RF1','RF1','RF1','RF1','RF1','RF2','RF1','RF1'};
% ChNum=[24,24,24,24,32,32,32,32,32,32];
% Area='FEF';

Date={'J062818','J073118'};
Files={'BG1','BG1'};
RFFiles={'RF1','RF1'};
ChNum=[24,32];
Area='FEF';


BgLable=[1,0,1,1,0,0,1];
addpath('Z:\data\RigB\GDGamble');

addpath('D:\Projects\GambleMIB\Gamble\');

for record=2%:2%10%:3%[1:10]%4:9%:4%1:length(Date)%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\JimmyRecordings\',char(Date(record)),'\'];
    %   Dir=[RootDir,'\GDRecordings\OzzyTraining\',char(Date(record)),'\'];
    
    DirMat=[RootDir,'\GDRecordings\JimmyRecordings\',char(Date(record)),'\'];
    DirFig=[RootDir,'\figures\',char(Date(record)),'\'];
    RFFig=[RootDir,'\OnOffData\PhaseII\',Area,'\figures\'];
    DirGambleData=[RootDir,'\OnOffData\PhaseII\',Area,'\',char(Date(record)),'\BG\'];
    DirRFData=[RootDir,'\OnOffData\PhaseII\',Area,'\',char(Date(record)),'\RF\'];
    
    Ch_num=ChNum(record);
  %  BasicInfo.depth=150:150:150*Ch_num;
    BasicInfo.Monkey='Jimmy';
    BasicInfo.CorticalArea=Area;
    if exist(DirGambleData)==0
        mkdir(DirGambleData);
        mkdir(DirRFData);
    end
    
    
% %     %%%%%% for RF part %%%%%%%%%%%%%%%%%%%%%%
%     plx_filenameRF=[Dir,char(RFFiles(record)),'.pl2'];
%     Eventfile=[Dir,char(RFFiles(record)),'.mat'];
%     tcounts=plx_info(plx_filenameRF,1);
%     
%     SaveEventfile=[DirRFData,char(RFFiles(record)),'Event.mat'];
%     SaveSpikefile=[DirRFData,char(RFFiles(record)),'Spike.mat'];
%     %%% creat both event and spike files
%      SpikeOrgTsRF(plx_filenameRF,Eventfile,Ch_num,SaveEventfile,SaveSpikefile,BasicInfo)
% %    % SpikeOrgRigBRF_OnOff(plx_filenameRF,Eventfile,Ch_num,DirFig,char(Date(record)),RFFig,SaveSpikefile)
% %     SpikeOrgRigBRF_OnOff_V4(plx_filenameRF,Eventfile,Ch_num,DirFig,char(Date(record)),RFFig,SaveSpikefile)
% 
%     %    SpikeOrgTsRFV4(plx_filenameRF,Eventfile,Ch_num,SaveEventfile,SaveSpikefile,BasicInfo)
    
    
%     %     %%% for gamble part
    plx_filename=[Dir,char(Files(record)),'-01.pl2'];
    tcounts=plx_info(plx_filename,1);
    
    Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
    Eventfile=[DirMat,char(Files(record)),'.mat'];
    LFPfile=[DirMat,char(Files(record)),'LFP.mat'];
    
    
    SaveEventfile=[DirGambleData,char(Files(record)),'Event.mat'];
    SaveSpikefile=[DirGambleData,char(Files(record)),'Spike2.mat'];
    %
    BGEvent(Eventfile,SaveEventfile,BasicInfo);
    SpikeOrgTs(plx_filename,Eventfile,SaveEventfile,SaveSpikefile,Ch_num)
end