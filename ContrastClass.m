function [aa1,aa2,aa3]=ContrastClass(InfoTrial,sp0,lb3)
for o=1:3
    
    clear I
    %%%% no choice: test whether different options in PD modulate contrast
    %%%% info
    I=(InfoTrial.ChoiceD~=0  & (InfoTrial.DOpt(:,1)==opt(o)) & InfoTrial.Targ2Opt==0 );
    [aa1(o)]=RFClassifier(sp0(:,I)',lb3(I));
    
    
    clear I
    %%%% choice: test whether different options in PD modulate contrast
    %%%% info
    I=(InfoTrial.ChoiceD~=0  & (InfoTrial.DOpt(:,1)==opt(o)) & InfoTrial.Targ2Opt~=0  & InfoTrial.DChoice(:,1)==1);
    % aa2(t,o)=1-SVMClassifier(sp0(:,I)',lb3(I));
    [aa2(o)]=RFClassifier(sp0(:,I)',lb3(I));
    
    
    clear I
    %%%% choice: test whether different options in PD modulate contrast
    %%%% info
    I=(InfoTrial.ChoiceD~=0  & (InfoTrial.DOpt(:,1)==opt(o)) & InfoTrial.Targ2Opt~=0  & InfoTrial.DChoice(:,1)==-1);
    % aa2(t,o)=1-SVMClassifier(sp0(:,I)',lb3(I));
    [aa3(o)]=RFClassifier(sp0(:,I)',lb3(I));
    
end

%
%     clear I
%     %%%% no choice: test option influce detectability of the option (left
%     %%%% vs right)
%     I=(InfoTrial.ChoiceD~=0  & (InfoTrial.DOpt(:,1)==opt(o) | InfoTrial.DOpt(:,2)==opt(o) ) & InfoTrial.Targ2Opt==0 );
%     aa3(o)=1-RFClassifier(sp0(:,I)',lb0(I));
%
%
%
%     clear I
%     I=(InfoTrial.ChoiceD~=0 & (InfoTrial.DOpt(:,1)+InfoTrial.DOpt(:,2)==optsum(o)) & InfoTrial.Targ2Opt~=0 );
%     %%%% choice: test option combination influce detectability of movement direction (left
%     %%%% vs right)
%     aa4(o)=1-RFClassifier(sp0(:,I)',lb0(I));
%
%     end
%
%
%     for contrast=1%:3
%         clear I
%         if period==1
%             I=(InfoTrial.ChoiceD~=0  & InfoTrial.ContrastBG==3 & InfoTrial.Targ2Opt==0 );
%         else
%             I=(InfoTrial.ChoiceD~=0  & InfoTrial.ContrastBG==3 & InfoTrial.Targ2Opt==0 & InfoTrial.DChoice(:,1)==1);
%         end
%
%          aa5(contrast)=1-SVMClassifier(sp0(:,I)',lb1(I));
%     end