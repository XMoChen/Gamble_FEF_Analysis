%%% Error bar plot 
%%% Written by xc   01/25/2017
function errorbarplot(model_series,model_error,barsize)

if nargin ==2
bar(model_series);hold on; 
elseif nargin==3
bar(model_series,barsize);hold on;
end
numgroups = size(model_series, 1); 
numbars = size(model_series, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on baarweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      h=errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end
% %hc = get(h, 'Children')
% set(hc(1),'color','r') %// data
% set(hc(2),'color',[0.5 0.5 0.5]) %// error bars