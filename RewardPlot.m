function A=RewardPlot(InfoTrial,result0,N_neu,plotflag)

C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;
%nochoice
%1-5 pd reward 1-5  type 1
%6-10 pd reward 1-5  type 2
%11-15 npd reward 1-5  type 1
%16-20 npd reward 1-5  type 2
%choice
%21-25 pd reward 1-5  type 1
%26-30 pd reward 1-5  type 2
%31-35 npd reward 1-5  type 1
%36-40 npd reward 1-5  type 2

% 
figure(N_neu)
tr=-501:500;
RewardA=[1*10^(-3),1,2,3,4];
ColorRW={'r:','g:','b','g','r'};
% subplot(221)
%%% for legend
% for result=1:5
% %     rp=1;%:6
%     I=InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1  & InfoTrial.Reward==RewardA(result) & InfoTrial.RewardPattern<=2;
%     if plotflag==1
%         figure(N_neu)
%         r0=nanmean(result0);
%         plot(tr,r0,char(ColorRW(result)),'LineWidth',1);hold on;
%     end
% %     legend({'0','1','2','3','4','5'})
% 
% end

% for d=1:2
%     subplot(2,2,d)
%     for result=1:5
%         I1=InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,d)==1  & InfoTrial.Reward==RewardA(result) ;%& InfoTrial.RewardPattern<=2;
% %         I2=InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,d)==1  & InfoTrial.Reward==RewardA(result) & InfoTrial.RewardPattern>2;
%     A(result+(d-1)*10,:)= nanmean(result0(I1,:),1);
% %     A(result+5+(d-1)*10,:)= nanmean(result0(I2,:),1);
%    
%         if plotflag==1
%             plot(tr,nanmean(result0(I1,:),1),char(ColorRW(result)),'LineWidth',1.5);hold on
% %             plot(tr,nanmean(result0(I2,:),1),char(ColorRW(result)),'LineWidth',1.5);hold on
%             box off;set(gca,'TickDir','out')
%             if d==1
%                 title('FC  PD');
%             else
%                 title('FC  NPD');
%             end
%         end
%         
%     end
% end



for d=1:2
    for result=1:5
        I1= InfoTrial.ContrastBG==1 & InfoTrial.DChoice(:,d)==1  & InfoTrial.Reward==RewardA(result);% & InfoTrial.RewardPattern<=2;
        I2= InfoTrial.ContrastBG>1 & InfoTrial.DChoice(:,d)==1  & InfoTrial.Reward==RewardA(result);% & InfoTrial.RewardPattern<=2;
    A(result+(d-1)*5,:)= nanmean(result0(I1,:),1);
    A(result+(d-1)*5+10,:)= nanmean(result0(I2,:),1);

    end
end

rmin=min(A(:))*0.7; 
rmax=25;%max(A(:))*1.1;
for d=1:2
    for result=1:5
        if plotflag==1
            subplot(2,2,d)
            I1= InfoTrial.ContrastBG==1 & InfoTrial.DChoice(:,d)==1  & InfoTrial.Reward==RewardA(result);% & InfoTrial.RewardPattern<=2;
            plot(tr,nanmean(result0(I1,:),1),char(ColorRW(result)),'LineWidth',1.5);hold on
%             plot(tr,nanmean(result0(I2,:),1),char(ColorRW(result)),'LineWidth',1.5);hold on
             axis([-300 400 rmin rmax]);
             box off;set(gca,'TickDir','out')
             
            subplot(2,2,d+2)
            I1= InfoTrial.ContrastBG>1 & InfoTrial.DChoice(:,d)==1  & InfoTrial.Reward==RewardA(result);% & InfoTrial.RewardPattern<=2;
            plot(tr,nanmean(result0(I1,:),1),char(ColorRW(result)),'LineWidth',1.5);hold on
%             plot(tr,nanmean(result0(I2,:),1),char(ColorRW(result)),'LineWidth',1.5);hold on
             axis([-300 400 rmin rmax]);
             box off;set(gca,'TickDir','out')

            if d==1
                title('PD');
            else
                title('NPD');
            end
        end
    end
end
A=Scale(A);