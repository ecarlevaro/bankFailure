 %load IT
load '..\..\..\data\SAMS\n80_fs98q4_ft01q4_Lag4_logAssets_Wrest.mat'
% 40 banks, 13 time periods, 10 covariates with intercept (no intercept)
data = struct('X', X')
adoptiondate = y' 
% Network (distance matrix)
W = Wstd

% Characteristics of network:
eig(W) % not invertible
trace(W) % should be 0
% Number of regions: 40 
% Number of nonzero links: 281 
% Percentage nonzero weights: 17.5625 
% Average number of links: 7.025 
% 4 regions with no links

% Initial value from a linear spatial autoregresive model (SAR)
% compute mean of X
% For all vars
vars=[1 2 3 4 5 6 7 8 9 10 11];
% only with intercept
%vars = 1
% Initial values computed in R using spatialreg package and a linar SAR.
% Covariates are the mean overtime for each bank (the mean of a NxK matrix
% X ignorings NAs due to right censoring)
% Initial values only with intercept

% Initi values with all vars
%init_beta = [-5.66E-01	-6.71E-08 -5.44E-03 9.49E-03 -5.83E-02 1.35E-05 -7.65E-03 1.33E-02 7.79E-03]
%init_rho = 0.33425

init=[iniValues(end) iniValues(1:end-1) iniValues(end)]';

%i = size(W, 1)
%N = size(W, 1)
%T = size(data, 2)
%N --- The number of banks
%T --- The number of time periods (t is the index for time, t=1 corresponds to 1997q4)
%adoptiondate --- A vector of length N with the failure date
%W - the interbank network
%data.X --- A struct with T fields containing the exogenous variables

% rho1 - spatial effect of banks that fail in the same period
% rho2 - spatial effect of banks that have already failed

% This should be equal to N, since it is the row sum and the sum
sum(sum(W, 2), 1)
sum(sum(Wstd, 2), 1)
% W is already normalised
%normalize W
for i=1:size(W,1)
    if sum(W(i,:))~=0
disp(i, ' caca ')
        W(i,:)=W(i,:)/sum(W(i,:));
    end
end

tic

[paramest,paramstd,logL,H]=spatial_duration3(adoptiondate,data,W,vars, init);

fprintf('Distance Matrix B, logL= %3.2f\n',logL)
fprintf('parameter\t estimate (std)\n')
fprintf('rho1\t %2.4f (%2.4f)\n',paramest(end),paramstd(end))
fprintf('rho2\t %2.4f (%2.4f)\n',paramest(1),paramstd(1))
for i=1:length(vars)
    fprintf('var. %1.0d\t %2.4f (%2.4f)\n',vars(i),paramest(i+1),paramstd(i+1))
end

time_needed=toc;
fprintf('Elapsed time: '); disp(secs2hms(time_needed));
save results_n80_fs98q4_ft01q4_Lag4_logAssets_Wrest