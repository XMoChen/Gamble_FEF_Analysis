
clear all
close all
RootDir='D:\Projects\GambleMIB';

%20, 24, 26, 27
%%% Data Organize for On and OFF state analysis
Date={'G042417','G042017','G042117','G042317'};
Files={'G042417','0420172','0421172','G042317'};
ChNum=[24,24,24,24,24,24];
BasicInfo.area='FEF';

%%% Data Organize for On and OFF state analysis
% Date={'G082017','G082617','G082817','G090117','G103017','G103117'};
% Files={'G082017','G082617','G082817','G090117','G103017','G103117'};
% ChNum=[16,16,16,16,16,15];
% BasicInfo.area='V4';

% Date={'G073017','G080117','G080417','G080817','G083017'};
% Files={'G073017','G080117','G0804172','G080817','G083017'};
% ChNum=[16,16,24,32,32];
% BasicInfo.area='FEF';

% %%% records Prob
% Date={'G050717','G050417','G050217','G042817','G042717','G042617'};
% Files={'G050717','G050417','G050217','G042817','G042717','G042617'};
% ChNum=[24,24,24,24,24,24];


addpath('D:\Projects\GambleMIB\Gamble\');

for record=1%:4%1:length(Date)%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\',char(Date(record)),'\'];
    %   Dir=[RootDir,'\GDRecordings\OzzyTraining\',char(Date(record)),'\'];
    
    DirMat=[RootDir,'\Mat\',char(Date(record)),'\'];
    DirFig=[RootDir,'\figures\',char(Date(record)),'\'];
    RFFig=[RootDir,'\figures\RFFigs\'];
    DirGambleData=[RootDir,'\OnOffData\',char(Date(record)),'\Gamble\'];
    DirRFData=[RootDir,'\OnOffData\',char(Date(record)),'\RF\'];
    
    Ch_num=ChNum(record);
    BasicInfo.depth=150:150:150*Ch_num;
    BasicInfo.Monkey='Ozzy';
    
    if exist(DirGambleData)==0
        mkdir(DirGambleData);
        mkdir(DirRFData);
    end
    
    
    %%%%%% for RF part %%%%%%%%%%%%%%%%%%%%%%
    plx_filenameRF=[Dir,'RF1.pl2'];
    Eventfile=[Dir,'RF1.mat'];
    tcounts=plx_info(plx_filenameRF,1);
    
    SaveEventfile=[DirRFData,char(Files(record)),'Event.mat'];
    SaveSpikefile=[DirRFData,char(Files(record)),'Spike.mat'];
    %%% creat both event and spike files
     SpikeOrgTsRF(plx_filenameRF,Eventfile,Ch_num,SaveEventfile,SaveSpikefile,BasicInfo)
%    SpikeOrgTsRFV4(plx_filenameRF,Eventfile,Ch_num,SaveEventfile,SaveSpikefile,BasicInfo)
    
    
%     %     %%% for gamble part
    plx_filename=[Dir,char(Files(record)),'-sort1.pl2'];
    tcounts=plx_info(plx_filename,1);
    
    Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
    Eventfile=[DirMat,char(Files(record)),'Event.mat'];
    LFPfile=[DirMat,char(Files(record)),'LFP.mat'];
    
    
    SaveEventfile=[DirGambleData,char(Files(record)),'Event.mat'];
    SaveSpikefile=[DirGambleData,char(Files(record)),'Spike.mat'];
    %
    OnOffEvent(Eventfile,SaveEventfile,BasicInfo);
    SpikeOrgTs(plx_filename,Eventfile,SaveSpikefile,Ch_num)
end