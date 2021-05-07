% INFERENCE
% For a probit model the LM test on a paramater in X Beta is proportional
% to the R2 of u on X with X(1,:) = [1 1 1...1]
% LM(Beta_rest) = T R2_u
% MARTIN, HURN, HARRIS p822 Discrete time series model

% Estimate restricted model
% Restricted model
M = 1 % # of linear restrictions
[N K] = size(X);
% column 3 is CAPITAL RATIO
Xr = [X(:,1:2) X(:,4:size(X, 2))];
%Xr = [X(:,1:3) X(:,5)]
Beta_rest = (Xr'*Xr)^(-1) * (Xr'*Y);

% Projection matrix
PXr = Xr*((Xr'*Xr)^(-1))*Xr';
Ur_hat = Y - Xr*Beta_rest;
%mean(Y - Xr*Beta_rest)
% Regression of Ur_hat (from restricted model) on X
PX = X* (X'*X)^(-1) * X';
% Yhat' * Yhat
SSmodel = (PX*Ur_hat)' * (PX*Ur_hat);
SStotal = Ur_hat'*Ur_hat;
R2 = SSmodel / SStotal

LM = N*R2;
pValue = chi2cdf(LM, M, 'upper')

%%%
%%% ESTIMATE VAR-COV MATRIX OF ESTIMATOR
%%%

% divide the individual beta hat by the diagonal element
% of J_ki. 
% The null that Beta = 0 can be tested with a Z-test
% This is distributed as % Multivariate Normal with mean Beta_ki_{last} and variance J_ki{last}
% see p101 Martin Hurn Harris
% HYPOTHESIS TESTING

OmegaG_hat = (1/N)*J
% Should be a positive definite matrix, then all eigenvalues are positive
eig(OmegaG_hat)

%
% USING HESSIAN ¿or Information Matrix?
% CAMERON, TRIVEDI 2005, p469
% Pdf is Nx1, equal to F'(X*Beta), marginal prob.
% F_XBeta is the CDF, is Nx1: F(X*Beta)
Weights = Pdf.^2 .* (F_XBeta.*(1-F_XBeta)).^(-1); %Nx1
%W is NxN
W = eye(N).*Weights; %NxN
% KxK

OmegaH_hat =  (X' * W * X)^(-1)
% Should be a positive definite matrix, then all eigenvalues are positive
eig(OmegaH_hat)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE STANDARD ERRORS
% Martin, Hurn, Harris, p101 '3.6 Computing standard errors'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Beta / diagonal elements from OMega
% Test using Jacobian
seBetaJ_hat = sqrt(diag(OmegaG_hat));
tStatJ = Beta_ki{i} ./ seBetaJ_hat

% Test using Hessian
seBetaH_hat = sqrt(diag(OmegaH_hat));
tStatH = Beta_ki{i} ./ seBetaH_hat

% H0: beta_1 = 0
