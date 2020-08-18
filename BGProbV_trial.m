%function DirectionValueSpike17_BG(Spikefile,Eventfile,DirFig,Ch_num)
%%%% dock the figures
close all
set(0,'DefaultFigureWindowStyle','docked');
load(Spikefile,'SaccadeEndRate','TargetRate','BackgroundRate','ResultRate','l_ts')
load(Eventfile,'InfoTrial','InfoExp','ProbBlock','V_BG');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
clear ContrastBG
C1=(InfoTrial.Background<=6);
ContrastBG(C1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
ContrastBG(C2)=2;
C3=(InfoTrial.Background>12 );
ContrastBG(C3)=3;
ContrastBG=ContrastBG';

D1_V=InfoExp.RewardLeft'.*(InfoExp.Orientation==1);
D2_V=InfoExp.RewardRight'.*(InfoExp.Orientation==1);
D4_V=InfoExp.RewardLeft'.*(InfoExp.Orientation==2);
D3_V=InfoExp.RewardRight'.*(InfoExp.Orientation==2);
D1_V_trial=D1_V(InfoTrial.Block);
D2_V_trial=D2_V(InfoTrial.Block);
D3_V_trial=D3_V(InfoTrial.Block);
D4_V_trial=D4_V(InfoTrial.Block);
D_V_trial=[D1_V_trial,D2_V_trial,D3_V_trial,D4_V_trial];
V_all=unique(D2_V_trial);
% V_all=V_all(2:length(V_all));

PreferD=1;

GS_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt==0;
GC_I=InfoTrial.TrialType==1 & InfoTrial.Targ2Opt~=0;
D_I=InfoTrial.TrialType==2 ;
%%% Receptive field in the preferred direction
PreferIn=(InfoTrial.PreferD==1);
PreferOut=( InfoTrial.PreferD==2);

PreferV=D4_V_trial+D1_V_trial;


Direction_Color={'k','k:'};
V_all=[0;V_all];
V_Color={'m','g','k','c','b','r'};


%%
close all
unit_all=0;
for ch=1:Ch_num%20%25%1:Ch_num
    for unit=2:length(l_ts(ch,:))%2%3%2:length(l_ts(ch,:))
        if l_ts(ch,unit)>5000
            unit_all=unit_all+1;
           
            
            
            
            eval(['Spike=TargetRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_TG=Spike;
            eval(['Spike=SaccadeEndRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_SC=Spike;
            eval(['Spike=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_BG=Spike;
            eval(['Spike=ResultRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            Spike_RT=Spike;
            
                                      
            clear Spike_BG_base*                      
            Spike_BG_base=nanmean(Spike_BG(:,1:100),2);
            base_I=InfoTrial.TargetOn~=0;
            Spike_BG_base=Spike_BG_base(base_I);
            Spike_BG_base=[nanmean(Spike_BG_base(1:100))*ones(100,1);Spike_BG_base];
           if 1==0
            sigma=10;
            edges=[-3*sigma:1:3*sigma];
            kernel=normpdf(edges,0,sigma)';
            Spike_BG_base00=convn(Spike_BG_base,kernel,'same'); 
            Spike_BG_base00=Spike_BG_base00(101:end);
           end
%             Spike_BG_base=[nanmean(Spike_BG_base(1:100))*ones(100,1);Spike_BG_base(base_I)];
            windowSize = 50;
            b = (1/windowSize)*ones(1,windowSize);
            a = 1;
            Spike_BG_base00=filter(b,a,Spike_BG_base);
            Spike_BG_base00=Spike_BG_base00(101:end);
            Spike_BG_base0=zeros(size(Spike_BG,1),1);
            Spike_BG_base0(base_I)=Spike_BG_base00;
            
            Spike_BG=Spike_BG-repmat(Spike_BG_base0,1,size(Spike_BG,2));
            Spike_TG=Spike_TG-repmat(Spike_BG_base0,1,size(Spike_TG,2));
            Spike_SC=Spike_SC-repmat(Spike_BG_base0,1,size(Spike_SC,2));
            Spike_RT=Spike_RT-repmat(Spike_BG_base0,1,size(Spike_RT,2));           

    if 1==0       
            if 1==1%hSig(unit_all,1)==0 & hSig(unit_all,3)==0 & hSig(unit_all,4)==0 & hSig(unit_all,5)==0% ...
            % & ( hSig(unit_all,9)>0 | hSig(unit_all,10)>0) &  hSig(unit_all,7)==0
             %  hSig(unit_all,6)==0 & hSig(unit_all,7)==0 & hSig(unit_all,8)==0 ...
            figure(unit_all) 
            Epoch={'BG','TG','SC','RT'};
            %%%% Align on target onset
            for ep=1:4
                clear Spike tt Spike_max Spike_min
                eval(['Spike=Spike_',char(Epoch(ep)),';']);
                               
                clear t clim
                if ep==1
                    t=-100:501;
                elseif ep==2
                    t=-1000:501;
                elseif ep==3
                    t=-500:1001;
                else
                    t=-500:501;
                end
                
                subplot(2,2,ep)

                    I=InfoTrial.Repeat==0 & InfoTrial.Reward>0;
                    opt2=InfoTrial.Targ2Opt(I);
                    spk0=nanmean(Spike(I,t>0 & t<500),2);
                    spk01(opt2==0)=nan;spk01(opt2~=0)=spk0(opt2~=0);
                    spk02(opt2~=0)=nan;spk02(opt2==0)=spk0(opt2==0);
                    
                    plot(spk01,'k.');hold on;
                    plot(spk02,'b.');hold on;
                    
              title(['Ch',num2str(ch),'N',num2str(unit)])      
              xlabel([char(Epoch(ep)),' onset']);% title('Single');
            end
            
            end         
   if 1==1         
              for block=1:20
              prob_trial(InfoTrial.Block==block)=ProbBlock(block);
              end
              
                  
                  t=-1000:501;
                  Backg=nanmean(Spike_TG(:,t>-800 & t<0),2);
                  Targ=nanmean(Spike_TG(:,t>0 & t<500),2);
                  t=-500:1001;
                  preSac=nanmean(Spike_SC(:,t>-500 & t<0),2);
                  posSac=nanmean(Spike_SC(:,t>0 & t<500),2);
                  t=-500:501;
                  preRes=nanmean(Spike_RT(:,t>-500 & t<0),2);
                  posRes=nanmean(Spike_RT(:,t>0 & t<500),2);


%%

for block=1:20
 clear I   
    for ii=1:8
        if ii==1
I=ContrastBG==2 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;

        elseif ii==2
I=ContrastBG==2 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,2)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;
        elseif ii==3
I=ContrastBG==2 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;
        elseif ii==4
I=ContrastBG==2 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;
        elseif ii==5
I=ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;
        elseif ii==6
 I=ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,2)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;
        elseif ii==7
I=ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;
        elseif ii==8
I=ContrastBG==1 & InfoTrial.Repeat==0 & InfoTrial.Targ2Opt~=0 & InfoTrial.DChoice(:,1)==1 & InfoTrial.Reward>0 & InfoTrial.Block==block ;
        end
Reward(ii,block)=nanmean(InfoTrial.Reward(I));
BGAct(ii,block)=nanmean(Backg(I)); % single  direction 1 nobackground 
posSacAct(ii,block)=nanmean(posSac(I)); % single  direction 1 nobackground 
preSacAct(ii,block)=nanmean(preSac(I)); % single  direction 1 nobackground 
preRtAct(ii,block)=nanmean(preRes(I)); % single  direction 1 nobackground 

    end
end


%for con=1:4
% figure(2)

for con=1:4%1:4
    figure(con)
    clear Act
    if con==1
        Act=BGAct;
    elseif con==2
        Act=preSacAct;
    elseif con==3
        Act=posSacAct;
    elseif con==4
        Act=preRtAct;
    end
 clims=[-inf inf min(Act(:))*1.2, max(Act(:))*1.2];
FlagTitle={'BG Single Dir1','BG Single Dir2','BG Choice Dir1','BG Choice Dir2'...
    'NBG Single Dir1','NBG Single Dir2','NBG Choice Dir1','NBG Choice Dir2'};
Flagexlable={'Dir1 reward','Dir2 reward','Dir1 reward','Dir2 reward',...
    'Dir1 reward','Dir2 reward','Dir1 reward','Dir2 reward'};
for nn=1:8
    subplot(4,4,nn)
    plot(ProbBlock,Act(nn,:),'k.','MarkerSize',10);hold on;   
   if mod(nn,2)==1
        plot(ProbBlock(V_BG(1,:)>10),Act(nn,V_BG(1,:)>10),'b.','MarkerSize',10);hold on; 
   xlabel('ChoiceProb Dir1'); 
   else
        plot(1-ProbBlock(V_BG(2,:)>10),Act(nn,V_BG(2,:)>10),'b.','MarkerSize',10);hold on; 
   xlabel('ChoiceProb Dir2');
   end
    title(char(FlagTitle(nn)))
    axis(clims)
    
end

for nn=1:8
    subplot(4,4,nn+8)
    plot(Reward(nn,:),Act(nn,:),'k.','MarkerSize',10);hold on; 
    if mod(nn,2)==1
        plot(Reward(nn,V_BG(1,:)>10),Act(nn,V_BG(1,:)>10),'b.','MarkerSize',10);hold on; 
    else
        plot(Reward(nn,V_BG(2,:)>10),Act(nn,V_BG(2,:)>10),'b.','MarkerSize',10);hold on; 
    end
    title(char(FlagTitle(nn)))
    axis(clims)
    xlabel(char(Flagexlable(nn)));
end
end

            end
          
              
          end   
        end
    end
end

% %%
% clims=[-inf inf min([min(Backg1),min(preSac1)])*1.5, max(Targ1)*1.5];
% figure(2)
% subplot(441)
% plot(ProbBlock(V_BG(3,:)'==1),Backg1(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),Backg1(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
% 
% subplot(442)
% plot(ProbBlock(V_BG(3,:)'==1),Targ1(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),Targ1(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
% 
% subplot(443)
% plot(ProbBlock(V_BG(3,:)'==1),preSac1(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),preSac1(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
% 
% subplot(444)
% plot(ProbBlock(V_BG(3,:)'==1),posSac1(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),posSac1(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
% 
% subplot(445)
% plot(ProbBlock(V_BG(3,:)'==1),Backg2(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),Backg2(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
% 
% subplot(446)
% plot(ProbBlock(V_BG(3,:)'==1),Targ2(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),Targ2(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
% 
% subplot(447)
% plot(ProbBlock(V_BG(3,:)'==1),preSac2(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),preSac2(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
% 
% subplot(448)
% plot(ProbBlock(V_BG(3,:)'==1),posSac2(V_BG(3,:)'==1),'k.','MarkerSize',10);hold on;
% plot(ProbBlock(V_BG(3,:)'==2),posSac2(V_BG(3,:)'==2),'b.','MarkerSize',10);hold on;
% axis(clims)
