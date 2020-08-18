function kernel=SpikedensityKernel(Kernelflag)
if strcmp(Kernelflag,'exponential')
Growth=1; Decay=10;
Half_BW=round(Decay*5);
BinSize=(Half_BW*2)+1;
Kernel=[0:Half_BW];
Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
Half_Kernel=Half_Kernel./sum(Half_Kernel);
Kernel(1:Half_BW)=0;
Kernel(Half_BW+1:BinSize)=Half_Kernel;
Kernel=Kernel.*1000;
kernel=Kernel';
elseif strcmp(Kernelflag,'gaussian')
    sigma=30;
    edges=[-3*sigma:1:3*sigma];
    kernel=normpdf(edges,0,sigma)'*1000;
end