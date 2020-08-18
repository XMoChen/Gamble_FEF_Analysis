% posner_opentask.m
% Initializes the screen for the posner task, the data output, and the
% target stimuli used throughout the task

% Initialize trial number
trialnum = 0;

% Flag to keep running task
continue_running = 1;

% Set the ITI for the first trial.
iti = itimin + (itimin - itimax) .* rand(1,1);

%% Ensure output

% Initialize outputs
global task_data;
task_data = struct();
global trial_data;
trial_data = struct([]);

% Connection with Eyelink if not in testing mode
if EYEBALL
    try,       
        if Eyelink('IsConnected') ~= 1
            disp('Trying to connect to Eyelink, attempt #1(/2):');
            r = Eyelink('Initialize');
            if r ~= 0
                WaitSecs(.5) % wait half a sec and try again
                disp('Trying to connect to Eyelink, attempt #2(/2):');
                r = Eyelink('Initialize');
            end
        elseif Eyelink('IsConnected') == 1
            r = 0; % means OK initialization
        end

        if r == 0;
            disp('Eyelink successfully initialized!')
            % Get origin
            eyeparams.origin = origin;

            Eyelink('Command', 'screen_pixel_coords = %d %d %d %d', ...
                rect(1), rect(2), rect(3), rect(4) );
            Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA,PUPIL');
            edfname = strcat(filename,'.edf');
            Eyelink('openfile',edfname);

            % Calibrate tracker
            Eyelink('StartSetup');
            Eyelink('DriftCorrStart', origin(1), origin(2));
            Eyelink('ApplyDriftCorr');

            % Start of the task
            taskstart = GetSecs;
        elseif r ~= 0
            % If Eyelink can't initialize: report error and quit
            disp('Eyelink failed to initialize, check connections');
            continue_running = 0;
        end

    catch
        % If Eyelink can't initialize: report error and quit
        disp('Eyelink failed to initialize, check connections');
        continue_running = 0;
    end
end

% Name datafile in case it was forgotten
if ~exist('filename')
    disp('Subject name not provided, using unnamed as name')
    subject = sprintf('unnamed');
else
    subject = filename;
end;

% Create directory where data will be stored
filestart = filename;
filename0=strcat(dataDirectory,splitChar,filename);
mkdir(filename0)
cd(filename0)
dataDirectory=filename0;
% filename = strcat(filename,'_g');
backhome = pwd;

% cd(dataDirectory)
% 
% files = dir;
% files = {files([files.isdir]==1).name};
% 
% if sum(strcmp(files,filestart))<1 % but if we're wrong
%     mkdir(filestart)
% end
% 
% dataDirectory = strcat(dataDirectory,splitChar,filestart);
% cd(dataDirectory)
% 
% % zpad = '_00';
% % filename
% % if ~isdir(filename)
% %     mkdir(filename)
% % end
% % else
% %     i = 1;
% %     filename = strcat(filestart,zpad,num2str(i));
% %     while isdir(filename)
% %         i = i+1;
% %         if i >= 10
% %             zpad = '_0';
% %         end
% %         filename = strcat(filestart,zpad,num2str(i));
% %     end
% %     mkdir(filename);
% % end
% % 
% % cd(filename)
% backhome = pwd;

%% Setup stimuli

% Convert cue and targ features to appropriate units
tOffsetDG = tOffsets;
%tOffsets = deg2px(tOffsets, env); <- happens just in time

diodeRect = [(rect(3)-60) (rect(4)-60) rect(3) rect(4)];
diodeColor = [255 255 255];

% Setup stimuli and fixation rects
fixSize = deg2px(fixSize, env)./2;
fix_err = deg2px(fix_err, env)./2;
fixRect = [origin origin] + [-fixSize -fixSize fixSize fixSize];
fixWindow=[origin origin] + [-fix_err -fix_err fix_err fix_err];
targD=deg2px(targDis,env)./2; % target position 10 visual degree
for i=1:4
phi=(2*pi*i/4)-pi/8;
targOrigin(i,:)=[origin(1,1)+targD*sin(phi) origin(1,2)+targD*cos(phi)];
end
targSize = deg2px(targSize, env)./2;
targ_err = deg2px(targ_err, env)./2;

% this now happens just in time
% thetas = thetas*(pi./180); % convert thetas to radians
% targOffsets = deg2px(targOffsets);

errorSize = deg2px(errorSize, env)./2;
errorRect = [origin origin] + [-errorSize -errorSize errorSize errorSize];

% get a list of image names
u=0;
    for i = [1,2]  % load 3 and 4
        u=u+1;
        curIm = imread(strcat(imageDirectory, '\', num2str(i)), 'jpg');
        imageIdx(u) = {curIm};
    end
ImageSequence=(rand(1, ntrials)>=0.5)+1;
ImageDirection=[ones(round(ntrials/4),1),2*ones(round(ntrials/4),1),...
   3*ones(round(ntrials/4),1),4*ones(round(ntrials/4),1)];
ImageDirection=ImageDirection(randperm(ntrials));
%% Make Eyelink start recording

if EYEBALL
    Eyelink('startrecording');
end

%% Save all the task data

cd(backhome)

% if ~isempty(which('v2struct'))
%     task = v2struct;
% end % probably doesn't actually work - gotta do some messing
% saves all the variables we've generated so far:
save(strcat(filename,'_taskVariables'));

