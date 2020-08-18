subplot(421)
clear h
d_color={'k','r'};
for d=1:2  
h(d)=plot(t,squeeze(nanmean((nanmean(nanmean(FireAll0(:,:,d,:,:),2),4)),1))',char(d_color(d))); hold on;
plotstd(t,squeeze((nanmean(nanmean(FireAll0(:,:,d,:,:),2),4))),char(d_color(d))); hold on;
end
legend([h(1),h(2)], {'D1','D2'});
box off;set(gca,'TickDir','out')
title('Direction');
axis(lim); axis square 


con_color={'k','g','m'};
for d=1:2   
subplot(4,2,2+d)
for contr=1:3
h(contr)=plot(t,squeeze(nanmean((nanmean(nanmean(FireAll0(:,contr,d,:,:),2),4)),1))',char(con_color(contr))); hold on;
plotstd(t,squeeze((nanmean(nanmean(FireAll0(:,contr,d,:,:),2),4))),char(con_color(contr))); hold on;
end
%plot(t,squeeze((nanmean(nanmean(nanmean(FireAll0(:,:,d,:,:),1),4))))); hold on;
box off;set(gca,'TickDir','out')
legend([h(1),h(2),h(3)],{'0','1','2'});
title('Contrast');
axis(lim); axis square 
end


r_color={'k','b','r'};
for d=1:2   
subplot(4,2,4+d)
for v=1:3
h(v)=plot(t,squeeze(nanmean((nanmean(nanmean(FireAll0(:,1,d,v,:),2),4)),1))',char(r_color(v))); hold on;
plotstd(t,squeeze(((nanmean(FireAll0(:,1,d,v,:),2)))),char(r_color(v))); hold on;
end
%plot(t,squeeze((nanmean(nanmean(FireAll0(:,:,d,:,:),1),2)))'); hold on;
%plot(t,squeeze(nanmean(nanmean(FireMean,1),2))); hold on;
box off;set(gca,'TickDir','out')
legend([h(1),h(2),h(3)],{'low','med','high'});
title('Subjective Value');
axis(lim); axis square 
end
r_color={'k','b','r'};
for d=1:2   
subplot(4,2,6+d)
for v=1:3
h(v)=plot(t,squeeze(nanmean((nanmean(nanmean(FireAll0(:,2:3,d,v,:),2),4)),1))',char(r_color(v))); hold on;
plotstd(t,squeeze(((nanmean(FireAll0(:,2:3,d,v,:),2)))),char(r_color(v))); hold on;
end
%plot(t,squeeze((nanmean(nanmean(FireAll0(:,:,d,:,:),1),2)))'); hold on;
%plot(t,squeeze(nanmean(nanmean(FireMean,1),2))); hold on;
box off;set(gca,'TickDir','out')
legend([h(1),h(2),h(3)],{'low','med','high'});
title('Subjective Value');
axis(lim); axis square 
end