function [mr0,nr0]=plotminmax(t,r,mr0,nr0,color_num)
                plot(t,r','Color',color_num); hold on;
                mr=max(r);
                nr=min(r);
                if mr>mr0 
                    mr0=mr;
                end
                if nr<nr0
                    nr0=nr;
                end
                box off;set(gca,'TickDir','out')