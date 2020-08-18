% posner_opentrial
% Initializes a new trial

% Increment trialnum
trialnum = trialnum + 1;
disp(num2str(trialnum))


% Trial timing vars
ITIstart = NaN; % start of ITI
ITIend = NaN;   % end of ITI
fixon = NaN;    % fixation appearance
fixacq = NaN;   % fixation acquired
fixoff = NaN;   % fixation removal
targon = NaN;  % stimuli appearance
targoff = NaN; % stimuli off
goCue = NaN;
targAcq = NaN;  % target acquisition
trialstart = NaN;   % start of the trial
juiceTime = NaN;

alltimes = [];

% Timing for this trial:
iti = itimin + ((itimax - itimin) .* rand(1,1));
fixHold = fixHoldMin + ((fixHoldMax - fixHoldMin) .* rand(1,1));
targGap = targGapMin + ((targGapMax - targGapMin) .* rand(1,1));

if rand(1,1) < pNoGap
    noGap = 1
else
    noGap = 0;
end

% Error vars
error_made = NaN;   % error flag
errortype = NaN;    % type of error made (1 = brokefix, 2 = nochoice (t), 3 = brokechoice)
brokeFixTime = NaN; % time of broken fixation
correct = NaN;  % flag for correct trial

% load the chosen stimulus, make the texture
img = imageIdx{ImageSequence(trialnum)};
% imgIndx = Screen('MakeTexture', w, img);

CurrentDirection=ImageDirection(trialnum);
targRect = [targOrigin(CurrentDirection,:) targOrigin(CurrentDirection,:)] + [-targSize -targSize targSize targSize];
targError = [targOrigin(CurrentDirection,:) targOrigin(CurrentDirection,:)] + [-targ_err -targ_err targ_err targ_err];


% Initialize sample data
global samples
sample_size = 0;

if EYEBALL
    while ~sample_size
        sample_size = size(Eyelink('GetQueuedData'), 1);
    end
end

samples = NaN(sample_size,1);

% Display boxes in Eyelink
if EYEBALL
    
    Eyelink('command', 'clear_screen %d', 0);
    Eyelink('command', 'draw_cross %d %d 15', env.screenWidth/2, env.screenHeight/2);
    Eyelink('command', 'draw_box %d %d %d %d 15', round(fixWindow(1)), round(fixWindow(2)), round(fixWindow(3)), round(fixWindow(4)));
    
%     Eyelink('command', 'draw_box %d %d %d %d 15', round(actualBox(1)), round(actualBox(2)), round(actualBox(3)), round(actualBox(4)));
    
end