% Linear SAR estimation
addpath(genpath('C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\etoolbox'))
load('sims_SAR_Wfull.mat')

for i=1:length(sims)
    estimates = est_SAR(sims(i).data.Y, sims(i).data.X, sims(i).data.W);
    vnames = strvcat('dependant', 'intercept', 'capital', 'liquidity', 'shortFunding');
    prt(estimates, vnames)
end

function estimates =  est_SAR(Y, X, W)
 
    %normalize W
    for i=1:size(W,1)
        if sum(W(i,:))~=0
            W(i,:) = W(i,:)/sum(W(i,:));
        end
    end

    rng(31, 'twister');
    info.lflag = 0; % use full lndet no approximation
    estimates = sar( Y, X, W, info);   
    
end
