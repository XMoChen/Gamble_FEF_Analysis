%    function SpikeOrgRigB(filename,Spikefile,Eventfile)
     filename=plx_filename;
     [n, Time5, Code5] = plx_event_ts(filename, 5);
     [n, Time7, Code7] = plx_event_ts(filename, 7);

% Event01=PL2EventTs(filename, 'EVT01');
% Event02=PL2EventTs(filename, 'EVT01');
% Event01 = Event01.Ts;
% Event02 = Event02.Ts;
 Event01 =Time5;
 Event02 =Time7;

trialstart=Time5;
trialsend=Time7;

if length(Event02)<length(Event01)
trialsend(length(Event01))=Event01(length(Event01));
end



Flag={'a','b','c','d','e','f'};


%%%%% number of spikes per channel
tcounts=plx_info(filename,1);
l_ts=zeros(16,5);
for ch=1:16
    l_ts(ch,1:length(nonzeros(tcounts(:,ch+1))))=nonzeros(tcounts(:,ch+1));
end
%%
for ch=1:16
    for unit=1:length(l_ts(ch,:))
        if l_ts(ch,unit)~=0
            clear a trial ts substract

            [n,spike_ts]=plx_ts(filename,ch,unit-1);
            a=spike_ts;
            %             a=PL2Ts(filename,['SPK0',num2str(ch)],unit-1);
            for trial=1:length(trialstart)
            clear substract currentspike
            currentspike=a(a>=trialstart(trial) & a<=trialsend(trial));
            % align on trial start ms
            substract=(currentspike-trialstart(trial));
           if isempty(substract)~=1
            ts(trial,1:length(substract))=substract;
           else
            ts(trial,:)=0;
           end
            eval(['SPK_',num2str(ch),num2str(unit),'=ts;']);
            end
%             end
        end
    end
end
%%
save(Spikefile,'SPK*','l_ts','trialstart','trialsend');
save(Eventfile,'trialstart','trialsend','-append');