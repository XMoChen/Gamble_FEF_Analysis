function FixationTrainingRigB(filename,mode)
filename='test';
mode='EYE';
try
    ListenChar(2);
    
    express_params_g;    % Load the parameters
    openTask_g; % general rig specific
    express_opentask_g;  % Open the task

    while trialnum < ntrials && continue_running
        express_opentrial_g; % Initialize a new trial
        express_runtrial_g;  % Run the trial
        express_closetrial_g;    % Close the trial
    end
    closeTask; % general rig specific function
    ListenChar(0);               
    
catch
    
    sca;
    ListenChar(0);
    closeDIO;
    commandwindow;
    rethrow(lasterror);
    q = lasterror
    
end 
