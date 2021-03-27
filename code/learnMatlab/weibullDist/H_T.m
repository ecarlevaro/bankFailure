function [HTheta_T] = H_T(Theta, Y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
   alpha = Theta(1)
   beta = Theta(2)
   Halphas_t = -1/(alpha^2)
   HalphaBeta_t = -mean( log(Y).*(Y.^beta) )
   Hbetas_t = -1/(beta^2) - alpha*mean( log(Y) .* Y.^(beta) )
   
   HTheta_T = [ Halphas_t    HalphaBeta_t
                HalphaBeta_t Hbetas_t ]
end

