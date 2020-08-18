%function ContrastRiskOrgClassify(Spikefile,Eventfile,Ch_num)
% substract the baseline during fixation
%%%% dock the figures
%%%% do not analyze the unsorted ones
%close all
set(0,'DefaultFigureWindowStyle','docked');
clear ContrastBG BG* TG* Sac* Res*

load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','Unit_channel','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';




BG_Color={'k','b','g'};
risk_l=[2,12,11];
load(Spikefile,'BG0','TG0');

BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
%close all

unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>5000
            unit_all=unit_all+1;
            Unit_channel(unit_all,1)=ch;
            % figure(unit_all)
            
            
            
            for period= 1:4
                clear  Spike_BG*
                if period==1
                    t_bg=-100:501;
                    eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='BG';
                    T_s=150:600;
                    BG0=zeros(size(Spike,1),1);
                  %  BG0=nanmean(Spike(:,t_bg>-200 & t_bg<-50),2);
                     Spike_BG0=bsxfun(@minus,Spike,BG0);
                    Spike_BG=(zscorematrix(Spike_BG0));
                    BGAll(unit_all,:,:)=Spike_BG;
                elseif period==2
                    t_bg=-500:1001;
                    eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='TG';
                    T_s=550:1000;
                     Spike_BG0=bsxfun(@minus,Spike,BG0);
                    Spike_BG=(zscorematrix(Spike_BG0));
                    TGAll(unit_all,:,:)=Spike_BG;

                elseif period==3
                    t_bg=-500:501;
                    eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='Sac';
                    Spike_BG0=bsxfun(@minus,Spike,BG0);
                    Spike_BG=(zscorematrix(Spike_BG0));
                    SacAll(unit_all,:,:)=Spike_BG;

                else
                    t_bg=-500:501;
                    eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='Res';
                    Spike_BG0=bsxfun(@minus,Spike,BG0);
                    Spike_BG=(zscorematrix(Spike_BG0));
                    ResAll(unit_all,:,:)=Spike_BG;

                end
                

            end
            
        end
    end
    
    
    

    
end

%%
figure(11)
Option=[2,12,11];
Color_p={'b','g','r'};
for contrast=1:3
    for opt=1:3
subplot(3,3,contrast)
BGAllMean=squeeze(nanmean((nanmean(BGAll,3)),1));
I=InfoTrial.Reward>0 & InfoTrial.Targ2Opt==0 &   InfoTrial.DOpt(:,1)==Option(opt) &  InfoTrial.ContrastBG==contrast;
sum(I)
plot(InfoTrial.DRate(I,1), BGAllMean(I),[char(Color_p(opt)),'.']); hold on;  
 axis([ 0 1 -inf inf]);
 
subplot(3,3,contrast+3)
TGAllMean=squeeze(nanmean((nanmean(TGAll(:,:,500:1000),3)),1));
I=InfoTrial.Reward>0 & InfoTrial.Targ2Opt==0 &   InfoTrial.DOpt(:,1)==Option(opt) &  InfoTrial.ContrastBG==contrast;
sum(I)
plot(InfoTrial.DRate(I,1), TGAllMean(I),[char(Color_p(opt)),'.']); hold on;  
 axis([ 0 1 -inf inf]);
 
subplot(3,3,contrast+6)
ResAllMean=squeeze(nanmean(nanmean(ResAll(:,:,100:500),3),1));
I=InfoTrial.Reward>0 & InfoTrial.Targ2Opt==0 &   InfoTrial.DOpt(:,1)==Option(opt) &  InfoTrial.ContrastBG==contrast;
sum(I)
plot(InfoTrial.DRate(I,1), ResAllMean(I),[char(Color_p(opt)),'.']); hold on;  
 axis([ 0 1 -inf inf]);
 
    end
end

%save(Spikefile,'BG0','TG0','Sac0','Res0','Unit_channel','-append');
%a0=zscore(a0);
%%
t_sac=-500:501;
t_result=-500:501;
t_targ=-500:1001;
t_bg=-100:501;
Opt=[2,12,11];

%%


for period=1%:2
clear Error DChosen* t_0 t_1  aa* periodname
if period==1
    A=BGAll;
    t_0=t_bg;
    periodname='BG';
else
    A=TGAll(:,:,400:1200);
    t_0=t_targ(400:1200);
    periodname='TG';
end


    lb0=InfoTrial.DChoice(:,1);
    lb1=InfoTrial.DOpt(:,1);  % PD opt
    lb2=InfoTrial.DOpt(:,2);  % NPD opt
    lb3=InfoTrial.ContrastBG;  % Contrast


%%%%% I_sub subset of the trials
%%%%% SubI subcategory index
%%%%% SubI_opt   subcategory label
%%%%% sp0 data
%%%%% label
%%%%% PerN  permultation number




%%% compare contrast information at forced choice, chosen across different
%%% options
%%
perN=100; 
sp0=squeeze(mean(A(:,:,t_0>50 & t_0<500 ),3));
SubI= InfoTrial.DOpt(:,1);
SubI_opt=[2,12,11];

I_sub=InfoTrial.ChoiceD~=0 ;
[ContrastFC,ContrastFC_per]=ContrastClassPer(I_sub,SubI,SubI_opt,sp0,lb3,perN);     
ContrastFC_c=ContrastFC-nanmean(ContrastFC_per,2)';

I_sub=InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0;
[ContrastC,ContrastC_per]=ContrastClassPer(I_sub,SubI,SubI_opt,sp0,lb3,perN);     
ContrastC_c=ContrastC-nanmean(ContrastC_per,2)';  

figure(10)
subplot(241)
bar([ContrastFC;ContrastC]);
legend({'Low R','Mid R','High R'})
set(gca,'XTickLabel',{'Forced Choice','Choice'});
axis([0.5 2.5 0 1.5]);box off; set(gca,'TickDir','out');


%%
for nu=1:size(sp0,1)
    for op=1:3
        I_sub=InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & SubI==SubI_opt(op);
        [Inf_RSFC(nu,op),Sig0FC(nu,op)]=MutualInfo_NM(sp0(nu,I_sub),lb3(I_sub),10,3);

        I_sub=InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & SubI==SubI_opt(op);
        [Inf_RSC(nu,op),Sig0C(nu,op)]=MutualInfo_NM(sp0(nu,I_sub),lb3(I_sub),10,3);

    end
end
subplot(243)
errorbarplot([nanmean(Inf_RSFC,1);nanmean(Inf_RSC,1)],[nanstderror(Inf_RSFC,1);nanstderror(Inf_RSC,1)]);
%legend({'Low R','Mid R','High R'})
set(gca,'XTickLabel',{'Forced Choice','Choice'});
box off; set(gca,'TickDir','out');

%%
%%%% compare contrast information at forced choice, chosen and nonchosen
%%%% location
clear SubI I_sub
I_sub=InfoTrial.ChoiceD~=0;
SubI(InfoTrial.Targ2Opt==0)=1;
SubI(InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1)=2;
SubI(InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1)=3;
SubI_opt=[1,2,3];
[ContrastFCC,ContrastFCC_per]=ContrastClassPer(I_sub,SubI',SubI_opt,sp0,lb3,perN);     
ContrastFCC_c=ContrastFCC-nanmean(ContrastFCC_per,2)';  
subplot(242)
bar(ContrastFCC,0.3);
set(gca,'XTickLabel',{'FChoice','Chosen','NonChosen'});
box off; set(gca,'TickDir','out');
%%
%%%% compare option information at different contrast level
clear SubI I_sub
I_sub=InfoTrial.ChoiceD~=0 & InfoTrial.Reward>0
SubI=lb3;
SubI_opt=[1,2,3];
[OptionContrast,OptionContrast_per]=ContrastClassPer(I_sub,SubI,SubI_opt,sp0,lb1,perN);     
OptionContrast_c=OptionContrast-nanmean(OptionContrast_per,2)';  
subplot(243)
bar(OptionContrast,0.3);
set(gca,'XTickLabel',{'Low C','Mid C','High C'});
opt0=[2,12,11];


% figure()
% clear a
% for c=1:3
%     for opt=1:3
%         a(c,opt)=nanmean(sp0(lb1==opt0(opt) & lb3==c & I_sub==1));
%     end
% end
% a(:,3)
% bar(a)
% % I_sub=InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1;
% % [ContrastCNChosen,ContrastCNChosen_per]=ContrastClassPer(I_sub,SubI,SubI_opt,sp0,lb3,perN);     
% % ContrastCNChosen_c=ContrastCNChosen-nanmean(ContrastCNChosen_per,2)'; 
% % figure()
% % bar([1-ContrastFC;1-ContrastCChosen;1-ContrastCNChosen]);
% %%
% %%% compare option information at forced choice
% 
% I_sub=InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0;
% [ContrastFC,ContrastFC_per]=ContrastClassPer(I_sub,SubI,SubI_opt,sp0,lb1,perN);     
% ContrastFC_c=ContrastFC-nanmean(ContrastFC_per,2)';
% 
% figure()
% bar([ContrastFC;ContrastCChosen;ContrastCNChosen]);
% %%
% 
% 
% 
% 
% for t=1:floor(size(A,3)/20)
%     tic
%     sp0=squeeze(mean(A(:,:,((t-1)*20+1):(t*20)),3));
%     lb0=InfoTrial.DChoice(:,1);
%     lb1=InfoTrial.DOpt(:,1);  % PD opt
%     lb2=InfoTrial.DOpt(:,2);  % NPD opt
%     lb3=InfoTrial.ContrastBG;  % Contrast
%     
%  
% %for contrast=1:3
% optsum=[14,13,23];
% opt=[2,12,11];
% 
%     
% 
%         
%         
% %     eval([periodname,'FC.Contrast_opt=aa1;']);  
% %     eval([periodname,'C.Contrast_opt=aa2;']);  
% % 
% %     eval([periodname,'FC.DChoice_optSum=aa3;']);  
% %     eval([periodname,'C.DChoice_optSum=aa4;']);    
%     
%     eval([periodname,'FC.Opt_contrast=aa5;']);    

          
    toc
end





%%
t_sac=-500:501;
t_result=-500:501;
t_targ=-500:1001;
t_bg=-100:501;
Opt=[2,12,11];
for period=1:2
    
    if period==1
    periodname='BG';
    tt=t_bg(1:20:floor((length(t_bg)/20)-1)*20+1);
    else
    periodname='TG';
    tt=t_targ(400:20:floor((1200/20)-1)*20+1);
    end
    
    eval(['C=',periodname,'C;']);
    eval(['FC=',periodname,'FC;']);
    
 %%%%% choic info    
figure(period+8)
%for con=1:3
for op=1:3
subplot(2,4,op)
plot(tt,squeeze(nanmean(FC.DChoice_optSum(:,op),2)),char(Color(op)));hold on;
axis([-inf inf 0.4 1])
if period==1
xlabel('BG onset');title('Choice FC');
else
xlabel('TG onset');title('Choice FC');
end
end
subplot(2,4,4)
bar(nanmean(FC.DChoice_optSum,1),0.4)
axis([0 5 0 1])

%for con=1:3
for op=1:3
subplot(2,4,op+4)
plot(tt,squeeze(nanmean(C.DChoice_optSum(:,op),2)),char(Color(op)));hold on;
axis([-inf inf 0.4 1])
if period==1
xlabel('BG onset');title('Choice C');
else
xlabel('TG onset');title('Choice C');
end
end
subplot(2,4,8)
bar(nanmean(C.DChoice_optSum,1),0.4)
axis([0 5 0 1])


%%%%% contrast info    
figure(10+period)
%for con=1:3
for op=1:3
subplot(2,4,op)
plot(tt,squeeze(nanmean(FC.Contrast_opt(:,op),2)),char(Color(op)));hold on;
axis([-inf inf 0.3 1])
if period==1
xlabel('BG onset');title('Contrast FC');
else
xlabel('TG onset');title('Contrast FC');
end
    
end
subplot(2,4,4)
bar(nanmean(FC.Contrast_opt,1),0.4)
axis([0 5 0 1])

%for con=1:3
for op=1:3
subplot(2,4,op+4)
plot(tt,squeeze(nanmean(C.Contrast_opt(:,op),2)),char(Color(op)));hold on;
axis([-inf inf 0.3 1])
if period==1
xlabel('BG onset');title('Contrast C');
else
xlabel('TG onset');title('Contrast C');
end
end
subplot(2,4,8)
bar(nanmean(C.Contrast_opt,1),0.4)
axis([0 5 0 1])



%%%%% opt info    
figure(12+period)
%for con=1:3
for op=1%:3
subplot(2,4,op)
plot(tt,squeeze(nanmean(FC.Opt_contrast(:,op),2)),char(Color(op)));hold on;
axis([-inf inf 0.3 1])
if period==1
xlabel('BG onset');title('Contrast FC');
else
xlabel('TG onset');title('Contrast FC');
end
    
end
subplot(2,4,4)
bar(nanmean(FC.Opt_contrast,1),0.4)
axis([0 5 0 1])

end