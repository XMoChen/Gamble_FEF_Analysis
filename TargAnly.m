function [FireAll,FireAll_C]=TargAnly (Eventfile,Spikefile,record)
load(Eventfile);
load(Spikefile);

clear PreferDI
if exist('InfoTrial')~=1
InfoTrial=TrialInfo;
end
if exist('SelectI')==1
I_select=SelectI;
else
 I_select=   InfoTrial.Reward>0;
end

%%
Neu_num=length(fieldnames(BackgroundRate));
names=fieldnames(TargetRate);
TF=find(contains(names,'Unit'));

SaccadeEndRate0=(struct2cell(TargetRate));
BackgroundRate0=(struct2cell(BackgroundRate));

clear SaccadeEndRate1
uu=0;
for nu=1:Neu_num
  
    clear a b
   eval(['a= SaccadeEndRate0{',num2str((nu)),'};'])   
   eval(['b= BackgroundRate0{',num2str(nu),'};'])  
%     a=b;
    a=a(I_select,:);
     b=b(I_select,:);
    b0=b(:,1:100);b1=nanmean(b0,2);b2=nanmean(a(:,300:1300),2);
   [h,p]=ttest2(b1(1:200), b1((end-199):end));
   [h,p2]=ttest2(b1, b2);
    if nanmean(a(:))>5 & p2<0.05%& p>0.0001
        uu=uu+1;
        SaccadeEndRate1(uu,:,:)= (a-(b1))/std(b1(:));
    
    targ_a= (a-b1)/std(b1(:));
    D1I=InfoTrial_valid.Targ2Opt==0 & (InfoTrial_valid.ChoiceD==1);
    D2I=InfoTrial_valid.Targ2Opt==0 & (InfoTrial_valid.ChoiceD==2);
    d1=nanmean(targ_a(D1I,350:500),2);
    d2=nanmean(targ_a(D2I,350:500),2);
    if ttest2(d1,d2)==1 & nanmean(d2)>nanmean(d1)
        PreferDI(uu,1)=2;PreferDI(uu,2)=1;
    else
        PreferDI(uu,1)=1;PreferDI(uu,2)=2;
    end
    Neu_I(nu)=1;
    else
    Neu_I(nu)=0;
    end
end
clear SaccadeEndRate0
% SaccadeEndRate1=SaccadeEndRate1(:,I_select,:);
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
Reg.Repeat=InfoTrial_valid.Repeat;
Reward1=InfoTrial_valid.Reward.*(InfoTrial_valid.ChoiceD==1);
Reward2=InfoTrial_valid.Reward.*(InfoTrial_valid.ChoiceD==2);

for tr=6:size(InfoTrial_valid,1)
   Reg.Reward1(1:5)=Reward1(tr-5:tr-1); 
   Reg.Reward2(1:5)=Reward2(tr-5:tr-1); 
end


for nu=1:size(PreferDI,1)
for contr=1:3
    for d=1:2
        u=0;
        for v=[2,12,11]
            u=u+1;
             
            clear II
            II= find(Reg.Repeat==0 & Reg.Contrast==contr & Reg.ChoiceD==PreferDI(nu,d) & Reg.ChoiceOpt==v & Reg.TrialType==0);
%             for i_l=1:(length(II)-1)
%                 if II(i_l+1)-II(i_l)>15
%                     i_sw=i_l;
%                 end
%             end
%             
%             if i_sw<10                
%                 II_1=[II(1:i_sw);II(i_sw)*ones(10,1)];
%             else
%             II_1=II(1:10);
%             end
%             II_10=II_1(1:10);
% 
%             
%             clear II0
%             if (length(II)-i_sw)<10
%                 II_2=[II((1+i_sw):end);II(end)*ones(10,1)];
%             else
%             II_2=II((1+i_sw):(10+i_sw));
%             end
%             II_20=II_2(1:10);
% 
%             clear II
%             II=[II_10;II_20];
            
            clear II_C
            II_C= find(Reg.Repeat==0 & Reg.Contrast==contr & Reg.ChoiceD==PreferDI(nu,d) & Reg.ChoiceOpt==v & Reg.TrialType==1);
%             if length(II)~=10
%                 II0_C=[II_C,II_C(randperm(length(II)))];
%                 II_C=II0_C(1:10);
%             end

           
            FireAll(contr,d,u,nu,1:30,:)=nan(30,size(SaccadeEndRate1,3));
            FireAll(contr,d,u,nu,1:length(II),:)=squeeze(SaccadeEndRate1(nu,II,:));
   
            FireAll_C(contr,d,u,nu,1:80,:)=nan(80,size(SaccadeEndRate1,3));
            if length(II_C)>0  
            FireAll_C(contr,d,u,nu,1:length(II_C),:)=squeeze(SaccadeEndRate1(nu,II_C,:));
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
fm=FireMean(:);fm=fm(~isnan(fm));
lim=[-600 1800 min(fm)*0.9 max(fm)*1.1];
t=-600:size(SaccadeEndRate1,3)-601;
figure(record)

subplot(341)
d_color={'k','r'};
%for d=1:2  
plot(t,squeeze(nanmean(nanmean(FireMean,1),3))); hold on;
%end
box off;set(gca,'TickDir','out')
legend({'Dir 1','Dir 2'});
title('Direction');
axis(lim); axis square 

subplot(343)
d_color={'k','r'};
plot(t,squeeze(nanmean(nanmean(FireMean_C,1),3))); hold on;
box off;set(gca,'TickDir','out')
legend({'Dir 1','Dir 2'});
title('Direction');
axis(lim); axis square 

con_color={'k','g','m'};
for d=1:2   
subplot(3,4,4+d)
plot(t,squeeze(nanmean(FireMean (:,d,:,:),3))); hold on;
box off;set(gca,'TickDir','out')
legend({'0','1','2'});
title('Contrast');
axis(lim); axis square 
end

con_color={'k','g','m'};
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
box off;set(gca,'TickDir','out')
legend({'low','med','high'});
title('Subjective Value');
axis(lim); axis square 
end

r_color={'k','b','r'};
for d=1:2   
subplot(3,4,10+d)
plot(t,squeeze(nanmean(FireMean_C (:,d,:,:),1))); hold on;
box off;set(gca,'TickDir','out')
legend({'low','med','high'});
title('Subjective Value');
axis(lim); axis square 
end
save(Spikefile,'PreferDI','Neu_I','-append');
%%
% figure(2)
% subplot(121)
% plot(t,squeeze(nanmean(nanmean(nanmean(nanmean(FireAll(:,:,:,:,1:3,:),1),2),4),5))');
% axis(lim); axis square 
% 
% subplot(122)
% plot(t,squeeze(nanmean(nanmean(nanmean(nanmean(FireAll(:,:,:,:,4:10,:),1),2),4),5))');
% axis(lim); axis square 

