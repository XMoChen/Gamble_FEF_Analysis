clear all
close all
RootDir='D:\Projects\GambleMIB';


% %%% records Prob
% Date={'G050717','G050417','G050217','G042817','G042717','G042617'};
% Files={'G050717','G050417','G050217','G042817','G042717','G042617'};
% ChNum=[24,24,24,24,24,24];
% Name='ProbabilityFEF';


% new V4 recording
% Date={'G082017','G082617','G082817','G090117','G103017','G103117'}
% Files={'G082017','G082617','G082817','G090117','G103017','G103117'};
% ChNum=[16,16,16,16,16,15];
% Name='MeanspreadV4';


% % % %%% new recording  FEF
%%%'G073017','G080117','G080417','G080817',
% Date={'G080817','G083017'}
% Files={'G080817','G083017'};
% ChNum=[32,32]
% Name='MeanspreadFEF';
Date={'G073017','G080117','G080417','G080817','G083017'}
Files={'G073017','G080117','G080417','G080817','G083017'};
ChNum=[16,16,24,32,32]
Name='MeanspreadFEF';


addpath('D:\Projects\GambleMIB\Gamble\');
DirFig='D:\Projects\GambleMIB\figures\Sum\';
    Flag={'FC.ContrastRisk','FCPDV.ContrastRisk','FCNPDV.ContrastRisk','ChoicePDChosen.ContrastRisk','ChoicePDNChosen.ContrastRisk','ChoiceNPDChosen.ContrastRisk','ChoiceNPDNChosen.ContrastRisk','RiskPre','RiskNPre'...
           'FC.ContrastRisk','ChoicePD.ContrastRisk','ChoiceNPD.ContrastRisk','FC.Contrast','ChoicePD.Contrast','ChoiceNPD.Contrast'};
    

 Unit_channel_all=[];
        for ii=1:7
            eval(['BGAll.',char(Flag(ii)),'=[];']);
            eval(['TGAll.',char(Flag(ii)),'=[];']);
            eval(['SacAll.',char(Flag(ii)),'=[];']);
            eval(['ResAll.',char(Flag(ii)),'=[];']);
            
        end


for record=5%[length(Date)]%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\',char(Date(record)),'\'];
    %   Dir=[RootDir,'\sGDRecordings\OzzyTraining\',char(Date(record)),'\'];
    
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
%      ContrastRiskOrgRaw(Spikefile,Eventfile,Ch_num);  % raw without substract the baseline
%        ContrastRiskOrg(Spikefile,Eventfile,Ch_num);   % BG0 & TG0   fixation as baseline
%      ContrastRiskOrg2(Spikefile,Eventfile,Ch_num);   % BG & TG    before visual input as baseline

       
       
    %BehaviorAnalysis2017(Eventfile,DirFig);   
 %   ContrastRiskOrgProb(Spikefile,Eventfile,Ch_num);   % BG0 & TG0   fixation as baseline

    clear TG BG;
    load(Spikefile,'TG','BG','Sac','Res','Unit_channel')
    
    if record==1    
    Unit_channel_all=Unit_channel;
    else
    Unit_channel_all=[Unit_channel_all;Unit_channel];
    end



        for ii=1:7
            
            eval(['BGAll.',char(Flag(ii)),'=cat(1,BGAll.',char(Flag(ii)),',BG.',char(Flag(ii)),');']);
            eval(['TGAll.',char(Flag(ii)),'=cat(1,TGAll.',char(Flag(ii)),',TG.',char(Flag(ii)),');']);
            eval(['SacAll.',char(Flag(ii)),'=cat(1,SacAll.',char(Flag(ii)),',Sac.',char(Flag(ii)),');']);
            eval(['ResAll.',char(Flag(ii)),'=cat(1,ResAll.',char(Flag(ii)),',Res.',char(Flag(ii)),');']);
            
        end
%         for ii=7:9
%             
%             eval(['BGAll',num2str(con),'.',char(Flag(ii)),'MI=cat(1,BGAll',num2str(con),'.',char(Flag(ii)),'MI,BG.',char(Flag(ii)),'MI);']);
%             eval(['TGAll',num2str(con),'.',char(Flag(ii)),'MI=cat(1,TGAll',num2str(con),'.',char(Flag(ii)),'MI,TG.',char(Flag(ii)),'MI);']);
%             eval(['BGAll',num2str(con),'.',char(Flag(ii)),'MISig=cat(1,BGAll',num2str(con),'.',char(Flag(ii)),'MISig,BG.',char(Flag(ii)),'MISig);']);
%             eval(['TGAll',num2str(con),'.',char(Flag(ii)),'MISig=cat(1,TGAll',num2str(con),'.',char(Flag(ii)),'MISig,TG.',char(Flag(ii)),'MISig);']);
%             
%         end
%         
%         for ii=10:12
%             eval(['BGAll',num2str(con),'.',char(Flag(ii)),'MI=[BGAll',num2str(con),'.',char(Flag(ii)),'MI,BG.',char(Flag(ii)),'MI];']);
%             eval(['TGAll',num2str(con),'.',char(Flag(ii)),'MI=[TGAll',num2str(con),'.',char(Flag(ii)),'MI,TG.',char(Flag(ii)),'MI];']);
%             eval(['BGAll',num2str(con),'.',char(Flag(ii)),'MISig=[BGAll',num2str(con),'.',char(Flag(ii)),'MISig,BG.',char(Flag(ii)),'MISig];']);
%             eval(['TGAll',num2str(con),'.',char(Flag(ii)),'MISig=[TGAll',num2str(con),'.',char(Flag(ii)),'MISig,TG.',char(Flag(ii)),'MISig];']);
%         end
   
   
end



%%
close all
I_select= Unit_channel_all(:,3)>=0;
BG=BGAll;
TG=TGAll;
Sac=SacAll;
Res=ResAll;
% ContrastFigure1;
% ContrastFigure2NoBG;

%%%% for probability modulations
% ContrastFigure1Prob;
% PlotRiskytrial;
DirFig='D:\Projects\GambleMIB\figures\Sum\';

%%%% for reward magnitude
ContrastFigure1_2;
RiskandContrastPlot;

% for f=1:4
% h10=figure(f);
% h10.Renderer='Painters';
% 
% saveas( h10, [DirFig,Name,num2str(f)],'svg');
% 
% % print( h10, '-djpeg', [DirFig,Name,num2str(f)]);
% % print( h10, '-dpdf','-fillpage',[DirFig,Name,num2str(f)]);
% end
 
% PlotRiskytrial;
% for ii=1:2
%     
%     if ii==1
%         A.FCPDV.ContrastRisk=BGAll.FC.ContrastRisk;
%         A.FCNPDV.ContrastRisk=BGAll.FCNPDV.ContrastRisk;
%         A.FCSumV.ContrastRisk=BGAll.FCSumV.ContrastRisk;
%         t_bg=-100:501;
%         
%     else
%         A.FCPDV.ContrastRisk=TGAll.FCPDV.ContrastRisk;
%         A.FCNPDV.ContrastRisk=TGAll.FCNPDV.ContrastRisk;
%         A.FCSumV.ContrastRisk=TGAll.FCSumV.ContrastRisk;
%         t_bg=-500:1001;
%         
%     end
%     
%     
%     a=squeeze(nanmean(TGAll.ChoicePD.ContrastRisk(:,:,:),1));
%     clim=[min(t_bg) max(t_bg) nanmin(a(:))-0.2 1.5];
%     
%     Colors={'k','b','r'};
%     FlagTitle={'Low Risk','Medium Risk','High Risk'};
%     
%     figure(6+ii)
%     for risk=1:3
%         subplot(3,3,risk)
%         for contrast=1:3
%             a=squeeze(nanmean(A.FCPDV.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
%             a=squeeze(nanmean(A.FCNPDV.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
%         subplot(3,3,risk+6)
%         for contrast=1:3
%             a=squeeze(nanmean(A.FCSumV.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
% end
% 
% 
% for ii=1:2
%     
%     
%     if ii==1
%         A.FC.ContrastRisk=BGAll.FC.ContrastRisk;
%         A.ChoicePD.ContrastRisk=BGAll.ChoicePD.ContrastRisk;
%         A.ChoiceNPD.ContrastRisk=BGAll.ChoiceNPD.ContrastRisk;
%         t_bg=-100:501;
%         
%     else
%         A.FC.ContrastRisk=TGAll.FC.ContrastRisk;
%         A.ChoicePD.ContrastRisk=TGAll.ChoicePD.ContrastRisk;
%         A.ChoiceNPD.ContrastRisk=TGAll.ChoiceNPD.ContrastRisk;
%         t_bg=-500:1001;
%         
%     end
%     
%     
%     a=squeeze(nanmean(TGAll.ChoicePD.ContrastRisk(I_select,:,:),1));
%     clim=[min(t_bg) max(t_bg) nanmin(a(:))-0.2 1.5];
%     
%     Colors={'k','b','r'};
%     FlagTitle={'Low Risk','Medium Risk','High Risk'};
%     figure(ii*2-1)
%     for risk=1:3
%         subplot(3,3,risk)
%         for contrast=1:3
%             a=squeeze(nanmean(A.FC.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
%             a=squeeze(nanmean(A.ChoicePD.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
%             a=squeeze(nanmean(A.ChoiceNPD.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
%             a=squeeze(nanmean(A.FC.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
%             a=squeeze(nanmean(A.ChoicePD.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
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
%             a=squeeze(nanmean(A.ChoiceNPD.ContrastRisk(I_select,(contrast*3-3)+risk,:),2));
%             plotstd(t_bg,a,char(Colors(risk)))
%             axis(clim); box off;set(gca,'TickDir','out')
%             
%         end
%         title( FlagTitle(contrast))
%     end
%     
% end
% 
% 
% 
% xl_flag={'Low_r','Med_r','High_r'};
% Flag={'FC.ContrastRisk','ChoicePD.ContrastRisk','ChoiceNPD.ContrastRisk'};
% 
% figure(5)
% for ii=1:3
%     subplot(3,2,ii*2-1)
%     clear a aSig
%     eval(['a=BGAll.',char(Flag(ii)),'MI;']);
%     subplot(3,2,ii*2-1)
%     % a(aSig>0.05)=nan;
%     bar(nanmean(a(I_select,:)),0.4);hold on;
%     errorbar(nanmean(a(I_select,:)),nanstderror(a(I_select,:),1)','k.');
%     axis([ 0 4 0 0.2]);
%     set(gca,'XTickLabel',xl_flag);
%     axis square;box off;set(gca,'TickDir','out')
%     
%     clear a
%     eval(['a=TGAll.',char(Flag(ii)),'MI;']);
%     % a(aSig>0.05)=nan;
%     subplot(3,2,ii*2)
%     bar(nanmean(a(I_select,:)),0.4);hold on;
%     errorbar(nanmean(a(I_select,:)),nanstderror(a(I_select,:),1)','k.');
%     axis([ 0 4 0 0.2]);
%     set(gca,'XTickLabel',xl_flag);
%     axis square;box off;set(gca,'TickDir','out')
%     
% end
% 
% %%
% figure(6)
% subplot(121)
% a=[BGAll.FC.ContrastClassify;BGAll.ChoicePD.ContrastClassify;BGAll.ChoiceNPD.ContrastClassify]';
% bar(nanmean(a),0.4);hold on;
% errorbar(nanmean(a),nanstderror(a,1)','k.');
% 
% subplot(122)
% a=[TGAll.FC.ContrastClassify;TGAll.ChoicePD.ContrastClassify;TGAll.ChoiceNPD.ContrastClassify]';
% bar(nanmean(a),0.4);hold on;
% errorbar(nanmean(a),nanstderror(a,1)','k.');
% 
