 function plotstd(t,x,color)
% x=squeeze(ConditionsIn_Spike(:,1,:));
% color='r:';
color1=color(1);
colorn=1;
if strncmp(color1,'r',1)==1
    cfill=[1,0.8,0.8];
elseif strncmp(color1,'k',1)==1
    cfill=[0.8,0.8,0.8];
elseif strncmp(color1,'b',1)==1
    cfill=[0.8,0.8,1];
elseif strncmp(color1,'m',1)==1
    cfill=[1,0.8,1];
elseif strncmp(color1,'g',1)==1
    cfill=[0.8,1,0.8];
elseif strncmp(color1,'c',1)==1
    cfill=[0.8,1,1];
else
      cfill=color+0.1;
      cfill(cfill>1)=1;
      colorn=0;
end  
r=squeeze(nanmedian(x,1));
if colorn==1
plot(t,r,color);hold on;
else
 plot(t,r,'Color',color);hold on;
end   
sdx=nanstd(x,1)/sqrt(size(x,1)-1);
tx=[t,flipdim(t,2)];
y=[r+sdx,flipdim(r-sdx,2)];
h=fill(tx,y,cfill);hold on;
alpha(0.5);
%cfill
set(h,'edgecolor',cfill);
alpha(0.5);
if colorn==1
plot(t,r,color);hold on;
else
 plot(t,r,'Color',color);hold on;
end 
