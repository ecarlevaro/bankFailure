    %
%
% ESTIMATION
%
%
% Quasi-Newthon: BHHH Algorithm with squeezing (lambda)
% Martin, Hurn & Harris, Chapter 3 Numerical estimation methods, p93
%N=500
cd 'C:\Users\emi.ABLE-22868\OneDrive\UWA PhD\bankFailure\code\probit'

Xtable = readtable( ['Xsim-', char(string(N)), '.csv'] );
Ytable = readtable( ['Ysim-', char(string(N)), '.csv']);
X = table2array(Xtable);
Y = table2array(Ytable);
N = size(X, 1)

% Adding an irrelevant variable
%X = [X 10*unifrnd(0, 1, N,1)];

%
% Quasi-Newthon: BHHH Algorithm with squeezing (lambda)
%
KI = 30 % iterations
logLik_ki = cell(KI,1);
G_T_ki = cell(KI,1);
Beta_ki = cell(KI,1);
% OLS for initial values
Beta_ki{1} = (X'*X)^(-1) * X'*Y;
tolerance = 1e-06;

logLik_ki{1} = log_lik(Beta_ki{1}, Y, X);

for i = 2:KI
    %Gtheta_T{i-1} = -1/theta_ki{i-1} + 1/(theta^2)*mean(Y)% Tx1
    %Htheta_T{i-1} = 1/(theta^2) - 2/(theta^3)*mean(Y)
    %i=2
    
    %G is NxK matrix
    % Pdf is Nx1, equal to F'(X*Beta), marginal prob.
    % F_XBeta is the CDF, is Nx1 F(X*Beta)
    [G Pdf F_XBeta] = G_tt(Beta_ki{i-1}, Y, X); 
    % Save gradient, Jacobian and Pdf
    G_T_ki{i-1} = [ mean(G(:,1)) 
                    mean(G(:,2))];
    %Pdf_ki{i-1} = Pdf
    %F_XBeta_ki{i-1} = F_XBeta
    J = G'*G; %KxK
    Gprojection = J^(-1) * G'*ones(N,1);
    lambda = .1;
    Beta_ki{i} = Beta_ki{i-1} + lambda*Gprojection;
    logLik_ki{i} = log_lik(Beta_ki{i}, Y, X);
    logLik_ki{i}
    % Squeezing
    for sqz_j = 2:10
        if logLik_ki{i} < logLik_ki{i-1}
            lambda = 1/sqz_j;
            Beta_ki{i} = Beta_ki{i-1} + lambda*Gprojection;
            logLik_ki{i} = log_lik(Beta_ki{i}, Y, X);
        else
            break
        end
    end %end squeezing    
    
    % Convergence
    if abs(logLik_ki{i} - logLik_ki{i-1}) < tolerance
        break;
    end
end % end iteration
csvwrite( ['Estimation-Beta-N-', char(string(N)), '.csv'] , Beta_ki{i});

Beta_ki{i}



