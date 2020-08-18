%%%%%%%%%%%%%%% does not work
%function ContrastRiskOrgClassify(Spikefile,Eventfile,Ch_num)
% substract the baseline during fixation
%%%% dock the figures
%%%% do not analyze the unsorted ones
close all
set(0,'DefaultFigureWindowStyle','docked');
clear ContrastBG BG* TG* Sac* Res*

load(Spikefile,'SaccadeRate','TargetRate','BackgroundRate','ResultRate','Unit_channel','l_ts')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;



BG_Color={'k','b','g'};
risk_l=[2,16,17,18];
load(Spikefile,'BG0','TG0');
%%
BG_Color=copper(3);%[ 0,0,0; 0,1,0; 0,0,1];
close all


%%
t_result=-500:501;
t_targ=-500:1001;
t_bg=-100:501;
Opt=[2,16,17,18];


for period=1:2
clear Error DChosen* t_0 t_1  aa* periodname
if period==1
    AFC=BG0.FChoiceAll;
    AC=BG0.ChoiceAll;
    ChoiceAll_label=BG0.ChoiceAll_label;
    FChoiceAll_label=BG0.FChoiceAll_label;

    t_0=t_bg;
    periodname='BG';
else
    AFC=TG0.FChoiceAll(:,:,400:1200);
    AC=TG0.ChoiceAll(:,:,400:1200);
    ChoiceAll_label=TG0.ChoiceAll_label;
    FChoiceAll_label=TG0.FChoiceAll_label;
    t_0=t_targ(400:1200);
    periodname='TG';
end

for t=1:floor(size(AFC,3)/20)
    tic
    spFC=squeeze(mean(AFC(:,:,((t-1)*20+1):(t*20)),3));
    spC=squeeze(mean(AC(:,:,((t-1)*20+1):(t*20)),3));

    lb0=ChoiceAll_label(:,4);  % choice
    lb1=ChoiceAll_label(:,2);  % PD opt
    lb2=ChoiceAll_label(:,3);  % NPD opt
    lb3=ChoiceAll_label(:,1);  % Contrast
    
    lb0_1=FChoiceAll_label(:,4);  % choice
    lb1_1=FChoiceAll_label(:,2);  % PD opt
    lb2_1=FChoiceAll_label(:,3);  % NPD opt
    lb3_1=FChoiceAll_label(:,1);  % Contrast
    
   
   figure(1)
   for con=1:3
   plot(squeeze(nanmean(nanmean(BG0.ChoiceAll(:,lb3==con,:),2),1)),'Color',char(Color(con)));hold on;
   end
    
for contrast=1:3
    for o=2:4
    clear I    
    I=(lb3_1==contrast & (lb1_1==Opt(o) | lb2_1==Opt(o))  );
    aa3(t,contrast,o-1)=1-RFClassifier(spFC(:,I)',lb0_1(I));
    
    clear I    
    I=(lb3==contrast & (lb1==Opt(o) | lb2==Opt(o))  );
    aa4(t,contrast,o-1)=1-RFClassifier(spC(:,I)',lb0(I));
    end

end
    eval([periodname,'FC.DChoice_opt=aa3;']);  
    eval([periodname,'C.DChoice_opt=aa4;']);  
   
 %%%%% for individual Opt   
    
%     clear I 
%     for o=1:4
%     clear I 
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa11(t,o)=1-RFClassifier(sp0(:,I)',lb3(I));  
%     
%     clear I   
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa12(t,o)=1-RFClassifier(sp0(:,I)',lb3(I)); 
%     
%     clear I      
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==0  & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa13(t,o)=1-RFClassifier(sp0(:,I)',lb3(I));  
%     
%     clear I
%     I=(InfoTrial.ChoiceD~=0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==-1  & InfoTrial.DOpt(:,1)==Opt(o) & InfoTrial.Reward>=0);
%     aa14(t,o)=1-RFClassifier(sp0(:,I)',lb3(I)); 
%     
%     end
%     eval([periodname,'FC.CatrastChosen_opt=aa11;']);
%     eval([periodname,'C.CatrastChosen_opt=aa12;']);   
%     eval([periodname,'FC.CatrastNChosen_opt=aa13;']);  
%     eval([periodname,'C.CatrastNChosen_opt=aa14;']);     
    
    
          
    toc
end


end


%%

Color={'k','b','m','r'}
for period=1:2
        if period==1
    periodname='BG';
    tt=t_bg(1:20:floor((length(t_bg)/20)-1)*20+1)
    else
    periodname='TG';
    tt=t_targ(400:20:floor((1200/20)-1)*20+1);
    end
    
    eval(['C=',periodname,'C;']);
    eval(['FC=',periodname,'FC;']);
    
figure(period)
%for con=1:3
for op=1:4
subplot(3,2,op)
plot(tt,squeeze(nanmean(FC.DChoice_opt(:,:,op),2)),char(Color(op)));hold on;
axis([-inf inf 0.4 0.8])

end
subplot(3,2,5)
bar(squeeze(mean(nanmean(FC.DChoice_opt(:,:,:),2),1)),0.4)
axis([0 5 0 0.8])



figure(period+2)
%for con=1:3
for op=1:4
subplot(3,2,op)
plot(tt,squeeze(nanmean(C.DChoice_opt(:,:,op),2)),char(Color(op)));hold on;
axis([-inf inf 0.4 0.8])

end
subplot(3,2,5)
bar(squeeze(mean(nanmean(C.DChoice_opt(:,:,:),2),1)),0.4)
axis([0 5 0 0.8])


end
