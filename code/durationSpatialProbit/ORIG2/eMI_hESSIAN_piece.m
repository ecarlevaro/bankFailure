
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
    %At time t: which countries have switched?
    I=(a<tt);
    %Which countries switch at time t?
    J=(a==tt);
    y=J(I==0);
    X=[sum(W(I==0,I==1),2) data(tt).X(I==0 | J==1,vars)]; %first column is effect of countries that have already switched
    Whier=W(I==0,I==0);
    for i=1:size(Whier,1)
        if sum(Whier(i,:))~=0
            Whier(i,:)=Whier(i,:)/sum(Whier(i,:));
        end
    end
    
    L=L-LikeliSALEISProbitcode(Whier,X,y,3,1000,[param(end); param(1:end-1)]);

end
end