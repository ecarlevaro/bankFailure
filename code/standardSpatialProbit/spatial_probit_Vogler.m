function [paramest,paramstd,logL,Varcov]=spatial_probit(y,X,W)

    %In: spatial probit data (a is a vector with adoptiond dates, data is a struct with exo. vars for each period, W the spatial weigth matrix and vars which columns of data(t).X to include)
    %Out: ml-estimates, standard deviation and value of loglikelihood
    %Optimization- and econometrics toolbox are needed

    %handy stuff
    options = optimset;
    options = optimset('Display' ,'notify');
    options = optimset('HessUpdate' ,'bfgs'); %bfgs
    %options = optimset(options,'InitialHessType' ,'scaled-identity');
    options = optimset('LargeScale' ,'off');
    options = optimset('MaxFunEvals',1e4, 'MaxIter',1e4);
    N=size(W,1); 
    %T=max(a(a<inf));
    T=size(X,2)
    % EMI: the matrix S of covariates, ?is the average for the time? 
    % Yes. S is only used as covariate for the 1-perio SAR model. 
    % The probit likelihood is computed 
    %{ 
    S=0;
    for t=1:T
        S=S+data(t).X(:,vars);
    end
    S=S/T;
    %}
    %{
    % EMI: I?m pooling all observations.
    % EMI: then S is (58*21)*7
        S = data(1).X(:,vars) 
            for t=2:T
                S = [S;
                    data(t).X(:,vars)];
            end
            % EMI: exapands Y to 58x24
            Y = repelem( (a<Inf), T);
            W = repmat(W, T);
            r = sar(Y,S,W);
   %}
    % a<inf generates a dummy var with 1 for countries that adopted IT
    temp = sar(y,X,W); 
    beta_init=[temp.beta; tan(.5*pi*temp.rho)];
    clear temp; %get good initial value
    %beta_init=[temp.beta; temp.rho];
    %seed=rand(N,100); %use same random numbers to facilitate convergence;

  
    %find optimal value for rho
    %while not(exist('optbeta','var')) 
        %EMI: check the existenve of the (var)iable 'optbeta'
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
T=1
    H=0;
    for t=1:T
    H=H+hessian(@(z)LikeliSALEISProbitcode(W, X, y, 3,1000,z),[paramest(end); paramest(1:end-1)]);
    end
    Varcov=inv(H);
    paramstd=sqrt(diag(Varcov))';

    function ll = adjlogl(beta)
        rhoadj=2*atan(beta(end))/pi;
        %rhoadj=beta(end);
        ll=0;
        for t=1:T
            ll=ll+feval(@(z)LikeliSALEISProbitcode(W, X, y, 3,1000,[rhoadj; z]),beta(1:end-1));
        end
    end
end



