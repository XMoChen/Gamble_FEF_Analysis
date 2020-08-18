function giveJuice_G

% giveJuice
global dio env

 beep();

juiceChannel = 1;
juiceSecs = 0.5;
pulseWidth1 = 0.2;
pulseWidth2 = 0.5;

tmp = zeros(1,1);
[tmp(juiceChannel)] = deal(1);
on = [1 0 0 0 0 0 0 0];%tmp + allDIOclosed;%env.allDIOclosed;
off = [0 0 0 0 0 0 0 0];%allDIOclosed;%env.allDIOclosed;

% get timestamp
timeStamp = GetSecs();
 counter = 0;
while counter < 25 %GetSecs() < timeStamp+pulseWidth1 %
    dio.outputSingleScan(on);
      counter = counter + 1;
end
% dio.outputSingleScan(off);
    % close DIO
timeStamp = GetSecs();
counter = 0;
while counter < 200 %GetSecs() < timeStamp+pulseWidth2
dio.outputSingleScan(off);
  counter = counter + 1;

end
% 
% % timeStamp = GetSecs();
%  counter = 0;
% while counter < 50 %GetSecs() < timeStamp+pulseWidth1 %
%     dio.outputSingleScan(on);
%     counter = counter + 1;
% end
