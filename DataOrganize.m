function DataOrganize(Eventfile,Spikefile,LFPfile,SummaryFile,SummaryImage,Filename)
load(Eventfile);
load(Spikefile);
load(LFPfile);

%%

if exist('InfoTrial')~=1
    InfoTrial=TrialInfo;
end
I_select=InfoTrial.ResultOn>0;
InfoTrial_valid=InfoTrial(I_select,:);


Neu_num=length(fieldnames(BackgroundRate));
names=fieldnames(TargetRate);
TF=find(contains(names,'Unit'));


name=fieldnames(TargetHist);

BGHist0=(struct2cell(BackgroundHist));
TimeStart=-200;
BGTimeEpoch=TimeStart:(size(BackgroundHist.Ch2Unit1,2)-2+TimeStart);

TGHist0=(struct2cell(TargetHist));
TimeStart=-600;
TGTimeEpoch=TimeStart:(size(TargetHist.Ch2Unit1,2)-1+TimeStart);

SCHist0=(struct2cell(SaccadeHist));
TimeStart=-500;
SCTimeEpoch=TimeStart:(size(SaccadeHist.Ch2Unit1,2)-1+TimeStart);

RTHist0=(struct2cell(ResultHist));
TimeStart=-500;
RTTimeEpoch=TimeStart:(size(ResultHist.Ch2Unit1,2)-1+TimeStart);


for nu=1:Neu_num
    
    
    name0=name{nu};
    Key = 'Ch';
    Index = strfind(name0, Key);
    ChannelNumber = sscanf(name0(Index(1) + length(Key):end), '%g', 1);
    ChannelIndex(nu)=ChannelNumber;
    
    Key = 'Unit';
    Index = strfind(name0, Key);
    NeuNumber = sscanf(name0(Index(1) + length(Key):end), '%g', 1);
    NeurIndex(nu)=NeuNumber;
    
    
    % Background -100 to 0
    eval(['a= BGHist0{',num2str(nu),'};']) ;
    BG_n100_0(nu,:,:)=a(:,BGTimeEpoch>-100 & BGTimeEpoch<=0);
    
    
    % Target -350 to 50   & 0 to 400
    eval(['a= TGHist0{',num2str(nu),'};']) ;
    TG_n350_50(nu,:,:)=a(:,TGTimeEpoch>-350 & TGTimeEpoch<=50);
    TG_0_400(nu,:,:)=a(:,TGTimeEpoch>0 & TGTimeEpoch<=400);
    
    
    % SaccadeEnd -400 to 0
    eval(['a= SCHist0{',num2str(nu),'};']) ;
    SC_n300_100(nu,:,:)=a(:,SCTimeEpoch>-300 & SCTimeEpoch<=100);
    
    
    % Result -350 to 50
    eval(['a= RTHist0{',num2str(nu),'};']) ;
    RT_n350_50(nu,:,:)=a(:,RTTimeEpoch>-350 & RTTimeEpoch<=50);
    
end


TimeStart=-500;
BGTimeEpoch_LFP=TimeStart:(size(LFP_Background_1,2)-1+TimeStart);
TimeStart=-1000;
TGTimeEpoch_LFP=TimeStart:(size(LFP_Target_1,2)-1+TimeStart);
TimeStart=-1000;
SCTimeEpoch_LFP=TimeStart:(size(LFP_Saccade_1,1)-1+TimeStart);
TimeStart=-1000;
RTTimeEpoch_LFP=TimeStart:(size(LFP_Result_1,2)-1+TimeStart);

for ch=1:ChannelNumber
    eval(['a=LFP_Background_',num2str(ch),';']);
    BG_n200_0_LFP(ch,:,:)=a(:,BGTimeEpoch_LFP>-200 & BGTimeEpoch_LFP<=0);
    
    clear a
    eval(['a=LFP_Target_',num2str(ch),';']);
    TG_n350_50_LFP(ch,:,:)=a(:,TGTimeEpoch_LFP>-350 & TGTimeEpoch_LFP<=50);
    
    clear a
    eval(['a=LFP_Target_',num2str(ch),';']);
    TG_0_400_LFP(ch,:,:)=a(:,TGTimeEpoch_LFP>0 & TGTimeEpoch_LFP<=400);
    
    clear a
    eval(['a=LFP_Saccade_',num2str(ch),';']);
    SC_n300_100_LFP(ch,:,:)=a(:,SCTimeEpoch_LFP>-300 & SCTimeEpoch_LFP<=100);
    
    clear a
    eval(['a=LFP_Result_',num2str(ch),';']);
    RT_n350_50_LFP(ch,:,:)=a(:,RTTimeEpoch_LFP>-350 & RTTimeEpoch_LFP<=50);
    
    
end



% Calculate spectrum
FlagPd={'BG_n200_0','TG_n350_50','TG_0_400','SC_n300_100','RT_n350_50'};

eval(['a=',char(FlagPd(1)),'_LFP;']);
for ch=1:ChannelNumber
    clear a0
    a0=squeeze(a(ch,:,:))';
    a_fft(ch,:,:)=10*log10(pmtm(a0,3,512)+10^-10)';
end
eval([char(FlagPd(1)),'_LFP_fft=a_fft;']);


for cond=2:5
    clear a a_fft
    eval(['a=',char(FlagPd(cond)),'_LFP;']);
    for ch=1:ChannelNumber
        clear a0
        a0=squeeze(a(ch,:,:))';
        % bg spectrum from the background
        bg0=ones(size(a0,2),1)*nanmean(squeeze(BG_n200_0_LFP_fft(ch,:,:)),1);
        a_fft(ch,:,:)=10*log10(pmtm(a0,3,512)+10^-10)'-bg0;
    end
    eval([char(FlagPd(cond)),'_LFP_fft=a_fft;']);
    [~,f]=pmtm(a0(:,1),3,512);
    
end

%%
FlagPd={'BG_n200_0','TG_n350_50','TG_0_400','SC_n300_100','RT_n350_50'};

% Select all choice trial sna devide by choice derections
ChoiceTrial=table2array(InfoTrial(:,8))~=0;
ChoiceDirection=table2array(InfoTrial(:,12));


D1=ChoiceTrial==1 & ChoiceDirection==1;
D2=ChoiceTrial==1 & ChoiceDirection==2;

h=figure();

for cond=2:5
    subplot(3,4,cond-1)
    clear a0
    eval(['a0=',char(FlagPd(cond)),';'])
    if cond==2
        t=-350:49;
        ylabel('Spike');
    elseif cond==3
        t=0:399;
    elseif cond==4
        t=-300:99;
    else
        t=-350:49;
    end
    plot(t,squeeze(nanmean(nanmean(a0(:,D1,:),1),2)),'k'); hold on
    plot(t,squeeze(nanmean(nanmean(a0(:,D2,:),1),2)),'r'); hold on
    axis([min(t) max(t) -inf inf]);
    
end


for cond=2:5
    subplot(3,4,cond-1+4)
    clear a0
    eval(['a0=',char(FlagPd(cond)),'_LFP;'])
    if cond==2
        t=-350:49;
        ylabel('LFP');
    elseif cond==3
        t=0:399;
    elseif cond==4
        t=-300:99;
    else
        t=-350:49;
    end
    plot(t,squeeze(nanmean(nanmean(a0(:,D1,:),1),2)),'k'); hold on
    plot(t,squeeze(nanmean(nanmean(a0(:,D2,:),1),2)),'r'); hold on
    axis([min(t) max(t) -inf inf]);
end


[~,f]=pmtm(a0(:,1),3,512);
f=f*500/pi;
for cond=2:5
    subplot(3,4,cond-1+8)
    if cond==2
        ylabel('LFP Powever');
    end
    clear fft0
    eval(['fft0=',char(FlagPd(cond)),'_LFP_fft;'])
    plot(f,squeeze(nanmean(nanmean(fft0(:,D1,:),1),2)),'k'); hold on
    plot(f,squeeze(nanmean(nanmean(fft0(:,D2,:),1),2)),'r'); hold on
    axis([0 150 -inf inf]);
end
suptitle((Filename))
%%
save(SummaryFile,'BG_*','TG*','SC_*','RT_*','InfoTrial');
print(h,[SummaryImage,Filename],'-jpg');

