function Spike_Gamble_Jimmy_ISI(Eventfile,Spikefile,chnum)


close all;
% chnum=ChNum(record);
load(Spikefile,'Target*all','l_ts','SPK*')
load(Eventfile,'InfoTrial');
 
% if exist('table')~=1
%     table=table_all;
% end


clear FFT1 FFTAll
neu=0;
letter={'a','b','c','d','e'};
for ch=1:chnum
    for unit=1:max(find(l_ts(ch,:)>0))
        
        clear Spike Spike_Timing
        try
%             eval(['Spike=','Prob_',num2str(ch),'_',num2str(unit),'all;']);
            try
            eval(['Spike_Timing=','SPK_',num2str(ch),'_',num2str(unit),';']);
            catch
            eval(['Spike_Timing=','SPK_',num2str(ch),num2str(unit),';']);                
            end
        catch
            continue;
%             eval(['Spike=','Prob_',num2str(ch),'_all;']);
%            eval(['Spike_Timing=','SPK_',num2str(ch),'_all;']);
        end
        
        neu=neu+1;
        % get rid of the spikes which are visually triggered
       % Spike_Timing1=Spike_Timing;
        for trial=1:size(Spike_Timing,1)
            clear t
            t=squeeze(Spike_Timing(trial,:));
            t_i=t>InfoTrial.TargetOn(trial)*0.001+0.2 &  t<InfoTrial.TargetOn*0.001+0.8;
            Spike_Timing(trial,t_i)=0;
            T_time(trial)=0.6;
        end
        % ISI
 
        clear ISI_dif Spike_Timing0 T 

                Spike_Timing0=Spike_Timing;
                T_time0=T_time;
              
               
               
        ISI_dif=diff(Spike_Timing0');ISI_dif=ISI_dif(:); ISI_dif=ISI_dif(ISI_dif>0);

        % Total duration
        T=sum(T_time0);%sum(max(Spike_Timing0,[],2)- Spike_Timing0(:,1));
        N=sum(sum(Spike_Timing0>0));
        deltaT=1;
        r=sum(ISI_dif<=0.002);

if r>0
        p=0;%rand(1);
%         p0= fsolve(@(p)FalseError(p,r,deltaT,N,T),p);
%         ISI_15ms(neu)=p0;
        ISI_15msPro(neu)=r/N;
        
else
%         ISI_15ms(neu)=0;
        ISI_15msPro(neu)=r/N;

end
%         P= solve(eqn, p );
%         ISI_3ms(neu)=r/length(ISI_dif);
        % histogram(ISI_dif(ISI_dif<50),1:50);
    end
end

%save(SpikeOrgfile,'Control*','Inact*','SpikeAllCond');
 save(Spikefile,'ISI_15msPro','-append');
end
        function F=FalseError(p,r,deltaT,N,T)
        F=r-(2* deltaT * (N.^2) *(1-p) *p )/T;
        end
