function [oosLoss1,oosLoss1_per]=SVMClassifierPer(r0,X,perN)
category=(unique(X));
                t=templateSVM('Standardize',1);
%                 rng(1) % For reproducibility
                Mdl=fitcecoc(r0,X,'Learner',t,'Prior','uniform');
%                 oosLoss1=1-kfoldLoss(Mdl);
                CVMdl=crossval(Mdl);
                oosLoss1=1-kfoldLoss(CVMdl);
                
for per=1:perN
    X=X(randperm(length(X)),:);
   % II0=I0;
                t=templateSVM('Standardize',1);
%                 rng(1) % For reproducibility
                Mdl=fitcecoc(r0,X,'Learner',t,'Prior','uniform');
%                 oosLoss1=1-kfoldLoss(Mdl);
                CVMdl=crossval(Mdl);
                oosLoss1_per(per)=1-kfoldLoss(CVMdl);
end
% 