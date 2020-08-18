function ContrastRiskOrg2(Spikefile,Eventfile,Ch_num)
% substract the baseline during fixation
%%%% dock the figures
%%%% do not analyze the unsorted ones
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
clear ContrastBG BG TG Sac
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
            
            eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            t_bg=-500:1001;
            rsp1=nanmean(Spike(InfoTrial.Targ2Opt==0  &   InfoTrial.DChoice(:,1)==1,t_bg>50 & t_bg<200),2);
            rsp2=nanmean(Spike(InfoTrial.Targ2Opt==0  &   InfoTrial.DChoice(:,2)==1,t_bg>50 & t_bg<200),2);
%             if nanmean(rsp1)>mean(rsp2)
%                 1=1;
%             else
%                 1=2;
%             end
%             
            for period= 1:4
                clear Spike
                
                if period==1
                    t_bg=-100:501;
                    eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='BG';
                    T_s=150:600;
                elseif period==2
                    t_bg=-500:1001;
                    eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='TG';
                    T_s=550:1000;
                    
                elseif period==3
                    t_bg=-500:501;
                    eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='Sac';
                else
                    t_bg=-500:501;
                    eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='Res';
                end
                
                mr0=0;
                nr0=1000;
                
                clear Spike_BG;
                if period==1
                    %                     Spike_BG=bsxfun(@minus,Spike,BG0);
                    Spike_BG=Spike;
                    Spike_BG=(zscorematrix(Spike_BG));
                    
                    
                    
                    
                   bg0=nanmean(Spike(:,t_bg>-200 & t_bg<-50),2);
                   bg1=bg0(InfoTrial.ContrastBG==1 & InfoTrial.ChoiceD>0 );
                   bg2=bg0(InfoTrial.ContrastBG==2 & InfoTrial.ChoiceD>0);
                   bg3=bg0(InfoTrial.ContrastBG~=3 & InfoTrial.ChoiceD>0);

                   [h2,p]=ttest2(bg1,bg2); [h1,p]=ttest2(bg1,bg3);

                    
                    if h2==0 & h1==0%abs(mean(bg1)-mean(bg2))<min(std(bg1),std(bg2))
                        Unit_channel(unit_all,3)= 1;
                    else
                        Unit_channel(unit_all,3)= 0;
                    end
                elseif period==2
                    bg0=nanmean(Spike(:,t_bg>-200 & t_bg<-50),2);
                    [h1,p]=ttest(nanmean(Spike(:,t_bg>50 & t_bg<200),2),bg0);
                    if h1>0
                        Unit_channel(unit_all,2)= 1;
                    end
                    Spike_BG=Spike;
                    Spike_BG=(zscorematrix(Spike_BG));
                    
                    
                    Unit_channel(unit_all,4)= 1;
                    
                    %  BGRateAll(unit_all,:,:)=Spike_BG;
                else
                    %                     BG0=nanmean(Spike(:,t_bg>-50 & t_bg<0),2);
                    %                     Spike_BG=bsxfun(@minus,Spike,BG0);
                    Spike_BG=Spike;
                    Spike_BG=(zscorematrix(Spike_BG));
                    %  TGRateAll(unit_all,:,:)=Spike_BG;
                end
                for contrast=1:3
                    
                    %%%% force choice, same nochoice value but in different
                    %%%% blocks
                    
                    
                    [r1,r2,r3]=deal(nan(size(t_bg)));
                    
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD>0 &  InfoTrial.Reward>0  ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD>0 &  InfoTrial.Reward>0 ),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.Targ2Opt==0 &  InfoTrial.ChoiceD>0 &  InfoTrial.Reward>0 ),:),1);
                    
                    eval([FlagVar,'.FC.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                    
                    [r1,r2,r3]=deal(nan(size(t_bg)));
                    
                    
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1 &  InfoTrial.Reward>0  ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1 &  InfoTrial.Reward>0 ),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,1)==1 &  InfoTrial.Reward>0 ),:),1);
                    
                    eval([FlagVar,'.FCPDV.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                    
                    [r1,r2,r3]=deal(nan(size(t_bg)));
                    
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==2 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,3-1)==1 &  InfoTrial.Reward>0 ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==12 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,3-1)==1 &  InfoTrial.Reward>0 ),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==11 &  InfoTrial.Targ2Opt==0 &  InfoTrial.DChoice(:,3-1)==1 &  InfoTrial.Reward>0 ),:),1);
                    eval([FlagVar,'.FCNPDV.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                    
                    
                    
                end
                
                
                
                
                %%%%%%%%%%%%%%%%%% chose choice prefered direction
                
                
                
                for contrast=1:3
                    [r1,r2,r3]=deal(nan(size(t_bg)));
                    
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1 &  InfoTrial.Reward>0 ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,1)==1 &  InfoTrial.Reward>0 ),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1 &  InfoTrial.Reward>0 ),:),1);
                    
                    eval([FlagVar,'.ChoicePDChosen.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                end
                
                for contrast=1:3
                    [r1,r2,r3]=deal(nan(size(t_bg)));
                    
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==-1 &  InfoTrial.Reward>0 ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,1)==-1 &  InfoTrial.Reward>0 ),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==-1 &  InfoTrial.Reward>0 ),:),1);
                    
                    eval([FlagVar,'.ChoicePDNChosen.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                end
                
                
                
                for contrast=1:3
                    [r1,r2,r3]=deal(nan(size(t_bg)));
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==2 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,3-1)==1 &  InfoTrial.Reward>0  ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==12 &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,3-1)==1 &  InfoTrial.Reward>0 ),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==11 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,3-1)==1 &  InfoTrial.Reward>0 ),:),1);
                    
                    eval([FlagVar,'.ChoiceNPDChosen.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                end
                
                for contrast=1:3
                    [r1,r2,r3]=deal(nan(size(t_bg)));
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==2 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,3-1)==-1 &  InfoTrial.Reward>0  ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==12 &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,3-1)==-1 &  InfoTrial.Reward>0 ),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,3-1)==11 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,3-1)==-1 &  InfoTrial.Reward>0 ),:),1);
                    
                    eval([FlagVar,'.ChoiceNPDNChosen.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                end
                
                
%                 risk_std=std(abs(InfoTrial.GamblePerc-InfoTrial.RGamblePerc));
%                 I_risk_1=InfoTrial.GamblePerc>InfoTrial.RGamblePerc+risk_std & InfoTrial.DOpt(:,1)>10 & InfoTrial.DChoice(:,2)==-1;
%                 I_risk_2=InfoTrial.GamblePerc>InfoTrial.RGamblePerc+risk_std & InfoTrial.DOpt(:,2)>10 & InfoTrial.DChoice(:,1)==-1;
%                 for contrast=1:3
%                     r1(contrast,:)=nanmean(Spike_BG(I_risk_1 & InfoTrial.ContrastBG==contrast,:));
%                     r2(contrast,:)=nanmean(Spike_BG(I_risk_2 & InfoTrial.ContrastBG==contrast,:));
%                 end
%                 
%                 if 1==1
%                     eval([FlagVar,'.RiskPre(unit_all,:,:)=r1;']);
%                 else
%                     eval([FlagVar,'.RiskNPre(unit_all,:,:)=r2;']);
%                 end
    



                 %OrgData;
                
%                 eval([FlagVar,'.ChoiceAll(unit_all,:,:)=  ChoiceAll;'])
%                 eval([FlagVar,'.FChoiceAll(unit_all,:,:)=  FChoiceAll;'])
%                 eval([FlagVar,'.ChoiceAll_label=  ChoiceAll_label;'])
%                 eval([FlagVar,'.FChoiceAll_label= FChoiceAll_label;'])                
            end
            
        end
    end
    
    
    
    
end

save(Spikefile,'BG','TG','Sac','Res','Unit_channel','-append');


%%
% Color={'k.','k--','k:','k','b.','b--','b:','b','r.','r--','r:','r'};
% figure(10)
% for ii=1:12
%     if ii<=4
%     plot(squeeze(nanmean(BG.FC.ContrastRisk(:,ii,:),1)),char(Color(ii)));hold on;
%     elseif ii<=8
%     plot(squeeze(nanmean(BG.FC.ContrastRisk(:,ii,:),1)),char(Color(ii)));hold on;
%     else
%     plot(squeeze(nanmean(BG.FC.ContrastRisk(:,ii,:),1)),char(Color(ii)));hold on;
%     end
% end


%%
% I_select=Unit_channel(:,3)>=0;
% ContrastFigure1_2;
% RiskandContrastPlot;


%%
% 
% Flag={'FC.ContrastRiskReg','ChoicePD.ContrastRiskReg','ChoiceNPD.ContrastRiskReg'};
% xl_flag={'Low_r','Med_r','High_r'};
% figure(5)
% for ii=1:3
%     subplot(3,4,ii*4-1)
%     clear a aSig
%     eval(['a=BG.',char(Flag(ii)),'Coef;']);
%     eval(['aSig=BG.',char(Flag(ii)),'Sig;']);
%     subplot(3,4,ii*4-3)
%    % a(aSig>0.05)=nan;
%     bar(nanmean(a),0.4);hold on;
%     errorbar(nanmean(a),nanstderror(a,1)','k.');
%     axis([ 0 4 0 0.3]);
%     set(gca,'XTickLabel',xl_flag);
%     axis square;box off;set(gca,'TickDir','out')
% 
%     subplot(3,4,ii*4-2)
%     bar(sum(aSig<0.05),0.4);hold on;
%     axis([ 0 4 0 40]);
%     set(gca,'XTickLabel',xl_flag);
%     axis square;box off;set(gca,'TickDir','out')
% 
%     clear a aSig
%     eval(['a=TG.',char(Flag(ii)),'Coef;']);
%     eval(['aSig=TG.',char(Flag(ii)),'Sig;']);
%    % a(aSig>0.05)=nan;
%     subplot(3,4,ii*4-1)
%     bar(nanmean(a),0.4);hold on;
%     errorbar(nanmean(a),nanstderror(a,1)','k.');
%     axis([ 0 4 0 0.3]);
%     set(gca,'XTickLabel',xl_flag);
%     axis square;box off;set(gca,'TickDir','out')
% 
%     subplot(3,4,ii*4-0)
%     bar(sum(aSig<0.05),0.4);hold on;
%     axis([ 0 4 0 40]);
%     set(gca,'XTickLabel',xl_flag);
%     axis square;box off;set(gca,'TickDir','out')
% 
% end
% 
% %%
% figure(6)
% subplot(221)
% a=[BG.FC.ContrastRegCoef;BG.ChoicePD.ContrastRegCoef;BG.ChoiceNPD.ContrastRegCoef]';
% bar(nanmean(a),0.4);hold on;
% errorbar(nanmean(a),nanstderror(a,1)','k.');
% subplot(222)
% a=[BG.FC.ContrastRegSig;BG.ChoicePD.ContrastRegSig;BG.ChoiceNPD.ContrastRegSig]';
% bar(nanmean(a<0.05),0.4);hold on;
% subplot(223)
% a=[TG.FC.ContrastRegCoef;TG.ChoicePD.ContrastRegCoef;TG.ChoiceNPD.ContrastRegCoef]';
% bar(nanmean(a),0.4);hold on;
% errorbar(nanmean(a),nanstderror(a,1)','k.');
% subplot(224)
% a=[TG.FC.ContrastRegSig;TG.ChoicePD.ContrastRegSig;TG.ChoiceNPD.ContrastRegSig]';
% bar(nanmean(a<0.05),0.4);hold on;
% 
%                 r1=squeeze(BG.FC.ContrastRisk(1,1,:));r2=squeeze(BG.FC.ContrastRisk(1,2,:));r3=squeeze(BG.FC.ContrastRisk(1,3,:));
%                 subplot(121)
%                 plot(r1,'k');hold on; plot(r2,'b');hold on; plot(r3,'r');
% 
%                 r1=squeeze(TG.FC.ContrastRisk(1,1,:));r2=squeeze(TG.FC.ContrastRisk(1,4,:));r3=squeeze(TG.FC.ContrastRisk(1,7,:));
%                 subplot(122)
%                 plot(r1,'k');hold on; plot(r2,'b');hold on; plot(r3,'r');
% 
% 
%                 if period==1       %Background period  without considering the target direction
% 
%                     r0=nanmean(Spike_BG(   InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0,T_s ),2);
%                     X=InfoTrial.ContrastBG(   InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0);
%                 else
%                     r0=nanmean(Spike_BG(  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1,T_s ),2);
%                     X=InfoTrial.ContrastBG(  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1);
%                 end
%                 [Inf_RS,Sig0]=MutualInfo_NM(r0,X,6,3);
%                  eval([FlagVar,'.FC.ContrastMI(unit_all)=Inf_RS;']);
%                  eval([FlagVar,'.FC.ContrastMISig(unit_all)=Sig0;']);
% 
%                 oosLoss1=SVMClassifier(r0,X);
%                 eval([FlagVar,'.FC.ContrastClassify(unit_all)=oosLoss1;']);
%                     statsx =regstats(r0,X);
%                     b=statsx.beta(2);r=statsx.adjrsquare;sig=statsx.tstat.pval(2);
%                     %   eval([FlagVar,'.FC.ContrastRegCoef(unit_all)=b;']);
%                     eval([FlagVar,'.FC.ContrastRegCoef(unit_all)=r;']);
%                     eval([FlagVar,'.FC.ContrastRegSig(unit_all)=sig;']);
%                     [b,sig]= MutualInfo_NM(r0,X,3,3);
%                     eval([FlagVar,'.FC.ContrastMIInf(unit_all)=b;']);
%                     eval([FlagVar,'.FC.ContrastMISig(unit_all)=sig;']);
% 
% 
%                 for risk_i=1:3
%                     clear r0 X oosLoss1
%                     risk_i0=risk_l(risk_i);
%                     if period==1
%                         r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0,T_s),2);
%                         X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0);
%                     else
%                         r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1,T_s),2);
%                         X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1);
%                     end
% %                     oosLoss1=SVMClassifier(r0,X);
% %                     eval([FlagVar,'.FC.ContrastRiskClassify(unit_all,risk_i)=oosLoss1;']);
%                  [Inf_RS,Sig0]=MutualInfo_NM(r0,X,6,3);
%                  eval([FlagVar,'.FC.ContrastRiskMI(unit_all,risk_i)=Inf_RS;']);
%                  eval([FlagVar,'.FC.ContrastRiskMISig(unit_all,risk_i)=Sig0;']);
%                     %                         statsx =regstats(r0,X);b=statsx.adjrsquare;sig=statsx.tstat.pval(2);
%                     %                         %[b,sig]= MutualInfo_NM(r0,X,3,3);
%                     %                         eval([FlagVar,'.FC.ContrastRiskRegCoef(unit_all,risk_i)=b;']);
%                     %                         eval([FlagVar,'.FC.ContrastRiskRegSig(unit_all,risk_i)=sig;']);
%                 end
%                     [b,sig]= MutualInfo_NM(r0,X,3,3);
%                     eval([FlagVar,'.FC.ContrastRiskMIInf(unit_all)=b;']);
%                     eval([FlagVar,'.FC.ContrastRiskMISig(unit_all)=sig;']);
% 
%                 clear r0 X oosLoss1
%                 r0=nanmean(Spike_BG( InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1,T_s),2);
%                 X=InfoTrial.ContrastBG(  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1);
% %                 oosLoss1=SVMClassifier(r0,X);
% %                 eval([FlagVar,'.ChoiceNPD.ContrastClassify(unit_all)=oosLoss1;']);
%                 [Inf_RS,Sig0]=MutualInfo_NM(r0,X,6,3);
%                  eval([FlagVar,'.ChoiceNPD.ContrastMI(unit_all)=Inf_RS;']);
%                  eval([FlagVar,'.ChoiceNPD.ContrastMISig(unit_all)=Sig0;']);
% statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
% [b,sig]= MutualInfo_NM(r0,X,3,3);
%                 eval([FlagVar,'.ChoiceNPD.ContrastRegCoef(unit_all)=b;']);
%                 eval([FlagVar,'.ChoiceNPD.ContrastRegSig(unit_all)=sig;']);
% 
%                 for risk_i=1:3
%                     clear r0 X oosLoss1
%                     risk_i0=risk_l(risk_i);
%                     r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1,T_s),2);
%                     X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1);
% 
%                     %statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
%                     %[b,sig]= MutualInfo_NM(r0,X,3,3);
%                     if sum(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1)>10
% %                         oosLoss1=SVMClassifier(r0,X);
% %                         eval([FlagVar,'.ChoiceNPD.ContrastRiskClassify(unit_all,risk_i)=oosLoss1;']);
%                 [Inf_RS,Sig0]=MutualInfo_NM(r0,X,6,3);
%                  eval([FlagVar,'.ChoiceNPD.ContrastRiskMI(unit_all,risk_i)=Inf_RS;']);
%                  eval([FlagVar,'.ChoiceNPD.ContrastRiskMISig(unit_all,risk_i)=Sig0;']);
%                         %                         eval([FlagVar,'.ChoiceNPD.ContrastRiskRegCoef(unit_all,risk_i)=b;']);
% %                         eval([FlagVar,'.ChoiceNPD.ContrastRiskRegSig(unit_all,risk_i)=sig;']);
%                     else
%                  eval([FlagVar,'.ChoiceNPD.ContrastRiskMI(unit_all,risk_i)=nan;']);
%                  eval([FlagVar,'.ChoiceNPD.ContrastRiskMISig(unit_all,risk_i)=nan;']);
% %                         eval([FlagVar,'.ChoiceNPD.ContrastRiskClassify(unit_all,risk_i)=nan;']);
% %                         eval([FlagVar,'.ChoiceNPD.ContrastRiskRegCoef(unit_all,risk_i)=nan;']);
% %                         eval([FlagVar,'.ChoiceNPD.ContrastRiskRegSig(unit_all,risk_i)=nan;']);
%                     end
%                 end
%                 clear r0 X statsx
%                 r0=nanmean(Spike_BG(InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1,T_s),2);
%                 X=InfoTrial.ContrastBG( InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1);
% %                 oosLoss1=SVMClassifier(r0,X);
% %                 eval([FlagVar,'.ChoicePD.ContrastClassify(unit_all)=oosLoss1;']);
%                 [Inf_RS,Sig0]=MutualInfo_NM(r0,X,6,3);
%                  eval([FlagVar,'.ChoicePD.ContrastMI(unit_all)=Inf_RS;']);
%                  eval([FlagVar,'.ChoicePD.ContrastMISig(unit_all)=Sig0;']);
%                 statsx =regstats(r0,X);b=statsx.adjrsquare;sig=statsx.tstat.pval(2);
%                 %[b,sig]= MutualInfo_NM(r0,X,3,3);
%                 eval([FlagVar,'.ChoicePD.ContrastRegCoef(unit_all)=b;']);
%                 eval([FlagVar,'.ChoicePD.ContrastRegSig(unit_all)=sig;']);
% 
%                 for risk_i=1:3
%                     clear r0 X oosLoss1
%                     risk_i0=risk_l(risk_i);
%                     r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1,T_s),2);
%                     X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1);
% %                 oosLoss1=SVMClassifier(r0,X);
% %                 eval([FlagVar,'.ChoicePD.ContrastRiskClassify(unit_all,risk_i)=oosLoss1;']);
%                 [Inf_RS,Sig0]=MutualInfo_NM(r0,X,6,3);
%                  eval([FlagVar,'.ChoicePD.ContrastRiskMI(unit_all,risk_i)=Inf_RS;']);
%                  eval([FlagVar,'.ChoicePD.ContrastRiskMISig(unit_all,risk_i)=Sig0;']);
% %                     statsx =regstats(r0,X);b=statsx.adjrsquare;sig=statsx.tstat.pval(2);
% %                     %[b,sig]= MutualInfo_NM(r0,X,3,3);
% %                     eval([FlagVar,'.ChoicePD.ContrastRiskRegCoef(unit_all,risk_i)=b;']);
% %                     eval([FlagVar,'.ChoicePD.ContrastRiskRegSig(unit_all,risk_i)=sig;']);
%                 end

%%%%%%%%%%%%%%%%%% chose non- prefered direction
