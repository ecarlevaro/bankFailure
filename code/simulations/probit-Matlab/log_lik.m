function [logLik] = log_lik(Beta, Y, X)
% Standard normal distribution log likelihood    
    pdf = @(x) exp(-(x.^2)/2) / sqrt(2*pi)
    % F(X Beta)
    F_XBeta = zeros(length(Y),1)
    for i = 1:length(Y)
        F_XBeta(i, :) = integral(pdf, -10, X(i,:) * Beta) %Nx1    
    end
    
    logLik = mean( Y.*log( F_XBeta) + (1-Y).*log(1 - F_XBeta) )
end