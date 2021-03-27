
% Weibull distribution
% p95 Example 3.6
%
%

N = 30
KI = 8
Theta = [1
         0.5]
Y = wblrnd(Theta(1), Theta(2), N, 1)
%f_y = 1/theta * exp[-(y_t/theta)]
%lnLik_T = -ln(theta) + 1/theta*mean(Y)

logLik_ki = cell(KI,1)
G_T_ki = cell(KI,1)
H_T_ki = cell(KI,1)
Theta_ki = cell(KI,1)
Theta_ki{1} = [0.6
               0.7]
% Newton-Rapson alogrithm    
for i = 2:KI
    %Gtheta_T{i-1} = -1/theta_ki{i-1} + 1/(theta^2)*mean(Y)% Tx1
    %Htheta_T{i-1} = 1/(theta^2) - 2/(theta^3)*mean(Y)
    logLik_ki{i-1} = log_lik(Theta_ki{i-1}, Y)
    G_T_ki{i-1} = G_T(Theta_ki{i-1}, Y)
    H_T_ki{i-1} = H_T(Theta_ki{i-1}, Y)
    Theta_ki{i} = Theta_ki{i-1} - (H_T_ki{i-1})^(-1) * G_T_ki{i-1}
    
end

% Quasi-Newthon: BHHH Algorithm with squeezing (lambda)

logLik_ki = cell(KI,1)
G_T_ki = cell(KI,1)
Theta_ki = cell(KI,1)
Theta_ki{1} = [0.6
               0.7]
tolerance = 1e-05

logLik_ki{1} = log_lik(Theta_ki{1}, Y)

for i = 2:KI
    %Gtheta_T{i-1} = -1/theta_ki{i-1} + 1/(theta^2)*mean(Y)% Tx1
    %Htheta_T{i-1} = 1/(theta^2) - 2/(theta^3)*mean(Y)
    %i=2
    X = G_tt(Theta_ki{i-1}, Y) %Tx2 matrix
    G_T_ki{i-1} = [mean(X(:,1)) 
                mean(X(:,2))]
    Xprojection = (X' * X)^(-1) * X' * ones(N,1)
    lambda = 1
    Theta_ki{i} = Theta_ki{i-1} + lambda*Xprojection
    logLik_ki{i} = log_lik(Theta_ki{i}, Y)
    
    % Squeezing
    for sqz_j = 2:10
        logLik_ki{i} = log_lik(Theta_ki{i}, Y)
        if logLik_ki{i} < logLik_ki{i-1}
            lambda = 1/sqz_j
            Theta_ki{i} = Theta_ki{i-1} + lambda*Xprojection
        else
            break
        end
    end %end squeezing    
    
    % Convergence
    if abs(logLik_ki{i} - logLik_ki{i-1}) < tolerance
        break;
    end
end % end iteration

