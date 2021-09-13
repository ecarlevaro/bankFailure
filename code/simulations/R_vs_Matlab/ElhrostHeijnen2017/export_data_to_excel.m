addpath 'C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\ElhrostHeijnen2017\standard-spatial-probit'
addpath(genpath('C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\etoolbox'))
load IT

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

tic

%normalize W
for i=1:size(W,1)
    if sum(W(i,:))~=0
        W(i,:)=W(i,:)/sum(W(i,:));
    end
end

%normalize A
for i=1:size(A,1)
    if sum(A(i,:))~=0
        A(i,:)=A(i,:)/sum(A(i,:));
    end
end

%normalize B
for i=1:size(B,1)
    if sum(B(i,:))~=0
        B(i,:)=B(i,:)/sum(B(i,:));
    end
end

%normalize C
for i=1:size(C,1)
    if sum(C(i,:))~=0
        C(i,:)=C(i,:)/sum(C(i,:));
    end
end

vars=[1 2 3 4 5 6 7];

%handy stuff
options = optimset;
options = optimset(options,'Display' ,'iter');
options = optimset(options,'HessUpdate' ,'bfgs'); %bfgs
%options = optimset(options,'InitialHessType' ,'scaled-identity');
options = optimset(options,'LargeScale' ,'off');
options = optimset(options,'MaxFunEvals',1e8, 'MaxIter',1e8);
N=size(W,1); 
%T=max(a(a<inf));
T=size(data,2)

S=0;
for t=1:T
S=S+data(t).X(:,vars);
end
S=S/T;

a = adoptiondate

    writematrix(a<inf, 'C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\simulations\R_vs_Matlab\ElhrostHeijnen2017\their_data.xlsx',...
        'Sheet', 'adoption')
    writematrix(S, 'C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\simulations\R_vs_Matlab\ElhrostHeijnen2017\their_data.xlsx',...
        'Sheet', 'S')
    writematrix(W, 'C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\simulations\R_vs_Matlab\ElhrostHeijnen2017\their_data.xlsx',...
        'Sheet', 'W')
    
res0 = sar(a<inf,S,W);
prt(res0)

info.lflag = 0; % use full lndet no approximation
result0 = sar(y, X, W, info)
prt(result0)