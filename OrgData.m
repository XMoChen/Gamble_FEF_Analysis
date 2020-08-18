                ChoiceAll_label=[];ChoiceAll=[];
                FChoiceAll_label=[];FChoiceAll=[];
                for contrast=1:3
                    for opt1=1:4
                        for opt2=1:4
                            
                            clear I0
                            I0=InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,preDir)==risk_l(opt1) &  InfoTrial.DOpt(:,3-preDir)==risk_l(opt2) ;
                            if sum(I0)>0
                                
                                for choice=1:2
                                    
                                    
                                    clear label r0 I0
                                    %%%%%%%%%%%%% Force choice
                                    if period<3
                                        if choice==1
                                            I0=InfoTrial.Targ2Opt==0 & InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,preDir)==risk_l(opt1) &  InfoTrial.DOpt(:,3-preDir)==risk_l(opt2)  &  InfoTrial.DChoice(:,preDir)==1;
                                        else
                                            I0=InfoTrial.Targ2Opt==0 & InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,preDir)==risk_l(opt1) &  InfoTrial.DOpt(:,3-preDir)==risk_l(opt2)  &  InfoTrial.DChoice(:,3-preDir)==1;
                                        end
                                    else
                                        if choice==1
                                            I0=InfoTrial.Reward>0  & InfoTrial.Targ2Opt==0 & InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,preDir)==risk_l(opt1) &  InfoTrial.DOpt(:,3-preDir)==risk_l(opt2)  &  InfoTrial.DChoice(:,preDir)==1;
                                        else
                                            I0=InfoTrial.Reward>0  & InfoTrial.Targ2Opt==0 & InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,preDir)==risk_l(opt1) &  InfoTrial.DOpt(:,3-preDir)==risk_l(opt2)  &  InfoTrial.DChoice(:,3-preDir)==1;
                                        end
                                    end
                                    
                                                                if sum(I0)>=15
                                                                    r0=Spike_BG(I0,:);
                                                                    a_s_i=randsample(sum(I0),15);
                                                                    FChoiceAll=cat(1,FChoiceAll,r0(a_s_i,:));
                                                                elseif sum(I0)>0
                                                                    r0=Spike_BG(I0,:);
                                                                    a_s_i=randsample(sum(I0),15,true);
                                                                    FChoiceAll=cat(1,FChoiceAll,r0(a_s_i,:));
                                                                else
                                                                    FChoiceAll=cat(1,FChoiceAll,nan(15,size(Spike_BG,2)));
                                                                end
                                                                label(1:15,1)=contrast;
                                                                label(1:15,2)=risk_l(opt1);
                                                                label(1:15,3)=risk_l(opt2);
                                                                label(1:15,4)=choice;
                                                                FChoiceAll_label=cat(1,FChoiceAll_label,label);
%                                     if sum(I0)>0
%                                         r0=Spike_BG(I0,:);
%                                         FChoiceAll=cat(1,FChoiceAll,r0);
%                                         label(1:sum(I0),1)=contrast;
%                                         label(1:sum(I0),2)=risk_l(opt1);
%                                         label(1:sum(I0),3)=risk_l(opt2);
%                                         label(1:sum(I0),4)=choice;
%                                         FChoiceAll_label=cat(1,FChoiceAll_label,label);
%                                     end
                                    
                                    
                                    
                                    clear label r0 I0
                                    %%%%%%%%%%%%% choice
                                    if period<3
                                        I0=InfoTrial.Targ2Opt~=0 & InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,preDir)==risk_l(opt1) &  InfoTrial.DOpt(:,3-preDir)==risk_l(opt2)  &  InfoTrial.DChoice(:,preDir)==2*(choice-1.5);
                                    else
                                        I0=InfoTrial.Targ2Opt~=0 & InfoTrial.ContrastBG==contrast &  InfoTrial.DOpt(:,preDir)==risk_l(opt1) &  InfoTrial.DOpt(:,3-preDir)==risk_l(opt2) &  InfoTrial.Reward>0  &  InfoTrial.DChoice(:,preDir)==2*(choice-1.5);
                                    end
                                    
                                    if sum(I0)>0
                                        r0=Spike_BG(I0,:);
                                        ChoiceAll=cat(1,ChoiceAll,r0);
                                        label(1:sum(I0),1)=contrast;
                                        label(1:sum(I0),2)=risk_l(opt1);
                                        label(1:sum(I0),3)=risk_l(opt2);
                                        label(1:sum(I0),4)=choice;
                                        ChoiceAll_label=cat(1,ChoiceAll_label,label);
                                    end
                                    %   sum(I0)
                                    %                                 if sum(I0)>=15
                                    %                                     r0=Spike_BG(I0,:);
                                    %                                     a_s_i=randsample(sum(I0),15);
                                    %                                     ChoiceAll=cat(1,ChoiceAll,r0(a_s_i,:));
                                    %                                 elseif sum(I0)>0
                                    %                                     r0=Spike_BG(I0,:);
                                    %                                     a_s_i=randsample(sum(I0),15,true);
                                    %                                     ChoiceAll=cat(1,ChoiceAll,r0(a_s_i,:));
                                    %                                 else
                                    %                                     ChoiceAll=cat(1,ChoiceAll,nan(15,size(Spike_BG,2)));
                                    %                                 end
                                    %                                 label(1:15,1)=contrast;
                                    %                                 label(1:15,2)=risk_l(opt1);
                                    %                                 label(1:15,3)=risk_l(opt2);
                                    %                                 label(1:15,4)=choice;
                                    %                                 ChoiceAll_label=cat(1,ChoiceAll_label,label);
                                    
                                    
                                end
                            end
                        end
                    end
                end