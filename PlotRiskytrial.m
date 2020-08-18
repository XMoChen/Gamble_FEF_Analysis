t_sac=-500:501;
t_result=-500:501;
t_targ=-500:1001;
t_bg=-100:501;

figure(5) 
Color={'k','b','r'};
   for contrast=1:3
  subplot(4,3,contrast)
  r0=squeeze(nanmean(BGAll.RiskPre(:,contrast,:),2));
  plotstd(t_bg,r0,'b');hold on;
  r0=squeeze(nanmean(BGAll.RiskNPre(:,contrast,:),2));
  plotstd(t_bg,r0,'k');
  
  subplot(4,3,contrast+3)
  r0=squeeze(nanmean(TGAll.RiskPre(:,contrast,:),2));
  plotstd(t_targ,r0,'b');hold on;
  r0=squeeze(nanmean(TGAll.RiskNPre(:,contrast,:),2));
  plotstd(t_targ,r0,'k');
  
  subplot(4,3,contrast+6)
  r0=squeeze(nanmean(SacAll.RiskPre(:,contrast,:),2));
  plotstd(t_sac,r0,'b');hold on;
  r0=squeeze(nanmean(SacAll.RiskNPre(:,contrast,:),2));
  plotstd(t_sac,r0,'k');
  
  subplot(4,3,contrast+9)
  r0=squeeze(nanmean(ResAll.RiskPre(:,contrast,:),2));
  plotstd(t_result,r0,'b');hold on;
  r0=squeeze(nanmean(ResAll.RiskNPre(:,contrast,:),2));
  plotstd(t_result,r0,'k');
   end
  
%   subplot(422)
%   r0=squeeze(BGAll.RiskNPre(:,contrast,:));
%   plotstd(t_bg,r0,char(Color(contrast)));
%   
%   subplot(423)
%   r0=squeeze((TGAll.RiskPre(:,contrast,:)));
%   plotstd(t_targ,r0,char(Color(contrast)));hold on;
%   subplot(424)  
%   ro=squeeze((TGAll.RiskNPre(:,contrast,:)));
%   plotstd(t_targ,r0,char(Color(contrast)));
%   
%   subplot(425)
%   plotstd(t_sac,squeeze((SacAll.RiskPre(:,contrast,:))),char(Color(contrast)));hold on;
%   subplot(426)
%   plotstd(t_sac,squeeze((SacAll.RiskNPre(:,contrast,:))),char(Color(contrast)));hold on;
%  
%   subplot(427)
%   plotstd(t_result,squeeze((ResAll.RiskPre(:,contrast,:))),char(Color(contrast)));hold on;
%   subplot(428)
%   plotstd(t_result,squeeze((ResAll.RiskNPre(:,contrast,:))),char(Color(contrast)));hold on;
%   end