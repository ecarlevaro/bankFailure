% N = 60
% y* := Pr[y=1|x] = F(x'beta)
% i = random binary vector
% Y := round((y* * i))

% SIMULATION PROBIT DATA
% Bernoulli distribution is a binomial with 1 trial
% x = [capital liquidity shortFunding]
N = 400;
capital = unifrnd(0.08, 0.30, [N 1]);
liquidity = unifrnd(0.01, 0.35, [N 1]);
shortFunding = unifrnd(0.01, 0.40, [N 1]);
X = [ones(N, 1) capital liquidity shortFunding]
% The ratio between coefficients is equal to the ratio of the marginal
% effects
Beta = [0.3 
        -4 
        -2
        3]
Y_p = normcdf(X * Beta);
Y = binornd(1, Y_p);
% end simulation