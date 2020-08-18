close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','l_ts','UnitInfo')
load(Eventfile,'InfoTrial','InfoExp');

close all
 unit_all=0;
 t=-500:501;
for ch=1:Ch_num
    for unit=2:length(l_ts(ch,:)-1)
if l_ts(ch,unit)>1000
  unit_all=unit_all+1;   
  figure(unit_all)
  
  
  
  eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
  Spike_TG=Spike;
  eval(['Targ_dmax=UnitInfo.Ch',num2str(ch),'Unit',num2str(unit),'.TargPreferD;']);   

for g=1:2
    if g==1
        I_g=InfoTrial.GoNoGo~=5 & InfoTrial.GoNoGo>0;
    else
        I_g=InfoTrial.GoNoGo==5;
    end
    I_P=I_g & InfoTrial.DetectDirection==Targ_dmax & InfoTrial.PreferD==Targ_dmax & InfoTrial.Repeat==0;
    I_correct_P=I_P & InfoTrial.Reward>0;
    I_NP= I_g & InfoTrial.DetectDirection==Targ_dmax & InfoTrial.NPreferD==Targ_dmax & InfoTrial.Repeat==0;
    I_correct_NP=I_NP & InfoTrial.Reward>0;  
    I_O= I_g & InfoTrial.DetectDirection==Targ_dmax & InfoTrial.NPreferD~=Targ_dmax & InfoTrial.PreferD~=Targ_dmax & InfoTrial.Repeat==0;
    I_correct_O=I_O & InfoTrial.Reward>0;
 if g==1
subplot(221)
  plotstd(t,Spike(I_correct_P,:),'r');hold on;
  plotstd(t,Spike(I_correct_NP,:),'b');hold on;
  plotstd(t,Spike(I_correct_O,:),'k');hold on;
  
  subplot(223)
  plotstd(t,Spike(I_P,:),'r');hold on;
  plotstd(t,Spike(I_NP,:),'b');hold on;
  plotstd(t,Spike(I_O,:),'k');hold on;
 else
subplot(222)
  plotstd(t,Spike(I_correct_P,:),'r');hold on;
  plotstd(t,Spike(I_correct_NP,:),'b');hold on;
  plotstd(t,Spike(I_correct_O,:),'k');hold on;
  
    subplot(224)
  plotstd(t,Spike(I_P,:),'r');hold on;
  plotstd(t,Spike(I_NP,:),'b');hold on;
  plotstd(t,Spike(I_O,:),'k');hold on;
 end
end
end
    end
end