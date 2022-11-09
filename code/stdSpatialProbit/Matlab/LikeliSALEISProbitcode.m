function phat= LikeliSALEISProbitcode(W,X,y,iter,ns,par)

warning('off', 'MATLAB:rankDeficientMatrix')

% W denotes NxN matrix of spatial weight 
% y denotes Nx1 vector of a binary dependent variable 
% iter denotes number of EIS regressions 
% ns  denotes number of trajectories 
% par denotes Kx1 vector of paramters with par(1) being the spatial paramter rho!!



% determine number of observations
N=length(W);

% create Q matrix that allows to write the likelihood as an integral in
% terms of upper bounds
Q = spdiags(1-2*y,0,N,N);

% starting values
param=par;
% applies sine restriction to spatial paramter rho which ensures |rho|<=c
c=1-0.00001;
param(1)=rhorestrict(par(1),c);  % => search value for param(1) which satisfies sin(param(1))*c=rho


% create common random numbers (crn's)
rng(1234567) % control seed
crnu=unifrnd(0,1,N,ns)';

% inverse covariance matrix and truncation threshold 
Destinv=speye(N,N)-sin(param(1))*c*W;
Sigmainv=Q'*(Destinv'*Destinv)*Q;
v=(Destinv*(-Q))\(X*param(2:end));
% reorder to reduce number of non-zero elements during EIS procedure
ppp=symamd(Sigmainv);
Sigmainv=Sigmainv(ppp,ppp);
v=v(ppp);

         % matrices and vectors needed for sampling u and computing likelihood estimate
         av   = zeros(N,1);
         ap   = zeros(N,1);
         aq   = cell(N,1);
         avec = zeros(N,1);
         bmat = spalloc(N,N,ceil(0.02*N^2));
         eisc = zeros(N,2);
         u = zeros(ns,N);
         
         
         % initial draws         
         
         % coefficients of the initial sampler
         Smat=Sigmainv;
         for i=1:N
             av(i)=1/Smat(1,1);             
             aq{i} = - Smat(2:N-(i-1),1)/Smat(1,1);
             Smat = Smat(2:N-(i-1),2:N-(i-1)) - 1/Smat(1,1)*(Smat(2:N-(i-1),1)*Smat(2:N-(i-1),1)');
         end
         
         % simulating from the initial sampler         
         u(:,N)  = sqrt(av(N))*norminv(normcdf(v(N)/sqrt(av(N)),0,1)*crnu(:,N),0,1);
         
         for i=N-1:-1:2
             u(:,i)    = u(:,i+1:N)*aq{i} + sqrt(av(i))*norminv(normcdf((v(i)-u(:,i+1:N)*aq{i})/sqrt(av(i)),0,1).*crnu(:,i),0,1);
         end
         
        
         % loop through the EIS iterations  
         for k=1:iter
             
             Pmatstar = spalloc(N-1,N-1,ceil(0.01*N^2));             
             Smat=Sigmainv;             
             qvecstar = zeros(N-1,1);
             rstar    = 0;
             
             a = v(1)*sqrt(Smat(1,1)); % (1 X 1)
             b = Smat(2:N,1)/sqrt(Smat(1,1));  % (N-1 X 1)
             Smat = Smat(2:N,2:N) -(Smat(2:N,1)*Smat(2:N,1)')/Smat(1,1); 

             % loop through the regions: 2 -> N-1
             for i=2:N-1
                 
                 % EIS regression
                 omeg = a + u(:,i:N)*b;  % (ns X 1)
                 phim = normcdf(omeg);
                 phim(phim==0)=realmin; % necessary to mantain sparsity of Pmat
                 yy   = log( phim ); 
                 xx   = [ones(ns,1) omeg (omeg.*omeg)]; % (ns X 3)
                 beis = xx\yy;
                 beis(isnan(beis))=inf;
                 alphahat = -2*beis(3);
                 alphahat(alphahat<0)=0; % avoid negative variance in Pmat
                 betahat  =  -beis(2);
                 
                 % store expreesions needed for likelihood evaluation                 
                 avec(i) = a;
                 bmat(i:N,i) = b;
                 eisc(i,1) = alphahat;
                 eisc(i,2) = betahat;
                 
                 % P-matrix and q-vector
                 Pmat = alphahat*(b*b') + Pmatstar + [Smat(1,1) Smat(2:N-(i-1),1)'; Smat(2:N-(i-1),1) (Smat(2:N-(i-1),1)*Smat(2:N-(i-1),1)')/Smat(1,1)] ;
                 qvec = qvecstar - (betahat + alphahat*a)*b;
                 r    = alphahat*(a^2) + 2*betahat*a + rstar;
                 
                 % coefficients of the EIS sampler
                 av(i) = 1/Pmat(1,1);
                 ap(i) = qvec(1)/Pmat(1,1);
                 aq{i} = - Pmat(2:N-(i-1),1)/Pmat(1,1);
                 
                 % update
                 a = sqrt(Pmat(1,1))*( v(i) - (qvec(1)/Pmat(1,1)) );
                 b = Pmat(2:N-(i-1),1)/sqrt(Pmat(1,1)) ;
                 
                 Pmatstar = Pmat(2:N-(i-1),2:N-(i-1)) - (Pmat(2:N-(i-1),1)*Pmat(2:N-(i-1),1)')/Pmat(1,1);
                 qvecstar = qvec(2:N-(i-1)) - (qvec(1)*Pmat(2:N-(i-1),1))/Pmat(1,1);
                 rstar    = r -  (qvec(1)^2)/Pmat(1,1) + log(Pmat(1,1)) - log(Smat(1,1));
                 Smat = Smat(2:N-(i-1),2:N-(i-1)) - (Smat(2:N-(i-1),1)*Smat(2:N-(i-1),1)')/Smat(1,1);
             
             end
             
             % for the last region             
             omeg = a +  u(:,N)*b;  % (ns X 1)
             omeg=full(omeg); % sometimes omeg results as sparse which causes an error later in the code 
             
             % EIS regression
             phim = normcdf(omeg); % (ns X 1)
             yy   = log( phim ); 
             xx   = [ones(ns,1) omeg (omeg.*omeg)]; % (ns X 3)
             beis = xx\yy;
             alphahat = -2*beis(3);
             alphahat(alphahat<0)=0; % avoid negative variance in Pmat
             betahat  =  -beis(2);
             
             % store expreesions needed for likelihood evaluation  
             avec(N)   = a;
             bmat(N,N) = b;
             eisc(N,1) = alphahat;
             eisc(N,2) = betahat;                   
             
             % P-matrix and q-vector
             Pmat = Smat + alphahat*(b*b') + Pmatstar;
             qvec = qvecstar - (betahat + alphahat*a)*b;
             r    = alphahat*(a^2) + 2*betahat*a + rstar;
             
             % coefficients of the EIS sampler
             av(N) = 1/Pmat(1,1);
             ap(N) = qvec(1)/Pmat(1,1);
             % end loop through regions
             

             % simulating from the EIS sampler
             u(:,N)  = ap(N) + sqrt(av(N))*norminv(normcdf((v(N)-ap(N))/sqrt(av(N)),0,1)*crnu(:,N),0,1);
             
             for i=N-1:-1:2
                 u(:,i)    = ap(i) + u(:,i+1:N)*aq{i} + sqrt(av(i))*norminv(normcdf((v(i) - ap(i) - u(:,i+1:N)*aq{i})/sqrt(av(i)),0,1).*crnu(:,i),0,1);
             end
             
         end % end loop EIS iterations
           
           
           % computing the EIS estimate of the probability           
           omegamat = repmat(avec(2:N),1,ns) + (u(:,2:N)*bmat(2:N,2:N))'; % N-1 x ns
           phieis=normcdf(omegamat);
           lng=log( phieis) + 0.5*(  repmat(eisc(2:N,1),1,ns).*(omegamat.*omegamat) + 2*repmat(eisc(2:N,2),1,ns).*(omegamat)    ) ;
           scal=mean(mean(lng)); % needed for numerical stabilization
           lngs=lng-scal; % N-1 x ns
           tg1    = log(mean(exp(sum(lngs))));
           logchiN = 1/2*(log(av(N)) + log(Smat(1,1)) + 2*log(normcdf( (v(N) - ap(N))/sqrt(av(N)),0,1 )) - r + ((ap(N)^2)/av(N)));       
           phat = -(logchiN+tg1)- (N-1)*scal;      
         
end


function x=rhorestrict(rho,c)

 x= fsolve(@sinerestrict,0.3,optimset('fsolve'),rho,c);
 
end
 

function yr=sinerestrict(x,rho,c)
    
    yr=rho-sin(x)*c;

end
