% N = 100
% y* := Pr[y=1|x] = F(x'beta)
% i = random binary vector
% Y := round((y* * i))

% x = [capital liquidity shortFunding]

load('W_simulated_sparse.mat')

function sim = sim_SAR(W)
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
Y = A*X*Beta + A*Epsilon;

sim.data.X = X
sim.data.Y = Y
sim.data.W = W
sim.info.gamma = [Beta 
                rho]

save('sim_SAR_Wsparse.mat', 'sim')
% end simulation