function FullRegressionOrg(Spikefile,Eventfile,Ch_num)
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


%%
BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
close all

unit_all=0;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:))
        if l_ts(ch,unit)>10000
            unit_all=unit_all+1;
            Unit_channel(unit_all)=ch;
            % figure(unit_all)
            
            
            
            for period= 1:2%:3
                
                if period==1
                    t_bg=-100:501;
                    eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='BG';
                elseif period==2
                    t_bg=-500:1001;
                    eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='TG';
                elseif period==3
                    t_bg=-500:501;
                    eval(['Spike=SaccadeRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
                    FlagVar='Sac';
                end
                
                mr0=0;
                nr0=1000;
                
                if period==1
                BG0=nanmean(Spike(:,t_bg>-100 & t_bg<0),2);
                end
                Spike_BG=bsxfun(@minus,Spike,BG0);
                Spike_BG=zscorematrix(Spike_BG);

                
                
                if period==1       %Background period  without considering the target direction
                    
                    r0=nanmean(Spike_BG(   InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0,t_bg>0 & t_bg<500 ),2);
                    X(1,:)=InfoTrial.ContrastBG(   InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0); % Contrast
                    Risk(InfoTrial.DOpt==2)=1; Risk(InfoTrial.DOpt==12)=2;Risk(InfoTrial.DOpt==11)=3;
                    X(2,:)=Risk(InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0); % Risk
                    X(3,:)=InfoTrial.DRate(InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0); % Choice Probability
                    
                    statsx =regstats(r0,X);
                    b=statsx.beta(2);r=statsx.adjrsquare;sig=statsx.tstat.pval(2);
                 %   eval([FlagVar,'.FC.ContrastRegCoef(unit_all)=b;']);
                    eval([FlagVar,'.FC.ContrastRegCoef(unit_all)=b;']);
                    eval([FlagVar,'.FC.ContrastRegSig(unit_all)=sig;']);
%                     [b,sig]= MutualInfo_NM(r0,X,3,3);
%                     eval([FlagVar,'.FC.ContrastMIInf(unit_all)=b;']);
%                     eval([FlagVar,'.FC.ContrastMISig(unit_all)=sig;']);                    
                    
                    
                    for risk_i=1:3
                    clear r0 X statsx
                    risk_i0=risk_l(risk_i);
                    r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0,t_bg>0 & t_bg<500 ),2);
                    X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0);
                    statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
                    %[b,sig]= MutualInfo_NM(r0,X,3,3);
                    eval([FlagVar,'.FC.ContrastRiskRegCoef(unit_all,risk_i)=b;']);
                    eval([FlagVar,'.FC.ContrastRiskRegSig(unit_all,risk_i)=sig;']);
                    end
%                     [b,sig]= MutualInfo_NM(r0,X,3,3);
%                     eval([FlagVar,'.FC.ContrastRiskMIInf(unit_all)=b;']);
%                     eval([FlagVar,'.FC.ContrastRiskMISig(unit_all)=sig;']);                      
                    
                    
                else        %Target period  : target in the RF
                    
                    r0=nanmean(Spike_BG(  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1,t_bg>0 & t_bg<500 ),2);
                    X=InfoTrial.ContrastBG(  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1);
                    statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
                    %[b,sig]= MutualInfo_NM(r0,X,3,3);
                    eval([FlagVar,'.FC.ContrastRegCoef(unit_all)=b;']);
                    eval([FlagVar,'.FC.ContrastRegSig(unit_all)=sig;']);
                    
                    
                    for risk_i=1:3
                    clear r0 X statsx
                    risk_i0=risk_l(risk_i);
                    r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1,t_bg>0 & t_bg<500 ),2);
                    X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1);
                    statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
                    %[b,sig]= MutualInfo_NM(r0,X,3,3);
                    eval([FlagVar,'.FC.ContrastRiskRegCoef(unit_all,risk_i)=b;']);
                    eval([FlagVar,'.FC.ContrastRiskRegSig(unit_all,risk_i)=sig;']);
                    end
                    
                    
                end
                
                
                
  %%%%%%%%%%%%%%%%%% chose choice prefered direction              
                
                
                
                for contrast=1:3
                    r1=nan(size(t_bg));
                    r2=nan(size(t_bg));
                    r3=nan(size(t_bg));
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1 ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,1)==1),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,1)==1),:),1);
                    eval([FlagVar,'.ChoicePD.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                end
                
                

                clear r0 X statsx               
                r0=nanmean(Spike_BG(InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1,t_bg>0 & t_bg<500 ),2);
                X=InfoTrial.ContrastBG( InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1);
                statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
                %[b,sig]= MutualInfo_NM(r0,X,3,3);
                eval([FlagVar,'.ChoicePD.ContrastRegCoef(unit_all)=b;']);
                eval([FlagVar,'.ChoicePD.ContrastRegSig(unit_all)=sig;']);

               for risk_i=1:3
                clear r0 X statsx
                risk_i0=risk_l(risk_i);
                r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1,t_bg>0 & t_bg<500 ),2);
                X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1);
                statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
                %[b,sig]= MutualInfo_NM(r0,X,3,3);
                eval([FlagVar,'.ChoicePD.ContrastRiskRegCoef(unit_all,risk_i)=b;']);
                eval([FlagVar,'.ChoicePD.ContrastRiskRegSig(unit_all,risk_i)=sig;']);
               end
                             
     %%%%%%%%%%%%%%%%%% chose non- prefered direction              
             
                for contrast=1:3
                    r1=nan(size(t_bg));
                    r2=nan(size(t_bg));
                    r3=nan(size(t_bg));
                    r1=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==2 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1 ),:),1);
                    r2=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==12 &  InfoTrial.Targ2Opt~=0  &  InfoTrial.DChoice(:,2)==1),:),1);
                    r3=nanmean(Spike_BG((InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,1)==11 &  InfoTrial.Targ2Opt~=0 &  InfoTrial.DChoice(:,2)==1),:),1);
                    eval([FlagVar,'.ChoiceNPD.ContrastRisk(unit_all,(contrast*3-2):contrast*3,:)=[r1;r2;r3];']);
                end
                

                r0=nanmean(Spike_BG( InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1,t_bg>0 & t_bg<500 ),2);
                X=InfoTrial.ContrastBG(  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1);
                %statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
                %[b,sig]= MutualInfo_NM(r0,X,3,3);
                eval([FlagVar,'.ChoiceNPD.ContrastRegCoef(unit_all)=b;']);
                eval([FlagVar,'.ChoiceNPD.ContrastRegSig(unit_all)=sig;']);

                for risk_i=1:3
                clear r0 X statsx
                risk_i0=risk_l(risk_i);
                r0=nanmean(Spike_BG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1,t_bg>0 & t_bg<500 ),2);
                X=InfoTrial.ContrastBG(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1);
                %statsx =regstats(r0,X);b=statsx.beta(2);sig=statsx.tstat.pval(2);
                %[b,sig]= MutualInfo_NM(r0,X,3,3);
                if sum(InfoTrial.DOpt(:,1)==risk_i0 &  InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1)>10
                eval([FlagVar,'.ChoiceNPD.ContrastRiskRegCoef(unit_all,risk_i)=b;']);
                eval([FlagVar,'.ChoiceNPD.ContrastRiskRegSig(unit_all,risk_i)=sig;']);
                else
                eval([FlagVar,'.ChoiceNPD.ContrastRiskRegCoef(unit_all,risk_i)=nan;']);
                eval([FlagVar,'.ChoiceNPD.ContrastRiskRegSig(unit_all,risk_i)=nan;']);           
                end
                end
                               
                
            end
            
        end
    end
    
 BG0=BG;
 TG0=TG;
 
 
end
save(Spikefile,'BG0','TG0','Unit_channel','-append');
%%

% 
% for ii=1:2
%     
%     
%     if ii==1
%         A.FC.ContrastRisk=BG.FC.ContrastRisk;
%         A.ChoicePD.ContrastRisk=BG.ChoicePD.ContrastRisk;
%         A.ChoiceNPD.ContrastRisk=BG.ChoiceNPD.ContrastRisk;
%         t_bg=-100:501;
%         
%     else
%         A.FC.ContrastRisk=TG.FC.ContrastRisk;
%         A.ChoicePD.ContrastRisk=TG.ChoicePD.ContrastRisk;
%         A.ChoiceNPD.ContrastRisk=TG.ChoiceNPD.ContrastRisk;
%         t_bg=-500:1001;
%         
%     end
%     
%     
%     a=squeeze(nanmean(TG.ChoicePD.ContrastRisk(:,:,:),1));
%     clim=[min(t_bg) max(t_bg) nanmin(a(:)) 1.5];
%     
%     Colors={'k','b','r'};
%     FlagTitle={'Low Risk','Medium Risk','High Risk'};
%     figure(ii*2-1)
%     for risk=1:3
%         subplot(3,3,risk)
%         for contrast=1:3
%             a=squeeze(nanmean(A.FC.ContrastRisk(:,(contrast*3-3)+risk,:),2));
%             plotstd(t_bg,a,char(Colors(contrast)))
%             axis(clim); box off;set(gca,'TickDir','out')
%             
%         end
%         title( FlagTitle(risk))
%         if risk==1
%             title(['Contrast' FlagTitle(risk)]);
%         end
%     end
%     
%     for risk=1:3
%         subplot(3,3,risk+3)
%         for contrast=1:3
%             a=squeeze(nanmean(A.ChoicePD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
%             plotstd(t_bg,a,char(Colors(contrast)))
%             axis(clim); box off;set(gca,'TickDir','out')
%             
%         end
%         title( FlagTitle(risk))
%     end
%     
%     
%     for risk=1:3
%         subplot(3,3,risk+6)
%         for contrast=1:3
%             a=squeeze(nanmean(A.ChoiceNPD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
%             plotstd(t_bg,a,char(Colors(contrast)))
%             axis(clim); box off;set(gca,'TickDir','out')
%             
%         end
%         title( FlagTitle(risk))
%     end
%     
%     
%     Colors={'k','g','m'};
%     
%     FlagTitle={'Low Contrast','Medium Contrast','High Contrast'};
%     figure(ii*2)
%     for contrast=1:3
%         subplot(3,3,contrast)
%         for risk=1:3
%             a=squeeze(nanmean(A.FC.ContrastRisk(:,(contrast*3-3)+risk,:),2));
%             plotstd(t_bg,a,char(Colors(risk)))
%             axis(clim); box off;set(gca,'TickDir','out')
%             
%         end
%         title( FlagTitle(contrast))
%         if risk==1
%             title(['Risk' FlagTitle(risk)]);
%         end
%     end
%     
%     for contrast=1:3
%         subplot(3,3,contrast+3)
%         for risk=1:3
%             a=squeeze(nanmean(A.ChoicePD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
%             plotstd(t_bg,a,char(Colors(risk)))
%             axis(clim); box off;set(gca,'TickDir','out')
%             
%         end
%         title( FlagTitle(contrast))
%     end
%     
%     
%     for contrast=1:3
%         subplot(3,3,contrast+6)
%         for risk=1:3
%             a=squeeze(nanmean(A.ChoiceNPD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
%             plotstd(t_bg,a,char(Colors(risk)))
%             axis(clim); box off;set(gca,'TickDir','out')
%             
%         end
%         title( FlagTitle(contrast))
%     end
%     
% end
% %%
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

