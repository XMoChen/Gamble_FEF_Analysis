function [aa1,aa1per]=ContrastClassPer(I_sub, I,opt,sp0,lb3,perN)
%%%%% I_sub subset of the trials
%%%%% SubI subcategory index
%%%%% SubI_opt   subcategory label
%%%%% sp0 data
%%%%% label
%%%%% PerN  permultation number

for o=1:length(opt)
    
    clear II
    %%%% no choice: test whether different options in PD modulate contrast
    %%%% info
    II=I_sub & (I==opt(o)) ;
   % [aa1(o),aa1per(o,:)]=RFClassifierPer(sp0(:,II)',lb3(II),perN);
    [aa1(o),aa1per(o,:)]=SVMClassifierPer(sp0(:,II)',lb3(II),perN);

end   
    
%     clear I
%     %%%% choice: test whether different options in PD modulate contrast
%     %%%% info
%     I=(InfoTrial.ChoiceD~=0  & (I==opt(o)) & InfoTrial.Targ2Opt~=0  & InfoTrial.DChoice(:,1)==1);
%     % aa2(t,o)=1-SVMClassifier(sp0(:,I)',lb3(I));
%     [aa2(o),aa2per(o,:)]=RFClassifierPer(sp0(:,I)',lb3(I),perN);
%     
%     
%     clear I
%     %%%% choice: test whether different options in PD modulate contrast
%     %%%% info
%     I=(InfoTrial.ChoiceD~=0  & (I==opt(o)) & InfoTrial.Targ2Opt~=0  & InfoTrial.DChoice(:,1)==-1);
%     % aa2(t,o)=1-SVMClassifier(sp0(:,I)',lb3(I));
%     [aa3(o),aa3per(o,:)]=RFClassifierPer(sp0(:,I)',lb3(I),perN);
%     
% end

