% Simulate a SAR model
% y = rho*W*y + X*Beta + Epsilon
% Epsilon follows a Normal(0,1)
% Input are a graph matrices (W) of different sizes that were generated in R using network_sim.Rmd
% x = [capital liquidity shortFunding]

load('Ws.mat')
Ws(1) = s1
Ws(2) = s2
Ws(3) = s3

for i=1:length(Ws)
    sims(i) = sim_SAR(Ws(i).W)
end

save('sims_SAR_Wfull.mat','sims')

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
end
% end simulation