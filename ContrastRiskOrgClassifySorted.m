%function ContrastRiskOrgClassify(Spikefile,Eventfile,Ch_num)
% substract the baseline during fixation
%%%% dock the figures
%%%% do not analyze the unsorted ones
close all
set(0,'DefaultFigureWindowStyle','docked');
clear ContrastBG BG* TG* Sac* Res*

load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','Unit_channel','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;



BG_Color={'k','b','g'};
risk_l=[2,12,11];
load(Spikefile,'BG0','TG0');
%%
BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
close all

unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>5000
            unit_all=unit_all+1;
            Unit_channel(unit_all,1)=ch;
            % figure(unit_all)
            
            
            
            for period= 1:4
                
                if period==1
                    t_bg=-100:501;
                    eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='BG';
                    T_s=150:600;
                    Spike_BG=(zscorematrix(Spike));
                    BGAll(unit_all,:,:)=Spike_BG;
                    
                elseif period==2
                    t_bg=-500:1001;
                    eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='TG';
                    T_s=550:1000;
                    Spike_BG=(zscorematrix(Spike));
                    TGAll(unit_all,:,:)=Spike_BG;

                elseif period==3
                    t_bg=-500:501;
                    eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='Sac';
                    Spike_BG=(zscorematrix(Spike));
                    SacAll(unit_all,:,:)=Spike_BG;

                else
                    t_bg=-500:501;
                    eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='Res';
                    Spike_BG=(zscorematrix(Spike));
                    ResAll(unit_all,:,:)=Spike_BG;

                end
                

            end
            
        end
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

             risk_std=std(abs(InfoTrial.GamblePerc-InfoTrial.RGamblePerc));
             I_risk_1=InfoTrial.GamblePerc>InfoTrial.RGamblePerc+risk_std & InfoTrial.DOpt(:,1)>10;
             I_risk_2=InfoTrial.GamblePerc>InfoTrial.RGamblePerc+risk_std & InfoTrial.DOpt(:,2)>10;
  figure(10) 
  subplot(221)
  plotstd(t_bg,squeeze(nanmean(BGAll(:,I_risk_1,:),2)),'b');hold on;
  plotstd(t_bg,squeeze(nanmean(BGAll(:,I_risk_2,:),2)),'r');
  
  subplot(222)
  plotstd(t_targ,squeeze(nanmean(TGAll(:,I_risk_1,:),2)),'b');hold on;
  plotstd(t_targ,squeeze(nanmean(TGAll(:,I_risk_2,:),2)),'r');
  
  subplot(223)
  plotstd(t_sac,squeeze(nanmean(SacAll(:,I_risk_1,:),2)),'b');hold on;
  plotstd(t_sac,squeeze(nanmean(SacAll(:,I_risk_2,:),2)),'r');
  subplot(224)
   plotstd(t_result,squeeze(nanmean(ResAll(:,I_risk_1,:),2)),'b');hold on;
  plotstd(t_result,squeeze(nanmean(ResAll(:,I_risk_2,:),2)),'r');

%%


for period=1:2
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

for t=1:floor(size(A,3)/20)
    tic
    sp0=squeeze(mean(A(:,:,((t-1)*20+1):(t*20)),3));
    lb0=InfoTrial.DChoice(:,1);
    lb1=InfoTrial.DOpt(:,1);  % PD opt
    lb2=InfoTrial.DOpt(:,2);  % NPD opt
    lb3=InfoTrial.ContrastBG;  % Contrast
    
 
%%%%%%%%%%%%% Choice
%     clear I 
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.Reward>=0);
%     aa1(t)=1-RFClassifier(sp0(:,I)',lb0(I));   
%     t_1(t)=t_0(((t-1)*20+11));
%     eval([periodname,'FC.DChoice=aa1;']);
%     for contrast=1:3
%         clear I
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.ContrastBG==contrast);
%     aa1(t,contrast)=1-RFClassifier(sp0(:,I)',lb0(I));
%     end
%     eval([periodname,'FC.DChoice_Contrast=aa1;']);
%    
% 
%     for contrast=1:3
%         clear I
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.ContrastBG==contrast);
%     aa2(t,contrast)=1-RFClassifier(sp0(:,I)',lb0(I));
%     end
%     eval([periodname,'C.DChoice_Contrast=aa2;']);   
    

    for o=1:3
    clear I    
    I=(InfoTrial.ChoiceD~=0 & (InfoTrial.DOpt(:,1)==Opt(o) | InfoTrial.DOpt(:,1)==Opt(o)) & InfoTrial.Targ2Opt==0 );
    aa3(t,o)=1-RFClassifier(sp0(:,I)',lb0(I));
    
    clear I    
    I=(InfoTrial.ChoiceD~=0 & (InfoTrial.DOpt(:,1)==Opt(o) | InfoTrial.DOpt(:,1)==Opt(o)) & InfoTrial.Targ2Opt~=0 );
    aa4(t,o)=1-RFClassifier(sp0(:,I)',lb0(I));
    end
    eval([periodname,'FC.DChoice_opt=aa3;']);  
    eval([periodname,'C.DChoice_opt=aa4;']);  
   
 %%%%% for individual Opt   
    
%     clear I 
%     for o=1:3
%     clear I 
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa11(t,o)=1-RFClassifier(sp0(:,I)',lb3(I));  
%     
%     clear I   
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa12(t,o)=1-RFClassifier(sp0(:,I)',lb3(I)); 
%     
%     clear I      
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==0  & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa13(t,o)=1-RFClassifier(sp0(:,I)',lb3(I));  
%     
%     clear I
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1  & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa14(t,o)=1-RFClassifier(sp0(:,I)',lb3(I)); 
%     
%     end
%     eval([periodname,'FC.CatrastChosen_opt=aa11;']);
%     eval([periodname,'C.CatrastChosen_opt=aa12;']);   
%     eval([periodname,'FC.CatrastNChosen_opt=aa13;']);  
%     eval([periodname,'C.CatrastNChosen_opt=aa14;']);     
%     
    
          
    toc
end


end


%%

for period=1:2
    
    if period==1
    periodname='BG';
    tt=t_bg(1:20:floor((length(t_bg)/20)-1)*20+1)
    else
    periodname='TG';
    tt=t_targ(400:20:floor((1200/20)-1)*20+1);
    end
    
    eval(['C=',periodname,'C;']);
    eval(['FC=',periodname,'FC;']);
    
    figure(period)
    subplot(341)
    plot(tt,FC.DChoice_Contrast(:,1),'k');hold on;
    plot(tt,FC.DChoice_Contrast(:,2),'b');hold on;
    plot(tt,FC.DChoice_Contrast(:,3),'r'); hold on;
    legend({'LC','MC','HC'});
    axis([min(tt) max(tt) 0.2 1])
    title('Movement Direction FC')
    
    subplot(342)
    plot(tt,FC.DChoice_opt(:,1),'k');hold on;
    plot(tt,FC.DChoice_opt(:,2),'g');hold on;
    plot(tt,FC.DChoice_opt(:,3),'m'); hold on;
    legend({'LR','MR','HR'});
    axis([min(tt) max(tt) 0.2 1])
    title('Movement Direction FC')   
          
    subplot(343)
    plot(tt,C.DChoice_Contrast(:,1),'k');hold on;
    plot(tt,C.DChoice_Contrast(:,2),'b');hold on;
    plot(tt,C.DChoice_Contrast(:,3),'r'); hold on;
%     legend({'LC','MC','HC'});
    axis([min(tt) max(tt) 0.2 1])
    title('Movement Direction C')
    
    
    subplot(344)
    plot(tt,C.DChoice_opt(:,1),'k');hold on;
    plot(tt,C.DChoice_opt(:,2),'g');hold on;
    plot(tt,C.DChoice_opt(:,3),'m'); hold on;
%     legend({'LR','MR','HR'});
    axis([min(tt) max(tt) 0.2 1])
    title('Move Dir Choice ') 
    
    
    
    subplot(349)
    plot(tt,FC.CatrastChosen,'b'); hold on;
    plot(tt,FC.CatrastNChosen,'b:'); hold on;
    plot(tt,C.CatrastChosen,'m');
     plot(tt,C.CatrastNChosen,'m:');
    axis([min(tt) max(tt) 0.2 1])
    title('Contrast');
    
    subplot(3,4,10)
    plot(tt,FC.CatrastChosen_opt(:,1),'k');hold on;
    plot(tt,FC.CatrastChosen_opt(:,2),'g');hold on;
    plot(tt,FC.CatrastChosen_opt(:,3),'m');hold on;
%     legend({'Low R','Medium R','High R'});
    axis([min(tt) max(tt) 0.2 1])

    subplot(3,4,11)
    plot(tt,C.CatrastChosen_opt(:,1),'k');hold on;
    plot(tt,C.CatrastChosen_opt(:,2),'g');hold on;
    plot(tt,C.CatrastChosen_opt(:,3),'m');hold on;
%     legend({'Low R','Medium R','High R'});
    axis([min(tt) max(tt) 0.2 1])
 
    subplot(3,4,12)
    plot(tt,C.CatrastNChosen_opt(:,1),'k');hold on;
    plot(tt,C.CatrastNChosen_opt(:,2),'g');hold on;
    plot(tt,C.CatrastNChosen_opt(:,3),'m');hold on;
%     legend({'Low R','Medium R','High R'});
    axis([min(tt) max(tt) 0.2 1])
%     subplot(223)
%     plot(tt,FC.PDoptChosen,'b'); hold on;
%     plot(tt,FC.PDoptNChosen,'b:'); hold on;
% 
%     plot(tt,C.PDoptChosen,'m');
%     plot(tt,C.PDoptNChosen,'m:');
%     axis([min(tt) max(tt) 0.2 1])
%     title('PD Opt');
%     
%     
%     subplot(224)
%     plot(tt,FC.NPDoptChosen,'b'); hold on;
%     plot(tt,FC.NPDoptNChosen,'b:'); hold on;
% 
%     plot(tt,C.NPDoptChosen,'m');
%     plot(tt,C.NPDoptNChosen,'m:');
%     axis([min(tt) max(tt) 0.2 1])
%     title('PD Opt');

end
%%


%%% BG choice

for period=1:2
clear Error DChosen* t_0 t_1
if period==1
    A=BGAll;
    t_0=t_bg;
    periodname='BG';
else
    A=TGAll(400:1200);
    t_0=t_targ(400:1200);
    periodname='TG';
end

for t=1:floor(size(A,3)/20)
    tic
    sp0=mean(A(:,:,((t-1)*20+1):(t*20)));
    lb0=InfoTrial.DChoice(:,1);
    clear I
    for contrast=1:3
    I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.ContrastBG==contrast);
    DChosen_ct(t,contrast)=1-RFClassifier(sp0(:,I)',lb0(I));
    end
    t_1(t)=t_0(((t-1)*20+11));
    eval([periodname,'FC.DChoice_Contrast=DChosen_ct;']);
    
    clear I
    for o=1:3
    I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.Targ1Opt==Opt(o));
    DChosen_op(t,o)=1-RFClassifier(sp0(:,I)',lb0(I));
    end
    eval([periodname,'FC.DChoice_Opt=DChosen_op;']);
       

    clear I
    for contrast=1:3
    I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.ContrastBG==contrast);
    DChosen_ct_c(t,contrast)=1-RFClassifier(sp0(:,I)',lb0(I));
    end
    eval([periodname,'C.DChoice_Contrast=DChosen_ct_c;']);
    
    
   clear I
    for o=1:3
    I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.Targ1Opt==Opt(o));
    DChosen_op_c(t,o)=1-RFClassifier(sp0(:,I)',lb0(I));
    end
    eval([periodname,'C.DChoice_Opt=DChosen_op_c;']);
    
    toc
end


end

%%
for period=1:2
    
    if period==1
    periodname='BG';
    else
    periodname='TG';
    end

for ii=1:4
    if ii==1
    eval(['a=',periodname,'FC.DChoice_Contrast;']);
    elseif ii==2
    eval(['a=',periodname,'FC.DChoice_Opt;']);
    elseif ii==3
    eval(['a=',periodname,'C.DChoice_Contrast;']);
    elseif ii==4
    eval(['a=',periodname,'C.DChoice_Opt;']);
    end
    
figure(1)
subplot(2,2,ii)
    
plot(t_1,a(:,1),'k');hold on;
plot(t_1,a(:,2),'b');hold on;
plot(t_1,a(:,3),'r');hold on;
axis([min(t_0) max(t_0) 0.2 1]);
box off;set(gca,'TickDir','out')
xlabel(periodname);

if ii==1
    legend({'LowC','MediumC','HighC'});
    title('FC')
elseif ii==2
      legend({'LowR','MediumR','HighR'});  
title('FC')
else
    title('Choice');
end
end
end
%%
