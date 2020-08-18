% posner_runtrial.m
% Runs a posner cued target trial based on the parameters specified

try
 
    esc_check;
    
    error_made = 0;
    
    % ITI period starts
    ITIstart = GetSecs;
    
    % ITI (while gathering pupil data / checking for esc)
    while (GetSecs - ITIstart) < iti
        sampleEye;
    end
    
    % ITI period ends
    ITIend = GetSecs;
    
    Eyelink( 'Message', 'Image %ld', ImageSequence(trialnum));    
    Eyelink( 'Message', 'Direction %ld', CurrentDirection);    

    % Trial starts
    trialstart = GetSecs;
    Eyelink( 'Message', 'Trialstart');    

    sampleEye;  % (does nothing if EYEBALL)
    
    % Fixation onset
    Screen(w,'FillOval',fixcolor,fixRect);
    fixon = Screen(w,'Flip');
    Eyelink( 'Message', 'FixationOn');    

    sampleEye;
    
    % Wait for fixation
    fixed = 0;
    while (GetSecs - fixon) < time2fix && ~fixed
        fixed = checkFix(origin, fix_err, space);
    end
    
    % If fixation acquired, record time of acquisition
    if fixed
        Eyelink( 'Message', 'FixationIn');    
        fixacq = GetSecs;
    else
        fixacq = 0;
        error_made = 1;
        errortype = 1;  % no fixation
    end
    
    % Hold fixation
    while ((GetSecs - fixacq) < fixHold) && fixed
        
        fixed = checkFix(origin, fix_err, space);
        
        if ~fixed
            error_made = 1;
            errortype = 2;  % broken fixation
        end
        
    end
    
    Eyelink('command','draw_box %d %d %d %d 15', round(targError(1)), round(targError(2)),round(targError(3)),round(targError(4)));
    sampleEye;
    if ~error_made % fix off and target on time

            % then targ onset
            Screen(w, 'PutImage', img, targRect);

%             Screen('DrawTexture',w,imgIndx,[],targRect);
            targon = Screen(w,'Flip');
            Eyelink('Message', 'TargetOn');

        
    end
    
    if ~error_made % Continue without overlap period
        
        % check for target acquisition
        acquired = 0;
        while ((GetSecs - targon) < time2choose) && ~acquired
            if checkFix(targOrigin, targ_err, up);
                targAcq = GetSecs();
                acquired = 1;
                Eyelink('Message', 'TargetIn');

            else
                sampleEye;
                esc_check;
            end
        end
        
        if ~acquired
            
            error_made = 1; % see if he's still fixing
            fixed = checkFix(origin, fix_err, space);
            
            if fixed
                errortype = 4;  % Didn't move eyes
            else
                errortype = 5;  % Didn't choose targ
            end
            
        end
        
    end
    
    if ~error_made % Hold fixation of chosen targ
        
        % Hold fixation of target
        held = 1;
        while ((GetSecs - targAcq) < targHoldTime) && held
            
            held = checkFix(targOrigin, targ_err, up);
            
            if ~held
                error_made = 1;
                errortype = 6;  % broke targ fixation
            else
                sampleEye;
                esc_check;
            end
            
        end
        
        % Remove targs from the screen
        
    end
    
    % Some type of error in the trial
    if error_made
        
        %Screen(w,'FillRect',errorColor,errorRect);
        %errorFeedback = Screen(w,'Flip'); 
%         while ((GetSecs - errorFeedback) < errorSecs)
%             sampleEye;
%             esc_check;
%         end
        
        correct = 0;
        trialstop = GetSecs();

        if errortype == 1 % No fixation
            
            % CODE FOR NO FIX
            
        elseif errortype == 2 % Broken fixation, overlap
            
            % CODE FOR BROKEN FIX, OVERLAP
            
        elseif errortype == 3 % Broken fixation, gap
            
            % CODE FOR BROKEN FIX, GAP
        
        elseif errortype == 4 % Didn't move eyes from fixation
            
            % CODE FOR NO EYE MOVE TO TARG
            
        elseif errortype == 5 % No target selected
            
            % CODE FOR NO TARG CHOSEN
            
        elseif errortype == 6 % Broke target fixation
            
            % CODE FOR BROKE TARG FIX
            
        end
        errortype
        
    else % No errors, correct trial
        Eyelink( 'Message', 'Reward');
%         juiceTime = markEvent('juice');
%         giveJuice_G;
         giveJuice_GN(4);
%          beep;
        correct = 1
        trialstop = GetSecs();
        
    end
    
catch
    
    %sca
    fprintf('ERROR')
    q = lasterror;
    
    rethrow(lasterror);
    
    correct = 0;
    
end