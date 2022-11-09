load results0.mat
% load InflationTargeting results from previous matlab file after model has been estimated

% rho1 - spatial effect of countries that switch in the same period
% rho2 - spatial effect of countries that have already switched

fprintf('Distance Matrix W, variable set C, logL= %3.2f\n',logL)
fprintf('parameter\t estimate (std)\n')
fprintf('rho1\t %2.4f (%2.4f)\n',paramest(end),paramest(end)/paramstd(end))
%fprintf('rho2\t %2.4f (%2.4f)\n',paramest(1),paramest(1)/paramstd(1))
for i=1:length(vars)
     fprintf('var. %1.0d\t %2.4f (%2.4f)\n',vars(i),paramest(i+1),paramest(i)/paramstd(i))
end

% Print out effects estimates
Varcov=Varcov;
tic
N = 105
T = 1
vars = [1 2 3 4 5 6 7 8 9 10]
info.N=N;
info.T=T;
info.cov=Varcov; %inv(H);
info.parm=paramest;

y=zeros(N*T,1);
x=zeros(N*T,length(vars)+1);
W=zeros(N,N,T);
index=zeros(T,1);

for tt=1:T
    % At time t: which countries have switched?
    I=(adoptiondate<tt);
    index(tt)=N-sum(I);
    %Which countries switch at time t?
    if (tt==1) t1=1;t2=index(tt);
    else t1=t1+index(tt-1);t2=t2+index(tt);
    end
    J=(adoptiondate==tt);
    y(t1:t2,1)=J(I==0);
    x(t1:t2,:)=[sum(V(I==0,I==1),2) data(tt).X(I==0 | J==1,vars)]; %first column is effect of countries that have already switched
    W(1:index(tt),1:index(tt),tt)=V(I==0,I==0);
end

info.cflag=1; % model contains an intercept
%info.cflag=0; % model does not contain an intercept
spat_model=0;
%info.index=index; % no needed for SAR model (spat_model=0)
direct_indirect_effects_estimates_probit(info,W,y,x,spat_model);

