% N = 100
% y* := Pr[y=1|x] = F(x'beta)
% i = random binary vector
% Y := round((y* * i))
% SIMULATION PROBIT DATA
% Bernoulli distribution is a binomial with 1 trial
% x = [capital liquidity shortFunding]

load('..\SAR_sim\W_simulated.mat')
N = size(W, 1)

%normalize W
for i=1:size(W,1)
    if sum(W(i,:))~=0
        W(i,:) = W(i,:)/sum(W(i,:));
    end
end
rng(31, 'twister');
capital = unifrnd(0.08, 0.30, [N 1]);
liquidity = unifrnd(0.01, 0.35, [N 1]);
shortFunding = unifrnd(0.01, 0.40, [N 1]);
X = [ones(N, 1) capital liquidity shortFunding]
% The ratio between coefficients is equal to the ratio of the marginal
% effects
rho = -0.3
Beta = [0.3 
        -4 
        -2
        3]
Epsilon = random('Normal', 0, 1, N, 1);
I = eye(N);
A = (I - rho*W)^(-1);

Ystar = normcdf( A*X*Beta);
Y = binornd(1, Ystar)

simData.X = X
simData.Y = Y
simData.W = W

save('sim_SAR_probit2.mat', 'simData')
% end simulation