% PURPOSE: An example of using gwr()
%          Geographically weighted regression model
%          (on a small data set)                  
%---------------------------------------------------
% USAGE: gwr_d 
%---------------------------------------------------

% load the Anselin data set
load anselin.dat;
y = anselin(:,1);
nobs = length(y);
x = [ones(nobs,1) anselin(:,2:3)];
[nobs nvar] = size(x);
north = anselin(:,4);
east = anselin(:,5);

vnames = strvcat('crime','constant','income','hvalue');

% y =  dependent variable
% x = a matrix of indepdendent variables
% east holds  x-coordinates
% north holds y-coordinates
% nobs = # of observations
% nvar = # of explanatory variables
info.dtype = 'gaussian'; % Gaussian distance weighting
tic; result1 = gwr(y,x,east,north,info); toc;
%prt(result1,vnames);
info.dtype = 'exponential'; % exponential distance weighting
tic; result2 = gwr(y,x,east,north,info); toc;
%prt(result2,vnames);
info.dtype = 'tricube'; % tricube distance weighting
info.qmin = nvar+1; info.qmax = 20;
tic; result3 = gwr(y,x,east,north,info); toc;
%prt(result3,vnames);


% re-order the data
[ys,yind] = sort(anselin(:,1));
nobs = length(y);
xs = [ones(nobs,1) anselin(yind,2:3)];
[nobs nvar] = size(x);
norths = anselin(yind,4);
easts = anselin(yind,5);

info.dtype = 'gaussian'; % Gaussian distance weighting
tic; result1s = gwr(ys,xs,easts,norths,info); toc;
%prt(result1,vnames);
info.dtype = 'exponential'; % exponential distance weighting
tic; result2s = gwr(ys,xs,easts,norths,info); toc;
%prt(result2,vnames);
info.dtype = 'tricube'; % tricube distance weighting
info.qmin = nvar+1; info.qmax = 20;
tic; result3s = gwr(ys,xs,easts,norths,info); toc;
%prt(result3,vnames);

% plot results for comparison (see also plt)
tt=1:nobs;
subplot(3,1,1),
plot(tt,result1.beta(yind,1),tt,result1s.beta(:,1),'--');
legend('Gaussian','Gaussian2');
ylabel('Constant term');
subplot(3,1,2),
plot(tt,result2.beta(yind,2),tt,result2s.beta(:,2));
legend('Exponential','Exponential2');
ylabel('Household income');
subplot(3,1,3),
plot(tt,result3.beta(yind,3),tt,result3s.beta(:,3),'--');
legend('tricube','tricube2');
ylabel('House value');

