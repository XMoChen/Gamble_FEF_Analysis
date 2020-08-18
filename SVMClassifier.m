function oosLoss1=SVMClassifier(r0,X)
category=(unique(X));
                t=templateSVM('Standardize',1);
%                 rng(1) % For reproducibility
                Mdl=fitcecoc(r0,X,'Learner',t,'Prior','uniform');
%                 oosLoss1=1-kfoldLoss(Mdl);
                CVMdl=crossval(Mdl);
                oosLoss1=kfoldLoss(CVMdl);