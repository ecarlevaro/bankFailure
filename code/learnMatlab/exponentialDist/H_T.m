function [HTheta_T] = H_T(Theta, Y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
   theta = Theta(1)
   HTheta_T = 1/(theta^2) - (2/(theta^3))*mean(Y)
end

