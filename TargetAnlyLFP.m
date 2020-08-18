function [FireAll,FireAll_C]=TargetAnlyLFP (Eventfile,LFPfile,record,Ch_num)
load(Eventfile);
load(LFPfile);

if exist('InfoTrial')~=1
InfoTrial=TrialInfo;
end
% if exist('SelectI')==1
% I_select=SelectI;
% else
%I_select=InfoTrial.ResultOn2>0;
I_select=InfoTrial.Reward>0;

% end

%%


clear TargetRate1
u=0;
for nu=1:Ch_num
    
    clear a bs
    eval(['a= LFP_Target_',num2str(nu),';'])   
    LFP_Result(nu,:,:)= a;    
    
end
clear TargetRate0
%TargetRate1=TargetRate1(:,I_select,:);
%%
Reg.Contrast=InfoTrial_valid.ContrastBG;
Reg.TrialType=InfoTrial_valid.Targ2Opt>0;

Reg.ChoiceD=InfoTrial_valid.ChoiceD;

Reg.Risk(InfoTrial_valid.ChoiceOpt==2)=0;
Reg.Risk(InfoTrial_valid.ChoiceOpt==12)=0.5;
Reg.Risk(InfoTrial_valid.ChoiceOpt==11)=1;
Reg.SubjV(InfoTrial_valid.ChoiceOpt==2)=SubjV(1)/SubjV(3);
Reg.SubjV(InfoTrial_valid.ChoiceOpt==12)=SubjV(2)/SubjV(3);
Reg.SubjV(InfoTrial_valid.ChoiceOpt==11)=SubjV(3)/SubjV(3);
Reg.ChoiceOpt=InfoTrial_valid.ChoiceOpt;
Reward1=InfoTrial_valid.Reward.*(InfoTrial_valid.ChoiceD==1);
Reward2=InfoTrial_valid.Reward.*(InfoTrial_valid.ChoiceD==2);
Reg.Repeat=InfoTrial_valid.Repeat;

for tr=6:size(InfoTrial_valid,1)
   Reg.Reward1(1:5)=Reward1(tr-5:tr-1); 
   Reg.Reward2(1:5)=Reward2(tr-5:tr-1); 
end


for nu=1:Ch_num
for contr=1:3
    for d=1:2
        u=0;
        for v=[2,12,11]
            u=u+1;
            
            
            clear II
            
              II= find(Reg.Contrast==contr & Reg.ChoiceD==d & Reg.ChoiceOpt==v & Reg.TrialType==0);
            clear II_C
            II_C= find(Reg.Repeat==0 & Reg.Contrast==contr & Reg.ChoiceD==1 & Reg.ChoiceOpt==v & Reg.TrialType==1);

            FireAll(contr,d,u,nu,1:30,:)=nan(30,size(LFP_Result,3));
            FireAll(contr,d,u,nu,1:length(II),:)=squeeze(LFP_Result(nu,II,:));
            FireAll_C(contr,d,u,nu,1:100,:)=nan(100,size(LFP_Result,3));
            if length(II_C)>0  
            FireAll_C(contr,d,u,nu,1:length(II_C),:)=squeeze(LFP_Result(nu,II_C,:));
            end
        end
    end
end
end
FireMean=squeeze(nanmean(nanmean(FireAll,4),5));
FireMean_C=squeeze(nanmean(nanmean(FireAll_C,4),5));

FireAll=permute(FireAll,[4,1,2,3,5,6]);     
FireAll_C=permute(FireAll_C,[4,1,2,3,5,6]);          
       

%%
lim=[-500 500 min(FireMean(:))*0.9 max(FireMean(:))*1.2];
t=-500:size(LFP_Result,3)-501;
figure(2*record)

subplot(341)
d_color={'k','r'}
%for d=1:2  
plot(t,squeeze(nanmean(nanmean(FireMean,1),3))); hold on;
%end
box off;set(gca,'TickDir','out')
legend({'Dir 1','Dir 2'});
title('Direction');
axis(lim); axis square 

subplot(343)
%for d=1:2  
plot(t,squeeze(nanmean(nanmean(FireMean_C,1),3))); hold on;
%end
box off;set(gca,'TickDir','out')
legend({'Dir 1','Dir 2'});
title('Direction');
axis(lim); axis square 

con_color={'k','g','m'}
for d=1:2   
subplot(3,4,4+d)
plot(t,squeeze(nanmean(FireMean (:,d,:,:),3))); hold on;
box off;set(gca,'TickDir','out')
legend({'0','1','2'});
title('Contrast');
axis(lim); axis square 
end

con_color={'k','g','m'}
for d=1:2   
subplot(3,4,6+d)
plot(t,squeeze(nanmean(FireMean_C (:,d,:,:),3))); hold on;
box off;set(gca,'TickDir','out')
legend({'0','1','2'});
title('Contrast');
axis(lim); axis square 
end


r_color={'k','b','r'};
for d=1:2   
subplot(3,4,8+d)
plot(t,squeeze(nanmean(FireMean (:,d,:,:),1))); hold on;

%plot(t,squeeze(nanmean(nanmean(FireMean,1),2))); hold on;
box off;set(gca,'TickDir','out')
legend({'low','med','high'});
title('Subjective Value');
axis(lim); axis square 
end

r_color={'k','b','r'};
for d=1:2   
subplot(3,4,10+d)
plot(t,squeeze(nanmean(FireMean_C (:,d,:,:),1))); hold on;

%plot(t,squeeze(nanmean(nanmean(FireMean,1),2))); hold on;
box off;set(gca,'TickDir','out')
legend({'low','med','high'});
title('Subjective Value');
axis(lim); axis square 
end
%%
% figure(2)
% subplot(121)
% plot(t,squeeze(nanmean(nanmean(nanmean(nanmean(FireAll(:,:,:,:,1:3,:),1),2),4),5))');
% axis(lim); axis square 
% 
% subplot(122)
% plot(t,squeeze(nanmean(nanmean(nanmean(nanmean(FireAll(:,:,:,:,4:10,:),1),2),4),5))');
% axis(lim); axis square 

