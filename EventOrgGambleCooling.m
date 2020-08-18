 function InfoTrial=EventOrgGambleCooling(tablefile,Eventfile)
 Filetag={'I','C'};
tablefile0=tablefile;
    
  for iii=1:length(Filetag)
      clear ChoiceD ChoiceND ChoiceOpt ChoiceNOpt Result Reward FixationOn FixationIn FixationOff TargetOn CherckerOn ChoiceIn
      clear ResultOn PreferD PreferOpt BackGroundOn      
      clear GoNoGo DetectDirection ChoiceIn I Block GI ChoiceNOpt Targ1Direction rowIndices tr InfoTrial GarborTime
      clear *Opt *Choice *Rate
      %%%%
%   InfoExp   Important information for the experiment
%   InfoTrial   Basic information for each trial

%%%%%  Gamble trials in the mat
% 1. direction; (1-4 direction 1; 5-8 direction 2
% 2. left reward ; 3.right reward; 
% 4. block number; 
% 5. fixation over lap time; 6. fixation on; 7. fixation in; 8. target on; 
% 9. fixation off; 10 choice in; 11 choice; 
% 12 reward pattern; 13 result; 14. result on; 15. gamble 1 or not 2; 
% 16 reward left; 17 reward right; 18 repeat; 19 reward received;
% 21 trial type; 22 direction 1 corresponding to which position ; 23  direction 2 corresponding to which position
% 24 back ground   25 start time 26 Background on

%%%%%  detection trials in the mat
% 1. position   2. choice maintained time (fixation long enough) ;  3. checkerboard on time (level of difficulty)
% 4. direction pattern (1 vertical and 2  hori) ;  
% 5 detection difficulty; similar to 3
% 6 go (1,2 ,3,4) /no go;
% 7. fixation on; 8 fixation in; 9 target on== 10 fixation off; 
% 11 choice in; 12 choice; 13 choice on; 14 result on; 15 result ; 16 reward time;
% 17. reward received; 18 repeat; 19 checkerboard on; 
% 20 reward pattern 22 block 21 trial type  24 back ground 25 start time 26 Background on




%   Files='NP3';
% %%%NP2
%  Flagt={'N1','C1','N2','N22','C2','C22','N3','C3'};
 % %%%NP3
%  Flagt={'N1','C1','N2','C2','C22','N3','N4'};
load(Eventfile,'InfoTrial','InfoExp');

tablefile=[tablefile0(1:end-4), char(Filetag(iii)),'.mat'];

[TableAll,InfoExp]=loadtablefile(tablefile);
if isfield(InfoExp,'Orientation')==0 | InfoExp.DirectionNum==2
Orientation=[ones(1,8);2*ones(1,8)];
Orientation=Orientation(:);
InfoExp.Orientation=Orientation;
elseif InfoExp.DirectionNum==1
 Orientation=[ones(1,8);1*ones(1,8)];
Orientation=Orientation(:);
InfoExp.Orientation=Orientation;
end
  for i=1:size(TableAll,1)
      I=TableAll(i,:)>=(TableAll(i,25)-3) & TableAll(i,:)<(TableAll(i,25)+3);
      TableAll(i,I)=TableAll(i,I)-TableAll(i,25);
  end
 
%%
load(Eventfile,'trialstart','trialsend');%,'TargetOn','ResultOn','RewardOn');
% event time recorded in plexon file
% if exist('RewardOn');
% TargetOn=TargetOn(1,1:size(TableAll,1));
% ResultOn=ResultOn(1,1:size(TableAll,1));
% RewardOn=RewardOn(1,1:size(TableAll,1));
% TargetOn_pl=TargetOn;
% ResultOn_pl=ResultOn;
% RewardOn=RewardOn*1000;
% InfoTrial.TargetOn_pl=TargetOn_pl';
% InfoTrial.ResultOn_pl=ResultOn_pl';
% InfoTrial.RewardOn=RewardOn';
% 
% end


%%%% general trial information
GI=TableAll(:,21)==1;
DI=TableAll(:,21)==2;
  TrialType=TableAll(:,21);
  Block(TableAll(:,21)==1)=TableAll(TableAll(:,21)==1,4);
  Block(TableAll(:,21)==2)=TableAll(TableAll(:,21)==2,22);
  Background=TableAll(:,24);
  Repeat=TableAll(:,18);
%%%  behavior 
%%%%%%%%% Gamble behavior
  Targ1Direction=zeros(1,size(TableAll,1));
  Targ2Direction=zeros(1,size(TableAll,1));
  Targ1Direction(GI & TableAll(:,1)==3)=1;%TableAll(GI & TableAll(:,1)==3,22)';
  Targ1Direction(GI & TableAll(:,1)==4)=2;%TableAll(GI & TableAll(:,1)==4,23)';
  Targ1Direction(GI & TableAll(:,1)==7)=4;%TableAll(GI & TableAll(:,1)==7,22)';
  Targ1Direction(GI & TableAll(:,1)==8)=3;%TableAll(GI & TableAll(:,1)==8,23)';
  Targ1Direction(GI & (TableAll(:,1)==5 | TableAll(:,1)==6 ))=4;%TableAll(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==5),22)';
  Targ2Direction(GI & (TableAll(:,1)==5 | TableAll(:,1)==6))=3;%TableAll(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==5),23)';
  Targ1Direction(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 ))=1;%TableAll(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==5),22)';
  Targ2Direction(GI & (TableAll(:,1)==1 | TableAll(:,1)==2))=2;%TableAll(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==5),23)';


  Targ1Opt=zeros(1,size(TableAll,1));
  Targ2Opt=zeros(1,size(TableAll,1));
  Targ1Opt(GI & TableAll(:,1)==3)=TableAll(GI & TableAll(:,1)==3,2)';
  Targ1Opt(GI & TableAll(:,1)==4)=TableAll(GI & TableAll(:,1)==4,3)';
  Targ1Opt(GI & TableAll(:,1)==7)=TableAll(GI & TableAll(:,1)==7,2)';
  Targ1Opt(GI & TableAll(:,1)==8)=TableAll(GI & TableAll(:,1)==8,3)'; 
  Targ1Opt(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==6))=TableAll(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==6),2)';
  Targ2Opt(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==6))=TableAll(GI & (TableAll(:,1)==1 | TableAll(:,1)==2 | TableAll(:,1)==5 | TableAll(:,1)==6),3)';

  ChoiceD=zeros(1,size(TableAll,1));
  ChoiceND=zeros(1,size(TableAll,1));

  ChoiceD((Targ2Opt(:)==0)  & GI  & TableAll(:,11)~=0)=Targ1Direction((Targ2Opt(:)==0)  & GI  & TableAll(:,11)~=0);
  ChoiceD((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==1)=Targ1Direction((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==1);
  ChoiceD((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2)=Targ2Direction((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2);
  ChoiceND((Targ2Opt(:)==0)  & GI  & TableAll(:,11)~=0)=0;
  ChoiceND((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==1)=Targ2Direction((Targ2Opt(:)~=0)   & GI  & TableAll(:,11)==1);
  ChoiceND((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2)=Targ1Direction((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2);

  ChoiceOpt=zeros(1,size(TableAll,1));
  ChoiceNOpt=zeros(1,size(TableAll,1));
  
  ChoiceOpt(((Targ2Opt(:)==0)  & GI  & TableAll(:,11)~=0)==1)=Targ1Opt(((Targ2Opt(:)==0)  & GI  & TableAll(:,11)~=0)==1);
  ChoiceOpt(((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==1)==1)=Targ1Opt(((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==1)==1);
  ChoiceOpt(((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2)==1)=Targ2Opt(((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2) );
  ChoiceNOpt((Targ2Opt(:)==0)  & GI  & TableAll(:,11)~=0)=0;
  ChoiceNOpt((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==1)=Targ2Opt((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==1);
  ChoiceNOpt((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2)=Targ1Opt((Targ2Opt(:)~=0)  & GI  & TableAll(:,11)==2);

  Result=zeros(1,size(TableAll,1));
  Reward=zeros(1,size(TableAll,1));
  Result(GI)=TableAll(GI,13);
  Reward(GI)=TableAll(GI,19);

  %%%%%%%%% Detection behavior
  DetectDirection(DI)=TableAll(DI,1);
  DetectDirection(~DI)=0;
  GarborTime(DI)=TableAll(DI,3);
  GarborTime(~DI)=0;
  GoNoGo(DI)=TableAll(DI,6);
  GoNoGo(~DI)=0;
  
  ChoiceD(DI)=TableAll(DI,12);
  Result(DI)=TableAll(DI,14);
  Reward(DI)=TableAll(DI,17);
  
  %%%  time event
  if size(TableAll,2)>=26
  BackGroundOn=TableAll(:,26)*1000;
  else
   BackGroundOn=TableAll(:,7)*1000;
  end
  FixationOn(GI)=TableAll(GI,6)*1000;
  FixationOn(DI)=TableAll(DI,7)*1000;
  FixationIn(GI)=TableAll(GI,7)*1000;
  FixationIn(DI)=TableAll(DI,8)*1000;
  FixationOff(GI)=TableAll(GI,9)*1000;
  FixationOff(DI)=TableAll(DI,9)*1000;
  TargetOn(GI)=TableAll(GI,8)*1000;  
  TargetOn(DI)=TableAll(DI,9)*1000; 
  CherckerOn(DI)=TableAll(DI,19)*1000;
  CherckerOn(~DI)=0;
  ChoiceIn(GI)=TableAll(GI,10)*1000;  
  ChoiceIn(DI)=TableAll(DI,11)*1000;  
%   ChoiceOn(GI)=TableAll(GI,10);  
%   ChoiceOn(GI)=TableAll(DI,13);  
 ResultOn(GI)=TableAll(GI,14)*1000;
 ResultOn(DI)=TableAll(DI,14)*1000;
 %%
 DirectionInfo=zeros(max(Block),4,2);
  for b1=1:max(Block)
   I=(Block'==b1 & GI & ChoiceNOpt'~=0 & Targ2Direction'~=0);
   if sum(I)>0
%    Targ1Opt
%    nanmean(Targ1Direction(I))
%    nanmean(Targ1Opt(I))
   DirectionInfo(b1,nanmean(Targ1Direction(I)),1)=nanmean(Targ1Opt(I));
   DirectionInfo(b1,nanmean(Targ2Direction(I)),1)=nanmean(Targ2Opt(I));
   DirectionInfo(b1,nanmean(Targ1Direction(I)),2)=sum(I' & ChoiceOpt==Targ1Opt)/sum(I);
   DirectionInfo(b1,nanmean(Targ2Direction(I)),2)=sum(I' & ChoiceOpt==Targ2Opt)/sum(I);
   dd=DirectionInfo(b1,:,1);
   DirectionInfo(b1,dd==0,:)=nan;
   
   
   GambleRate_block(b1)=sum(I' & ChoiceOpt>10)/sum(I);
   if sum(I' & ChoiceOpt==Targ1Opt)> sum(I' & ChoiceOpt==Targ2Opt)
   PreferD_block(b1)=nanmean(Targ1Direction(I));
   PreferOpt_block(b1)=nanmean(Targ1Opt(I));
   NPreferD_block(b1)=nanmean(Targ2Direction(I));
   NPreferOpt_block(b1)=nanmean(Targ2Opt(I));
   else
   PreferD_block(b1)=nanmean(Targ2Direction(I));
   PreferOpt_block(b1)=nanmean(Targ2Opt(I));  
   NPreferD_block(b1)=nanmean(Targ1Direction(I));
   NPreferOpt_block(b1)=nanmean(Targ1Opt(I));  
   end
   if PreferOpt_block(b1)>10
   Gamble_block(b1)=PreferOpt_block(b1);
   Sure_block(b1)=NPreferOpt_block(b1);
   else
   Gamble_block(b1)=NPreferOpt_block(b1);
   Sure_block(b1)=PreferOpt_block(b1);
   end
   else
       PreferD_block(b1)=nan;
       PreferOpt_block(b1)=nan;
   end
  end
  InfoExp.PreferD_block=PreferD_block;
  InfoExp.PreferOpt_block=PreferOpt_block;
  InfoExp.NPreferD_block=NPreferD_block;
  InfoExp.NPreferOpt_block=NPreferOpt_block; 
InfoExp.Gamble_block=Gamble_block;
InfoExp.Sure_block=Sure_block;
InfoExp.GambleRate_block=GambleRate_block;
InfoExp.DirectionInfo=DirectionInfo;
  
InfoTrial=table;
bk=0; prD=0;prO=0;
InfoTrial.Block=Block';

 for tr=1:length(ChoiceIn)
     if InfoTrial.Block(tr)~=bk
         BlockSwitch(tr)=1;
         prD=0;prO=0;
     end
     bk=InfoTrial.Block(tr);
     D1Opt(tr)=DirectionInfo(bk,1,1);
     D2Opt(tr)=DirectionInfo(bk,2,1);
     D3Opt(tr)=DirectionInfo(bk,3,1);
     D4Opt(tr)=DirectionInfo(bk,4,1);
     D1Rate(tr)=DirectionInfo(bk,1,2);
     D2Rate(tr)=DirectionInfo(bk,2,2);
     D3Rate(tr)=DirectionInfo(bk,3,2);
     D4Rate(tr)=DirectionInfo(bk,4,2);
     if ChoiceD(tr)==1
         D1Choice(tr)=1;
     else
         D1Choice(tr)=0;
     end
     if ChoiceD(tr)==2
         D2Choice(tr)=1;
     else
        D2Choice(tr)=0; 
     end
     if ChoiceD(tr)==3
         D3Choice(tr)=1;  
     else
         D3Choice(tr)=0;
     end
     if ChoiceD(tr)==4
         D4Choice(tr)=1;
     else
         D4Choice(tr)=0;
     end
     
     if ChoiceND(tr)==1
         D1Choice(tr)=-1;
     elseif ChoiceND(tr)==2
         D2Choice(tr)=-1;
     elseif ChoiceND(tr)==3
         D3Choice(tr)=-1;  
     elseif ChoiceND(tr)==4
         D4Choice(tr)=-1;
     end
     
          
     if GI(tr)==1 & ChoiceNOpt(tr)~=0
         %%%%% choice trial prefer option is the chosen option
         PreferD(tr)=ChoiceD(tr);
         PreferOpt(tr)=ChoiceOpt(tr);
         if ChoiceD(tr)~=prD & prD~=0
             SwitchPrefer(tr)=1;
         end
         prD=ChoiceD(tr);
         prO=ChoiceOpt(tr);
     elseif GI(tr)==1 & Targ2Opt(tr)~=0
         %%%%%%%% choice non-chosen trial prefer option is previous chosen
         %%%%%%%% option
         PreferD(tr)=prD;
         PreferOpt(tr)=prO; 
     elseif GI(tr)==1 & Targ2Opt(tr)==0
         %%%%%%%%%%%%%% no-choice trial: prefer option is the prefered
         %%%%%%%%%%%%%% direction in the block
         PreferD(tr)= PreferD_block(bk);
         PreferOpt(tr)= PreferOpt_block(b1); 
     else
                  %%%%%%%% choice detection trial prefer option is previous chosen
         %%%%%%%% option
         PreferD(tr)=prD;
         PreferOpt(tr)=prO; 
     end
 end
         
         
%%
InfoTrial.TrialType=TrialType;
InfoTrial.Background=Background;
InfoTrial.Repeat=Repeat;
InfoTrial.Targ1Direction=Targ1Direction';
InfoTrial.Targ2Direction=Targ2Direction';
InfoTrial.Targ1Opt=Targ1Opt';
InfoTrial.Targ2Opt=Targ2Opt';
InfoTrial.DetectDirection=DetectDirection';
InfoTrial.GarborTime=GarborTime';
InfoTrial.GoNoGo=GoNoGo';
InfoTrial.ChoiceD=ChoiceD';
InfoTrial.ChoiceND=ChoiceND';
InfoTrial.ChoiceOpt=ChoiceOpt';
InfoTrial.ChoiceNOpt=ChoiceNOpt';
InfoTrial.Result=Result';
InfoTrial.Reward=Reward';
InfoTrial.FixationOn=FixationOn';
InfoTrial.FixationIn=FixationIn';
InfoTrial.FixationOff=FixationOff';
InfoTrial.TargetOn=TargetOn';
% InfoTrial.TargetOn_pl=TargetOn_pl';
InfoTrial.CherckerOn=CherckerOn';
InfoTrial.ChoiceIn=ChoiceIn';
InfoTrial.ResultOn=ResultOn';
% InfoTrial.RewardOn=RewardOn';
InfoTrial.PreferD=PreferD';
InfoTrial.PreferOpt=PreferOpt';
InfoTrial.BackGroundOn=BackGroundOn;
if iii==1
    InfoTrial.Temperature(:,1)=38;
else
     InfoTrial.Temperature(:,1)=15;
end
 
%%
DOpt(1,:)=D1Opt;
DOpt(2,:)=D2Opt;
DOpt(3,:)=D3Opt;
DOpt(4,:)=D4Opt;
% size(DOpt)
% size(InfoTrial)
InfoTrial.DOpt=DOpt';

DChoice(1,:)=D1Choice;
DChoice(2,:)=D2Choice;
DChoice(3,:)=D3Choice;
DChoice(4,:)=D4Choice;
InfoTrial.DChoice=DChoice';
DRate(1,:)=D1Rate;
DRate(2,:)=D2Rate;
DRate(3,:)=D3Rate;
DRate(4,:)=D4Rate;
InfoTrial.DRate=DRate';
InfoTrial.RewardPattern=TableAll(:,12);


eval(['InfoTrial',char(Filetag(iii)),'=InfoTrial;']);

save(Eventfile,'InfoTrial*','InfoExp*','-append');
  end
InfoTrial=cat(1,InfoTrialC,InfoTrialI);
save(Eventfile,'InfoTrial*','InfoExp*','-append');

%save(Spikefile,'TableAll','-append');