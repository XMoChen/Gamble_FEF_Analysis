function  y=mymodelfun (x,b) 


%prelec=@(b,x) exp(-b(2)*(-log(x)).^b(1));%b*x;%
power=@(b,x) x.^b;
Utility=@(b,x) power(b(1),x(:,1))*0.5+power(b(1),x(:,2))*0.5;
%size(x)
UtilityDif=@(b,x) Utility(b,x(:,1:2))-Utility(b,x(:,3:4));
y=(1./(1 + exp(-UtilityDif(b(1),x))+b(2)))+10^-10;

end