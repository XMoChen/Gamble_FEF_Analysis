 T_b=-100:501;
 
 Color={'k','g','b','r'};

 
for plot_n=1:4
    

         plot_i(:,1)=(9-(plot_n-1)*4):(12-(plot_n-1)*4);
if plot_n==4
    plot_i=[1,5,9;2,6,10;3,7,11;4,8,12];
end
      
figure(plot_n)
subplot(561)
for op=1:4
    plotstd( T_b,squeeze((nanmean(BG.FC.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
end
xlabel('Background Onset');
title(['Forced Choice  N=',num2str(sum(I_select))]);
axis([-100 600 -0.5 0.7]);box off;set(gca,'TickDir','out')

    subplot(563)
    for op=1:4
    plotstd( T_b,squeeze((nanmean(BG.ChoicePDChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
    end
xlabel('Background Onset');
title('Choice PD Chosen');
axis([-100 600 -0.5 0.7]);box off;set(gca,'TickDir','out')

 subplot(564)
     for op=1:4
    plotstd( T_b,squeeze((nanmean(BG.ChoicePDNChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
     end
xlabel('Background Onset');
title('Choice PD NonChosen');
axis([-100 600 -0.5 0.7]);box off;set(gca,'TickDir','out')

r0=squeeze(nanmean((nanmean(TG.FCPDV.ContrastRisk(I_select,[6,9],:),2)),1));
plmax=0.5;%max(r0(:))+0.2;
plmin=min(r0(:))-0.2;

T_t=-500:1001;

subplot(567)
     for op=1:4
   plotstd( T_t,squeeze((nanmean(TG.FCPDV.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
     end
xlabel('Target Onset');
title('Forced Choice PDV');
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(568)
     for op=1:4
   plotstd( T_t,squeeze((nanmean(TG.FCNPDV.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
     end
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
xlabel('Target Onset');
title('Forced Choice NPDV');

for op=2:4
subplot(5,6,8+op)
    plotstd( T_t,squeeze((nanmean(TG.ChoicePDChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
    plotstd( T_t,squeeze((nanmean(TG.ChoicePDNChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),'k');hold on;   

xlabel('Target Onset');
if op==2
title('Choice; PDrisk NPD=2 (PD color); PDChosen(color) vs PDNonChosen');
end
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
end

subplot(5,6,13)
     for op=2:4
   plotstd( T_t,squeeze((nanmean(TG.ChoicePDChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
     end
xlabel('Target Onset');
title('PD Chose PDV vs 2');
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(5,6,14)
     for op=2:4
   plotstd( T_t,squeeze((nanmean(TG.ChoiceNPDNChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
     end
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
xlabel('Target Onset');
title('PD Chose 2 vs NPDV');

for op=2:4
subplot(5,6,14+op)
    plotstd( T_t,squeeze((nanmean(TG.ChoiceNPDChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),'k');hold on;
    %%% 2 chosen
    plotstd( T_t,squeeze((nanmean(TG.ChoiceNPDNChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;   

xlabel('Target Onset');
if op==2
title('Choice; PDsafe PD=2 NPD color; PDChosen(color) vs PDNonChosen');
end
axis([-300 800 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
end
 


 T_r=-500:501;
 T_s=-500:501;

for period=1:2
 if period==1
     T_s0=T_s;
     Sac0=Sac;
     else
     T_s0=T_r;
     Sac0=Res;
 end
for op=1:4
subplot(5,6,19+ (period-1)*6)
plotstd( T_s0,squeeze((nanmean(Sac0.FCPDV.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
if period==1
xlabel('Saccade Onset');
else
xlabel('Result Onset');
end
title('Forced Choice PDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')


subplot(5,6,20+ (period-1)*6)
plotstd( T_s0,squeeze((nanmean(Sac0.FCNPDV.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
title('Forced Choice NPDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(5,6,21+ (period-1)*6)
plotstd( T_s0,squeeze((nanmean(Sac0.ChoicePDChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
title('Choice PD Chosen PDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(5,6,22+ (period-1)*6)
plotstd( T_s0,squeeze((nanmean(Sac0.ChoicePDNChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
title('Choice PD NonChosen PDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')

subplot(5,6,23+ (period-1)*6)
plotstd( T_s0,squeeze((nanmean(Sac0.ChoiceNPDChosen.ContrastRisk(I_select,plot_i(op,:),:),2))),char(Color(op)));hold on;
title('Choice NPD Chosen NPDV');
axis([-300 500 plmin-0.1 plmax+0.1]);box off;set(gca,'TickDir','out')
end
end

end