function direct_indirect_effects_estimates_probit(info,W,y,x,spat_model)
% PURPOSE: computes and prints direct, indirect and total effects estimates of spatial probit model 
%---------------------------------------------------
% USAGE: direct_indirect_effects_estimates(info,x,spat_model)
% Where: info       = a structure which needs to be provided by the user 
%        W          = spatial weights matrix used to estimate model 
%        spat_model = 0, sar model
%                   = 1, spatial Durbin model
%--------------------------------------------------- 
% Developed by J.Paul Elhorst winter 2013
% University of Groningen
% Department of Economics, Econometrics and Finance
% 9700AV Groningen
% the Netherlands
% j.p.elhorst@rug.nl
%
N=info.N;
parm=info.parm;
cflag=info.cflag;
cov=info.cov;
%seed=info.seed;

if (spat_model==0)
    
[junk nvar]=size(x);
NSIM=1000;
if (cflag==1) nvarc=nvar-1; else nvarc=nvar; end
simresults=zeros(nvarc+1,NSIM);
simdir=zeros(nvarc,NSIM);
simind=zeros(nvarc,NSIM);
simtot=zeros(nvarc,NSIM);
simdirnp=zeros(nvarc,NSIM);
simindnp=zeros(nvarc,NSIM);
simtotnp=zeros(nvarc,NSIM);
probsim=zeros(NSIM,1);
for sim=1:NSIM
    parms = chol(cov)'*randn(size(parm)) + parm;
    rhosim = parms(nvar+1,1);
    if (cflag==1) betasim=parms(2:nvar,1);betap=parms(1:nvar,1);
    else betasim=parms(1:nvar,1);betap=betasim;
    end
    simresults(:,sim)=[betasim;rhosim];
    for p=1:nvarc
        C=zeros(N,N);
        for i=1:N
            for j=1:N
            if (i==j) C(i,j)=betasim(p);
            else C(i,j)=0;
            end
            end
        end
        hulp=(eye(N)-rhosim*W)\eye(N);
        mu=hulp*x*betap;
        Sigma=hulp*hulp';
        for i=1:N
            Sigma2=Sigma(i,i);
            Sigma1=Sigma;
            Sigma1(i,:)=[];
            Sigma1(:,i)=[];
            Sigma21=Sigma(i,:);Sigma21(:,i)=[];
            Sigma12=Sigma(:,i);Sigma12(i,:)=[];
            yobs=y;yobs(i)=[];
            muobs=mu;muobs(i)=[];
            help=Sigma1\eye(N-1);
            prob(i,1)=norm_pdf(y(i),mu(i)+Sigma21*help*(yobs-muobs),Sigma2-Sigma21*help*Sigma12);
        end
        S=diag(prob)*hulp*C;
        Snp=hulp*C;
        EAVD(p,1)=sum(diag(S))/N; % average direct effect
        EAVI(p,1)=sum(sum(S,2)-diag(S))/N; % average indirect effect
        EAVC(p,1)=sum(sum(S,1)'-diag(S))/N; % average indirect effect
        simdir(p,sim)=EAVD(p,1);
        simind(p,sim)=EAVI(p,1);
        simtot(p,sim)=EAVD(p,1)+EAVI(p,1);
        EAVD(p,1)=sum(diag(Snp))/N; % average direct effect
        EAVI(p,1)=sum(sum(Snp,2)-diag(S))/N; % average indirect effect
        EAVC(p,1)=sum(sum(Snp,1)'-diag(S))/N; % average indirect effect
        simdirnp(p,sim)=EAVD(p,1);
        simindnp(p,sim)=EAVI(p,1);
        simtotnp(p,sim)=EAVD(p,1)+EAVI(p,1);
        probsim(sim)=mean(prob);
    end
end

format shortg;

fprintf(1,'    direct    t-stat   indirect    t-stat   total    t-stat no_prob multiplication\n');
[mean(simdirnp,2) mean(simdirnp,2)./std(simdirnp,0,2) mean(simindnp,2) mean(simindnp,2)./std(simindnp,0,2)...
    mean(simtotnp,2) mean(simtotnp,2)./std(simtotnp,0,2)]

mean(probsim)

fprintf(1,'    direct          t-stat     indirect       t-stat       total       t-stat \n');
[mean(simdir,2) mean(simdir,2)./std(simdir,0,2) mean(simind,2) mean(simind,2)./std(simind,0,2)...
    mean(simtot,2) mean(simtot,2)./std(simtot,0,2)]

format short;

elseif (spat_model==1)

[junk nvartot]=size(x);
if (cflag==1) nvar=(nvartot-1)/2; else nvar=nvartot/2; end
if (cflag==1) nvartotc=nvartot-1; else nvartotc=nvartot; end
NSIM=1000;
simresults=zeros(nvartotc+1,NSIM);
simdir=zeros(nvar,NSIM);
simind=zeros(nvar,NSIM);
simtot=zeros(nvar,NSIM);
for sim=1:NSIM
    parms = chol(cov)'*randn(size(parm)) + parm;
    rhosim = parms(nvartot+1,1);
    if (results.cflag==1) betasim=parms(2:nvartot,1);betap=parms(1:nvartot,1);
    else betasim=parms(1:nvartot,1);betap=betasim;
    end
    simresults(:,sim)=[betasim;rhosim];
    for p=1:nvar
        C=zeros(N,N);
        for i=1:N
            for j=1:N
            if (i==j) C(i,j)=betasim(p);
            else C(i,j)=betasim(nvar+p)*W(i,j);
            end
            end
        end
        hulp=(eye(N)-rhosim*W)\eye(N);
        mu=hulp*x*betap;
        Sigma=hulp*hulp';
        for i=1:N
            Sigma2=Sigma(i,i);
            Sigma1=Sigma;
            Sigma1(i,:)=[];
            Sigma1(:,i)=[];
            Sigma21=Sigma(i,:);Sigma21(:,i)=[];
            Sigma12=Sigma(:,i);Sigma12(i,:)=[];
            yobs=y;yobs(i)=[];
            muobs=mu;muobs(i)=[];
            help=Sigma1\eye(N-1);
            prob(i,1)=norm_pdf(y(i),mu(i)+Sigma21*help*(yobs-muobs),Sigma2-Sigma21*help*Sigma12);
        end
        S=diag(prob)*hulp*C;
        EAVD(p,1)=sum(diag(S))/N; % average direct effect
        EAVI(p,1)=sum(sum(S,2)-diag(S))/N; % average indirect effect
        EAVC(p,1)=sum(sum(S,1)'-diag(S))/N; % average indirect effect
        simdir(p,sim)=EAVD(p,1);
        simind(p,sim)=EAVI(p,1);
        simtot(p,sim)=EAVD(p,1)+EAVI(p,1);
    end
end
fprintf(1,'    direct    t-stat   indirect    t-stat   total    t-stat \n');
[mean(simdir,2) mean(simdir,2)./std(simdir,0,2) mean(simind,2) mean(simind,2)./std(simind,0,2)...
    mean(simtot,2) mean(simtot,2)./std(simtot,0,2)]     

elseif (spat_model==10) % 0 = spatial lag, 1 = W changes over time

index=info.index;
T=info.T;
nvar=size(x,2);
NSIM=100;
if (cflag==1) nvarc=nvar-1; else nvarc=nvar; end
simresults=zeros(nvarc+1,NSIM);
simdir=zeros(nvarc,NSIM);
simind=zeros(nvarc,NSIM);
simtot=zeros(nvarc,NSIM);
simdirnp=zeros(nvarc,NSIM);
simindnp=zeros(nvarc,NSIM);
simtotnp=zeros(nvarc,NSIM);
probsim=zeros(NSIM,1);
for sim=1:NSIM
    sim
    parms = chol(cov)'*randn(size(parm)) + parm;
    rhosim = parms(nvar+1,1);
%    if (cflag==1) betasim=[parms(2:nvar,1)];betap=parms(1:nvar,1); %Watch out, positions might change, depending on program
    if (cflag==1) betasim=[parms(1,1);parms(3:nvar,1)];betap=parms(1:nvar,1); %Watch out, positions might change, depending on program
    else betasim=parms(1:nvar,1);betap=betasim;
    end
    simresults(:,sim)=[betasim;rhosim];
    for t=1:T
    N=index(t);
    V=W(1:N,1:N,t); % V taken from W is time-specific !!!!
    if (t==1) t1=1;t2=index(t);
    else t1=t1+index(t-1);t2=t2+index(t);
    end
    if (t>6 && t<27)
        tel=t-6;
    for p=1:nvarc
        C=zeros(N,N);
        for i=1:N
            for j=1:N
            if (i==j) C(i,j)=betasim(p);
            else C(i,j)=0;
            end
            end
        end
        hulp=(eye(N)-rhosim*V)\eye(N);
        mu=hulp*x(t1:t2,:)*betap;
        Sigma=hulp*hulp';
        prob=zeros(N,1);
        for i=1:N
            Sigma2=Sigma(i,i);
            Sigma1=Sigma;
            Sigma1(i,:)=[];
            Sigma1(:,i)=[];
            Sigma21=Sigma(i,:);Sigma21(:,i)=[];
            Sigma12=Sigma(:,i);Sigma12(i,:)=[];
            yobs=y(t1:t2);yobs(i)=[];
            muobs=mu;muobs(i)=[];
            help=Sigma1\eye(N-1);
            prob(i,1)=norm_pdf(y(i),mu(i)+Sigma21*help*(yobs-muobs),Sigma2-Sigma21*help*Sigma12);
        end
        S=diag(prob)*hulp*C;
        Snp=hulp*C;
        EAVD(p,tel)=sum(diag(S))/N; % average direct effect
        EAVI(p,tel)=sum(sum(S,2)-diag(S))/N; % average indirect effect
        EAVC(p,tel)=sum(sum(S,1)'-diag(S))/N; % average indirect effect
        EAVDnp(p,tel)=sum(diag(Snp))/N; % average direct effect
        EAVInp(p,tel)=sum(sum(Snp,2)-diag(S))/N; % average indirect effect
        EAVCnp(p,tel)=sum(sum(Snp,1)'-diag(S))/N; % average indirect effect
    end
    end
    end
    simdir(:,sim)=mean(EAVD,2);
    simind(:,sim)=mean(EAVI,2);
    simtot(:,sim)=simdir(:,sim)+simind(:,sim);
    simdirnp(:,sim)=mean(EAVDnp,2);
    simindnp(:,sim)=mean(EAVInp,2);
    simtotnp(:,sim)=simdirnp(:,sim)+simindnp(:,sim);
    probsim(sim)=mean(prob);
end

format shortg;

fprintf(1,'    direct    t-stat   indirect    t-stat   total    t-stat no_prob multiplication\n');
[mean(simdirnp,2) mean(simdirnp,2)./std(simdirnp,0,2) mean(simindnp,2) mean(simindnp,2)./std(simindnp,0,2)...
    mean(simtotnp,2) mean(simtotnp,2)./std(simtotnp,0,2)]

mean(probsim)

fprintf(1,'    direct    t-stat   indirect    t-stat   total    t-stat \n');
[mean(simdir,2) mean(simdir,2)./std(simdir,0,2) mean(simind,2) mean(simind,2)./std(simind,0,2)...
    mean(simtot,2) mean(simtot,2)./std(simtot,0,2)]

format short;

else
    error('wrong input number of spat_model');

end