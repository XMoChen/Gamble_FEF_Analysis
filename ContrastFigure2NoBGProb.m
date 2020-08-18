 T_b=-100:501;

figure(3)
subplot(461)
    plotstd( T_b,squeeze((nanmean(BG.FC.ContrastRisk(I_select,1,:),2))),'g');hold on;
    plotstd( T_b,squeeze((nanmean(BG.FC.ContrastRisk(I_select,2,:),2))),'b');hold on;
    plotstd( T_b,squeeze((nanmean(BG.FC.ContrastRisk(I_select,3,:),2))),'m');hold on;
    plotstd( T_b,squeeze((nanmean(BG.FC.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Background Onset');
title(['Forced Choice  N=',num2str(sum(I_select))]);
axis([-100 600 -0.5 0.5]);box off;set(gca,'TickDir','out')

    subplot(463)
    plotstd( T_b,squeeze((nanmean(BG.ChoicePD.ContrastRisk(I_select,1,:),2))),'g');hold on;
    plotstd( T_b,squeeze((nanmean(BG.ChoicePD.ContrastRisk(I_select,2,:),2))),'b');hold on;
    plotstd( T_b,squeeze((nanmean(BG.ChoicePD.ContrastRisk(I_select,3,:),2))),'m');hold on;
    plotstd( T_b,squeeze((nanmean(BG.ChoicePD.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Background Onset');
title('Choice PD Chosen');
axis([-100 600 -0.5 0.5]);box off;set(gca,'TickDir','out')

 subplot(464)
    plotstd( T_b,squeeze((nanmean(BG.ChoiceNPD.ContrastRisk(I_select,1,:),2))),'g');hold on;
    plotstd( T_b,squeeze((nanmean(BG.ChoiceNPD.ContrastRisk(I_select,2,:),2))),'b');hold on;
    plotstd( T_b,squeeze((nanmean(BG.ChoiceNPD.ContrastRisk(I_select,3,:),2))),'m');hold on;
    plotstd( T_b,squeeze((nanmean(BG.ChoiceNPD.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Background Onset');
title('Choice PD NonChosen');
axis([-100 600 -0.5 0.5]);box off;set(gca,'TickDir','out')

r0=squeeze(nanmean((nanmean(TG.FCPDV.ContrastRisk(I_select,[6,9],:),2)),1));
plmax=1;%max(r0(:))+0.2;
plmin=min(r0(:))-0.2;

T_t=-500:1001;

subplot(467)
   plotstd( T_t,squeeze((nanmean(TG.FCPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
    plotstd( T_t,squeeze((nanmean(TG.FCPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
    plotstd( T_t,squeeze((nanmean(TG.FCPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
    plotstd( T_t,squeeze((nanmean(TG.FCPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Target Onset');
title('Forced Choice PDV');
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(468)
   plotstd( T_t,squeeze((nanmean(TG.FCNPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
    plotstd( T_t,squeeze((nanmean(TG.FCNPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
    plotstd( T_t,squeeze((nanmean(TG.FCNPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
    plotstd( T_t,squeeze((nanmean(TG.FCNPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Target Onset');
title('Forced Choice NPDV');
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')


subplot(469)
    plotstd( T_t,squeeze((nanmean(TG.ChoicePD.ContrastRisk(I_select,1,:),2))),'g');hold on;
    plotstd( T_t,squeeze((nanmean(TG.ChoiceNPD.ContrastRisk(I_select,1,:),2))),'k');hold on;   
%     plotstd( T_t,squeeze((nanmean(TG.ChoicePD.ContrastRisk(:,[2,5,8],:),2))),'b');hold on;
%     plotstd( T_t,squeeze((nanmean(TG.ChoicePD.ContrastRisk(:,[3,6,9],:),2))),'r');hold on;
xlabel('Target Onset');
title('Choice PD Chosen PDV');
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

 subplot(4,6,10)
%     plotstd( T_t,squeeze((nanmean(TG.ChoiceNPD.ContrastRisk(:,[1,4,7],:),2))),'g');hold on;
    plotstd( T_t,squeeze((nanmean(TG.ChoicePD.ContrastRisk(I_select,2,:),2))),'b');hold on;
    plotstd( T_t,squeeze((nanmean(TG.ChoiceNPD.ContrastRisk(I_select,2,:),2))),'k');hold on;
 
 %   plotstd( T_t,squeeze((nanmean(TG.ChoiceNPD.ContrastRisk(:,[3,6,9],:),2))),'r');hold on;
xlabel('Target Onset');
title('Choice PD NonChosen PDV');
 axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
 
  subplot(4,6,11)
    plotstd( T_t,squeeze((nanmean(TG.ChoicePD.ContrastRisk(I_select,3,:),2))),'m');hold on;
    plotstd( T_t,squeeze((nanmean(TG.ChoiceNPD.ContrastRisk(I_select,3,:),2))),'k');hold on;
 xlabel('Target Onset');
title('Choice PD NonChosen PDV');
 axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

   subplot(4,6,12)
    plotstd( T_t,squeeze((nanmean(TG.ChoicePD.ContrastRisk(I_select,4,:),2))),'r');hold on;
    plotstd( T_t,squeeze((nanmean(TG.ChoiceNPD.ContrastRisk(I_select,4,:),2))),'k');hold on;
 xlabel('Target Onset');
title('Choice PD NonChosen PDV');
 axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
 
 T_s=-500:501;
subplot(4,6,13)
plotstd( T_s,squeeze((nanmean(Sac.FCPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_s,squeeze((nanmean(Sac.FCPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_s,squeeze((nanmean(Sac.FCPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_s,squeeze((nanmean(Sac.FCPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;

xlabel('Saccade Onset');
title('Forced Choice PDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(4,6,14)
plotstd( T_s,squeeze((nanmean(Sac.FCNPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_s,squeeze((nanmean(Sac.FCNPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_s,squeeze((nanmean(Sac.FCNPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_s,squeeze((nanmean(Sac.FCNPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;

xlabel('Saccade Onset');
title('Forced Choice NPDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')


subplot(4,6,15)
plotstd( T_s,squeeze((nanmean(Sac.ChoicePD.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoicePD.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoicePD.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoicePD.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Saccade Onset');
title('Choice PD Chosen PDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

 subplot(4,6,16)
 plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPD.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPD.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPD.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPD.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Saccade Onset');
title('Choice PD NonChosen PDV');
 axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
 
 
 subplot(4,6,17)
plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_s,squeeze((nanmean(Sac.ChoiceNPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Saccade Onset');
title('Choice PD NonChosen NPDV');
 axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

 
  T_r=-500:501;
subplot(4,6,19)
plotstd( T_r,squeeze((nanmean(Res.FCPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_r,squeeze((nanmean(Res.FCPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_r,squeeze((nanmean(Res.FCPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_r,squeeze((nanmean(Res.FCPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Result Onset');
title('Forced Choice PDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(4,6,20)
plotstd( T_r,squeeze((nanmean(Res.FCNPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_r,squeeze((nanmean(Res.FCNPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_r,squeeze((nanmean(Res.FCNPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_r,squeeze((nanmean(Res.FCNPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Result Onset');
title('Forced Choice NPDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')


subplot(4,6,21)
plotstd( T_r,squeeze((nanmean(Res.ChoicePD.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoicePD.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoicePD.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoicePD.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Result Onset');
title('Choice PD Chosen PDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

 subplot(4,6,22)
 plotstd( T_r,squeeze((nanmean(Res.ChoiceNPD.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoiceNPD.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoiceNPD.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoiceNPD.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Result Onset');
title('Choice PD NonChosen PDV');
 axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
 
 subplot(4,6,23)
 plotstd( T_r,squeeze((nanmean(Res.ChoiceNPDV.ContrastRisk(I_select,1,:),2))),'g');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoiceNPDV.ContrastRisk(I_select,2,:),2))),'b');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoiceNPDV.ContrastRisk(I_select,3,:),2))),'m');hold on;
plotstd( T_r,squeeze((nanmean(Res.ChoiceNPDV.ContrastRisk(I_select,4,:),2))),'r');hold on;
xlabel('Result Onset');
title('Choice PD NonChosen  NPDV');
 axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')