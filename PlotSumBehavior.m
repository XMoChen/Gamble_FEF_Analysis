%%
%load('BehaviorSum.mat','Choice_All','Theta_All','Logi','SubjV_all');
Flag={'Monkey O','Monkey J','All'};
figure(20)
for fi=1:3
    if fi==1
        I=1:11;%1:6;
    elseif fi==2
        I=11:22;%7:11;
    else
        I=1:22;%1:11;
    end
subplot(3,3,fi)   
Ch_Perc=squeeze(nanmean(Choice_All(I,:,:),1));
Ch_Perc_std=squeeze(nanstd(Choice_All(I,:,:),1))/sqrt(length(I)-1);
errorbarplot(Ch_Perc',Ch_Perc_std');
box off;set(gca,'TickDir','out');
title(char(Flag(fi)));
if fi==1
legend({'Left','Right'});
end
sum(Ch_Perc(:))


subplot(3,3,fi+3)   
Ch_Perc=squeeze(nanmean(Theta_All(I,11:13),1));
Ch_Perc_std=squeeze(nanstd(Theta_All(I,11:13),1))/sqrt(length(I)-1);
bar(Ch_Perc,0.3);hold on;errorbar(1:3,Ch_Perc,Ch_Perc_std,'.k');
axis([0 4 -4 4]);
box off;set(gca,'TickDir','out')

subplot(3,3,fi+6)   
Ch_Perc=squeeze(nanmean(Theta_All(I,1:10),1));
Ch_Perc_std=squeeze(nanstd(Theta_All(I,1:10),1))/sqrt(length(I)-1);
x=-10:1:-1;
plot(x,flip(Ch_Perc),'k');hold on;errorbar(x,flip(Ch_Perc),flip(Ch_Perc_std),'.k');
axis([-11 0 -0.5 2.5]);
box off;set(gca,'TickDir','out')

end

figure(21)
subplot(221)
for i=22:-1:1
x=0:0.1:10;
if i<11%5
plot(x,power(x,Logi(i,1)),'b');hold on
else
plot(x,power(x,Logi(i,1)),'r');hold on
end    
end
plot(0:12,0:12,'k:');
box off;set(gca,'TickDir','out')
axis([0 6 0 6])
axis square
subplot(222)
bar(1:3,nanmean(SubjV_all(1:11,:),1),0.3);hold on;
errorbar(1:3,nanmean(SubjV_all(1:11,:),1),nanstd(SubjV_all(1:11,:),[],1)/sqrt(11-1),'.k');
axis square; box off;set(gca,'TickDir','out');
title('Monkey O');
subplot(224)
bar(1:3,nanmean(SubjV_all(12:22,:),1),0.3);hold on;
errorbar(1:3,nanmean(SubjV_all(12:22,:),1),nanstd(SubjV_all(12:22,:),[],1)/sqrt(11-1),'.k');
axis square
box off;set(gca,'TickDir','out')
title('Monkey J');
subplot(223)
bar(1:3,nanmean(SubjV_all(:,:),1),0.3);hold on;
errorbar(1:3,nanmean(SubjV_all(:,:),1),nanstd(SubjV_all(12:22,:),[],1)/sqrt(11-1),'.k');
axis square
box off;set(gca,'TickDir','out')
title('All');

%%
figure(22)
fun=@(x,xdata) x(1)*exp(x(2)*(x(3)+xdata));
xdata1=-10:1:-1;
xdata0=-10:0.1:-1;
x0=[1 0.5 0];
b1=lsqcurvefit(fun,x0,xdata1,flip(theta(1:10)));
plot(xdata0, fun(b1,xdata0),'k');hold on;
RewardHis=b1;
subplot(221)  
Ch_Perc=squeeze(nanmean(Theta_All(1:11,1:10),1));
b1=lsqcurvefit(fun,x0,xdata1,flip(Ch_Perc));
Ch_Perc_std=squeeze(nanstd(Theta_All(1:11,1:10),1))/sqrt(length(I)-1);
x=-10:1:-1;
plot(x,flip(Ch_Perc),'k.');hold on;errorbar(x,flip(Ch_Perc),flip(Ch_Perc_std),'.k'); hold on;
plot(xdata0, fun(b1,xdata0),'k');hold on;
axis([-11 0 -0.5 2.5]);
box off;set(gca,'TickDir','out')

Ch_Perc=squeeze(nanmean(Theta_All(12:22,1:10),1));
b1=lsqcurvefit(fun,x0,xdata1,flip(Ch_Perc));
Ch_Perc_std=squeeze(nanstd(Theta_All(12:22,1:10),1))/sqrt(length(I)-1);
x=-10:1:-1;
plot(x,flip(Ch_Perc),'b.');hold on;errorbar(x,flip(Ch_Perc),flip(Ch_Perc_std),'.b');
plot(xdata0, fun(b1,xdata0),'b');hold on;
axis([-11 0 -0.5 2.5]);
axis square
box off;set(gca,'TickDir','out')

subplot(222)  
Ch_Perc=squeeze(nanmean(Theta_All(I,11:13),1));
Ch_Perc_std=squeeze(nanstd(Theta_All(I,11:13),1))/sqrt(length(I)-1);
a=[squeeze(nanmean(Theta_All(1:11,11:13),1));squeeze(nanmean(Theta_All(12:22,11:13),1))]';
b=[squeeze(nanstd(Theta_All(1:11,11:13),1));squeeze(nanstd(Theta_All(12:22,11:13),1))]'/sqrt(length(I)-1);
errorbarplot(a,b,0.8);axis([0.5 3.5 -0.2 4]);
axis square
box off;set(gca,'TickDir','out')
legend({'Monkey O','Monkey J'});

subplot(223)
for i=22:-1:1
x=0:0.1:10;
if i<11%5
plot(x,power(x,Logi(i,1)),'b');hold on
else
plot(x,power(x,Logi(i,1)),'r');hold on
end    
end
plot(0:12,0:12,'k:');
box off;set(gca,'TickDir','out')
axis([0 6 0 6])
axis square

subplot(224)
a=[nanmean(SubjV_all(1:11,:),1);nanmean(SubjV_all(12:22,:),1)]';
b=[nanstd(SubjV_all(1:11,:),1);nanstd(SubjV_all(12:22,:),1)]'/sqrt(11-1);
errorbarplot(a,b,0.8);
axis square
box off;set(gca,'TickDir','out')
legend({'Monkey O','Monkey J'});


mean(Logi(1:11,1),1)
[~,p]=ttest(Logi(1:11,1)-1)

mean(Logi(12:22,1),1)
[~,p]=ttest(Logi(12:22,1)-1)
%%
Behavior2=(Behavior(:,1:5)+Behavior(:,6:10))/2;
figure(23)
m=nanmean(Behavior2(1:11,:),1);
m_std=nanstd(Behavior2(1:11,:),1)/sqrt(size(Behavior2(1:11,:),1)-1);
bar([1,2,4,5,7],m([1,5,2,4,3]),0.5);hold on;
errorbar([1,2,4,5,7],m([1,5,2,4,3]),m_std([1,5,2,4,3]),'k.');
box off;set(gca,'TickDir','out')

figure(24)
m=nanmean(Behavior2(12:end,:),1);
m_std=nanstd(Behavior2(12:end,:),1)/sqrt(size(Behavior2(12:end,:),1)-1);
bar([1,2,4,5,7],m([1,5,2,4,3]),0.5);hold on;
errorbar([1,2,4,5,7],m([1,5,2,4,3]),m_std([1,5,2,4,3]),'k.');
box off;set(gca,'TickDir','out')

MonkeyO=11;
Y=[Behavior2(1:MonkeyO,1);Behavior2(1:MonkeyO,5);Behavior2(1:MonkeyO,2);Behavior2(1:MonkeyO,4)];
S=[1:MonkeyO,1:MonkeyO,1:MonkeyO,1:MonkeyO]';
F1=[ones(MonkeyO*2,1);2*ones(MonkeyO*2,1)];
F2=[ones(MonkeyO,1);2*ones(MonkeyO,1);ones(MonkeyO,1);2*ones(MonkeyO,1)];
stats1 = rm_anova2(Y,S,F1,F2,{'Risk','Reward'});

MonkeyJ=11;
Y=[Behavior2((MonkeyO+1):end,1);Behavior2((MonkeyO+1):end,5);Behavior2((MonkeyO+1):end,2);Behavior2((MonkeyO+1):end,4)];
S=[1:MonkeyJ,1:MonkeyJ,1:MonkeyJ,1:MonkeyJ]';
F1=[ones(MonkeyJ*2,1);2*ones(MonkeyJ*2,1)];
F2=[ones(MonkeyJ,1);2*ones(MonkeyJ,1);ones(MonkeyJ,1);2*ones(MonkeyJ,1)];
stats2 = rm_anova2(Y,S,F1,F2,{'Risk','Reward'});