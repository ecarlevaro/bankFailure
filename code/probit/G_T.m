function [Gtheta_T] = G_T(Theta, Y)
% Computes the gradient vector for the Weibull distribturion    
    alpha = Theta(1)
    beta = Theta(2)
    Galpha_t = 1/alpha - mean(Y.^beta)
    Gbeta_t = 1/beta + mean(log(Y)) - alpha*(mean( log(Y).*(Y.^beta) ))
    Gtheta_T = [ Galpha_t
                 Gbeta_t]
end