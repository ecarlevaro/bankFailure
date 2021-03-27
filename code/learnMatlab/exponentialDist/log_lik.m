function [logLik] = log_lik(Theta, Y)
    theta = Theta(1)
    logLik = -log(theta) - (1/theta)*mean(Y)
end