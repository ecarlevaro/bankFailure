%aux. functions: max log-likelihood -- transform rho such that rho\in(-1,1)
function L=likadj(param)
    paramadj=param; 
    paramadj(end)=2*atan(param(end))/pi;
    L=lik(paramadj);
end