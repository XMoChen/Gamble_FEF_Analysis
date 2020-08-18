function FireAll=SaccadeEndAnly (Eventfile,Spikefile,record)
load(Eventfile);
load(Spikefile);

if exist('SelectI')==1
I_select=SelectI;
else
 I_select=   InfoTrial.Reward>0;
end

%%
Neu_num=length(fieldnames(SaccadeEndRate));
SaccadeEndRate0=(struct2cell(SaccadeEndRate));
BackgroundRate0=(struct2cell(BackgroundRate));

clear SaccadeEndRate1
u=0;
for nu=1:Neu_num
    u=u+1;
    clear a
    eval(['a= SaccadeEndRate0{',num2str(nu),'};'])   
    eval(['b= BackgroundRate0{',num2str(nu),'};'])   
    a=a(I_select,:);
    b=b(I_select,:);
    b0=b(:,1:100);b1=nanmean(b0,2);
   [h,p]=ttest2(b1(1:100), b0((end-99):end))
    if  p>0.05
        SaccadeEndRate1(u,:,:)= (a-(b1(:)))/std(b0(:));
    end
end
clear SaccadeEndRate0
%SaccadeEndRate1=SaccadeEndRate1(:,I_select,:);
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

for tr=6:size(InfoTrial_valid,1)
   Reg.Reward1(1:5)=Reward1(tr-5:tr-1); 
   Reg.Reward2(1:5)=Reward2(tr-5:tr-1); 
end

for nu=1:size(SaccadeEndRate1,1)
for contr=1:3
    for d=1:2
        u=0;
        for v=[2,12,11]
            u=u+1;
            FireMean(contr,d,u,:)=squeeze(nanmean(nanmean(SaccadeEndRate1(:,Reg.Contrast==contr & Reg.ChoiceD==d & Reg.ChoiceOpt==v & Reg.TrialType==0,:),1),2));
            
            II= find(Reg.Contrast==contr & Reg.ChoiceD==d & Reg.ChoiceOpt==v & Reg.TrialType==0);

            II= find(Reg.Contrast==contr & Reg.ChoiceD==d & Reg.ChoiceOpt==v & Reg.TrialType==0);
%             if length(II)~=10
%                 II0=[II,II(randperm(length(II)))];
%                 II=II0(1:10);
%             end

            FireAll(contr,d,u,nu,1:30,:)=nan(30,size(SaccadeEndRate1,3));
            FireAll(contr,d,u,nu,1:length(II),:)=squeeze(SaccadeEndRate1(nu,II,:));

        end
    end
end
end
 FireAll=permute(FireAll,[4,1,2,3,5,6]);          
%%
lim=[-500 500 min(FireMean(:))*0.9 max(FireMean(:))*1.2];
t=-500:size(SaccadeEndRate1,3)-501;
figure(record)

subplot(321)
d_color={'k','r'}
%for d=1:2  
plot(t,squeeze(nanmean(nanmean(FireMean,1),3))); hold on;
%end
box off;set(gca,'TickDir','out')
legend({'Dir 1','Dir 2'});
title('Direction');
axis(lim); axis square 


con_color={'k','g','m'}
for d=1:2   
subplot(3,2,2+d)
plot(t,squeeze(nanmean(FireMean (:,d,:,:),3))); hold on;
box off;set(gca,'TickDir','out')
legend({'0','1','2'});
title('Contrast');
axis(lim); axis square 
end


r_color={'k','b','r'};
for d=1:2   
subplot(3,2,4+d)
plot(t,squeeze(nanmean(FireMean (:,d,:,:),1))); hold on;

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

