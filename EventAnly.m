function [FireAll,FireAll_C,SpikeWaveSum]=EventAnly (EventName,Eventfile,Spikefile,record)
load(Eventfile);
load(Spikefile);

if exist('PreferDI2')==1
    PreferDI=PreferDI2;
    changeDI=0;
else
    changeDI=1;
end

if exist('InfoTrial')~=1
InfoTrial=TrialInfo;
end
I_select=InfoTrial.ResultOn>0;
InfoTrial_valid=InfoTrial(I_select,:);

%%
Neu_num=length(fieldnames(BackgroundRate));
names=fieldnames(TargetRate);
TF=find(contains(names,'Unit'));


if strcmp(EventName,'Result')==1
TargetRate0=(struct2cell(ResultRate));
elseif strcmp(EventName,'SaccadeEnd')==1
TargetRate0=(struct2cell(SaccadeEndRate));
elseif strcmp(EventName,'Saccade')==1
TargetRate0=(struct2cell(SaccadeRate));
elseif strcmp(EventName,'Target')==1
TargetRate0=(struct2cell(TargetRate));
elseif strcmp(EventName,'BackGround')==1
TargetRate0=(struct2cell(BackgroundRate));
end



BackgroundRate0=(struct2cell(BackgroundRate));
SpikeWave0=(struct2cell(SpikeWave));

clear TargetRate1
u=0;
for nu=1:Neu_num
    
    clear a bs
    eval(['a= TargetRate0{',num2str(nu),'};']) ;  
    eval(['b= BackgroundRate0{',num2str(nu),'};']) ; 
    
    a=a(I_select,:);
    b=b(I_select,:);
    b0=b(:,1:200);b1=nanmean(b0,2);
   [h,p]=ttest2(b1(1:200), b0((end-199):end));
    if Neu_I(nu)==1 
        u=u+1;
         b1std=nanstd(b1(:));
%         nanmean(b1(:))
%         if b1std<0.01
%             b1std=1;
%         end  
        if p<0.05
        TargetRate1(u,:,:)= (a-(b1(:)))/b1std;%(a-(b1(:)))/std(b1(:));
        TargetRate1(u,abs(b1-nanmean(b1))>2*nanstd(b1(:)),:)=nan;
        
        if strcmp(EventName,'BackGround')==1
          TargetRate1(u,:,:)= a;
          TargetRate1(u,abs(b1-nanmean(b1))>2*nanstd(b1(:)),:)=nan;
        end
        else
        TargetRate1(u,:,:)= (a-nanmean(b1(:)))/b1std;
        if strcmp(EventName,'BackGround')==1
          TargetRate1(u,:,:)= a;
        end
        end 
        eval(['SpikeWaveSum(',num2str(u),',:)=SpikeWave0{',num2str(nu),'};']);
    end
           
end

%I_select=I_select & (b1-nanmean(b1))<3*std(b1(:));

clear TargetRate0


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


for nu=1:size(PreferDI,1)
for contr=1:3
    for d=1:2
        u=0;
        for v=[2,12,11]
            u=u+1;
            
            
            clear II a0
            a0=squeeze(mean(TargetRate1(nu,:,:),3));
            II= find(isnan(a0')==0 & Reg.Repeat==0 & Reg.Contrast==contr & Reg.ChoiceD==PreferDI(nu,d) & Reg.ChoiceOpt==v & Reg.TrialType==0);

%             if length(II0)<15
%                 II0=[II0,II0(randperm(length(II0))),II0(randperm(length(II0))),II0(randperm(length(II0)))];
%                 II=II0(1:15);
%             end
            

%             % find block change
%             for i_l=1:(length(II)-1)
%                 if II(i_l+1)-II(i_l)>15
%                     i_sw=i_l;
%                 end
%             end
%             
%             if i_sw<7                
%                 II_1=[II(1:i_sw);II(i_sw)*ones(7,1)];
%             else
%             II_1=II(1:7);
%             end
%             II_10=II_1(1:7);
% 
%             
%             clear II0
%             if (length(II)-i_sw)<7
%                 II_2=[II((1+i_sw):end);II(end)*ones(7,1)];
%             else
%             II_2=II((1+i_sw):(7+i_sw));
%             end
%             II_20=II_2(1:7);
% 
%             clear II
%             II=[II_10;II_20];

                               
            clear II_C
            II_C= find(Reg.Repeat==0 & Reg.Contrast==contr & Reg.ChoiceD==PreferDI(nu,d) & Reg.ChoiceOpt==v & Reg.TrialType==1);
%             if length(II)~=10
%                 II0_C=[II_C,II_C(randperm(length(II)))];
%                 II_C=II0_C(1:10);
%             end

            FireAll(contr,d,u,nu,1:30,:)=nan(30,size(TargetRate1,3));
            FireAll(contr,d,u,nu,1:length(II),:)=squeeze(TargetRate1(nu,II,:));
%             FireAll(contr,d,u,nu,1:length(II),:)=squeeze(TargetRate1(nu,II,:));
            FireAll_C(contr,d,u,nu,1:100,:)=nan(100,size(TargetRate1,3));
            if length(II_C)>0  
            FireAll_C(contr,d,u,nu,1:length(II_C),:)=squeeze(TargetRate1(nu,II_C,:));
            end
        end
    end
end

PreferDI2=PreferDI;
if strcmp(EventName,'Target')==1
    t=-600:size(FireAll,6)-601;
    d1_mean=squeeze(nanmean(nanmean((nanmean(FireAll(:,1,:,nu,:,t>0 & t<500),6)),3),1));
    d2_mean=squeeze(nanmean(nanmean((nanmean(FireAll(:,2,:,nu,:,t>0 & t<500),6)),3),1));
if nanmean(d1_mean)<nanmean(d2_mean) %& ttest(d1_mean,d2_mean)==1
   
    clear m0s m0c
    m0s=FireAll(:,1,:,nu,:,:);
    m0c=FireAll_C(:,1,:,nu,:,:);
    FireAll(:,1,:,nu,:,:)=FireAll(:,2,:,nu,:,:);
    FireAll(:,2,:,nu,:,:)= m0s;
    FireAll_C(:,1,:,nu,:,:)=FireAll_C(:,2,:,nu,:,:);
    FireAll_C(:,2,:,nu,:,:)= m0c;
    PreferDI2(nu,1)=2-PreferDI(nu,1);
    PreferDI2(nu,2)=2-PreferDI(nu,2);    
end

    d1_mean=squeeze(nanmean(nanmean((nanmean(FireAll(:,1,:,nu,:,t>0 & t<500),6)),3),1));
    d2_mean=squeeze(nanmean(nanmean((nanmean(FireAll(:,2,:,nu,:,t>0 & t<500),6)),3),1));
%     [mean(d1_mean),mean(d2_mean)]
end

end

if strcmp(EventName,'Target')==1 & changeDI==1
save(Spikefile,'PreferDI2','-append');
end

FireMean=squeeze(nanmean(nanmean(FireAll,4),5));
FireMean_C=squeeze(nanmean(nanmean(FireAll_C,4),5));

FireAll=permute(FireAll,[4,1,2,3,5,6]);     
FireAll_C=permute(FireAll_C,[4,1,2,3,5,6]);          
       
min(FireMean(:))
%%
lim=[-500 300 min(FireMean(:))*0.9 max(FireMean(:))*1.2];
t=-500:size(TargetRate1,3)-501;
figure(2*record)

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

