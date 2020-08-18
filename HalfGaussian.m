function kernel=HalfGaussian(sigma)
%     sigma=15;
    edges=[-3*sigma:1:3*sigma];
    kernel=normpdf(edges,0,sigma);
    kernel(1,(1:(3*sigma)))=zeros(1,3*sigma);
    kernel=kernel/sum(kernel);