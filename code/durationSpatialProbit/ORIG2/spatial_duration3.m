function [paramest,paramstd,logL,H]=spatial_duration(a,data,W,vars,init)

%In: a (vector with adoptiondates), data (struct with the exogenous
                                          %variables), W (the spatial weight matrix), vars (which colums of X to include)
%Out: ml-estimates, standard deviation and value of loglikelihood
%Optimization- and econometrics toolbox are needed
%UPDATE: June 15, 2014
%This routine incorporates the likelihood function of Liesenfeld, Richard and Vogler (2013) and should be faster

%handy stuff
options = optimset;
options = optimset(options,'Display' ,'notify');
options = optimset(options,'MaxFunEvals' ,10000);
options = optimset(options,'MaxIter' ,5000);
N=size(W,1); 
% T=max(a(a<inf));
T=size(data,2);

if nargin==4 %if no initial guess has been supplied
    S=0;
    for t=1:T
        S=S+data(t).X(:,vars);
    end
    S=S/T;
    temp = sar(a<inf,S,W); 
    init=[temp.rho; temp.beta; temp.rho]; 
    clear temp S; %get good initial value
end

[paramest,logL]=fminsearch(@(x)-likadj(x),init,options);
temp=paramest(end);
paramest(end)=2*atan(temp)/pi;
logL=-logL;

try
    H=hessian(@lik,paramest);
    paramstd=sqrt(diag(-inv(H)));
catch
    paramstd=[];
end

%aux. functions: max log-likelihood -- transform rho such that rho\in(-1,1)
function L=likadj(param)
    paramadj=param; paramadj(end)=2*atan(param(end))/pi;
    L=lik(paramadj);
end

function L=lik(param)
    %the likelihood for the duration model
    L=0;
    for tt=1:T
        %{
        a = [ 3 4 4 5 Inf Inf]
        W = [ 0 1 0 1 0
              0 0 0 1 1
              1 1 1 0 1
              0 0 0 0 0
              1 1 1 0 0]
        tt = 4
        %}
        %At time t: which banks are dead? I=1 if bank is dead by time t
        I=(a<tt);
        %Which banks die at time t?
        J=(a==tt);
        % y at t has all banks that are alive at the beginning of t (= those who did not fail by t, I==0)
        y=J(I==0);% 1 x (Survivors+Failing on t)
        %{
        I==0: alive at the beginning of t
        I==1: dead
        select all rows in W of alive at the beginning of t and columns of dead
        W(I==0,I==1): links from alive to dead
        sum(W(I==0,I==1),2): a column vector with the sum of each row
        I==0 | J==1: choose all rows from X_t of banks alive at the
        beginning of t (not dead=I==0 OR dying on t, J==1)
        This column vector is another covariate that recover the weights of
        the dying banks with the bank that survive t (cells of W).
        %}
        
        X=[sum(W(I==0,I==1),2) data(tt).X(I==0 | J==1,vars)]; %first column is effect of countries that have already switched
        % The W matrix of only links between banks alive
        Whier=W(I==0,I==0);
        for i=1:size(Whier,1)
            % Normalises again the network matrix
            if sum(Whier(i,:))~=0
                Whier(i,:)=Whier(i,:)/sum(Whier(i,:));
            end
        end
        L=L-LikeliSALEISProbitcode(Whier,X,y,3,1000,[param(end); param(1:end-1)]);
    end
end

end
