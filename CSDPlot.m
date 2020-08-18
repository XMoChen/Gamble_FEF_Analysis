load(LFPfile,'LFP_Target*','LFP_Background*')
load(Eventfile,'InfoTrial','InfoExp');
InfoExp.Orientation=ones(size(InfoExp.RewardLeft))';
C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;

for ch=1:16
    eval(['a=LFP_Target_',num2str(ch),';']);
    eval(['b=LFP_Background_',num2str(ch),';']);
 
    I_a=InfoTrial.ContrastBG==3 & InfoTrial.ChoiceD>0;
    LFP_TG_mean(ch,:)=nanmean(bsxfun(@minus,a(I_a,500:1100),nanmean(a(I_a,50:100),2)),1);
    
    I_b=InfoTrial.Targ2Opt==0  & InfoTrial.DChoice(:,1)==1 ;
    LFP_BG_mean(ch,:)=nanmean(bsxfun(@minus,b(I_b,100:700),nanmean(b(I_b,50:100),2)),1);

end

figure(1)
subplot(221)
redblueCSD;
PlotLFPRaw(-100:500,1:16,LFP_BG_mean,[-max(LFP_BG_mean(:)),max(LFP_BG_mean(:))]);
colormap(color);

el_pos=(0.15:0.15:0.15*size(LFP_BG_mean,1));
CSD = computeCSD(LFP_BG_mean, el_pos,'spline');

subplot(222)
imagesc(CSD)


subplot(223)
redblueCSD;
PlotLFPRaw(-100:500,1:16,LFP_TG_mean,[-max(LFP_TG_mean(:)),max(LFP_TG_mean(:))]);
colormap(color);

el_pos=(0.15:0.15:0.15*size(LFP_BG_mean,1));
CSD = computeCSD(LFP_TG_mean, el_pos,'spline');

subplot(224)
imagesc(CSD)
% PlotLFPRaw(-100:500,1:16,CSD,[-max(CSD(:))*0.9,max(CSD(:))*0.9] );colorbar

