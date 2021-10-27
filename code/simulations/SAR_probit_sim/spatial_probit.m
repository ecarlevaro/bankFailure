%load IT
addpath(genpath('C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\standardSpatialProbit'))
%y = readmatrix("Y_s98.Priv.01.onT.csv")
%X = readmatrix("X_s98.Priv.01.onT.csv")
%W = readmatrix("W_1998.csv")

load('C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\simulations\SAR_probit_sim\sim_SAR_probit2.mat')
y = simData.Y
X = simData.X
W = simData.W

%normalize W
for i=1:size(W,1)
    if sum(W(i,:))~=0
        W(i,:)=W(i,:)/sum(W(i,:));
    end
end

varNames = strvcat('dependant', 'intercept', 'capital', 'liquidity', 'shortFunding')
info.lflag = 0; % use full lndet no approximation
linearSAR = sar(y, X, W, info)
prt(linearSAR, varNames)
% Play with a symmetric W
%symmW = W + W'
%eig(symmW)
%W = symmW
%Data (See Hanna's XLS-file for details)
%N --- The number of countries
%T --- The number of time periods (t is the index for time, t=1 corresponds to 1985)
%adoptiondate --- A vector of length N with the adoption date
%W - ten-nearest neighbors matrix
% A - common language matrix
% B - common legal origin matrix
% C - common membership in BIS
%data.X --- A struct with T fields containing the exogenous variables

%var. 1 = Intercept
%var. 2 = Inflation
%var. 3 = GDP growth
%var. 4 = Exchange rate regime
%var. 5 = Government debt
%var. 6 = Financial development
%var. 7 = LCBI
%var. 8 = Duration
%var. 9-36 - time dummies

% rho1 - spatial effect of countries that switch in the same period
% rho2 - spatial effect of countries that have already switched

% is W invertible? W is not invertible and need not to be. (I - rho W) must
% be invertible (be a diagonal dominant matrix after row normalisation)
k = size(X, 2)-1
vars=[1 2 3 4 5 6 7 8 9 10];
[paramest,paramstd,logL,Varcov]=spatial_probit_Vogler(y,X,W);

fprintf('Distance Matrix B, logL= %3.2f\n',logL)
fprintf('parameter\t estimate (std)\n')
fprintf('rho\t %2.4f (%2.4f)\n',paramest(end),paramest(end)/paramstd(end))
for i=1:k  
    fprintf('var. %1.0d\t %2.4f (%2.4f)\n',i,paramest(i),paramest(i)/paramstd(i))
end

time_needed=toc;
fprintf('Elapsed time: '); disp(secs2hms(time_needed));
save results0
csvwrite('paramest.csv', paramest)
csvwrite('paramstd.csv', paramstd)
