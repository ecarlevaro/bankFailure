%load IT
load BAFA_data
BAFAd = struct('X', X')
adoptiondate = y' - 151

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
W = Wstd

%normalize W
for i=1:size(W,1)
    if sum(W(i,:))~=0
        W(i,:)=W(i,:)/sum(W(i,:));
    end
end



vars=[1];
[paramest,paramstd,logL,H]=spatial_duration3(adoptiondate,BAFAd,W,vars);

fprintf('Distance Matrix B, logL= %3.2f\n',logL)
fprintf('parameter\t estimate (std)\n')
fprintf('rho1\t %2.4f (%2.4f)\n',paramest(end),paramstd(end))
fprintf('rho2\t %2.4f (%2.4f)\n',paramest(1),paramstd(1))
for i=1:length(vars)
    fprintf('var. %1.0d\t %2.4f (%2.4f)\n',vars(i),paramest(i+1),paramstd(i+1))
end

time_needed=toc;
fprintf('Elapsed time: '); disp(secs2hms(time_needed));
save results1