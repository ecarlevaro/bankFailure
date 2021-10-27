% Linear SAR estimation
addpath(genpath('C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\etoolbox'))
load('sim_SAR_Wsparse.mat')
% True parameters are
rho = sim.info.gamma(end)
Beta = sim.info.gamma(1:end-1)
W = sim.data.W;
%normalize W
for i=1:size(W,1)
    if sum(W(i,:))~=0
        W(i,:) = W(i,:)/sum(W(i,:));
    end
end

rng(31, 'twister');
vnames = strvcat('dependant', 'intercept', 'capital', 'liquidity', 'shortFunding');
info.lflag = 0; % use full lndet no approximation
result0 = sar( sim.data.Y, sim.data.X, W, info);
prt(result0, vnames)
