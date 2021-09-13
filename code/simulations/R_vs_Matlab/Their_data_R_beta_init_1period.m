% Compute standard spatial probit model using 1-period data (T=1). 
% OUR DATA
% The beta_init vector with initial estimates come from R.
 %[paramest,paramstd,logL,Varcov] = puto()
 [paramest, paramstd, logL, Varcov ] = puto()
function [paramest, paramstd, logL, Varcov ] = puto()
    % LOAD DATA
    % THeir data
    addpath 'C:\Users\22457561\OneDrive\UWA PhD\bankFailure\code\simulations\R_vs_Matlab'
    addpath(genpath('C:\Users\22457561\OneDrive\UWA PhD\bankFailure\code\standardSpatialProbit'))

    path = 'C:\Users\22457561\OneDrive\UWA PhD\bankFailure\code\simulations\R_vs_Matlab'
    y = readmatrix(strcat(path, '\ElhrostHeijnen2017\their_data.xlsx'),...
            'Sheet', 'adoption')
    X = readmatrix(strcat(path, '\ElhrostHeijnen2017\their_data.xlsx'),...
            'Sheet', 'S')
    W = readmatrix(strcat(path, '\ElhrostHeijnen2017\their_data.xlsx'),...
            'Sheet', 'W')
    
    %normalize W
    for i=1:size(W,1)
        if sum(W(i,:))~=0
            W(i,:)=W(i,:)/sum(W(i,:));
        end
    end
    %In: spatial probit data (a is a vector with adoptiond dates, data is a struct with exo. vars for each period, W the spatial weigth matrix and vars which columns of data(t).X to include)
    %Out: ml-estimates, standard deviation and value of loglikelihood
    %Optimization- and econometrics toolbox are needed

    %handy stuff
    options = optimset;
    options = optimset(options,'Display' ,'iter');
    options = optimset(options,'HessUpdate' ,'bfgs'); %bfgs
    %options = optimset(options,'InitialHessType' ,'scaled-identity');
    options = optimset(options,'LargeScale' ,'off');
    options = optimset(options,'MaxFunEvals',1e8, 'MaxIter',1e8);
    N=size(W,1); 
    %T=max(a(a<inf));
    T=1

    % YOu don't need this since the matrix X is already the average over T
    % See the file, R_vs_Matlab/ELhorstHeijnen2017/Replication.mlx
    %{ 
    S=0;
        for t=1:T
            S=S+data(t).X(:,vars);
        end
        S=S/T;
    %}

    % INITIAL VALUE COMPUTED IN R
    %get good initial value
    %temp = sar(y,X,W); 
    %beta_init=[temp.beta; tan(.5*pi*temp.rho)]; 
    beta_init = [0.6569179 -1.6363411 -0.0316489 0.3040898 -0.0042748 -0.3129218 0.1021059 tan(.5*pi*-0.3569)]'
    %clear temp;
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
        H = H + hessian(@(z)LikeliSALEISProbitcode(W,data(t).X(:,vars),a<=t,3,1000,z), ...
            [paramest(end); paramest(1:end-1)]);
    end
    Varcov=inv(H);
    paramstd=sqrt(diag(Varcov))';
    
    %aux. functions: log-likelihood conditional after transforming rho back to [-1,1]
    function ll=adjlogl(beta)
        rhoadj=2*atan(beta(end))/pi;
        %rhoadj=beta(end);
        ll=0;
        for t=1:T
            %ll=ll+feval(@(z)LikeliSALEISProbitcode(W,data(t).X(:,vars),a<=t,3,1000,[rhoadj; z]),beta(1:end-1));
            ll= ll + feval(@(z)LikeliSALEISProbitcode(W, X, y, 3, 1000, [rhoadj; z]), beta(1:end-1));
        end
    end
end
