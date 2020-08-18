clear all
close all
RootDir='D:\Projects\GambleMIB';

% % new V4 recording
Date={'G082017','G082617','G082817','G090117','G103017'}
Files={'G082017','G082617','G082817','G090117','G103017'};
ChNum=[16,16,16,16,16];


% % % % %%% new recording  FEF
% Date={'G073017','G080117','G080417','G080817','G083017'}
% Files={'G073017','G080117','G0804172','G080817','G083017'};
% ChNum=[16,16,24,32,32];


addpath('D:\Projects\GambleMIB\Gamble\');
FixAll_regression.FC.beta=[];
FixAll_regression.FC.sig=[];
FixAll_regression.Choice.beta=[];
FixAll_regression.Choice.sig=[];
BGAll_regression.FC.beta=[];
BGAll_regression.FC.sig=[];
BGAll_regression.Choice.beta=[];
BGAll_regression.Choice.sig=[];
TGAll_regression.FC.beta=[];
TGAll_regression.FC.sig=[];
TGAll_regression.Choice.beta=[];
TGAll_regression.Choice.sig=[];

N_neu=0;
for record=1:length(Date)%1:5%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\',char(Date(record)),'\'];
    %   Dir=[RootDir,'\GDRecordings\OzzyTraining\',char(Date(record)),'\'];
    
    DirMat=[RootDir,'\Mat\',char(Date(record)),'\'];
    DirFig=[RootDir,'\figures\',char(Date(record)),'\'];
    Ch_num=ChNum(record);
    
    
    
    
    %%%% mat files with orgnized events and activities
    Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
    Eventfile=[DirMat,char(Files(record)),'Event.mat'];
    LFPfile=[DirMat,char(Files(record)),'LFP.mat'];
    
    
    close all
    set(0,'DefaultFigureWindowStyle','docked');
    load(Eventfile,'InfoTrial','InfoExp');
    load(Spikefile,'ResultRate','l_ts')
    tr=-501:500;
   
    
    for ch=23%1:ChNum(record) % 6
    for unit=4%1:length(l_ts(ch,:)) % 3
        if l_ts(ch,unit)>5000
            N_neu=N_neu+1;
            clear result0
   eval(['result0=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
%    result0=ResultRate.Ch4Unit3;
%    result0=ResultRate.Ch4Unit4;
%    result0=ResultRate.Ch23Unit5;

   % legend({'0','1','2','3','4','5'})
   % if plot=1 plot the reward figure else no plot
   plotflag=1;
   A(N_neu,:,:)=RewardPlot(InfoTrial,result0,N_neu,plotflag);
   title(['Ch',num2str(ch),'Unit',num2str(unit)]);
        end
    end
    end

end

%%
% figure(1)
% ColorRW={'b','g','k','m','r'};
% subplot(221)
% %%% for legend
% % for ri=1:5
% % 
% %     plot(tr,nanmean(squeeze(A(:,ri,:)),1),'Color',char(ColorRW(ri)));hold on
% %     legend({'0','1','2','3','4','5'})
% % 
% % end
% 
% for d=1:2
%     
%     for ri=1:5
%     subplot(2,4,(d-1)*2+1)
%     plotstd(tr,squeeze(A(:,ri+(d-1)*10,:)),char(ColorRW(ri)));hold on
%     subplot(2,4,d*2)
%     plotstd(tr,squeeze(A(:,ri+5+(d-1)*10,:)),char(ColorRW(ri)));hold on
%             if d==1
%                 title('FC  PD');
%             else
%                 title('FC  NPD');
%             end        
%     end
% end
% 
% 
% for d=1:2
%     for ri=1:5
%             subplot(2,4,(d-1)*2+5)
% 
%     plotstd(tr,squeeze(A(:,ri+20+(d-1)*10,:)),char(ColorRW(ri)));hold on
%        
%     subplot(2,4,d*2+4)
% 
%     plotstd(tr,squeeze(A(:,ri+25+(d-1)*10,:)),char(ColorRW(ri)));hold on
%             if d==1
%                 title('FC  PD');
%             else
%                 title('FC  NPD');
%             end        
%     end
% end
% 
% %%
