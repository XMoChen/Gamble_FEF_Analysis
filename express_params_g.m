% posner_params.m
% Initialize the parameters for posner task

% Number of trials
ntrials = 20;

% Directory of where the data will be saved to
global gitDir
if IsOSX
    splitChar = '/';
else
    splitChar = '\';
end
dataDirectory = strcat(gitDir,splitChar,'Gamble',splitChar,'data');

imageDirectory = strcat(gitDir,splitChar,'Gamble',splitChar,'stimuli');
imStr = '.png';

% p(moving location)
pMove = 0.5; % need the location to move more frequently

% Timing window parameters (s)
time2fix = 5;
time2choose = 5;
fixHoldMin = 0.1;
fixHoldMax = 0.3;
targHoldTime = 0.12;

pNoGap = 0.1;
targGapMin = 0.15;
targGapMax = 0.15;

% Background color
bgcolor = [127 127 127];

% Fixation parameters
fixcolor = [255 255 255];
fixSize = .5; % in dg
fix_err = 20; % in dg

% Target parameters
targDis = 20; % only controls the width
targNum = 4;
targSize= 4;
targ_err=40;

% Inter-trial interval bounds (s)
itimin = 2;
itimax = 3;

% target locations
%
%       270
%   180     0
%       90
%

thetas = [0 180];
tOffsets = [10];
