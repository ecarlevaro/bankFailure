function [logLik] = log_lik(Theta, Y)
% Weibull distribution log likelihood    
    alpha = Theta(1)
    beta = Theta(2)
    logLik = log(alpha) + log(beta) + (beta-1)*mean( log(Y) ) - alpha*mean( Y.^beta )
end