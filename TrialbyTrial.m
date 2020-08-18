

figure(2)
t=-500:501;

clim=[0 120];
I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500  & GS_I==1 & InfoTrial.PreferD==Targ_dmax;
y=1:sum(I);
B=InfoTrial.Block(I);
for i=2:size(B)
    if B(i)~=B(i-1)
        change(i)=1;
    end
end
changeI=find(change==1);
Spike_TG_Chosen=Spike_TG(I,:);
subplot(221)
imagesc(t,y,Spike_TG_Chosen,clim);hold on;
for c=1:length(changeI)
    plot(t,changeI(c)*ones(size(t)),'r');hold on;
end

I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500  & GS_I==1 & InfoTrial.NPreferD==Targ_dmax;
y=1:sum(I);
B=InfoTrial.Block(I);
for i=2:size(B)
    if B(i)~=B(i-1)
        change(i)=1;
    end
end
Spike_TG_Chosen=Spike_TG(I,:);
subplot(222)
imagesc(t,y,Spike_TG_Chosen,clim);hold on;
for c=1:length(changeI)
    plot(t,changeI(c)*ones(size(t)),'r');hold on;
end

I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500  & GC_I==1 & InfoTrial.PreferD==Targ_dmax;
y=1:sum(I);
B=InfoTrial.Block(I);
for i=2:size(B)
    if B(i)~=B(i-1)
        change(i)=1;
    end
end
changeI=find(change==1);
Spike_TG_Chosen=Spike_TG(I,:);
subplot(223)
imagesc(t,y,Spike_TG_Chosen,clim);hold on;
for c=1:length(changeI)
    plot(t,changeI(c)*ones(size(t)),'r');hold on;
end
% axis([-200 

I= InfoTrial.Repeat>-1 & InfoTrial.SaccadeStart>500  & GC_I==1 & InfoTrial.NPreferD==Targ_dmax;
y=1:sum(I);
B=InfoTrial.Block(I);
for i=2:size(B)
    if B(i)~=B(i-1)
        change(i)=1;
    end
end
Spike_TG_Chosen=Spike_TG(I,:);
subplot(224)
imagesc(t,y,Spike_TG_Chosen,clim);hold on;
for c=1:length(changeI)
    plot(t,changeI(c)*ones(size(t)),'r');hold on;
end