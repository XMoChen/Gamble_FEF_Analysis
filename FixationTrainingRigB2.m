%  to test the visual triggered activity in the up left visual field
%  (singleton)


function FixationTrainingRigB2

try
    clear all
    close all
    setupDIO;  
    
    path='C:\Data';
    
    x_res=1600;
    y_res=1024;
    
    ppcm=26; %Number of pixels per centimeter
    obs_dist = 70;   % viewing distance (cm)
    %ppd=50; %Number of pixels per degree of visual angle
    ppd=2*obs_dist*ppcm*tan(pi/360);
    %fp_color=[0 185 255];   % color of fixation point blue
    
    
  %Marc fix  
   %0 185 255
    fp_color=[0 185 255];
    fpr=round(ppd*0.5); %radius of fixation point
 %   %      green=[0 200 0];
 %      blue=[0 185 255];
    
    
    window_fix_ini=round(8*ppd);
    window_fix=round(1.75*ppd); % fixation window (diameter)
    window_choice=round(8*ppd);
    single_pos=0;
    pos=1;
   
    offtime=0;
    steptime=0.016;
    OffSum=[];
    RtSumL=[];
    RtSumR=[];
    
    t_waitforfixation2=5.0;
    t_waitforchoice2=0.15;
    t_waitforchoice_all=2.0;
    t_image_free2=3.0;   % image viewing time
    t_fixation2=0.500;   %  required fixation time
    t_trialend2=0.750;   
    t_image_pop2=0.5;
    t_blank2=0.5;
    t_choice02=0.3;
    t12=0.200;   %    flash time before fixation
 
    
    
    drift_x=[];
    drift_y=[];
    
    corr_x=0;
    corr_y=0;
    
 %%%%%%% combined task   
%     PopLength=200;
%     FreeLength=30;
%     OnsetLength=10; % per condition
    
    
 %%%%%%%    change for behavior

    PopLength=0;%153;
    FreeLength=0;
    OnsetLength=200; % per condition

    Type_ID=[ones(1,PopLength),2*ones(1,OnsetLength*7),3*ones(1,FreeLength)];
    Type_ID=Type_ID(randperm(size(Type_ID,2)));
    
    %% Create MIB target movies
% phaseStep = 20; % affects the speed of movement
% [t1MovOriginal,t2MovOriginal,t3MovOriginal] = deal(NaN(ceil(360/phaseStep),1));
% 
% phase = 0;  % init phase
% 
% % Create all frames of each targ movie
% movies = zeros(3, 3, 360/phaseStep);
% for i = 1:(360/phaseStep);
%     
%     phase = phase + phaseStep;
%     
%     % Make cur frame for targ 1
%     frame = gabor(gSize, 2, t1orientation, phase, 20, 0.5, t1amp);
%     frame = frame .* env.colorDepth;
%     t1MovOriginal(i) = Screen('MakeTexture',w,frame);
%     
%     % Make cur frame for targ 2
%     frame = gabor(gSize, 2, t2orientation, phase, 20, 0.5, t2amp);
%     frame = frame .* env.colorDepth;
%     t2MovOriginal(i) = Screen('MakeTexture',w,frame);
%     
%     
% end
    
%%%%%%%%%%%%%%%%%%%%%%%% for onset different task %%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    v_x_fp=[0, round(-6*ppd),round(-6*ppd),round(6*ppd),round(6*ppd)];  %2,3 location for target position (onset)
%      v_y_fp=[0, round(-6*ppd),round(-6*ppd)]-round(11.5*ppd);
     v_y_fp=[0, round(-6*ppd),round(6*ppd), round(-6*ppd),round(6*ppd)];
%      v_y_fp=[7.475*ppd -3.132*ppd,18.08*ppd,-3.132*ppd,18.08*ppd];
     % v_y_fp=[0.0*ppd -3.132*ppd,18.08*ppd,-3.132*ppd,18.08*ppd];
%          v_y_fp=[0, 0,0,0,0];


%     Off_time=[ -0.8,-0.4, -0.2, 0, 0.2, 0.4, 0.8];  % off set for onset trials
    
%     I_squence=[ones(1,OnsetLength),2*ones(1,OnsetLength),3*ones(1,OnsetLength),4*ones(1,OnsetLength),...
%         5*ones(1,OnsetLength),6*ones(1,OnsetLength),7*ones(1,OnsetLength),8*ones(1,OnsetLength)];

   I_squence=[ 5*ones(1,OnsetLength),6*ones(1,OnsetLength),7*ones(1,OnsetLength),8*ones(1,OnsetLength),...
   5*ones(1,OnsetLength),6*ones(1,OnsetLength),7*ones(1,OnsetLength),8*ones(1,OnsetLength)];
    I0=randperm(length(I_squence));
     I_squence0=I_squence(I0);
%       I_squence0=I_squence;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

    % Switch KbName into unified mode: It will use the names of the OS-X
    % platform on all platforms in order to make this script portable:
    KbName('UnifyKeyNames');    
  
    % Query keycodes:
    esc=KbName('ESCAPE');
    space=KbName('space');
    left=KbName('LeftArrow');
    right=KbName('RightArrow');
    up=KbName('UpArrow');
    down=KbName('DownArrow');
    coolkey=KbName('return');
    fixkey=KbName('f'); % reset drift correction 
    
    % EDF file: 1-8 characters plus .edf extension
    edfFile0=input('EDF file name:','s');
    edfFile=strcat(edfFile0,'.edf');
    
    
% set correct IP address for eyelink
ipConfig = 'netsh int ip set address \"Local Area Connection\" static 100.1.1.2 255.255.255.0';
result = system(ipConfig);

if result == 0
    disp('ip address sucessfully configured for eyelink')
else
    disp('ERROR: problem with IP address configuration')
end
%     %%%%%  add thermometer
%     devices=daq.getDevices ;
%     sTemp1=daq.createSession('ni');
%     sTemp2=daq.createSession('ni');
%     ch2=addAnalogInputChannel(sTemp2,'Dev3','ai0','Thermocouple');
%     ch1=addAnalogInputChannel(sTemp1,'Dev4','ai0','Thermocouple');
%     ch1.ThermocoupleType='T';
%     ch2.ThermocoupleType='T';

    
    % This script calls Psychtoolbox commands available only in OpenGL-based 
	% versions of the Psychtoolbox. (So far, the OS X Psychtoolbox is the
	% only OpenGL-base Psychtoolbox.)  The Psychtoolbox command AssertPsychOpenGL will issue
	% an error message if someone tries to execute this script on a computer without
	% an OpenGL Psychtoolbox
	AssertOpenGL;
    
   %% initialize eye
% Connection with Eyelink if not in testing mode
    try       
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
            edfname = 'ef.edf';
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


    
    % Get the list of screens and choose the one with the highest screen number.
	% Screen 0 is, by definition, the display with the menu bar. Often when 
	% two monitors are connected the one without the menu bar is used as 
	% the stimulus display.  Chosing the display with the highest dislay number is 
	% a best guess about where you want the stimulus displayed.  
    Screen('Preference', 'SkipSyncTests', 1);
    screens=Screen('Screens');
	screenNumber=max(screens);
    screenNumber=2;
    
    % Find the color values which correspond to white and black.  Though on OS
	% X we currently only support true color and thus, for scalar color
	% arguments,
	% black is always 0 and white 255, this rule is not true on other platforms will
	% not remain true on OS X after we add other color depth modes.  
	white=WhiteIndex(screenNumber);
	black=BlackIndex(screenNumber);
	gray=(white+black)/2;
	if round(gray)==white
		gray=black;
    end
      gray=159;


    
    % Hides the mouse cursor
	HideCursor;
    
	% Open a double buffered fullscreen window and draw a gray background 
	% to front and back buffers:
	[w, rect]=Screen('OpenWindow',screenNumber, 0,[],[],2,[],4);
    [center(1), center(2)] = RectCenter(rect);
    [width, height]=Screen('WindowSize', screenNumber);
    % do eyelink stuff
     el=EyelinkInitDefaults(w);
    
 

    % set EDF file contents
    %Eyelink('Command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE');
    %Eyelink('Command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS');
    % set link data (used for gaze cursor)
    Eyelink('Command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE');
    Eyelink('Command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS');
    Eyelink( 'Command', 'heuristic_filter = ON' );
    Eyelink('Command', 'select_parser_configuration = 0')
      Eyelink('Command','screen_phys_coords = -240.0 132.5 240.0 -132.5 '); % this is the size of the default screen Dell 2005FPW 
    % distance in mm from the center of the screen to [left top right bottom]
    % edge of screen                                                         
   Eyelink('Command', 'screen_distance = 300') %  Need to get from experimenter distance from center of eye to the center of the screen 
                                             % we need to measure this and get the proper number
   Eyelink('Command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
   %SETS 'screen_pixel_coords' field in *.ini file on host computer (in this case,
   %'physical.ini' to selected values
   Eyelink('Message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
   %notes that last change in edf file via message 
   openFile=Eyelink('Openfile', edfFile);
   if openFile~=0
        printf('Cannot create EDF file');
        Eyelink('Shutdown');
        return;    
    end;  
    
    % Validate the eye tracker calibration
    %EyelinkDoTrackerSetup(el,'v');    
    ListenChar(2);   
    KbWait;    
    Screen('Rect',w);  
    slack=Screen('GetFlipInterval', w)/2;  
    RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
   
    Screen('FillRect',w, gray-0);
    t_start_trial=Screen('Flip', w);
    color=gray; 
    step=10;
    pause=0;
    eye_used = el.LEFT_EYE;
    
    

    
%     Eyelink( 'Message', 'Fixation_time %ld', t_fixation*1000 );    
  
    Eyelink( 'Message', 'Wait fixation %ld', t_waitforfixation2 *1000);   
    Eyelink( 'Message', 'Choice time %ld', t_choice02 *1000);    
    Eyelink( 'Message', 'ITI %ld', t_trialend2 *1000); 
    Eyelink( 'Message', 'Central X(degree) %ld', round(v_x_fp(1)/ppd) );   
    Eyelink( 'Message', 'Central Y(degree) %ld', round(v_y_fp(1)/ppd ));    
%     Eyelink( 'Message', 'Central Y %ld',Attention_Loc);


    i_pop=0;
    i_free=0;
    i_onset=0;
    i=0;
    
 while (i+1)<=round(length(Type_ID))
     
    i=i+1;
        keyIsDown=0;    

     Type_ID(i);
     
    t_waitforfixation=t_waitforfixation2;
    t_waitforchoice=t_waitforchoice2;
    t_image_free=t_image_free2;   % image viewing time
    t_fixation=t_fixation2;   %  required fixation time
    t_trialend=t_trialend2;   
    t_image_pop=t_image_pop2;
    t_blank=t_blank2;
    t_choice0=t_choice02;
    t1=t12;   %    flash time before fixation
    
    Eyelink( 'Message', 'Trialstart');    
    trialStart;
    %Start recording
    Eyelink('StartRecording');
    %Eyelink('Command', 'record_status_message ''TRIAL %d''', i);
    Eyelink( 'Message', 'Trial Type %ld', round(Type_ID(i)) );    
   
    data.trialaccepted(i)=0;
    if i==1
        msg1=['Trial ' num2str(i)];
        Eyelink('Command', 'record_status_message ''%s'' ', msg1);
    elseif i>1   
        msg1=['Correct trial ' num2str(sum(data.trialaccepted)) ' out of initiated ' num2str(i)];
        Eyelink('Command', 'record_status_message ''%s'' ', msg1);
    end
    
    t_fixation=t_fixation+rand(1)*0.1;
%     Eyelink( 'Message', 'Fixation_time %ld', round(t_fixation*1000) );    
    x_fp=v_x_fp(1);
    y_fp=v_y_fp(1);
    
    gaze_x=x_fp+corr_x;
    gaze_y=y_fp-corr_y;
    

    fix=0;
    reward=0;
    repeat=1;
 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   for onset task %%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 if Type_ID(i)==2
     
 display(['OffMean: ',num2str(mean(OffSum))]);
   display(['Off: ',num2str(offtime*1000)]);
   display(['RtL: ',num2str(median(RtSumL))]);
   display(['RtR: ',num2str(median(RtSumR))]);
    
 i_onset=i_onset+1;
 t_choice=t_choice0+rand(1)*0.1;
 Eyelink( 'Message', 'ChoiceFixation_time %ld', round( t_choice0*1000 ));
 Direct=I_squence0(i_onset);    % Onset difference between left and right
 Eyelink('Message','Direction %d', Direct);
 Eyelink('Message','OnsetDif %ld', round(offtime*1000));

 
    Eyelink('command','clear_screen %d', 0);
    Eyelink('command','draw_box %d %d %d %d 15', round(center(1)+gaze_x-(window_fix_ini/2)), round(center(2)-gaze_y-(window_fix_ini/2)), round(center(1)+gaze_x+(window_fix_ini/2)),round(center(2)-gaze_y+(window_fix_ini/2)));
        
    
    fix=0;
    choice=0;
    reward=0;
    
    
   
    
    
    %START WAIT FOR FIXATION
    t_start=GetSecs;
    
    Eyelink('Message', 'Waitfix');
    
    while (fix==0 && ((GetSecs)-t_start)<t_waitforfixation),
    
     % Check recording status, stop display if error
     error=Eyelink('CheckRecording');
     if(error~=0)
         break;
     end 
      
          
% 	Screen('FillRect',w, gray);
%     Screen('DrawingFinished', w); 
% 	t_start_trial=Screen('Flip', w, t_start_trial + t1 - slack);
    
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp, center(2)-fpr-y_fp, center(1)+fpr+x_fp, center(2)+fpr-y_fp]); 
    Screen('DrawingFinished', w); 
	t_start_trial=Screen('Flip', w);
    Eyelink('Message', 'FixationOn');

   
     evt=Eyelink('NewestFloatSample');
      x_eye=evt.gx(eye_used+1);
      y_eye=evt.gy(eye_used+1);
      
     if ((x_eye >= (center(1)+gaze_x-(window_fix_ini/2)))&&(x_eye <= (center(1)+gaze_x+(window_fix_ini/2)))&&(y_eye >= (center(2)-gaze_y-(window_fix_ini/2)))&&(y_eye <= (center(2)-gaze_y+(window_fix_ini/2))))
      fix=1;    
     end  
     
     
     
     [keyIsDown, secs, keyCode]=KbCheck;   
    if keyIsDown==1
 [x_eye,y_eye,pause,corr_x,corr_y]=checkkeys3(keyIsDown,keyCode,pause,x_eye,y_eye,center,x_fp,y_fp,corr_x,corr_y);
    end       
    end
    %END WAIT FOR FIXATION
       Eyelink('Message', 'FixationIn');
 
    
    t_fixation_1=t_fixation/2;
    t_fixation_2=t_fixation_1;  
    %START FIXATION
    t_start=GetSecs;
        
   while (fix==1 && ((GetSecs)-t_start)<t_fixation_1)
    
    %Check recording status, stop display if error
    error=Eyelink('CheckRecording');
    if(error~=0)
      break;
    end    
        
     evt=Eyelink('NewestFloatSample');
     x_eye=evt.gx(eye_used+1);
     y_eye=evt.gy(eye_used+1);
    
    if not((x_eye >= (center(1)+gaze_x-(window_fix_ini/2)))&&(x_eye <= (center(1)+gaze_x+(window_fix_ini/2)))&&(y_eye >= (center(2)-gaze_y-(window_fix_ini/2)))&&(y_eye <= (center(2)-gaze_y+(window_fix_ini/2))))
      fix=0;    
    end        
        
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp, center(2)-fpr-y_fp, center(1)+fpr+x_fp, center(2)+fpr-y_fp]); 
    Screen('DrawingFinished', w); 
	t_start_trial=Screen('Flip', w);
    
    [keyIsDown, secs, keyCode]=KbCheck;   
    if keyIsDown==1
 [x_eye,y_eye,pause,corr_x,corr_y]=checkkeys3(keyIsDown,keyCode,pause,x_eye,y_eye,center,x_fp,y_fp,corr_x,corr_y);
    end   
   end
    
   
 %START FIXATION 2
    t_start=GetSecs;
        
   off=0; 
   
   while (fix==1 && ((GetSecs)-t_start)<t_fixation_2)
    
    %Check recording status, stop display if error
    error=Eyelink('CheckRecording');
    if(error~=0)
      break;
    end    
        
     evt=Eyelink('NewestFloatSample');
     x_eye=evt.gx(eye_used+1);
     y_eye=evt.gy(eye_used+1);
     
     drift_x(end+1)=x_eye;
     drift_y(end+1)=y_eye;
     
    if not((x_eye >= (center(1)+gaze_x-(window_fix_ini/2)))&&(x_eye <= (center(1)+gaze_x+(window_fix_ini/2)))&&(y_eye >= (center(2)-gaze_y-(window_fix_ini/2)))&&(y_eye <= (center(2)-gaze_y+(window_fix_ini/2))))
      fix=0;    
    end
    
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp, center(2)-fpr-y_fp, center(1)+fpr+x_fp, center(2)+fpr-y_fp]); 
    Screen('DrawingFinished', w); 

    
    [keyIsDown, secs, keyCode]=KbCheck;   
    if keyIsDown==1
 [x_eye,y_eye,pause,corr_x,corr_y]=checkkeys3(keyIsDown,keyCode,pause,x_eye,y_eye,center,x_fp,y_fp,corr_x,corr_y);
    end   
   end
    
   
    if fix==1
    
    if ~isempty(drift_x)
     dev_x=mean(drift_x);
     drift_x=[];
    end   
    
    if ~isempty(drift_y)
     dev_y=mean(drift_y);
     drift_y=[];
    end 
    
    corr_x=dev_x-(center(1)+x_fp);
    corr_y=dev_y-(center(2)-y_fp);
    
    if sqrt(corr_x^2+corr_y^2)<=((window_fix_ini/2)-0.5*ppd)
    gaze_x=x_fp+corr_x;
    gaze_y=y_fp-corr_y;
     
    Eyelink('command','clear_screen %d', 0);
    Eyelink('command','draw_box %d %d %d %d 15', round(center(1)+gaze_x-(window_fix/2)), round(center(2)-gaze_y-(window_fix/2)), round(center(1)+gaze_x+(window_fix/2)),round(center(2)-gaze_y+(window_fix/2)));
    end;   
    end;   
   
   
   
   
   
    Eyelink( 'Message', 'FixSuc %d', fix);

    %END FIXATION    
    
    %Choose between two targets
    if(fix==1)

    error=Eyelink('CheckRecording');
    if(error~=0)
      break;
    end 
 
 if  Direct<=4
     if Direct==1
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
     elseif Direct==2
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
    
     elseif Direct==3
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
     elseif Direct==4
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
        end
    
    
    Eyelink('command','draw_box %d %d %d %d 15', round(center(1)+x_fp1-(window_choice/2)), round(center(2)-y_fp1-(window_choice/2)), round(center(1)+x_fp1+(window_choice/2)),round(center(2)-y_fp1+(window_choice/2)));
    Eyelink('command','draw_box %d %d %d %d 15', round(center(1)+x_fp2-(window_choice/2)), round(center(2)-y_fp2-(window_choice/2)), round(center(1)+x_fp2+(window_choice/2)),round(center(2)-y_fp2+(window_choice/2)));
    

    if offtime>=0
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp1, center(2)-fpr-y_fp1, center(1)+fpr+x_fp1, center(2)+fpr-y_fp1]); 
    Screen('DrawingFinished', w); 
    t_start_trial=Screen('Flip', w);
    Eyelink('Message', 'Target1On');
    
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp1, center(2)-fpr-y_fp1, center(1)+fpr+x_fp1, center(2)+fpr-y_fp1]);   
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp2, center(2)-fpr-y_fp2, center(1)+fpr+x_fp2, center(2)+fpr-y_fp2]); 
    Screen('Flip', w, t_start_trial + abs(offtime) - slack);   
    Eyelink('Message', 'Target2On');
    
    elseif offtime==0
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp1, center(2)-fpr-y_fp1, center(1)+fpr+x_fp1, center(2)+fpr-y_fp1]);   
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp2, center(2)-fpr-y_fp2, center(1)+fpr+x_fp2, center(2)+fpr-y_fp2]); 
    Screen('Flip', w, t_start_trial + abs(offtime) - slack);   
    Eyelink('Message', 'Target1On');
    Eyelink('Message', 'Target2On');
        
    else
        
        
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp2, center(2)-fpr-y_fp2, center(1)+fpr+x_fp2, center(2)+fpr-y_fp2]); 
    Screen('DrawingFinished', w); 
    t_start_trial=Screen('Flip', w);
    Eyelink('Message', 'Target1On');
    
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp1, center(2)-fpr-y_fp1, center(1)+fpr+x_fp1, center(2)+fpr-y_fp1]);   
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp2, center(2)-fpr-y_fp2, center(1)+fpr+x_fp2, center(2)+fpr-y_fp2]); 
    Screen('Flip', w, t_start_trial + abs(offtime) - slack);   
    Eyelink('Message', 'Target2On');
    end
%     Eyelink('Message', 'Target1On');
%     Eyelink('Message', 'Target2On');
%     giveStim;
 else
     
          if Direct==5
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(5);
    y_fp2=v_y_fp(5);  

     elseif Direct==6
    x_fp1=v_x_fp(3);
    y_fp1=v_y_fp(3);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);  

    
     elseif Direct==7
    x_fp1=v_x_fp(4);
    y_fp1=v_y_fp(4);
    
    x_fp2=v_x_fp(3);
    y_fp2=v_y_fp(3);  
    

     elseif Direct==8
    x_fp1=v_x_fp(5);
    y_fp1=v_y_fp(5);
    
    x_fp2=v_x_fp(2);
    y_fp2=v_y_fp(2);  

          end
    
    Eyelink('command','draw_box %d %d %d %d 15', round(center(1)+x_fp1-(window_choice/2)), round(center(2)-y_fp1-(window_choice/2)), round(center(1)+x_fp1+(window_choice/2)),round(center(2)-y_fp1+(window_choice/2)));

    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp1, center(2)-fpr-y_fp1, center(1)+fpr+x_fp1, center(2)+fpr-y_fp1]); 
    Screen('DrawingFinished', w); 
    t_start_trial=Screen('Flip', w);
    Eyelink('Message', 'Loctarget');
    FixOn=GetSecs;
 end
  

       
    t_start=GetSecs;      
    % check the time when eye position leave fixation point
     fix2=1;  
    while (fix2~=0 && GetSecs-t_start< t_waitforchoice_all)
    
    %Check recording status, stop display if error
    error=Eyelink('CheckRecording');
    if(error~=0)
      break;
    end    
        
     evt=Eyelink('NewestFloatSample');
     x_eye=evt.gx(eye_used+1);
     y_eye=evt.gy(eye_used+1);
    
    if not((x_eye >= (center(1)+gaze_x-(window_fix_ini/2)))&&(x_eye <= (center(1)+gaze_x+(window_fix_ini/2)))&&(y_eye >= (center(2)-gaze_y-(window_fix_ini/2)))&&(y_eye <= (center(2)-gaze_y+(window_fix_ini/2))))
      fix2=0;    
      t_start=GetSecs;
    end        
      
    end

        
    while (fix==1 && fix2==0 && choice==0 && ((GetSecs)-t_start)< t_waitforchoice)

   %Check recording status, stop display if error
    error=Eyelink('CheckRecording');
    if(error~=0)
      break;
    end   
    
      evt=Eyelink('NewestFloatSample');
      x_eye=evt.gx(eye_used+1);
      y_eye=evt.gy(eye_used+1);
      
     
      
     if ((x_eye >= (center(1)+x_fp1-(window_choice/2)))&&(x_eye <= (center(1)+x_fp1+(window_choice/2)))&&(y_eye >= (center(2)-y_fp1-(window_choice/2)))&&(y_eye <= (center(2)-y_fp1+(window_choice/2))))
     choice=1;  
     Eyelink('Message', 'ChoiceIn');
    if Direct>4
    ChoiceIn=GetSecs;
    
    if  (Direct==5 | Direct== 6)
    
    RtSumL=[RtSumL;(ChoiceIn-FixOn)];
    elseif (Direct==7 | Direct== 8)
    
    RtSumR=[RtSumR;(ChoiceIn-FixOn)];
    end

    end

     end
     if   ((x_eye >= (center(1)+x_fp2-(window_choice/2)))&&(x_eye <= (center(1)+x_fp2+(window_choice/2)))&&(y_eye >= (center(2)-y_fp2-(window_choice/2)))&&(y_eye <= (center(2)-y_fp2+(window_choice/2))))
     choice=2;
     Eyelink('Message', 'ChoiceIn');

     end
%      if   ((y_eye < (center(2)-y_fp2-2*(window_fix/2))) && (y_eye > (center(2)-y_fp2+2*(window_fix/2))))
%      choice=100;
%      end
     end
    
%      disp('Choice');
     Eyelink('Message', 'Choice %d',choice);
     
    if choice ==1         
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp1, center(2)-fpr-y_fp1, center(1)+fpr+x_fp1, center(2)+fpr-y_fp1]); 
    Screen('DrawingFinished', w); 
    t_start_trial=Screen('Flip', w); 
    Eyelink('Message', 'Choice On');
    
    if Direct<=4
    offtime=offtime-steptime;
 if isempty(OffSum)==1
     OffSum=[ offtime*1000];
 else
     OffSum=[OffSum;offtime*1000];
 end
    end

     elseif choice ==2
         
    Screen('FillRect',w, gray);
    Screen('FillOval',w,fp_color, [center(1)-fpr+x_fp2, center(2)-fpr-y_fp2, center(1)+fpr+x_fp2, center(2)+fpr-y_fp2]); 
    Screen('DrawingFinished', w); 
    t_start_trial=Screen('Flip', w); 
    Eyelink('Message', 'Choice On');
    if Direct<=4
    offtime=offtime+steptime;
 if isempty(OffSum)==1
     OffSum=[ offtime*1000];
 else
     OffSum=[OffSum;offtime*1000];
 end

    end


    end
    
    t_start=GetSecs;
    choice2 =choice;
    while (choice>0 && choice<100 && choice2 ==choice &&((GetSecs)-t_start)<t_choice),
        
    
      evt=Eyelink('NewestFloatSample');
      x_eye=evt.gx(eye_used+1);
      y_eye=evt.gy(eye_used+1);
      
     choice2=0; 
     if ((x_eye >= (center(1)+x_fp1-(window_choice/2)))&&(x_eye <= (center(1)+x_fp1+(window_choice/2)))&&(y_eye >= (center(2)-y_fp1-(window_choice/2)))&&(y_eye <= (center(2)-y_fp1+(window_choice/2))))
     choice2=1;   
     end
     if   ((x_eye >= (center(1)+x_fp2-(window_choice/2)))&&(x_eye <= (center(1)+x_fp2+(window_choice/2)))&&(y_eye >= (center(2)-y_fp2-(window_choice/2)))&&(y_eye <= (center(2)-y_fp2+(window_choice/2))))
     choice2=2;
     end
       
    end
    
    Screen('FillRect',w, gray);
    Screen('DrawingFinished', w); 
	t_start_trial=Screen('Flip', w);
    
    
    if ( choice~=0 & fix==1 &  fix2==0  & choice2>0 )
             reward=1;
             data.trialaccepted(i)=1;
             Eyelink( 'Message', 'Reward %d', reward);
             giveJuice_GN(1);  
             repeat=0;
%            Repeat_flag=0;
    end       
    end   
 end
 

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%% trial end
 
%%%%%%%%%%%%%record temperature
%     temp=inputSingleScan(sTemp);
%     Eyelink( 'Message', 'Temperature %d', round(temp));


  Eyelink('command','clear_screen %d', 0);
   Screen('FillRect',w, gray);
    Screen('DrawingFinished', w); 
	t_start_trial=Screen('Flip', w);
    %START TRIAL END
    while ((GetSecs)-t_start_trial)<t_trialend,
        
       %Check recording status, stop display if error
       error=Eyelink('CheckRecording');
       if(error~=0)
           break;
       end
      
       [keyIsDown, secs, keyCode]=KbCheck;  
%        keyIsDown
    if keyIsDown==1
 [x_eye,y_eye,pause,corr_x,corr_y]=checkkeys3(keyIsDown,keyCode,pause,x_eye,y_eye,center,x_fp,y_fp,corr_x,corr_y);
    end   
            
            
            if (keyIsDown==1 && keyCode(esc))
                % Abort:
                ShowCursor;
                Screen('CloseAll');
                ListenChar(1);
                fprintf('Aborted.\n'); 
                Eyelink('StopRecording');
                Eyelink('CloseFile');
                % download data file
                 cd(path)      
                try
                    fprintf('Receiving data file ''%s''\n', edfFile );
                    status=Eyelink('ReceiveFile');
                    if status > 0
                        fprintf('ReceiveFile status %d\n', status);
                    end
                    if 2==exist(edfFile, 'file')
                        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
                    end
                catch
                    fprintf('Problem receiving data file ''%s''\n', edfFile );      
                end      
                Eyelink('ShutDown');
                return ;
            end; 
    end
    %STOP TRIAL END
%     temp1=inputSingleScan(sTemp1);
%     temp2=inputSingleScan(sTemp2);
% 
%     Eyelink( 'Message', 'Temperature1 %d', round(temp1));
%     Eyelink( 'Message', 'Temperature2 %d', round(temp2));
%     display(['Loop1: ', num2str(round(temp1))]);
%     display(['Loop2: ', num2str(round(temp2))]);

    Eyelink('Message', 'Trialend');    
    trialStop;
    
    %Stop recording
    Eyelink('StopRecording');
    
    
    %START PAUSE
    
    if (pause==1)
    Screen('FillRect',w, black);
    Screen('DrawingFinished', w); 
	Screen('Flip', w);   
    end  
    
    while (pause>0)
       %Check recording status, stop display if error
%        error=Eyelink('CheckRecording');
%        if(error~=0)
%          break;
%        end 
       
       
    pause =1 ;   
    [keyIsDown, secs, keyCode]=KbCheck;   
    if keyIsDown==1
 [x_eye,y_eye,pause,corr_x,corr_y]=checkkeys3(keyIsDown,keyCode,pause,x_eye,y_eye,center,x_fp,y_fp,corr_x,corr_y);
    end   
         
%     display('1');        
           
            if (keyIsDown==1 && keyCode(esc))
                ShowCursor;
                Screen('CloseAll');
                ListenChar(1);
                fprintf('Aborted.\n'); 
                Eyelink('StopRecording');
                Eyelink('CloseFile');
                % download data file
                 cd(path)      
                try
                    fprintf('Receiving data file ''%s''\n', edfFile );
                    status=Eyelink('ReceiveFile');
                    if status > 0
                        fprintf('ReceiveFile status %d\n', status);
                    end
                    if 2==exist(edfFile, 'file')
                        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
                    end
                catch
                    fprintf('Problem receiving data file ''%s''\n', edfFile );      
                end      
                Eyelink('ShutDown');
                return ;
            end; 
%         display('2');        
       end    
      %END PAUSE
      
      if repeat==1
      Type_ID=[Type_ID(i),Type_ID,];
       if Type_ID(i)==1
           Stim=[,Stim(i_pop),Stim]
       elseif Type_ID(i)==2
           I_squence0=[I_squence0(i_onset),I_squence0];
       elseif Type_ID(i)==3
          I_Order=[I_Order(i_free),I_Order];
       end
%        clear ID0
%        ID0=Type_ID((i+1):length(Type_ID));
%        ID0=ID0(randperm(length(ID0)));
%        Type_ID((i+1):length(Type_ID))=ID0;
      end
           
      
end
 
 

    Eyelink('CloseFile');
	% download data file
    cd(path)      
    try
        fprintf('Receiving data file ''%s''\n', edfFile );
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('ReceiveFile status %d\n', status);
        end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch
        fprintf('Problem receiving data file ''%s''\n', edfFile );      
    end      
    Eyelink('ShutDown');
    
    ShowCursor;
    Screen('CloseAll');
    ListenChar(1);
    fprintf('Done.\n');
    return;
    

    
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
%       ListenChar(1);
    Eyelink('ShutDown');
    % Restores the mouse cursor.
	ShowCursor;
    
    psychrethrow(psychlasterror);
end %try..catch..

