clear all
close all
RootDir='D:\Projects\GambleMIB';

% % new V4 recording
Date={'G082017','G082617','G082817','G090117'}
Files={'G082017','G082617','G082817','G090117'};
ChNum=[16,16,16,16];


% % % %%% new recording  FEF
Date={'G073017','G080117','G080417','G080817','G083017'}
Files={'G073017','G080117','G0804172','G080817','G083017'};
ChNum=[16,16,24,32,32];


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
    ContrastRiskRegress(Spikefile,Eventfile,Ch_num);
    clear TG_regression BG_regression Unit_channel
    load(Spikefile,'Fix*','TG*','BG*','Unit_channel')
    if record==1    
    Unit_channel_all=Unit_channel;
    else
    Unit_channel_all=[Unit_channel_all;Unit_channel];
    end
FixAll_regression.FC.beta=cat(1,FixAll_regression.FC.beta,Fix_regression.FC.beta);
FixAll_regression.FC.sig=cat(1,FixAll_regression.FC.sig,Fix_regression.FC.sig);
FixAll_regression.Choice.beta=cat(1,FixAll_regression.Choice.beta,Fix_regression.Choice.beta);
FixAll_regression.Choice.sig=cat(1,FixAll_regression.Choice.sig,Fix_regression.Choice.sig);
BGAll_regression.FC.beta=cat(1,BGAll_regression.FC.beta,BG_regression.FC.beta);
BGAll_regression.FC.sig=cat(1,BGAll_regression.FC.sig,BG_regression.FC.sig);
BGAll_regression.Choice.beta=cat(1,BGAll_regression.Choice.beta,BG_regression.Choice.beta);
BGAll_regression.Choice.sig=cat(1,BGAll_regression.Choice.sig,BG_regression.Choice.sig);
TGAll_regression.FC.beta=cat(1,TGAll_regression.FC.beta,TG_regression.FC.beta);
TGAll_regression.FC.sig=cat(1,TGAll_regression.FC.sig,TG_regression.FC.sig);
TGAll_regression.Choice.beta=cat(1,TGAll_regression.Choice.beta,TG_regression.Choice.beta);
TGAll_regression.Choice.sig=cat(1,TGAll_regression.Choice.sig,TG_regression.Choice.sig);

end

%%
I_select= Unit_channel_all(:,2)==1  ;

titleflag={'contrast', 'choiceprob', 'reward', 'risk','c*choiceprob', 'c*reward', 'c*risk'};
figure(1)
for ii=1:7%7
subplot(6,4,ii)
bound=round(max(abs(FixAll_regression.FC.beta(:,ii)))*1000)/1000;
xx=linspace(-bound,bound,10);
h=hist(FixAll_regression.FC.beta(:,ii),xx);
h2=hist(FixAll_regression.FC.beta(FixAll_regression.FC.sig(:,ii)<0.05,ii),xx);
bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
bar (xx,h2,'FaceColor',[0 .5 .5])
title(char(titleflag(ii)));

subplot(6,4,ii+8)
bound=round(max(abs(BGAll_regression.FC.beta(:,ii)))*1000)/1000;
xx=linspace(-bound,bound,10);
h=hist(BGAll_regression.FC.beta(:,ii),xx);
h2=hist(BGAll_regression.FC.beta(BGAll_regression.FC.sig(:,ii)<0.05,ii),xx);
bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
bar (xx,h2,'FaceColor',[0 .5 .5])
title(char(titleflag(ii)));

subplot(6,4,ii+16)
bound=round(max(abs(TG_regression.FC.beta(:,ii)))*1000)/1000;
xx=linspace(-bound,bound,10);
h=hist(TG_regression.FC.beta(:,ii),xx);
h2=hist(TG_regression.FC.beta(TG_regression.FC.sig(:,ii)<0.05,ii),xx);
bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
bar (xx,h2,'FaceColor',[0 .5 .5])
title(char(titleflag(ii)));

end
%%
titleflag={'contrast', 'choiceprob', 'reward', 'risk','choice', 'c*choiceprob', 'c*reward', 'c*risk','c*choice'};
figure(2)
for ii=1:9%9
    
subplot(6,5,ii)
bound=round(max(abs(FixAll_regression.Choice.beta(:,ii)))*1000)/1000;
xx=linspace(-bound,bound,10);
h=hist(FixAll_regression.Choice.beta(:,ii),xx);
h2=hist(FixAll_regression.Choice.beta(FixAll_regression.Choice.sig(:,ii)<0.05,ii),xx);
bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
bar (xx,h2,'FaceColor',[0 .5 .5])
title(char(titleflag(ii)));


subplot(6,5,ii+10)
bound=round(max(abs(BGAll_regression.Choice.beta(:,ii)))*1000)/1000;
xx=linspace(-bound,bound,10);
h=hist(BGAll_regression.Choice.beta(:,ii),xx);
h2=hist(BGAll_regression.Choice.beta(BGAll_regression.Choice.sig(:,ii)<0.05,ii),xx);
bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
bar (xx,h2,'FaceColor',[0 .5 .5])
title(char(titleflag(ii)));

subplot(6,5,ii+20)
bound=round(max(abs(TGAll_regression.Choice.beta(:,ii)))*1000)/1000;
xx=linspace(-bound,bound,10);
h=hist(TGAll_regression.Choice.beta(:,ii),xx);
h2=hist(TGAll_regression.Choice.beta(TGAll_regression.Choice.sig(:,ii)<0.05,ii),xx);
bar (xx,h,'FaceColor',[0.8 0.8 0.8]);hold on;
bar (xx,h2,'FaceColor',[0 .5 .5])
title(char(titleflag(ii)));
end