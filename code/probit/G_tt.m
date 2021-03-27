function [GBeta_T Pdf F_XBeta] = G_tt(Beta, Y, X)
% For the probit model it computes the NxK gradient matrix (the gradient
% evaluated at each observation)
    % Standard normal pdf
    pdf = @(x) exp(-(x.^2)/2) / sqrt(2*pi);
    % F(X Beta)
    F_XBeta = zeros(length(Y),1);
    for i = 1:length(Y)
        F_XBeta(i, :) = integral(pdf, -10, X(i,:) * Beta); %Nx1    
    end
    % Save pdf for Information matrix
    Pdf = pdf(X*Beta); % Nx1
    % weight for each observation
    weights = Pdf .* (Y - F_XBeta); % Nx1
    GBeta_T = weights .* X; %NxK vector

end

