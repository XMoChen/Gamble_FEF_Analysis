function  BehaviorAnalysis(Eventfile)
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

% I_Choice=InfoTrial.ChoiceOpt>0;
% I_Gamble=I_Choice>10;
% sigma=6;
% kernal=HalfGaussian(sigma);
% 


