function [Gtheta_T] = G_T(Theta, Y)
    theta = Theta(1)
    Gtheta_T = -1/theta + (1/(theta^2))*mean(Y)% Tx1
end