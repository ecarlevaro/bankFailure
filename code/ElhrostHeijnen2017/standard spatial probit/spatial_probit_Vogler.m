function [paramest,paramstd,logL,Varcov]=spatial_probit(a,data,W,vars)

%In: spatial probit data (a is a vector with adoptiond dates, data is a struct with exo. vars for each period, W the spatial weigth matrix and vars which columns of data(t).X to include)
%Out: ml-estimates, standard deviation and value of loglikelihood
%Optimization- and econometrics toolbox are needed

%handy stuff
options = optimset;
options = optimset(options,'Display' ,'iter');
options = optimset(options,'HessUpdate' ,'bfgs'); %bfgs
options = optimset(options,'InitialHessType' ,'scaled-identity');
options = optimset(options,'LargeScale' ,'off');
options = optimset(options,'MaxFunEvals',1e8, 'MaxIter',1e8);
N=size(W,1); 
%T=max(a(a<inf));
T=size(data,2)

S=0;
for t=1:T
S=S+data(t).X(:,vars);
end
S=S/T;
temp = sar(a<inf,S,W); beta_init=[temp.beta; tan(.5*pi*temp.rho)]; clear temp; %get good initial value
%beta_init=[temp.beta; temp.rho];
%seed=rand(N,100); %use same random numbers to facilitate convergence;

%find optimal value for rho
%while not(exist('optbeta','var'))
%try
[optbeta,logL]=fminsearch(@adjlogl,beta_init,options);
%catch err
%disp('Trying a new seed')
%seed=rand(N,100); %use new random numbers if convergence fails
%rethrow(err);
%end
%end

paramest=[optbeta(1:end-1); 2*atan(optbeta(end))/pi];
%paramest=optbeta;
logL=-logL;
 
H=0;
for t=1:T
H=H+hessian(@(z)LikeliSALEISProbitcode(W,data(t).X(:,vars),a<=t,3,1000,z),[paramest(end); paramest(1:end-1)]);
end
Varcov=inv(H);
paramstd=sqrt(diag(Varcov))';

%aux. functions: log-likelihood conditional after transforming rho back to [-1,1]
function ll=adjlogl(beta)
rhoadj=2*atan(beta(end))/pi;
%rhoadj=beta(end);
ll=0;
for t=1:T
    ll=ll+feval(@(z)LikeliSALEISProbitcode(W,data(t).X(:,vars),a<=t,3,1000,[rhoadj; z]),beta(1:end-1));
end
end

end

