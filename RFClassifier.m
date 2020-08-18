function Loc_error=RFClassifier(a0,I0)
% 
% i00=unique(I0);
% for i=1:length(i00)
%     Num(i)=sum(I0==i00(i));
% end
  %  pri=(sum(Num)*onese(1,length(i00))-Num)/(length(i00)-1)*sum(Num);

% aa0=[];  
% II0=[];
% for i=1:length(i00)
%     
%         a_s_i=randsample(sum(I0==i00(i)),min(Num));
%         ai=a0(I0==i00(i),:);
%         as=ai(a_s_i,:);
%         aa0=cat(1,aa0,as);
%         II0=cat(1,II0,i00(i)*ones(min(Num),1));       
% end
%    
aa0=a0;
II0=I0;
% if (max(Num)-min(Num))/sum(Num)<(1/length(i00))*0.5
rng(1); % For reproducibility
Mdl = TreeBagger(50,aa0,II0,'OOBPrediction','On','Method','classification','NumPredictorsToSample',...
      'all','Prior','uniform','PredictorSelection','curvature' );%'interaction-curvature'
%Mdl = TreeBagger(50,a0,I0,'OOBPrediction','On','Method','classification');
error=oobError(Mdl);
Loc_error=error(end);


% 
% 
% else
% %%% better with imbalanced number of samples for 100 sample in class A and
% %%% only 10 in class B
% t = templateTree;%('Surrogate','on');
% Mdl=fitcensemble(a0,I0, 'NumLearningCycles',50,'Method','RUSBoost','Learners',t,'CrossVal','on');
% kflc = kfoldLoss(Mdl);
% Loc_error=kflc(end);

% end
