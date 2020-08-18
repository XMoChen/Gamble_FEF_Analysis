%function  BehaviorAnalysis2017(Eventfile,DirFig)
load(Eventfile,'InfoTrial','InfoExp');

GOpt=unique(InfoExp.Gamble_block);
SOpt=unique(InfoExp.Sure_block);

% gi=0;
% for g=GOpt
%     gi=gi+1;
%     si=0;
%     for s=SOpt
%        si=si+1; 
%         I=(InfoExp.Gamble_block==g & InfoExp.Sure_block==s);
%         Choice(gi,si)=mean(
for tr=2:size(InfoTrial.PreferD,1)
    if InfoTrial.PreferD(tr)<3
    NPreferD(tr)=3-InfoTrial.PreferD(tr);
    else
    NPreferD(tr)=7-InfoTrial.PreferD(tr);
    end  
    if InfoTrial.Targ2Opt(tr-1)>-1
    Valid_ID(tr)=1;
    end
end
InfoTrial.NPreferD=NPreferD';
for d=1:4
    I_P=Valid_ID'==1 & InfoTrial.DetectDirection==d & InfoTrial.PreferD==d & InfoTrial.Repeat==0;
    I_correct_P=I_P & InfoTrial.Reward>0;
    I_NP=Valid_ID'==1 &  InfoTrial.DetectDirection==d & InfoTrial.NPreferD==d & InfoTrial.Repeat==0;
    I_correct_NP=I_NP & InfoTrial.Reward>0;  
    I_O=Valid_ID'==1 & InfoTrial.DetectDirection==d & InfoTrial.NPreferD~=d & InfoTrial.PreferD~=d & InfoTrial.Repeat==0;
    I_correct_O=I_O & InfoTrial.Reward>0;

    Correct(d,1)=sum(I_correct_P)/sum(I_P);
    Correct(d,2)=sum(I_correct_NP)/sum(I_NP);
    Correct(d,3)=sum(I_correct_O)/sum(I_O);    
end
%%
for dif=1:2
        clear I_*

    if dif==1
        I_d=InfoTrial.GarborTime<=0.2;
    else
        I_d=InfoTrial.GarborTime>0.2;
    end

for g=1:2
    if g==1
        I_g=InfoTrial.GoNoGo~=5 & InfoTrial.GoNoGo>0;
    else
        I_g=InfoTrial.GoNoGo==5;
    end
    I_P=I_d & I_g & Valid_ID'==1  & InfoTrial.PreferD==InfoTrial.DetectDirection & InfoTrial.Repeat==0;
    I_correct_P=I_P & InfoTrial.Reward>0;
    I_NP=I_d & I_g & Valid_ID'==1  & InfoTrial.NPreferD==InfoTrial.DetectDirection & InfoTrial.Repeat==0;
    I_correct_NP=I_NP & InfoTrial.Reward>0;  
    I_O=I_d & I_g & Valid_ID'==1 & InfoTrial.NPreferD~=InfoTrial.DetectDirection & InfoTrial.PreferD~=InfoTrial.DetectDirection & InfoTrial.Repeat==0;
    I_correct_O=I_O & InfoTrial.Reward>0;

    Correct2(1,g,dif)=sum(I_correct_P)/sum(I_P);
    Correct2(2,g,dif)=sum(I_correct_NP)/sum(I_NP);
    Correct2(3,g,dif)=sum(I_correct_O)/sum(I_O);  
    NumberCorrect(1,g,dif)=sum(I_correct_P);
    NumberCorrect(2,g,dif)=sum(I_correct_NP);
    NumberCorrect(3,g,dif)=sum(I_correct_O);
    NumberAll(1,g,dif)=sum(I_P);
    NumberAll(2,g,dif)=sum(I_NP);
    NumberAll(3,g,dif)=sum(I_O);
end
end
DitectionRate=Correct2;
save(Eventfile,'DitectionRate','NumberCorrect','NumberAll','InfoTrial','-append');

%%
%%% instananeous choice
ID_Choice=InfoTrial.Targ2Opt~=0 & InfoTrial.ChoiceOpt>0 & InfoTrial.ResultOn>0;
I_Choice=InfoTrial.ChoiceOpt(ID_Choice);
Gamble_Index=I_Choice>10;
Sure_Index=I_Choice<10 & I_Choice>0;
sigma=6;
kernel=HalfGaussian(sigma);
Gamble_Index_Ins=convn(Gamble_Index',kernel,'same')';
Sure_Index_Ins=convn(Sure_Index',kernel,'same')';
Gamble_Perc=Gamble_Index_Ins./(Sure_Index_Ins);
Sure_Perc=Sure_Index_Ins./(Gamble_Index_Ins);

GamblePerc=zeros(size(InfoTrial,1),1);
GamblePerc(ID_Choice,1)=atan(Gamble_Perc')*180/pi;
InfoTrial.GamblePerc=GamblePerc;

SurePerc=zeros(size(InfoTrial,1),1);
SurePerc(ID_Choice,1)=atan(Sure_Perc')*180/pi;
InfoTrial.SurePerc=SurePerc;


%%% instananeous reward ratio
Sure_Result=InfoTrial.Result(ID_Choice);
Sure_Result(Gamble_Index)=0;
Gamble_Result=InfoTrial.Result(ID_Choice);
Gamble_Result(Sure_Index)=0;

RGamble_Ins=convn(Gamble_Result',kernel,'same')';
RSure_Ins=convn(Sure_Result',kernel,'same')';
%%%% instant reward on choice trial with no-choice trial
RGamble_Perc=RGamble_Ins./(RSure_Ins);
RSure_Perc=RSure_Ins./RGamble_Ins;

RGamblePerc=zeros(size(InfoTrial,1),1);
RGamblePerc(ID_Choice,1)=atan(RGamble_Perc')*180/pi;
InfoTrial.RGamblePerc=RGamblePerc;

RSurePerc=zeros(size(InfoTrial,1),1);
RSurePerc(ID_Choice,1)=atan(RSure_Perc')*180/pi;
InfoTrial.RSurePerc=RSurePerc;

for trial=1:size(InfoTrial,1)
    if InfoTrial.ChoiceOpt(trial)>10
        ChosenPerc(trial)=InfoTrial.GamblePerc(trial)+100;
        RewardPerc(trial)=InfoTrial.RGamblePerc(trial)+100;

    else
        ChosenPerc(trial)=InfoTrial.SurePerc(trial);
        RewardPerc(trial)=InfoTrial.RSurePerc(trial);

    end   
end
InfoTrial.ChosenPerc=ChosenPerc';
InfoTrial.RewardPerc=RewardPerc';
        

Reward_Perc=zeros(size(InfoTrial,1),4);
Reward_Perc(InfoTrial.DOpt>10)=InfoTrial.DOpt(InfoTrial.DOpt>10);
Reward_Perc(Reward_Perc==18)=0.75;
Reward_Perc(Reward_Perc==17)=0.5;
Reward_Perc(Reward_Perc==16)=0.25;
% Reward_Perc(Reward_Perc==18)=0.8;
% Reward_Perc(Reward_Perc==17)=0.4;
% Reward_Perc(Reward_Perc==16)=0.2;
RGamble_Perc_block=Reward_Perc*4/2;
RGamble_Perc_block=RGamble_Perc_block(ID_Choice,:);

R=InfoTrial.DRate';
Choice_Perc=R((InfoTrial.DOpt'>10));
Choice_Perc=Choice_Perc(ID_Choice)./(1-Choice_Perc(ID_Choice));

figure(1)
subplot(311)
plot((atan(Gamble_Perc)*180/pi),'k','linewidth',2);hold on;
plot((atan(RGamble_Perc)*180/pi),'b','linewidth',2);hold on;
box off; set(gca,'TickDir','out');
legend({'Gamble ratio','Gamble Income ratio '},'Location','eastoutside')
axis([0 length(Gamble_Perc) 0 100])
[h,p]=ttest(Gamble_Perc,RGamble_Perc);
title(['Risk Seeking',' dif=',num2str(nanmean(atan(Gamble_Perc)-atan(RGamble_Perc))*180/pi,3),' p=',num2str(p,3)]);
%yyaxis right
subplot(312)

plot((atan(Sure_Perc)*180/pi),'k','linewidth',2);hold on;
plot((atan(RSure_Perc)*180/pi),'b','linewidth',2);hold on;
box off; set(gca,'TickDir','out');
legend({'Sure ratio','Sure income ratio '},'Location','eastoutside')
axis([0 length(Gamble_Perc) 0 100])
[h,p]=ttest(Gamble_Perc,RGamble_Perc);
% title(['Risk Seeking',' dif=',num2str(nanmean(atan(Gamble_Perc)-atan(RGamble_Perc))*180/pi,3),' p=',num2str(p,3)]);
%
subplot(313)
RGamble_Perc_block=atan(RGamble_Perc_block)*180/pi;
% plot(RGamble_Perc_block(:,1),'y','linewidth',2);hold on;
RGamble_Perc_block(RGamble_Perc_block==0)=nan;
plot(RGamble_Perc_block(:,1),'y','linewidth',2);hold on;
plot(RGamble_Perc_block(:,2),'g','linewidth',2);hold on;
plot(RGamble_Perc_block(:,3),'m','linewidth',2);hold on;
plot(RGamble_Perc_block(:,4),'c','linewidth',2);hold on;
plot(atan(Choice_Perc)*180/pi,'k','linewidth',2);
legend({'D1','D2','D3','D4','Gamble Prob'},'Location','eastoutside');
axis([0 length(Gamble_Perc) 0 100])
box off; set(gca,'TickDir','out');
title('Block Information');

%%     logistic regression
% prepare data
G_Direct(RGamble_Perc_block(:,1)>0,1)=1;  % gamble direction
G_Direct(RGamble_Perc_block(:,2)>0,1)=-1;
clear X
u=0;
for trial=11:length(Gamble_Index)
    u=u+1;
    clear a0 a1
    y(u,1)=Gamble_Index(trial);
%    X(trial-10,11:20)=Gamble_Result((trial-1):-1:(trial-10))==-1 & Sure_Result((trial-1):-1:(trial-10))==-1 ;
  
   a0=Gamble_Result((trial-1):-1:(trial-10))>0;
   a1=Gamble_Result((trial-1):-1:(trial-10))==0;
   X(u,1:10)=a0-a1;   % win 1  loss -1    notchosen -1
   
   
    clear a0 a1
    a0=Sure_Result((trial-1):-1:(trial-10))>0;   
    a1=Sure_Result((trial-1):-1:(trial-10))==0;
    
    X(u,11:20)=-a0+a1;  % gamble 1  safe -1
    X(u,1:10)=X(u,1:10)+a0';   % win 1  loss -1    sure 0

    
    X(u,21)=G_Direct(trial);
end
% X(X(:,11:20)>0)=1;
% X(X(:,11:20)==0)=-1;

% Initialize parameters
fprintf('Initializing parameters');
m = size(X, 1); % number of examples
lambda = 0; % regularization parameter 0.1
numLabels = length(unique(y))-1; % number of labels
fprintf('...done\n');

% % Split data into training and testing
% fprintf('Splitting Data into training and testing sets');
% [XTrain XTest yTrain yTest] = splitData(X, y);

theta = LRClassifier(X, y, numLabels, lambda);
figure(2)
subplot(221)
fun=@(x,xdata) x(1)*exp(x(2)*(x(3)+xdata));
xdata1=-10:1:-1;
xdata0=-10:0.1:-1;
x0=[1 0.5 11];
b1=lsqcurvefit(fun,x0,xdata1,flip(theta(1:10)));
plot(xdata0, fun(b1,xdata0),'k');hold on;
x0=[-0.1 1 7];
% b2=lsqcurvefit(fun,x0,xdata1,flip(theta(21:30)));
% plot(xdata0, fun(b2,xdata0),'b');hold on;
x0=[-1 1 11];
b3=lsqcurvefit(fun,x0,xdata1,flip(theta(11:20)));
plot(xdata0, fun(b3,xdata0),'r');hold on;
legend({'Gamble result','Repeat choice'},'Location','NorthWest');
plot(-10:1:-1,flip(theta(1:10))','ko','MarkerSize',3); hold on;
plot(-10:1:-1,flip(theta(11:20))','ro','MarkerSize',3); hold on;
% plot(-10:1:-1,flip(theta(21:30))','bo','MarkerSize',3); hold on;
plot(-10:1:-1,flip(theta(1:10))','ko','MarkerSize',2); hold on;
plot(-10:1:-1,flip(theta(11:20))','ro','MarkerSize',2); hold on;
% plot(-10:1:-1,flip(theta(21:30))','bo','MarkerSize',2); hold on;

% f = fit((-10:1:-1)',-theta(1:10)','exp1');
% plot(f,-10:1:-1,-flip(theta(1:10)))
axis([-10 0 0 3]);
ylabel('Weight');
box off; set(gca,'TickDir','out');
title({'Logestic regression',['Theta0=',num2str(theta(21),3),' Tg=',num2str(1/b1(2),3),' Ts=',num2str(1/b3(2),3)]});


I_W=X(:,1)>0;  % last win
P_W=sum(y==1 & I_W )/sum(I_W );  % gamble given won last trial
I_L=X(:,1)==-1 ; % last loss
P_L=sum(y==1 & I_L )/sum(I_L );


%%% reward sequence
I_WW=X(:,1)>0 & X(:,2)>0;
I_LL=(X(:,1)==-1  & X(:,2)==-1);
P_WW=sum(y==1 & I_WW )/sum(I_WW );  % gamble given won last trial
P_LL=sum(y==1 & I_LL )/sum(I_LL );


I_LW=X(:,1)>0 & X(:,2)==-1;   % recent win, two trials ago loss
I_WL=(X(:,1)==-1  & X(:,2)>0); % recent loss, two trials ago win
P_LW=sum(y==1 & I_LW )/sum(I_LW );  % gamble given won last trial
P_WL=sum(y==1 & I_WL )/sum(I_WL );


P=[P_WW,P_LW,P_W,P_L,P_WL,P_LL];
subplot(223)
plot(1:6,P,'m.','MarkerSize',20);hold on;
axis([0.5 6.5 0 1]);
set(gca,'XTickLabel',{'WW','LW','W','L','WL','LL'});
ylabel('Likelihood of choosing risky');
box off; set(gca,'TickDir','out');
xlabel('Previous outcome');

I_W0=[zeros(1,10),I_W'];InfoTrial.IW(ID_Choice)=I_W0==1;
I_L0=[zeros(1,10),I_L'];InfoTrial.IL(ID_Choice)=I_L0==1;
I_WW0=[zeros(1,10),I_WW'];InfoTrial.IWW(ID_Choice)=I_WW0==1;
I_LL0=[zeros(1,10),I_LL'];InfoTrial.ILL(ID_Choice)=I_LL0==1;
I_LW0=[zeros(1,10),I_WW'];InfoTrial.ILW(ID_Choice)=I_LW0==1;
I_WL0=[zeros(1,10),I_LL'];InfoTrial.IWL(ID_Choice)=I_WL0==1;
save(Eventfile,'InfoTrial','-append');

% I_WWW=X(:,1)>0 & X(:,2)>0 & X(:,3)>0;
% P(1,1)=sum(y==1 & I_WWW )/sum(I_WWW );
% I_WWL=X(:,1)==-1 & X(:,11)==-1 & X(:,2)>0 & X(:,3)>0;
% P(2,1)=sum(y==1 & I_WWL )/sum(I_WWL);
% 
% I_LWW=X(:,1)>0 & X(:,2)>0  & (X(:,13)==-1 & X(:,3)==-1);
% P(1,2)=sum(y==1 & I_LWW )/sum(I_LWW);
% I_LWL=(X(:,1)==-1 & X(:,11)==-1)  & X(:,2)>0  & (X(:,13)==-1 & X(:,3)==-1);
% P(2,2)=sum(y==1 & I_LWL )/sum(I_LWL);
% 
% I_WLW=X(:,1)>0 & X(:,2)==-1 & X(:,12)==-1 & X(:,3)>0;
% P(1,3)=sum(y==1 & I_WLW )/sum(I_WLW );
% I_WLL=X(:,1)==-1 & X(:,11)==-1 & X(:,2)==-1 & X(:,12)==-1 & X(:,3)>0;
% P(2,3)=sum(y==1 & I_WLL )/sum(I_WLL );
% 
% 
% I_LLW=X(:,1)>0 & X(:,2)==-1 & X(:,12)==-1 & X(:,3)==-1 & X(:,13)==-1;
% P(1,4)=sum(y==1 & I_LLW )/sum(I_LLW );
% I_LLL=X(:,1)==-1 & X(:,11)==-1 & X(:,2)==-1 & X(:,12)==-1 & X(:,3)==-1 & X(:,13)==-1 & X(:,4)==-1 & X(:,14)==-1;
% P(2,4)=sum(y==1 & I_LLL )/sum(I_LLL );
% 
% I_WL=(X(:,1)==-1 & X(:,2)==1  );
% I_WL_G=(I_WL & y==1);
% P_WG(1)=sum(I_WL_G)/sum(I_WL);
% 
% I_WWL=(X(:,1)==-1 & X(:,2)==1 & X(:,3)==1);
% I_WWL_G=(I_WWL & y==1);
% P_WG(2)=sum(I_WWL_G)/sum(I_WWL);
% 
% I_WWWL=(X(:,1)==-1 & X(:,2)==1 & X(:,3)==1 & X(:,4)==1);
% I_WWWL_G=(I_WWWL & y==1);
% P_WG(3)=sum(I_WWWL_G)/sum(I_WWWL);
% 
% I_LL=(X(:,1)==-1 & X(:,11)==-1 & X(:,2)==-1 & X(:,12)==-1 );
% 
% I_LL_G=(I_LL & y==1);
% P_LG(1)=sum(I_LL_G)/sum(I_LL);
% 
% I_LLL=(X(:,1)==-1  & X(:,11)==-1 & X(:,2)==-1  & X(:,12)==-1 & X(:,3)==-1 & X(:,13)==-1);
% I_LLL_G=(I_LLL & y==1);
% P_LG(2)=sum(I_LLL_G)/sum(I_LLL);

% I_LLLL=(X(:,1)==-1 & X(:,2)==-1 & X(:,3)==-1 & X(:,4)==-1 & X(:,11)==-1 & X(:,12)==-1 & X(:,13)==-1 & X(:,14)==-1);
% I_LLLL_G=(I_LLLL & y==1);
% P_LG(3)=sum(I_LLLL_G)/sum(I_LLLL);
subplot(222)
bar([P_L,P_W],0.3);
set(gca,'XTickLabel',{'Loose','Win'});
ylabel('Likelihood of choosing risky');
axis([0.5 2.5 0 1]);
box off; set(gca,'TickDir','out');
xlabel('Previous outcome');
% 
% subplot(224)
% plot(1:4,P(1,:),'m.','MarkerSize',20);hold on;
% plot(1:4,P(2,:),'b.','MarkerSize',20);hold on;
% ylabel('Likelihood of choosing risky');
% xlabel('Previous outcome');
% set(gca,'XTick',1:4);
% set(gca,'XTickLabel',{'WW','LW','WL','LL'});
% legend({'Win','loss'},'Location','SouthWest');
% title('Trial sequence')
% box off; set(gca,'TickDir','out');
% axis([0.5 4.5 0 1]);
% 
% % subplot(223)
% % plot(1:8,[P(1,:),P(2,:)],'k.','MarkerSize',20);hold on;
% % %plot(1:4,P(2,:),'b.','MarkerSize',20);hold on;
% % ylabel('Likelihood of choosing risky');
% % xlabel('Previous outcome');
% % set(gca,'XTick',1:8);
% % set(gca,'XTickLabel',{'3W','2W','2W','1W','1L','2L','2L','3L'});
% % % legend({'Win','loss'});
% % title('Trial sequence')
% % box off; set(gca,'TickDir','out');
% % axis([0.5 8.5 0 1]);
%%
risk_l=[2,16,17,18];


for opt1=2:4

 I1=InfoTrial.Targ2Opt~=0  &  InfoTrial.DOpt(:,1)==risk_l(opt1)  &  InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0;
 I2=InfoTrial.Targ2Opt~=0  &  InfoTrial.DOpt(:,1)==risk_l(opt1)  &  InfoTrial.DChoice(:,1)==-1 & InfoTrial.Reward>0;
ChoiceProb(opt1-1,1)=sum(I1)/(sum(I1)+sum(I2));

 I1=InfoTrial.Targ2Opt~=0  &  InfoTrial.DOpt(:,2)==risk_l(opt1)  &  InfoTrial.DChoice(:,2)==1 & InfoTrial.Reward>0;
 I2=InfoTrial.Targ2Opt~=0  &  InfoTrial.DOpt(:,2)==risk_l(opt1)  &  InfoTrial.DChoice(:,2)==-1 & InfoTrial.Reward>0;
ChoiceProb(opt1-1,2)=sum(I1)/(sum(I1)+sum(I2)); 
end
subplot(224)
 bar(ChoiceProb);

% plot(1:6,[flip(P_WG),P(4:6)],'m.','MarkerSize',20); hold on;
% set(gca,'XTick',1:6);
% set(gca,'XTickLabel',{'3WL','2WL','WL','L','2L','3L'});
% title('Trial sequence')
% ylabel('Gamble Probability');
% 
% % plot(-2:1:-1,flip(P_LG),'g.','MarkerSize',20);
% axis([-4 0 0 1]);
% box off; set(gca,'TickDir','out');
%%

h10=figure(1);
print( h10, '-djpeg', [DirFig,'BehaviorSum']);
print( h10, '-depsc', [DirFig,'BehaviorSum']);

% for trial=1:size(