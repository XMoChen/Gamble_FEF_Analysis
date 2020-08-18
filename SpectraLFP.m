function SpectraLFP(LFPOrgFile,LFPOrgFigure,filename)
load(LFPOrgFile);
Fs=1000;
NFFT=512;
for ch=1:size(Targ_FireAll,1)
    for contrast=1:size(Targ_FireAll,2)
        for d=1:size(Targ_FireAll,3)
            for v=1:size(Targ_FireAll,4)
                
                for trial=1:size(Targ_FireAll,5)
                    bg1=squeeze(Targ_FireAll(ch,contrast,d,v,trial,1:501));
                    bg2=squeeze(Targ_FireAll(ch,contrast,d,v,trial,1:501));
                    
                    sac=squeeze(Move_FireAll(ch,contrast,d,v,trial,501:1000));
                    rt=squeeze(Result_FireAll(ch,contrast,d,v,trial,201:500));
                  %  isnan(mean(sac))
                  if isnan(mean(sac))~=1 & mean(sac)~=0 & (bg1)~=0
                      [Sac_fft(ch,contrast,d,v,trial,:)]=log(abs(((pmtm(sac,2.5,NFFT,Fs,'eigen')))))-log(abs(((pmtm(bg1,2.5,NFFT,Fs,'eigen')))));
                      [Rest300_fft(ch,contrast,d,v,trial,:)]=log(abs(((pmtm(rt,2.5,NFFT,Fs,'eigen')))))-log(abs(((pmtm(bg2,2.5,NFFT,Fs,'eigen')))));
                      if isinf(nanmean(Sac_fft(ch,contrast,d,v,trial,:)))~=0
                          [Sac_fft(ch,contrast,d,v,trial,:)]=nan(257,1);
                          [Rest300_fft(ch,contrast,d,v,trial,:)]=nan(257,1);
                      end
                  else
                      [Sac_fft(ch,contrast,d,v,trial,:)]=nan(257,1);
                      [Rest300_fft(ch,contrast,d,v,trial,:)]=nan(257,1);
                  end
                end
                
            end
        end
    end
end
[a,f1]=pmtm(sac,4,NFFT,Fs,'eigen');
[a,f2]=pmtm(rt,4,NFFT,Fs,'eigen');

Sac_p500_fft=Sac_fft;
Rest_a500_fft=Rest300_fft;
save(LFPOrgFile,'Sac_p500_fft','Rest_a500_fft','-append');

%%
h10=figure()
subplot(341)
plot(f1,squeeze(nanmean(nanmean(nanmean(nanmean(Sac_fft,5),1),2),4)));
axis([0 150 -inf inf]);
title('Direction');

subplot(345)
plot(f1,squeeze(nanmean(nanmean(nanmean(Sac_fft(:,:,1,:,:,:),5),1),4)));
axis([0 150 -inf inf]);

subplot(346)
plot(f1,squeeze(nanmean(nanmean(nanmean(Sac_fft(:,:,2,:,:,:),5),1),4)));
axis([0 150 -inf inf]);
title('Contrast');

subplot(349)
plot(f1,squeeze(nanmean(nanmean(nanmean(Sac_fft(:,:,1,:,:,:),5),1),2)));
axis([0 150 -inf inf]);

subplot(3,4,10)
plot(f1,squeeze(nanmean(nanmean(nanmean(Sac_fft(:,:,2,:,:,:),5),1),2)));
%legend({'1','2','3'});
title('Value');
axis([0 150 -inf inf]);

subplot(343)
plot(f1,squeeze(nanmean(nanmean(nanmean(nanmean(Rest300_fft,5),1),2),4)));
axis([0 150 -inf inf]);
title('Direction');

subplot(347)
plot(f1,squeeze(nanmean(nanmean(nanmean(Rest300_fft(:,:,1,:,:,:),5),1),4)));
axis([0 150 -inf inf]);

subplot(348)
plot(f1,squeeze(nanmean(nanmean(nanmean(Rest300_fft(:,:,2,:,:,:),5),1),4)));
axis([0 150 -inf inf]);
title('Contrast');

subplot(3,4,11)
plot(f1,squeeze(nanmean(nanmean(nanmean(Rest300_fft(:,:,1,:,:,:),5),1),2)));
axis([0 150 -inf inf]);

subplot(3,4,12)
plot(f1,squeeze(nanmean(nanmean(nanmean(Rest300_fft(:,:,2,:,:,:),5),1),2)));
%legend({'1','2','3'});
title('Value');
axis([0 150 -inf inf]);
suptitle(filename);
print( h10, '-djpeg', [LFPOrgFigure,filename]);
