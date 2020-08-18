clear all
close all


% new V4 recording
%%% Ozzy 
Date={'G072617','G072717','G072917',...
    'G082017','G082617','G082817','G090117','G103017','G103117',...
    'G073017','G080117','G080417','G080817','G083017'};
Files={'Otrain9','Otrain10','Otrain12',...
    'G082017','G082617','G082817','G090117','G103017','G103117',...
    'G073017','G080117','G080417','G080817','G083017'};
RootDir='D:\Projects\GambleMIB';

%%%%Jimmy
Date={'J100217','J100317','J100417','J040218','J040418'};
Files={'G100217','G100317','G100417','J040218','J040418'};
RootDir='D:\Projects\GambleMIB\GDRecordings';


addpath('D:\Projects\GambleMIB\Gamble\');
DirFig='D:\Projects\GambleMIB\figures\Sum\';
Flag={'ResultEffect','RiskRegress','HistoryWL','HistoryWL2','ChoicePerc','RiskPerc'};


%  Unit_channel_all=[];
%         for ii=1:4
%             eval(['BehaviorAll.',char(Flag(ii)),'=[];']);
%             
%         end


for record=1:[length(Date)]%[3,5:8]  % valid from 6
    Dir=[RootDir,'\GDRecordings\',char(Date(record)),'\'];
    %   Dir=[RootDir,'\GDRecordings\OzzyTraining\',char(Date(record)),'\'];
    
    DirMat=[RootDir,'\Mat\',char(Date(record)),'\'];
    DirFig=[RootDir,'\figures\',char(Date(record)),'\'];    
    Eventfile=[DirMat,char(Files(record)),'Event.mat'];

   % BehaviorAnalysis2017_3Risk(Eventfile,DirFig)

    
    close all
    set(0,'DefaultFigureWindowStyle','docked');
    load(Eventfile,'BehaviorAlys');

    clear TG BG;



        for ii=1:6
            
            eval(['All',char(Flag(ii)),'(',num2str(record),',:)=[BehaviorAlys.',char(Flag(ii)),'];']);      
        end
   
end



%%
close all
figure(1)
subplot(231)
a=AllHistoryWL(:,1:5);
b=AllHistoryWL(:,6:10);
errorbarplot([nanmean(a,1);nanmean(b,1)],[nanstderror(a,1);nanstderror(b,1)]);
title('Trial History 1 back');
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'Left stay','Right stay'});
legend({'Win4','Win3','Safe','Loss1','Loss0'})
axis([0.5 2.5 0 1.2]);

subplot(232)
a=reshape(nanmean(AllChoicePerc,1),2,3);
b=reshape(nanstderror(AllChoicePerc,1),2,3);
errorbarplot(a',b');
set(gca,'XTickLabel',{'2','1/3 ','0/4 '});
axis([0.5 3.5 0 1]);
box off; set(gca,'TickDir','out');
ylabel('Choice Probability');
set(gca,'XTickLabel',{'Left stay','Right stay'});


subplot(233)
RiskPerc0(:,1)=AllRiskPerc(:,1);
RiskPerc0(:,2)=AllRiskPerc(:,3);
RiskPerc0(:,3)=AllRiskPerc(:,2);
a=(nanmean(RiskPerc0,1));
b=nanstderror(RiskPerc0,1);
bar(a,0.3);hold on;
errorbar(a,b,'k.');
axis([0.5 3.5 0 1]);
box off; set(gca,'TickDir','out');
set(gca,'XTickLabel',{'0/4 vs 2','0/4 vs 1/3','1/3 vs 2'});
ylabel('Risky Choice Probability');
% set(gca,'XTickLabel',{'Left stay','Right stay'});

% b=AllHistoryWL2(:,6:10);
% 
% errorbarplot([nanmean(a,1);nanmean(b,1)],[nanstderror(a,1);nanstderror(b,1)]);
% title('Trial History 2 back');
% box off; set(gca,'TickDir','out');
% set(gca,'XTickLabel',{'Left stay','Right stay'});
% % legend({'Win4','Win3','Safe','Loss1','Loss0'})
% axis([0.5 2.5 0 1.2]);

subplot(234)
bar(nanmean(AllRiskRegress,1),0.3);hold on;
errorbar(1:3,nanmean(AllRiskRegress,1),nanstderror(AllRiskRegress,1),'k.');
title('Logistic regression');
box off; set(gca,'TickDir','out');
for ii=1:3
    [h(ii),p(ii)]=ttest(AllRiskRegress(:,ii));
end


subplot(235)
theta=nanmean(AllResultEffect,1);
thetastd=nanstderror(AllResultEffect,1);
fun=@(x,xdata) x(1)*exp(x(2)*(x(3)+xdata));
xdata1=-10:1:-1;
xdata0=-10:0.1:-1;
x0=[1 0.5 0];
b1=lsqcurvefit(fun,x0,xdata1,flip(theta(1:10)));
h1=plot(xdata0, fun(b1,xdata0),'k');hold on;
x0=[-0.1 1 0];
% b2=lsqcurvefit(fun,x0,xdata1,flip(theta(21:30)));
% plot(xdata0, fun(b2,xdata0),'b');hold on;
x0=[-1 1 11];
b3=lsqcurvefit(fun,x0,xdata1,flip(theta(11:20)));
h2=plot(xdata0, fun(b3,xdata0),'r');hold on;
plot(-10:1:-1,flip(theta(1:10))','ko','MarkerSize',3); hold on;
errorbar(-10:1:-1,flip(theta(1:10))',flip(thetastd(1:10))','k.');
plot(-10:1:-1,flip(theta(11:20))','ro','MarkerSize',3); hold on;
errorbar(-10:1:-1,flip(theta(11:20))',flip(thetastd(1:10))','r.');
box off; set(gca,'TickDir','out');
h = findobj(gca,'Type','line');
legend([h(3), h(4)],{'Right result','Left result'},'Location','NorthWest');
axis([-11 0 -inf inf]);