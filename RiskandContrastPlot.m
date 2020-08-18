%%
% load(Spikefile,'BG0','TG0','Sac0','Res0','Unit_channel');
% 
% BG=BG0;
% TG=TG0;
% Sac=Sac0;
% Res=Res0;
clear A
for ii=1:2


    if ii==1
        A.FC.ContrastRisk=BG.FC.ContrastRisk;
        A.ChoicePD.ContrastRisk=BG.ChoicePDChosen.ContrastRisk;
        A.ChoiceNPD.ContrastRisk=BG.ChoicePDNChosen.ContrastRisk;
        t_bg=-100:501;

    else
        A.FC.ContrastRisk=TG.FCPDV.ContrastRisk;
        A.ChoicePD.ContrastRisk=TG.ChoicePDChosen.ContrastRisk;
        A.ChoiceNPD.ContrastRisk=TG.ChoicePDNChosen.ContrastRisk;
        t_bg=-500:1001;

    end


    a=squeeze(nanmean(TG.ChoicePDChosen.ContrastRisk(:,:,:),1));
    clim=[max([-200,min(t_bg)]) 500 nanmin(a(:))-0.2 1.5];

    Colors={'k','c','m'};
    FlagTitle={'Low Risk','Medium Risk','High Risk'};
    figure(ii*2+3)
    for risk=1:3
        subplot(3,3,risk)
        for contrast=1:3
            a=squeeze(nanmean(A.FC.ContrastRisk(:,(contrast*3-3)+risk,:),2));
            plotstd(t_bg,a,char(Colors(contrast)))
            axis(clim); box off;set(gca,'TickDir','out')

        end
        title( FlagTitle(risk))
        if risk==1
            title(['Contrast' FlagTitle(risk)]);
        end
    end

    for risk=1:3
        subplot(3,3,risk+3)
        for contrast=1:3
            a=squeeze(nanmean(A.ChoicePD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
            plotstd(t_bg,a,char(Colors(contrast)))
            axis(clim); box off;set(gca,'TickDir','out')

        end
        title( FlagTitle(risk))
    end


    for risk=1:3
        subplot(3,3,risk+6)
        for contrast=1:3
            a=squeeze(nanmean(A.ChoiceNPD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
            plotstd(t_bg,a,char(Colors(contrast)))
            axis(clim); box off;set(gca,'TickDir','out')

        end
        title( FlagTitle(risk))
    end


    Colors={'b','g','r'};

    FlagTitle={'Low Contrast','Medium Contrast','High Contrast'};
    figure(ii*2+4)
    for contrast=1:3
        subplot(3,3,contrast)
        for risk=1:3
            a=squeeze(nanmean(A.FC.ContrastRisk(:,(contrast*3-3)+risk,:),2));
            plotstd(t_bg,a,char(Colors(risk)))
            axis(clim); box off;set(gca,'TickDir','out')

        end
        title( FlagTitle(contrast))
        if risk==1
            title(['Risk' FlagTitle(risk)]);
        end
    end

    for contrast=1:3
        subplot(3,3,contrast+3)
        for risk=1:3
            a=squeeze(nanmean(A.ChoicePD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
            plotstd(t_bg,a,char(Colors(risk)))
            axis(clim); box off;set(gca,'TickDir','out')

        end
        title( FlagTitle(contrast))
    end


    for contrast=1:3
        subplot(3,3,contrast+6)
        for risk=1:3
            a=squeeze(nanmean(A.ChoiceNPD.ContrastRisk(:,(contrast*3-3)+risk,:),2));
            plotstd(t_bg,a,char(Colors(risk)))
            axis(clim); box off;set(gca,'TickDir','out')

        end
        title( FlagTitle(contrast))
    end

end