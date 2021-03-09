function z=loglik(param,y,x,W,seed)
%log-likelihood of spatial panel

b=param(1:end-1);
r=param(end);
N=size(W,1);

mu=inv(eye(N)-r*W)*x*b;
Sigma=inv(eye(N)-r*W)*inv(eye(N)-r*W)';

if nargin==5
    z=log(tnprob(mu,y,Sigma,seed));
else
    z=log(tnprob(mu,y,Sigma));
end