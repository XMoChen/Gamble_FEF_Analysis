close all
clear all
%main_dir='F:\Projects\GambleMIB\FEFLFPDataOrg\data\';
main_dir='F:\Projects\GambleMIB\FEFLFPDataOrg\';
fileList = dir([main_dir,'*.mat']);
Result_FireSum=[];
Result_FireFFTSum=[];
start_t0=800;
for file_i=1:length(fileList)
    filename=fileList(file_i).name;
    clear ResultFireAll activity_m Targ_FireAll
    load([main_dir,filename],'Move_FireAll');
    Result_FireAll=Move_FireAll;
    figure(file_i)
    activity_m=squeeze(nanmean(nanmean(nanmean(nanmean(nanmean(Result_FireAll,1),2),3),4),5));
    t=(1:size(Result_FireAll,6))-1000;
    if size(Result_FireAll,6)==1001
            t=(1:size(Result_FireAll,6))-500;
            start_t0=300;
    end

    plot(t,squeeze(activity_m));
    axis([-250 500 -inf inf]);
    Result_firing_sub=Result_FireAll(:,:,:,:,:,(start_t0+1):(start_t0+256));
    Result_FireSum=cat(1,Result_FireSum,Result_firing_sub);
    
    
    NFFT=256;
    Fs=1000;
    lfp_tiral=squeeze(Result_FireSum(1,1,1,1,1,:));
    [Pxx,F]=pmtm(lfp_tiral,2.5,NFFT,Fs,'eigen');
    
    for chan=1:size(Result_firing_sub,1)
        for contra=1:size(Result_firing_sub,2)
            for d=1:size(Result_firing_sub,3)
                for v=1:size(Result_firing_sub,4)
                    for trial=1:size(Result_firing_sub,5)
                        lfp_tiral=squeeze(Result_firing_sub(chan,contra,d,v,trial,:));
                        if isnan(lfp_tiral(1))==1 | nanmean(lfp_tiral)==0
                            Result_FireFFT(chan,contra,d,v,trial,:)=nan;
                        else
                            trial_fft=log((((pmtm(lfp_tiral,2.5,NFFT,Fs,'eigen')+10^-20))));
                            Result_FireFFT(chan,contra,d,v,trial,:)=trial_fft(F<150);
                            
                        end
                    end
                end
            end
        end
    end
    
    
    for chan=1:size(Result_firing_sub,1)
        clear Result_FireFFT_m
        Result_FireFFT_m=nanmean(nanmean(nanmean(nanmean(Result_FireFFT(chan,:,:,:,:,:),2),3),4),5);
        for d=1:size(Result_firing_sub,3)
            for v=1:size(Result_firing_sub,4)
                trial0=0;
                for contra=1:size(Result_firing_sub,2)
                    for trial=1:size(Result_firing_sub,5)
                        trial0=trial0+1;
                        % Result_FireFFT0(chan,contra,d,v,trial,:)=Result_FireFFT(chan,contra,d,v,trial,:)-Result_FireFFT_m;
                        
                        Result_FireFFT0(chan,d,v,trial0,:)=Result_FireFFT(chan,contra,d,v,trial,:)-Result_FireFFT_m;
                        
                    end
                end
            end
        end
    end
    Result_FireFFTSum=cat(1,Result_FireFFTSum,Result_FireFFT0);
    
    
end



%% plot fft and raw
figure()
t=(1:size(Result_FireAll,6))-1000;
Result_FireSum_nc=Result_FireFFTSum;%squeeze(nanmean(Result_FireFFTSum,2));
for d=1:size(Result_FireSum,3)
    fire_m=squeeze(nanmean(nanmean(nanmean(Result_FireSum(:,:,d,:,:,:),1),2),5));
    subplot(2,2,d)
    plot(t((start_t0+1):(start_t0+256)),fire_m);
    axis([-250 0 -inf inf]);
end

for d=1:size(Result_FireSum,3)
    fft_m=squeeze(nanmean(nanmean(nanmean(Result_FireFFTSum(:,d,:,:,:),1),2),4));
    subplot(2,2,d+2)
    plot(F(F<150),fft_m);
    axis([0 150 -inf inf]);
end

%% %%%%% dPCA analysis
addpath('F:\Projects\Core\dPCA-master\matlab\');
addpath('C:\Users\Xiaomo\Dropbox\2019FEF_Eligibility_Traces\SFN presentations\SNF2018\');
Result_FireSum_nc0=permute(Result_FireSum_nc,[1,3,2,5,4]);
[firingRates0,trialNum]=dPCA_dataOrg5D(Result_FireSum_nc0);


firingRates=firingRates0;
N = size(firingRates,1);%100;   % number of neurons
T = size(firingRates,4);%20;     % number of time points
S = size(firingRates,2);%7;       % number of value
D = size(firingRates,3);          % number of direction
E = size(firingRates,5);%20;     % maximal number of trial repetitions


time =F(F<150);% (1:size(firingRates,4)) *20/1000-0.5;  % Result


ifSimultaneousRecording = false;  % change this to simulate simultaneous
%                                  % recordings (they imply the same number
%                                  % of trials for each neuron)
% computing PSTHs
firingRatesAverage = nanmean(firingRates, 5);


% Define parameter grouping

combinedParams = {{1, [1 3]}, {2, [2 3]}, {3}, {[1 2], [1 2 3]}};
margNames = {'Value', 'Direction', 'Condition-independent', 'V/D Interaction'};
%margColours = [23 100 171; 187 20 25; 150 150 150; 114 97 171]/256;
margColours = [150 0 0; 150 0 0; 0 0 150; 0 0 200;0 0 250 ;0  200 0;0  250 0]/256;


timeEvents = time(max(find(time>0)));

% check consistency between trialNum and firingRates
for n = 1:size(firingRates,1)
    for s = 1:size(firingRates,2)
        for d = 1:size(firingRates,3)
            assert(isempty(find(isnan(firingRates(n,s,d,:,1:trialNum(n,s,d))), 1)), 'Something is wrong!')
        end
    end
end

% Step 1: dPCA with regularization

optimalLambda = dpca_optimizeLambda(firingRatesAverage, firingRates, trialNum, ...
    'combinedParams', combinedParams, ...
    'simultaneous', ifSimultaneousRecording, ...
    'numRep', 10, ...  % increase this number to ~10 for better accuracy
    'filename', 'tmp_optimalLambdas.mat');

Cnoise = dpca_getNoiseCovariance(firingRatesAverage, ...
    firingRates, trialNum, 'simultaneous', ifSimultaneousRecording);

[W,V,whichMarg] = dpca(firingRatesAverage, 20, ...
    'combinedParams', combinedParams, ...
    'lambda', optimalLambda, ...
    'Cnoise', Cnoise);

explVar = dpca_explainedVariance(firingRatesAverage, W, V, ...
    'combinedParams', combinedParams);

%%
dpca_plot(firingRatesAverage,  W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3,           ...
    'legendSubplot', 16, ...
    'ylims', (4*ones(1,100)));

% Optional: estimating "signal variance"

explVar = dpca_explainedVariance(firingRatesAverage, W, V, ...
    'combinedParams', combinedParams, ...
    'Cnoise', Cnoise, 'numOfTrials', trialNum);

% Note how the pie chart changes relative to the previous figure.
% That is because it is displaying percentages of (estimated) signal PSTH
% variances, not total PSTH variances. See paper for more details.

dpca_plot(firingRatesAverage, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3,           ...
    'legendSubplot', 16, ...
    'ylims', (4*ones(1,100)));



%% plot dpca
X = firingRatesAverage(:,:)';
Xcen = bsxfun(@minus, X, mean(X));
XfullCen = bsxfun(@minus, firingRatesAverage, mean(X)');
N = size(X, 1);
dataDim = size(firingRatesAverage);
Z = Xcen * W;


Dim=size(firingRatesAverage);
Zfull=reshape(Z,[20 Dim(2:end)]);

uni = unique(whichMarg);
componentsToPlot = [];
for u = 1:length(uni)
    componentsToPlot = [componentsToPlot find(whichMarg==uni(u), 3)];
end

figure(11)
Color={'b','m','r','b--','m--','r--','c:','c.','b-','b--','c:','c.','m-','m--','m:','m.'};
% CC=[255,0,0;250,0,0;50,0,0;0,255,0;0,150,0;0,50,0;0,0,255;0,0,150;0,0,50;255,255,255;150,150,150;50,50,50]/255;
% t=downsample(-500:500,20);
t=time;%(1:35);
% t=t+20;
yspan=[-0.3 0.3];
for i=1:length(componentsToPlot)
    subplot(4,3,i)
    a=reshape(Z(:,componentsToPlot(i)),[Dim(2:end)]);
    a0=permute(a,[3,1,2]);
    a_plot=a0(:,:);
    for in=1:size(a_plot,2)
        plot(F(F<150),a_plot(:,in),char(Color(in)),'linewidth',1.2);hold on
    end
    axis([min(t) 150 -8 8]);
    %     if i==7
    %       axis([min(t) 50 -2.5 6]);
    %     end
    %set(gca,'Visible','off')
    box off;set(gca,'TickDir','out')
    axis square
    title(num2str(explVar.componentVar(componentsToPlot(i)),2));
    %     signif=componentsSignif(componentsToPlot(i),:);
    %     signif(signif==0) = nan;
    %     plot(t, signif*0.1 + yspan(1) + (yspan(2)-yspan(1))*0.001, 'k', 'LineWidth', 3)
end


%% Optional: decoding
rp=10;
shulf=1;
decodingClasses = {[(1:S)' (1:S)' ], repmat([1:2], [S 1]), [],  [(1:S)' (S+(1:S))']};

accuracy = dpca_classificationAccuracy(firingRatesAverage, firingRates, trialNum, ...
    'lambda', optimalLambda, ...
    'combinedParams', combinedParams, ...
    'decodingClasses', decodingClasses, ...
    'simultaneous', ifSimultaneousRecording, ...
    'numRep', rp, ...        % increase to 100
    'filename', 'tmp_classification_accuracy.mat');

dpca_classificationPlot(accuracy, [], [], [], decodingClasses)

accuracyShuffle = dpca_classificationShuffled(firingRates, trialNum, ...
    'lambda', optimalLambda, ...
    'combinedParams', combinedParams, ...
    'decodingClasses', decodingClasses, ...
    'simultaneous', ifSimultaneousRecording, ...
    'numRep', rp, ...        % increase to 100
    'numShuffles', shulf, ...  % increase to 100 (takes a lot of time)
    'filename', 'tmp_classification_accuracy.mat');

dpca_classificationPlot(accuracy, [], accuracyShuffle, [], decodingClasses)

componentsSignif = dpca_signifComponents(accuracy, accuracyShuffle, whichMarg);

dpca_plot(firingRatesAverage, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3,           ...
    'legendSubplot', 16,                ...
    'componentsSignif', componentsSignif);
