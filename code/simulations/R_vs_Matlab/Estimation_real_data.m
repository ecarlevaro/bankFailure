% Estimate a SAR model using real data and LeSagePage2010 SAR library
addpath(genpath('C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\standardSpatialProbit'))
y = readmatrix("Y_s98.Priv.01.onT.csv")
X = readmatrix("X_s98.Priv.01.onT.csv")
W = readmatrix("W_1998.csv")

for i=1:size(W,1)
    if sum(W(i,:))~=0
        W(i,:)=W(i,:)/sum(W(i,:));
    end
end

% COMPUTE DESC STATS
% Means of X
for i=1:size(X,2)
    xMeans(i) = mean(X(:,i))
end
% Means of W
for i=1:size(W,2)
    wMeans(i) = mean(W(:,i))
end
yMean = mean(y)

writematrix(yMean, 'SAR_Matlab_estimation.xlsx','Sheet', 'DescStats', ...
'Range', 'A2:B2')
writematrix(xMeans', 'SAR_Matlab_estimation.xlsx','Sheet', 'DescStats', ...
'Range', 'B2:B22')
writematrix(wMeans', 'SAR_Matlab_estimation.xlsx','Sheet', 'DescStats', ...
'Range', 'C2:C122')


info.lflag = 0; % use full lndet no approximation
result0 = sar(y, X, W, info)
prt(result0, varNames)

