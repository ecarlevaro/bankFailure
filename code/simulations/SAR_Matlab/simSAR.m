% Simulate a SAR model and then estimate it using MLE as in pages 47-49 in
% LESAGE PACE 2009 book
% Spatial polynomial
% Y = rho W*Y + X*Beta + Epsilon
% Epsilon follows a Normal(0, Sigma2 I_n)
% p46 Ch3 MLE & see p128 Ch5 Bayesian MCMC
% 
N = 105
X = readmatrix("X_s98.Priv.01.onT.csv")
% Assets is highly skewed. 1 is the constant term
X = X(:, [1 3 4])
W = readmatrix("W_1998.csv")


rho = 0.4
I_n = eye(size(W,1))
SP = (I_n - rho W)^(-1)

y = 
Beta = [0.3;
          -1;
           2]

Alpha = uniform between -0.4 to 0.4
Epsilon = 
Y = SP (Alpha*i_n + X*Beta + Epsilon)