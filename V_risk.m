function [b,aic,bic,LL]=V_risk(x,z)


xx=[z,x];%(1-z),x(:,3:4),x(:,1:2)];
%xx=[z,x];
x=xx;
size(x)

%%%%  prelec probability modeld
 costfun= @ (b) -((sum(x(:,1).*log(mymodelfun(x(:,2:5),b))))+ sum(((1-x(:,1)).*log(abs((1-mymodelfun(x(:,2:5),b)))))));


cos0=100000;
for t=1:10
%b0=fmincon(costfun, [10*rand(1),10*rand(1) 10*rand(1)],[],[],[],[],[0,0,0],[10,10,30]);  
b0=fmincon(costfun, [5*rand(1) 5*rand(1)],[],[],[],[],[0 0 ],[5 5]);  

cos=costfun(b0);

if cos<cos0 %& isreal(cos2)==1
    b=b0;
    cos0=cos;
end
end

%RSS=sum((x(:,1)-mymodelfun2(x(:,2:5),b)).^2);
sampleN=length(x(:,1));
LL=-cos0/sampleN;
[aic,bic] = aicbic(-cos0,4,sampleN);


end



