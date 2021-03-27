function [Gtheta_t] = G_tt(Theta, Y)
% For the Weibull distribution it Computes the gradient vector at each observation
    alpha = Theta(1)
    beta = Theta(2)
    Galpha_t = 1/alpha - Y.^beta %Tx1 vector
    Gbeta_t = 1/beta + log(Y) - alpha*log(Y).*(Y.^beta) %Tx1 vector 
    Gtheta_t = [ Galpha_t Gbeta_t] %Tx2 
end