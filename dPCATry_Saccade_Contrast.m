clear all
close all


% Date={'G073017','G080117','G080417','G080817','G083017'};
% Files={'G073017','G080117','G0804172','G080817','G083017'};
% ChNum=[16,16,24,32,32];

Date={'G082017','G082617','G082817','G090117','G103017','G103117'};
Files={'G082017','G082617','G082817','G090117','G103017','G103117'};
ChNum=[16,16,16,16,16,15];

%%% V4 Recording
Date={'J042218','J042418','J043018','J050718','J051818'};
Files={'J0422182','J042418','J043018','J050718','J051818'};
ChNum=[24,24,24,24,24];
RootDir='D:\Projects\GambleMIB';

firingRates_all=[];
firingRates_NB_all=[];
trialNum_all=[];
trialNum_NB_all=[];
for record=5%1:6
    
    clear firingRates_NB firingRates trialNum trialNum_NB
    DirMat=[RootDir,'\Mat\',char(Date(record)),'\'];
    
    Spikefile=[DirMat,char(Files(record)),'Spike.mat'];
    Eventfile=[DirMat,char(Files(record)),'Event.mat'];
%      load(Spikefile,'l_ts','ResultRate','BackgroundRate');
    load(Eventfile,'InfoTrial');
     load(Spikefile,'l_ts','SaccadeEndRate','TargetRate','BackgroundRate');
%     ResultRate=TargetRate;
    Ch_num0=ChNum(record);
    %%
    I_choice=InfoTrial.Targ2Opt>0 & InfoTrial.ChoiceD>0; %sum(I_choice);
    I_NC=InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0; %sum(I_choice);
    
    
    C1=(InfoTrial.Background<=6);
    InfoTrial.ContrastBG(C1,1)=1;
    C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
    InfoTrial.ContrastBG(C2,1)=2;
    C3=(InfoTrial.Background>12 );
    InfoTrial.ContrastBG(C3,1)=3;
    
    
    
    unit_all=0;
    for ch=1:Ch_num0
        for unit=1:(max(find(l_ts(ch,:)>0)))
            if l_ts(ch,unit)>5000
                
                clear f f0
                eval(['ft=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                eval(['bg=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                eval(['f=SaccadeEndRate.Ch',num2str(ch),'Unit',num2str(unit),';']);

                %                 f=f-nanmean(bg(:,1:50),2)*ones(1,size(f,2));
%                  f=reshape(zscore(f(:)),size(f,1),size(f,2));%ScaleMean(f);%
                f0=downsample(f',5)';
               % & ttest(nanmean(bg(:,1:200),2), nanmean(bg(:,300:500),2))~=1
               bg_a=nanmean(bg(:,1:200),2);
               bg_a1=nanmean(bg(1:300,1:200),2);bg_a2=nanmean(bg(end-299:end,1:200),2);
               bg_b= nanmean(bg(:,350:500),2);
%                                if max(nanmean(f,1))>2  & ttest(bg_a,bg_b)==1 & nanmean(bg_b)>1.1*nanmean(bg_a) & ttest(nanmean(bg_a1),nanmean(bg_a2))~=1%&  ttest(nanmean(bg(1:100,1:200),2), nanmean(bg(end-99:end,1:200),2))~=1% ttest(f0(I_choice,55),f0(I_choice,1))==1

                if 1==1%max(nanmean(ft,1))>2  & ttest(bg_a,bg_b)==1 & nanmean(bg_b)>1.1*nanmean(bg_a) & ttest(nanmean(bg_a1),nanmean(bg_a2))~=1%&  ttest(nanmean(bg(1:100,1:200),2), nanmean(bg(end-99:end,1:200),2))~=1% ttest(f0(I_choice,55),f0(I_choice,1))==1
                    unit_all=unit_all+1;
%                     f0=(f0-nanmean(nanmean(bg(:,1:200),2),1))/nanstd(nanmean(bg(:,1:200),2));
                     f0=(f0-nanmin((f(:))))/(nanmax(f(:))-nanmin(f(:)));
                    for choice=1:2
                        u1=0;
                        for Opt1=1:3%[2,12,11]
                            u1=u1+1;
                            u2=0;

                            
                            clear ID ID_NC

                            %I_choice
                            %%%% background
                            ID= I_choice & InfoTrial.ContrastBG==Opt1 & InfoTrial.ChoiceD==choice & InfoTrial.ResultOn2>0; %& InfoTrial.ChoiceOpt==Opt1 ;
%                             sum(ID)
                            %%%% no background
                            ID_NC= I_NC &   InfoTrial.ContrastBG==Opt1 & InfoTrial.ChoiceD==choice & InfoTrial.ResultOn2>0; %& InfoTrial.ChoiceOpt==Opt1 ;
                            %end
                            
                            f00=cat(1,f0( ID==1,:), f0( ID_NC==1,:));
                            %f00=zscorematrix(f00);%reshape(zscore(f00(:)),size(f00,1),size(f00,2));
                            firingRates(unit_all,choice,u1,:,1:sum(ID))=f0( ID==1,:)';
                            firingRates(unit_all,choice,u1,:,(1+sum(ID)):250)=nan;%f00(randi(sum(ID),1,20-sum(ID)),:)';
                            trialNum(unit_all,choice,u1)=sum(ID);
                            
                            
                            firingRates_NB(unit_all,choice,u1,:,1:sum(ID_NC))=f0( ID_NC==1,:)';
                            firingRates_NB(unit_all,choice,u1,:,(1+sum(ID_NC)):250)=nan;%f00(randi(sum(ID_NC),1,20-sum(sum(ID_NC)))+sum(ID),:)';
                            trialNum_NB(unit_all,choice,u1)=sum(ID_NC);
                            
                        end
                    end
                end
            end
        end
    end
    
    firingRates_all=cat(1,firingRates_all,firingRates);
    firingRates_NB_all=cat(1,firingRates_NB_all,firingRates_NB);
    
    trialNum_all=cat(1,trialNum_all,trialNum);
    trialNum_NB_all=cat(1,trialNum_NB_all,trialNum_NB);
    
end
%%

%  load('OzzyResultSpikeTargConSum.mat','ContrastIndext')
% firingRates_all=firingRates_all(ContrastIndext,:,:,:,:);
% firingRates_NB_all=firingRates_NB_all(ContrastIndext,:,:,:,:);


clear a0 a0_NC
firingRatesAverage=squeeze(nanmean(firingRates_all,5));
% a0=permute(firingRatesAverage,[4,1,2,3]);

firingRatesAverage_NB=squeeze(nanmean(firingRates_NB_all,5));
% a0_NB=permute(firingRatesAverage_NB,[4,1,2,3]);
%%
t=downsample(-500:801,5);
%t=downsample(-500:1001,20);

color={'k','b','r'};
for direction=1:2
    for risk=1:3
        clear a00**
        a00=squeeze(firingRatesAverage(:,direction,risk,:));
        a00_NB=squeeze(firingRatesAverage_NB(:,direction,risk,:));
        
        figure(1)
        subplot(2,2,direction)
        plotstd(t,(a00(:,:)),char(color(risk)));hold on;
        %axis([-500 500 , -2 2]);
        box off; set(gca,'TickDir','out');

        subplot(2,2,direction+2)%
        plotstd(t,(a00_NB(:,:)),char(color(risk)));hold on;
        %axis([-500 500 , -2  2]);
        box off; set(gca,'TickDir','out');

    
figure(2)
subplot(2,3,(direction-1)*3+risk)
imagesc(a00(:,t>0 & t<500),[0 4])
box off; set(gca,'TickDir','out');

figure(3)
subplot(2,3,(direction-1)*3+risk)
imagesc(a00_NB(:,t>0 & t<500),[0 4])
box off; set(gca,'TickDir','out');
    end
    


end
%%
% figure(100)
% subplot(121)
% imagesc(squeeze(firingRates_NB_all(110,1,3,t>0 & t<500,:))')
% subplot(122)
% plot(t,squeeze(nanmean(firingRates_NB_all(110,1,3,:,:),5)),'r');hold on
% plot(t,squeeze(nanmean(firingRates_NB_all(110,1,2,:,:),5)),'b');hold on
% plot(t,squeeze(nanmean(firingRates_NB_all(110,1,1,:,:),5)),'k');hold on
% axis([-100 300 -inf inf])
%%
% size(firingRatesAverage)
% ttest(nanmean(firingRatesAverage(:,1,1,1:25),4),nanmean(firingRatesAverage(:,1,3,1:25),4));
% anova1(squeeze(nanmean(nanmean(firingRatesAverage(:,1,:,t>100 & t<300),4),2)))
% anova1(squeeze(nanmean(nanmean(firingRatesAverage(:,2,:,t>100 & t<300),4),2)))
% anova1(squeeze(nanmean(nanmean(firingRatesAverage_NB(:,1,:,t>100 & t<300),4),2)))
% anova1(squeeze(nanmean(nanmean(firingRatesAverage_NB(:,2,:,t>100 & t<300),4),2)))
%%
a=squeeze(nanmean(nanmean(firingRatesAverage(:,1,:,t>100 & t<300),4),2));
b=ones(size(a,1),1)*[1 2 3];b1=b(:);
[b0,~,~,~,STATS]=regress(a(:),[ones(size(b1)),b1]);
% plot(b1,a(:),'.');hold on;
% plot(b1,[ones(size(b1)),b1]*b0);
STATS(3)

a=squeeze(nanmean(nanmean(firingRatesAverage(:,2,:,t>100 & t<300),4),2));
b=ones(size(a,1),1)*[1 2 3];b1=b(:);
[b0,~,~,~,STATS]=regress(a(:),[ones(size(b1)),b1]);
% plot(b1,a(:),'.');hold on;
% plot(b1,[ones(size(b1)),b1]*b0);
STATS(3)

a=squeeze(nanmean(nanmean(firingRatesAverage_NB(:,1,:,t>100 & t<300),4),2));
b=ones(size(a,1),1)*[1 2 3];b1=b(:);
[b0,~,~,~,STATS]=regress(a(:),[ones(size(b1)),b1]);
% plot(b1,a(:),'.');hold on;
% plot(b1,[ones(size(b1)),b1]*b0);
STATS(3)


a=squeeze(nanmean(nanmean(firingRatesAverage_NB(:,2,:,t>100 & t<300),4),2));
b=ones(size(a,1),1)*[1 2 3];b1=b(:);
[b0,~,~,~,STATS]=regress(a(:),[ones(size(b1)),b1]);
plot(b1,a(:),'.');hold on;
plot(b1,[ones(size(b1)),b1]*b0);
STATS(3)


  %%  for each individual neurons
%  t=downsample(-500:501,20);
% t=downsample(-500:1001,20);

% color={'k','b','r'};
% for n=1%1:size(firingRates_all,1)%36,110%1:size(firingRates_all,1)
% for direction=1:2
%     for risk=1:3
%         clear a00**
%         a00=squeeze(firingRatesAverage(n,direction,risk,:));
%         a00_NB=squeeze(firingRatesAverage_NB(n,direction,risk,:));
%         
%         figure(n+1)
%         subplot(2,2,direction)
%         plot(t,a00(:,:),'Color',char(color(risk)));hold on;
%         axis([-500 500 , -1 3]);
%         box off; set(gca,'TickDir','out');
% 
%         subplot(2,2,direction+2)%
%         plot(t,a00_NB(:,:),'Color',char(color(risk)));hold on;
%         axis([0-500 500 , -1 3]);
%         box off; set(gca,'TickDir','out');
% 
%     end
% end
% end

  %%  for each individual neurons regression
%  t=downsample(-500:501,20);
% t=downsample(-500:1001,20);

color={'k','b','r'};
for n=1:size(firingRates_all,1)%36,110%1:size(firingRates_all,1)
 for direction=1:2
   
        clear a00** a a_NC
        a=squeeze(nanmean(firingRates_all(n,direction,:,t>100 & t<300,:),4))';
        a_NC=squeeze(nanmean(firingRates_NB_all(n,direction,:,t>100 & t<300,:),4))';
        
        clear  b b1 b0 a0 STATS
        b=ones(size(a,1),1)*[1 2 3];b1=b(:);
        a=a(:); a0=a(~isnan(a)); b1=b1(~isnan(a));
        [b0,~,~,~,STATS]=regress(a0(:),[ones(size(b1)),b1]);
        b_all(direction,n)=b0(2);
        b_all_sig(direction,n)=STATS(3);
        
        clear  b b1 b0 a0 STATS a
        b=ones(size(a_NC,1),1)*[1 2 3];b1=b(:);
        a=a_NC(:); a0=a(~isnan(a)); b1=b1(~isnan(a));
        [b0,~,~,~,STATS]=regress(a0(:),[ones(size(b1)),b1]);
        b_NC_all(direction,n)=b0(2);
        b_NC_all_sig(direction,n)=STATS(3);

end
end
figure(10)
subplot(221)
h0=hist(b_all(1,:),-1:0.1:1);
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
[h,p]=ttest(b_all(1,:));
h1=hist(b_all(1,b_all_sig(1,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
axis([-1 1 0 35]);
title(['Choice RF',num2str(p,3)]);

subplot(222)
h0=hist(b_all(2,:),-1:0.1:1);
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
[h,p]=ttest(b_all(2,:));
h1=hist(b_all(2,b_all_sig(2,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
axis([-1 1 0 35]);
title(['Choice NRF',num2str(p,3)]);



subplot(223)
h0=hist(b_NC_all(1,:),-1:0.1:1);
[h,p]=ttest(b_NC_all(1,:));
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
h1=hist(b_NC_all(1,b_NC_all_sig(1,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
title(['NoChoice RF',num2str(p,3)]);
axis([-1 1 0 35]);


subplot(224)
h0=hist(b_NC_all(2,:),-1:0.1:1);
[h,p]=ttest(b_NC_all(2,:));
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
h1=hist(b_NC_all(2,b_NC_all_sig(2,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
title(['NoChoice NRF',num2str(p,3)]);
axis([-1 1 0 35]);


  %%  for each individual neurons regression
%  t=downsample(-500:501,20);
% t=downsample(-500:1001,20);

color={'k','b','r'};
for n=1:size(firingRates_all,1)%36,110%1:size(firingRates_all,1)
 for direction=1:2
   
        clear a00** a a_NC
        a=squeeze(nanmean(firingRates_all(n,direction,:,t>-100 & t<0,:),4))';
        a_NC=squeeze(nanmean(firingRates_NB_all(n,direction,:,t>-100 & t<0,:),4))';
        
        clear  b b1 b0 a0 STATS
        b=ones(size(a,1),1)*[1 2 3];b1=b(:);
        a=a(:); a0=a(~isnan(a)); b1=b1(~isnan(a));
        [b0,~,~,~,STATS]=regress(a0(:),[ones(size(b1)),b1]);
        b_all(direction,n)=b0(2);
        b_all_sig(direction,n)=STATS(3);
        
        clear  b b1 b0 a0 STATS a
        b=ones(size(a_NC,1),1)*[1 2 3];b1=b(:);
        a=a_NC(:); a0=a(~isnan(a)); b1=b1(~isnan(a));
        [b0,~,~,~,STATS]=regress(a0(:),[ones(size(b1)),b1]);
        b_NC_all(direction,n)=b0(2);
        b_NC_all_sig(direction,n)=STATS(3);

end
end
figure(11)
subplot(221)
h0=hist(b_all(1,:),-1:0.1:1);
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
[h,p]=ttest(b_all(1,:));
h1=hist(b_all(1,b_all_sig(1,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
axis([-1 1 0 35]);
title(['Choice RF',num2str(p,3)]);

subplot(222)
h0=hist(b_all(2,:),-1:0.1:1);
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
[h,p]=ttest(b_all(2,:));
h1=hist(b_all(2,b_all_sig(2,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
axis([-1 1 0 35]);
title(['Choice NRF',num2str(p,3)]);



subplot(223)
h0=hist(b_NC_all(1,:),-1:0.1:1);
[h,p]=ttest(b_NC_all(1,:));
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
h1=hist(b_NC_all(1,b_NC_all_sig(1,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
title(['NoChoice RF',num2str(p,3)]);
axis([-1 1 0 35]);


subplot(224)
h0=hist(b_NC_all(2,:),-1:0.1:1);
[h,p]=ttest(b_NC_all(2,:));
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
h1=hist(b_NC_all(2,b_NC_all_sig(2,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
title(['NoChoice NRF',num2str(p,3)]);
axis([-1 1 0 35]);

  %%  for each individual neurons regression
%  t=downsample(-500:501,20);
% t=downsample(-500:1001,20);

color={'k','b','r'};
for n=1:size(firingRates_all,1)%36,110%1:size(firingRates_all,1)
 for direction=1:2
   
        clear a00** a a_NC
        a=squeeze(nanmean(firingRates_all(n,direction,:,t>0 & t<100,:),4))';
        a_NC=squeeze(nanmean(firingRates_NB_all(n,direction,:,t>0 & t<100,:),4))';
        
        clear  b b1 b0 a0 STATS
        b=ones(size(a,1),1)*[1 2 3];b1=b(:);
        a=a(:); a0=a(~isnan(a)); b1=b1(~isnan(a));
        [b0,~,~,~,STATS]=regress(a0(:),[ones(size(b1)),b1]);
        b_all(direction,n)=b0(2);
        b_all_sig(direction,n)=STATS(3);
        
        clear  b b1 b0 a0 STATS a
        b=ones(size(a_NC,1),1)*[1 2 3];b1=b(:);
        a=a_NC(:); a0=a(~isnan(a)); b1=b1(~isnan(a));
        [b0,~,~,~,STATS]=regress(a0(:),[ones(size(b1)),b1]);
        b_NC_all(direction,n)=b0(2);
        b_NC_all_sig(direction,n)=STATS(3);

end
end
figure(12)
subplot(221)
h0=hist(b_all(1,:),-1:0.1:1);
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
[h,p]=ttest(b_all(1,:));
h1=hist(b_all(1,b_all_sig(1,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
axis([-1 1 0 35]);
title(['Choice RF',num2str(p,3)]);

subplot(222)
h0=hist(b_all(2,:),-1:0.1:1);
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
[h,p]=ttest(b_all(2,:));
h1=hist(b_all(2,b_all_sig(2,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
axis([-1 1 0 35]);
title(['Choice NRF',num2str(p,3)]);



subplot(223)
h0=hist(b_NC_all(1,:),-1:0.1:1);
[h,p]=ttest(b_NC_all(1,:));
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
h1=hist(b_NC_all(1,b_NC_all_sig(1,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
title(['NoChoice RF',num2str(p,3)]);
axis([-1 1 0 35]);


subplot(224)
h0=hist(b_NC_all(2,:),-1:0.1:1);
[h,p]=ttest(b_NC_all(2,:));
bar(-1:0.1:1,h0,'facecolor',[0.5 0.5 0.5]);hold on;
h1=hist(b_NC_all(2,b_NC_all_sig(2,:)<0.05),-1:0.1:1);
bar(-1:0.1:1,h1,'facecolor',[0.2 0.2 0.2]);hold on;
title(['NoChoice NRF',num2str(p,3)]);
axis([-1 1 0 35]);
% h.EdgeColor = 'w';
%%
% t=downsample(-500:501,20);
% color={'k','b','r'};
% 
% for tt=1:2
% for direction=1:2
%     for risk=1:3
%         clear a00**
%         a00=squeeze(nanmean(firingRates_all(:,direction,risk,:,(3*tt-2):3*tt),5));
%         a00_NB=squeeze(nanmean(firingRates_NB_all(:,direction,risk,:,(3*tt-2):3*tt),5));
%         
%         figure(tt+5)
%         subplot(2,2,direction)
%         plot(t,nanmean(a00(:,:),1),'Color',char(color(risk)));hold on;
%         axis([-500 300 , -inf inf]);
%         
%         subplot(2,2,direction+2)%
%         plot(t,nanmean(a00_NB(:,:),1),'Color',char(color(risk)));hold on;
%         axis([-500 300 , -inf inf]);
%     end
% end
% end
%%
% for direction=1:2
% %     for t0=1:size(firingRates_all,4)
%     for neuron=1:size(firingRates_all,1)
%         a=squeeze(nanmean(firingRates_all(:,direction,:,10:25,:),4));
%         a_label=[1,2,3]'*ones(1,size(a,3));
%         
%         a=a(:,:);
%         a_label=a_label(:);
%         
%         I=isnan(mean(a,1))==0;
%         a=a(:,I);
%         a_label=a_label(I);
%         a_label_all=[];
%         for l=1:3
%             a_label0=find(a_label==l);
%             a_label1=a_label0;%a_label0(randperm(length(a_label0),20));
%             a_label_all=[a_label_all;a_label1];
%         end
%         Accuracy(direction,t0)=RFClassifier(a(:,a_label_all)',a_label(a_label_all))
%     end
% end
% figure(2)
% plot(t,1-Accuracy');
% axis([-500 300 , -inf inf]);

%%

%   save('OzzySaccadeSpikeSum.mat','firingRates_all','firingRates_NB_all','firingRatesAverage','firingRatesAverage_NB','trialNum_all','trialNum_NB_all');
%save(Spikefile_L,'firingRates*','trialNum*','InfoTrial','FR_info*','-append');