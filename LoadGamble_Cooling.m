 function  EDFtable=LoadGamble_Cooling(EDF_file,Eventfile)
% SaveFileName=[Path,'O3_5.asc']


Filetag={'I','C'};
EDF_file0=EDF_file;
    
  for iii=1:length(Filetag)
      
    clear EDFtable
    
      EDF_file=[EDF_file0(1:end-4), char(Filetag(iii)),'.asc'];

FileName=EDF_file;
PacketSize = 20000;

%%%%%%%%% Load the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  Loading the data from ' FileName]);
fid = fopen(FileName,'rt');
Data = fread(fid,'char');
fclose(fid);
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  ...done.']);
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  Splitting the data into rows']);
Data = char(Data');
[Data, RowNum] = Text2CellArray(Data,PacketSize);
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  ...done. (' num2str(RowNum) ' rows)']);


%%%%% Classify the rows %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  Classifying the rows']);
% Picking-up the rows with specific data-types
Types = [
    'MS'; % < 1> MSG
    'BU'; % < 2> BUTTON
    'SF'; % < 3> SFIX
    'EF'; % < 4> EFIX
    'SS'; % < 5> SSACC
    'ES'; % < 6> ESACC
    'SB'; % < 7> SBLINK
    'EB'; % < 8> EBLINK
    'PR'; % < 9> PRESCALER
    'VP'; % <10> VPRESCALER
    'EV'; % <11> EVENTS
    'SA'; % <12> SAMPLES
    'ST'; % <13> START
    'EN'; % <14> END
];
Category = zeros(1,RowNum);
temp = char(Data);
temp = temp(:,1:2); % Take first 2 characters of every row
for c=1:14 % for each category
    F = find((temp(:,1)==Types(c,1)) & (temp(:,2)==Types(c,2)));
    if c==13
        BlockNum = length(F);
        FS = F; % 'START' rows
    elseif c==14
        BlockNum = min([length(F) BlockNum]);
        FE = F; % 'END' rows
    end
    Category(F) = ones(1,length(F))*c;
end
clear temp;
% Classifying the rows
F = find(Category== 1);       MSG        = Data(F);
F = find(Category== 2);  Data_BUTTON     = Data(F);
F = find(Category== 3);  Data_SFIX       = Data(F);
F = find(Category== 4);  Data_EFIX       = Data(F);
F = find(Category== 5);  Data_SSACC      = Data(F);
F = find(Category== 6);  Data_ESACC      = Data(F);
F = find(Category== 7);  Data_SBLINK     = Data(F);
F = find(Category== 8);  Data_EBLINK     = Data(F);
F = find(Category== 9);       PRESCALER  = Data(F);
F = find(Category==10);       VPRESCALER = Data(F);
F = find(Category==11);       EVENTS     = Data(F);
F = find(Category==12);       SAMPLES    = Data(F);
F = find(Category==13);       START      = Data(F);
F = find(Category==14);       END        = Data(F);
% Picking-up data-only rows that is comprised of only values.
if BlockNum==0
    disp('No block is recorded in this file.');
    return;
else
    Data = char(Data);
    F = [];
    for b=1:BlockNum
        F = [F (FS(b)+1):(FE(b)-1)];
    end
    Data = Data(F,:);
end
clear FS FE;
DataRowChar = [double('0123456789.- ') 9]; % numbers, dot, minus, space and tab
DataRowNum = size(Data,1);
% To save memory, divide the data into several packets and process each
Fall = [];
for p=1:ceil(DataRowNum/PacketSize)
    S = (p-1)*PacketSize+1;
    E = p*PacketSize;
    if E>DataRowNum
        E = DataRowNum;
    end
    Packet = double(Data(S:E,:));
    temp = zeros(size(Packet,1),1);
    for c=1:length(DataRowChar)
        temp = temp + sum(Packet==DataRowChar(c),2);
    end
    F = find(temp==size(Packet,2));
    F = F + S - 1;
    Fall = [Fall; F];
end
clear temp F;
Data = [Data(Fall,:)];
clear Fall;
% report
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  ... done. (' num2str(BlockNum) ' blocks found)']);

%%%%% Determining START/END of each block %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  Detecting START/END timestamps of each block']);
% Find the timestamps of START and END
for b=1:BlockNum
    temp = double(char(START(b)));
    F = find(temp==9); % Find tab
    temp = temp((F(1)+1):F(2));
    STARTtime(b,:) = [b str2num(char(temp))];
    temp = double(char(END(b)));
    F = find(temp==9); % Find tab
    temp = temp((F(1)+1):F(2));
    ENDtime(b,:) = [b str2num(char(temp))];
end


% 
% %%%%% Convert the eye-position (X,Y) and pupil data into matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
% disp(['  ' Time '  Interpreting the raw data']);
% % To save memory, divide the data into several packets and process each
% DataRowNum = size(Data,1);
% RawData = [];
% for p=1:ceil(DataRowNum/PacketSize)
%     S = (p-1)*PacketSize+1;
%     E = p*PacketSize;
%     if E>DataRowNum
%         E = DataRowNum;
%     end
%     Packet = [double(Data(S:E,:))]';
%     L = numel(Packet);
%     % Finding the null-data, represented by '.' 
%     % (e.g., gaze-positions are lost during blinks) 
%     NullData = find((Packet(1:L-1)==46)&(Packet(2:L)==9)); % Finding "dot plus tab"
%     NullData = [NullData find((Packet(1:L-1)==46)&(Packet(2:L)==32))]; % Finding "dot plus space"
%     NullData = [NullData find((Packet(1:L)==46)&(mod([1:L],size(Packet,1))==0))]; % Finding dot at the end of the rows
%     Packet(NullData) = ones(1,length(NullData))*48; % Replace the dot with zero.
%     Data(S:E,:) = char(Packet');
%     RawData = [RawData; str2num(Data(S:E,:))];
% end
% % RawData
% clear Packet NullData;
% if size(RawData,1) < DataRowNum
%     Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
%     disp(['  ' Time '  !! The column numbers of the eye-posision data are not constant throughout.']);    
%     disp(['  ' char(ones(1,length(Time))*32) '  !! It may take longer time to process the data.']);
%     for r=1:size(Data,1)
%         NowData = str2num(deblank(Data(r,:))); 
%         L = length(NowData);
%         RawData(r,1:L) = NowData;
%     end
% end
% clear Data;
% 
% %%%%% Add block numbers to the data
% RawData = [zeros(size(RawData,1),1) RawData];
% for b=1:BlockNum
%     F = find( (RawData(:,2)>=STARTtime(b,2)) & (RawData(:,2)<=ENDtime(b,2)) );
%     RawData(F,1) = ones(length(F),1)*b;
% end
% % report
% Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
% disp(['  ' Time '  ...done.']);


% % Exclude the data if gaze position is outside the screen.
% Fx = (RawData(:,2)>=ScreenRect(1)) & (RawData(:,2)<=ScreenRect(3));
% Fy = (RawData(:,3)>=ScreenRect(2)) & (RawData(:,3)<=ScreenRect(4));
% F  = (Fx & Fy);
% clear Fx Fy;
% RawData = RawData(find(F),:);
% report
% temp = size(RawData,1);
% temp = round(temp/RowNum*1000)/10;
% Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
% disp(['  ' Time '  ...done. (' num2str(temp) '% data remain available)']);



%%%%% Convert the MSG (message) data into matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  Interpreting the MSG data']);
MSGtemp = double(char(MSG));
temp = size(MSGtemp,1);
MSGtime = [];
if isempty(MSG)==0 % If there are MSG rows
%    F = sum(MSGtemp==32);
%    F = find(F==temp);
%    if isempty(F) % If figures of the timestamps changes (e.g., 999999 -> 1000000)
        L = size(MSGtemp,2);
        MSGtemp2 = (MSGtemp==32); % find spaces
        for c=1:L
            mask(:,c) = sum(MSGtemp2(:,1:c),2);
        end
        mask = (mask==0);
        MSGtime = (MSGtemp.*mask) + (1-mask)*32; % Timestamps and spaces
        MSGtime = MSGtime(:,5:L); % Omit the "MSG + tab" of each row
        MSGtime = str2num(char(MSGtime));
        clear MSGtemp2 mask L;
 %   else
 %       F = F(1);
 %       MSGtime = str2num(char(MSGtemp(:,5:(F-1))));
 %   end
end
clear MSGtemp;
% Appending block numbers to the data
MSGtime = [zeros(temp,1) MSGtime];
for b=1:BlockNum
    F = find( (MSGtime(:,2)>=STARTtime(b,2)-600) & (MSGtime(:,2)<=ENDtime(b,2)) );
    MSGtime0(F,b) = ones(length(F),1)*b;
end
% report
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  ...done. (' num2str(temp) ' MSG rows)']);



%%%%% Convert the fixation data into matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  Interpreting the fixation data']);
% SFIX: start of fixation
SFIX = [];
if isempty(Data_SFIX)==0
    SFIX = double(char(Data_SFIX));
    SFIX = SFIX(:,6:size(SFIX,2));
    F = find(SFIX(:,1)==76); % find 'L' (i.e., left eye)
    SFIX(F,1) = ones(length(F),1)*48; % Convert the 'L' into '0'
    F = find(SFIX(:,1)==82); % find 'R' (i.e., right eye)
    SFIX(F,1) = ones(length(F),1)*49; % Convert the 'R' into '1'
    SFIX = str2num(char(SFIX));
end
% EFIX: end of fixation
EFIX = [];
if isempty(Data_EFIX)==0
    EFIX = double(char(Data_EFIX));
    EFIX = EFIX(:,6:size(EFIX,2));
    F = find(EFIX(:,1)==76); % find 'L' (i.e., left eye)
    EFIX(F,1) = ones(length(F),1)*48; % Convert the 'L' into '0'
    F = find(EFIX(:,1)==82); % find 'R' (i.e., right eye)
    EFIX(F,1) = ones(length(F),1)*49; % Convert the 'R' into '1'
    EFIX = str2num(char(EFIX));
end
% Appending block numbers to the data
SFIX = [zeros(size(SFIX,1),1) SFIX];
EFIX = [zeros(size(EFIX,1),1) EFIX];
for b=1:BlockNum
    F = find( (SFIX(:,3)>=STARTtime(b,2)) & (SFIX(:,3)<=ENDtime(b,2)) );
    SFIX(F,1) = ones(length(F),1)*b;
    F = find( (EFIX(:,4)>=STARTtime(b,2)) & (EFIX(:,4)<=ENDtime(b,2)) );
    EFIX(F,1) = ones(length(F),1)*b;
end
clear Data_SFIX Data_EFIX;
% report
temp = max([size(SFIX,1) size(EFIX,1)]);
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  ...done. (' num2str(temp) ' fixations)']);


%%%%% Convert the saccade data into matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  Interpreting the saccade data']);
% SSACC: Start of saccades
SSACC = [];
if isempty(Data_SSACC)==0
    SSACC = double(char(Data_SSACC));
    SSACC = SSACC(:,7:size(SSACC,2));
    F = find(SSACC(:,1)==76); % find 'L' (i.e., left eye)
    SSACC(F,1) = ones(length(F),1)*48; % Convert the 'L' into '0'
    F = find(SSACC(:,1)==82); % find 'R' (i.e., right eye)
    SSACC(F,1) = ones(length(F),1)*49; % Convert the 'R' into '1'
    SSACC = str2num(char(SSACC));
end
% ESACC: End of saccades
ESACC = [];
if isempty(Data_ESACC)==0
    ESACC = double(char(Data_ESACC));
    ESACC = ESACC(:,7:size(ESACC,2));
    F = find(ESACC(:,1)==76); % find 'L' (i.e., left eye)
    ESACC(F,1) = ones(length(F),1)*48; % Convert the 'L' into '0'
%     F = find(ESACC(:,1)==82); % find 'R' (i.e., right eye)
%     ESACC(F,1) = ones(length(F),1)*49; % Convert the 'R' into '1'
    
    for i=1:size(ESACC)
        if isempty(str2num(char(ESACC(i,:))))==0
        ESACC0(i,:) = str2num(char(ESACC(i,:)));
        else
          ESACC0(i,:) =0;
        end
    end
    ESACC=ESACC0;
end
% Appending block numbers to the data
SSACC = [zeros(size(SSACC,1),1) SSACC];
ESACC = [zeros(size(ESACC,1),1) ESACC];
for b=1:BlockNum
    F = find( (SSACC(:,3)>=STARTtime(b,2)) & (SSACC(:,3)<=ENDtime(b,2)) );
    SSACC(F,1) = ones(length(F),1)*b;
    F = find( (ESACC(:,4)>=STARTtime(b,2)) & (ESACC(:,4)<=ENDtime(b,2)) );
    ESACC(F,1) = ones(length(F),1)*b;
end
clear Data_SSACC Data_ESACC;
% report
temp = max([size(SSACC,1) size(ESACC,1)]);
Time=clock; Time=round(Time(4:6)); Time=[num2str(Time(1)) ':' num2str(Time(2)) ':' num2str(Time(3))];
disp(['  ' Time '  ...done. (' num2str(temp) ' saccades)']);


%%


for b=1:(BlockNum)
I=MSGtime0(:,b)==b;
MSG_sub=(strtrim(MSG(1,I)));
MSGtime_sub=((MSGtime(I,2)));
EDFtable(b,1)=0;
EDFtable(b,23)=0;

clear a t_start


t_start=STARTtime(b,2)-4;

 for i=1:size(MSG_sub,2)
    clear a      
    a=char(MSG_sub(1,i));
    k = strfind(MSG_sub(1,i), 'Trialstart');
    if isempty(k{1})~=1
        t_start(b)=MSGtime_sub(i);
        EDFtable(b,23)=MSGtime_sub(i);

    end  
 end
 
 
    if EDFtable(b,23)~=0
 for i=1:size(MSG_sub,2)
    clear a   
    
      a=char(MSG_sub(1,i));

 
    
    k = strfind(MSG_sub(1,i), 'FixationOn');
    if isempty(k{1})~=1
        EDFtable(b,1)=MSGtime_sub(i)-t_start(b);
    end
    
   
    k = strfind(MSG_sub(1,i), 'TargetOn');
    if isempty(k{1})~=1
        EDFtable(b,2)=MSGtime_sub(i)-t_start(b);
    end
    
    k = strfind(MSG_sub(1,i), 'FixationOff');
    if isempty(k{1})~=1
        EDFtable(b,3)=MSGtime_sub(i)-t_start(b);
    end
    
    k = strfind(MSG_sub(1,i), 'ChoiceIn');
    if isempty(k{1})~=1
        EDFtable(b,4)=MSGtime_sub(i)-t_start(b);
    end
    
      k = strfind(MSG_sub(1,i), 'ResultOn');
    if isempty(k{1})~=1
        EDFtable(b,12)=MSGtime_sub(i)-t_start(b);
    end
    
    k = strfind(MSG_sub(1,i), 'BGOn');
    if isempty(k{1})~=1
        EDFtable(b,13)=MSGtime_sub(i)-t_start(b);
    end
        
    EDFtable(b,5)=t_start(b);
    
    
    k = strfind(MSG_sub(1,i), 'Reward') ;
    k1= strfind(MSG_sub(1,i), 'RightReward') ;
    k2= strfind(MSG_sub(1,i), 'LeftReward') ;
    k3= strfind(MSG_sub(1,i), 'RewardOn');

    if isempty(k{1})~=1 & isempty(k3{1})==1 & isempty(k1{1})==1 & isempty(k2{1})==1 & EDFtable(b,11)==0
        
        str2num(a((k{1}+7):length(a)))
        EDFtable(b,11)=str2num(a((k{1}+7):length(a)));
        if EDFtable(b,11)==0
            EDFtable(b,11)=0.001;
        end

    end 
    
 end
 
 if EDFtable(b,4)>0 & EDFtable(b,3)==0
        EDFtable(b,3)=EDFtable(b,2);
 end
 
 

 
 %%%% find the saccade after fixation off and before choice in
 clear I
 I=find(ESACC(:,3)>(EDFtable(b,3)+EDFtable(b,5)-200) &  ESACC(:,4)<(EDFtable(b,4)+EDFtable(b,5))+300);
 ESACC(I,11)=b;
 if isempty(I)==0 & EDFtable(b,4)>0 & (max(ESACC(I,10))>3 )
     i0=find(ESACC(I,10)==max(ESACC(I,10)));
     i0=i0(1);
     I=I(i0);
 EDFtable(b,6)=ESACC(I,3)-t_start(b);
 EDFtable(b,7)=ESACC(I,4)-t_start(b);
 EDFtable(b,8)=ESACC(I,5);
 EDFtable(b,9)=ESACC(I,10);
 EDFtable(b,10)=ESACC(I,11);
 else
  EDFtable(b,6:10)=zeros(1,5);
 end
    end
end
%%
eval(['EDFtable',char(Filetag(iii)),'=EDFtable;']);

  end

  load(Eventfile,'InfoTrial');

EDFtable=cat(1,EDFtableC,EDFtableI);
EDFtable=EDFtable(1:size(InfoTrial,1),:);
% 
save(Eventfile,'EDFtable','-append');


InfoTrial.SaccadeStart=EDFtable(:,6);
InfoTrial.SaccadeEnd=EDFtable(:,7);
InfoTrial.SaccadeV=EDFtable(:,10);
InfoTrial.SaccadeAmp=EDFtable(:,9);
InfoTrial.Reward=EDFtable(:,11);
InfoTrial.ResultOn2=EDFtable(:,12);
InfoTrial.BGOn2=EDFtable(:,13);
InfoTrial.TGOn2=EDFtable(:,2);

save(Eventfile,'InfoTrial','-append');