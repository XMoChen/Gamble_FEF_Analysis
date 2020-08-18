function  BehaviorAnalysis2018ProbV_Cooling(Eventfile,DirFig)
close all;
 load(Eventfile,'InfoTrial','InfoExp');


Filetag={'C','I'};
    
for iii=1:length(Filetag) 
 for i=2:size(InfoTrial,1)
     if InfoTrial.Repeat(i)==1 & InfoTrial.Result(i)>0 & InfoTrial.Reward(i)==0
        InfoTrial.Repeat(i)=1 ;
     else
         InfoTrial.Repeat(i)=0;
     end
 end
 save(Eventfile,'InfoTrial','-append');
 clear ContrastBG
% C1=(InfoTrial.Background<=6);
% ContrastBG(C1)=1;
% C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
% ContrastBG(C2)=2;
% C3=(InfoTrial.Background>12 );
% ContrastBG(C3)=3;
% ContrastBG=ContrastBG';
clear ContrastBG
if iii==1
    ContrastBG=InfoTrial.Temperature>30;
else
    ContrastBG=InfoTrial.Temperature<20;
end




for block=1: max(InfoTrial.Block)
    BG_block(block)=nanmean(ContrastBG(InfoTrial.Block==block));
end
 
 V=[InfoExp.RewardLeft;InfoExp.RewardRight;];
 V_BG=[V;BG_block];
 InfoTrial.SaccadeV(InfoTrial.SaccadeV>10000)=nan;
 Rt0=InfoTrial.SaccadeStart-InfoTrial.FixationOff;
 Rt0(Rt0<0)=nan;
 ProbBlock=nan(1, max(InfoTrial.Block));
 for vv=[21,22,23,24,25]
     I_sum1=ContrastBG>=1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==vv & InfoTrial.DOpt(:,2)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt~=0;
     I_choose1=ContrastBG>=1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==vv & InfoTrial.DOpt(:,2)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt==4;
     prob(vv-20,1)=sum(I_choose1)/sum(I_sum1);
     ProbBlock(find(V(1,:)==vv & V(2,:)==4 &  BG_block==2))=sum(I_choose1)/sum(I_sum1);

     
     I_choose1_s=ContrastBG>=1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==vv & InfoTrial.DOpt(:,2)==4 & InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceOpt==vv;
     Rt(vv-20,1)=nanmean(Rt0(I_choose1_s));
     SaccadeV(vv-20,1)=nanmean(InfoTrial.SaccadeV(I_choose1_s));
     RewardV(vv-20,1)=nanmean(InfoTrial.Reward(I_choose1_s));
    
     
     I_sum2=ContrastBG>=1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,2)==vv & InfoTrial.DOpt(:,1)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt~=0;
     I_choose2=ContrastBG>=1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,2)==vv & InfoTrial.DOpt(:,1)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt==4;
     prob(vv-20,2)=sum(I_choose2)/sum(I_sum2);
     
     I_choose2_s=ContrastBG>=1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,2)==vv & InfoTrial.DOpt(:,1)==4 & InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceOpt==vv;
     Rt(vv-20,2)=nanmean(Rt0(I_choose2_s));
     SaccadeV(vv-20,2)=nanmean(InfoTrial.SaccadeV(I_choose2_s));
     RewardV(vv-20,2)=nanmean(InfoTrial.Reward(I_choose2_s));
     ProbBlock(find(V(2,:)==vv & V(1,:)==4 &  BG_block==2))=sum(I_choose2)/sum(I_sum2);

 
 end
ProbBlock=1-ProbBlock;
 
 figure(1+iii*2-2)
 

 subplot(221)
 bar(1-prob);
 title('Probablity')
 subplot(222)
 bar(Rt);
 title('Reaction time (ms)')
 subplot(223)
 bar(SaccadeV);
 title('Saccade Velocity')

 subplot(224)
 bar(RewardV);
 title('Reward')
 
 if iii==1
     suptitle('Control');
 else
     suptitle('Inactivation');
 end  


  for vv=[21,22,23,24,25]
     I_sum1=ContrastBG==1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==vv & InfoTrial.DOpt(:,2)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt~=0;
     I_choose1=ContrastBG==1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==vv & InfoTrial.DOpt(:,2)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt==4;
     prob(vv-20,1)=sum(I_choose1)/sum(I_sum1);
     
     I_choose1_s=ContrastBG==1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==vv & InfoTrial.DOpt(:,2)==4 & InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceOpt==vv;
     Rt(vv-20,1)=nanmean(Rt0(I_choose1_s));
     SaccadeV(vv-20,1)=nanmean(InfoTrial.SaccadeV(I_choose1_s));
     RewardV(vv-20,1)=nanmean(InfoTrial.Reward(I_choose1_s));
     ProbBlock(find(V(1,:)==vv & V(2,:)==4 &  BG_block==1))=sum(I_choose1)/sum(I_sum1);

     
     I_sum2=ContrastBG==1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,2)==vv & InfoTrial.DOpt(:,1)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt~=0;
     I_choose2=ContrastBG==1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,2)==vv & InfoTrial.DOpt(:,1)==4 & InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt==4;
     prob(vv-20,2)=sum(I_choose2)/sum(I_sum2);
     
     I_choose2_s=ContrastBG==1 & InfoTrial.Reward>0 & InfoTrial.DOpt(:,2)==vv & InfoTrial.DOpt(:,1)==4 & InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceOpt==vv;
     Rt(vv-20,2)=nanmean(Rt0(I_choose2_s));
     SaccadeV(vv-20,2)=nanmean(InfoTrial.SaccadeV(I_choose2_s));
     RewardV(vv-20,2)=nanmean(InfoTrial.Reward(I_choose2_s));
     ProbBlock(find(V(2,:)==vv & V(1,:)==4 &  BG_block==1))=sum(I_choose1)/sum(I_sum1);

  end

 
%  figure(2+iii*3-3)
%  subplot(221)
%  bar(1-prob);
%  subplot(222)
%  bar(Rt);
%  subplot(223)
%  bar(SaccadeV);
%  subplot(224)
%  bar(RewardV);
%  
%  figure(3+iii*3-3)
%  plot(ProbBlock)
end
save(Eventfile,'ProbBlock','V_BG','-append');
% h10=figure(1);
% print( h10, '-djpeg', [DirFig,'BehaviorSum1']);
% print( h10, '-depsc', [DirFig,'BehaviorSum1']);
% h10=figure(2);
% print( h10, '-djpeg', [DirFig,'BehaviorSum2']);
% print( h10, '-depsc', [DirFig,'BehaviorSum2']);
% h10=figure(3);
% print( h10, '-djpeg', [DirFig,'BehaviorSum3']);
% print( h10, '-depsc', [DirFig,'BehaviorSum3']);
% h10=figure(4);
% print( h10, '-djpeg', [DirFig,'BehaviorSum4']);
% print( h10, '-depsc', [DirFig,'BehaviorSum4']);
% for trial=1:size(