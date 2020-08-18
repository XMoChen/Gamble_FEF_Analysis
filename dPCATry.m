%clear all

load(Spikefile_L,'BackgroundRate');
%load(Spikefile,'BackgroundRate');
load(Eventfile,'InfoTrial');
load(Spikefile,'l_ts');


%%
I_choice=InfoTrial.Targ2Opt>0 & InfoTrial.ChoiceD>0; sum(I_choice);
I_NC=InfoTrial.Targ2Opt==0 & InfoTrial.ChoiceD>0; sum(I_choice);


C1=(InfoTrial.Background<=6);
InfoTrial.ContrastBG(C1,1)=1;
C2=(InfoTrial.Background>6 & InfoTrial.Background<=12 );
InfoTrial.ContrastBG(C2,1)=2;
C3=(InfoTrial.Background>12 );
InfoTrial.ContrastBG(C3,1)=3;


a=BackgroundRate.Ch1Unit2;
plot(mean(a,1));

tcounts=plx_info(plx_filename,1);
l_ts=zeros(Ch_num,5);
for ch=1:Ch_num
    maxn=max(find((tcounts(:,ch+1))>0));
    l_ts(ch,1:maxn)=tcounts(1:maxn,ch+1);
end

unit_all=0;
for ch=1:Ch_num
    for unit=1:max(find(l_ts(ch,:)>0))
        if l_ts(ch,unit)>10000
            
            clear f f0
            eval(['f=BackgroundRate.Ch',num2str(ch),'Unit',num2str(unit),';']);
            % f=reshape(zscore(f(:)),size(f,1),size(f,2));%ScaleMean(f);%
            f0=downsample(f',20)';
            if max(mean(f0,1))>5 %& ttest(f0(I_choice,55),f0(I_choice,1))==1
                unit_all=unit_all+1;
                
                for contrast=1:3
                    for choice=1:2
                        u1=0;
                        for Opt1=[2,11,12]
                            u1=u1+1;
                            u2=0;
                            for Opt2=[2,11,12]
                                u2=u2+1;
                                
                                
                                clear ID ID_NC
                                ID=I_choice & InfoTrial.ContrastBG==contrast & InfoTrial.ChoiceD==choice & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==Opt1 & InfoTrial.DOpt(:,2)==Opt2;
                                ID_NC=I_NC & InfoTrial.ContrastBG==contrast & InfoTrial.ChoiceD==choice & InfoTrial.Reward>0 & InfoTrial.DOpt(:,1)==Opt1 & InfoTrial.DOpt(:,2)==Opt2;
                                
                                f00=cat(1,f0( ID==1,:), f0( ID_NC==1,:));
                                f00=zscorematrix(f00);%reshape(zscore(f00(:)),size(f00,1),size(f00,2));
                                firingRates(unit_all,contrast,choice,u1,u2,:,1:sum(ID))=f00(1:sum(ID),:)';
                                firingRates(unit_all,contrast,choice,u1,u2,:,(1+sum(ID)):150)=nan;
                                trialNum(unit_all,contrast,choice,u1,u2)=sum(ID);
                                %             FR_info(unit_all,contrast,choice,1:sum(ID),1)=InfoTrial.DOpt(ID==1,1);
                                %             FR_info(unit_all,contrast,choice,1:sum(ID),2)=InfoTrial.DOpt(ID==1,2);
                                
                                
                                firingRates_NC(unit_all,contrast,choice,u1,u2,:,1:sum(ID_NC))=f00((sum(ID)+1):end,:)';
                                firingRates_NC(unit_all,contrast,choice,u1,u2,:,(1+sum(ID_NC)):150)=nan;
                                trialNum_NC(unit_all,contrast,choice,u1,u2)=sum(ID_NC);
                                %             FR_info_NC(unit_all,contrast,choice,1:sum(ID_NC),1)=InfoTrial.DOpt(ID_NC==1,1);
                                %             FR_info_NC(unit_all,contrast,choice,1:sum(ID_NC),2)=InfoTrial.DOpt(ID_NC==1,2);
                            end
                        end
                    end
                end
            end
        end
    end
end

clear a0 a0_NC
firingRatesAverage=squeeze(nanmean(firingRates,7));
a0=permute(firingRatesAverage,[6,1,2,3,4,5]);

firingRatesAverage_NC=squeeze(nanmean(firingRates_NC,7));
a0_NC=permute(firingRatesAverage_NC,[6,1,2,3,4,5]);
%%
t=downsample(-300:2500,20);
color={'k','b','r'};
for contrast=1:3
    for direction=1:2
        clear a00**
        a00=squeeze(a0(:,:,contrast,direction,:,:));
        a00_NC=squeeze(a0_NC(:,:,contrast,direction,:,:));
        
        subplot(2,2,direction)
        plot(t,nanmean(a00_NC(:,:),2),char(color(contrast)));hold on;
        axis([-200 inf , -inf inf]);
        subplot(2,2,direction+2)
        plot(t,nanmean(a00(:,:),2),char(color(contrast)));hold on;
        axis([-200 inf ,  -inf inf]);
    end
end

%save(Spikefile_L,'firingRates*','trialNum*','InfoTrial','FR_info*','-append');