%
%
% ESTIMATION
%
%



%f_y = 1/theta * exp[-(y_t/theta)]
%lnLik_T = -ln(theta) + 1/theta*mean(Y)
% Quasi-Newthon: BHHH Algorithm with squeezing (lambda)
% Martin, Hurn & Harris, Chapter 3 Numerical estimation methods, p93

% Adding an irrelevant variable
%X = [X 10*unifrnd(0, 1, N,1)]

KI = 18 % iterations
logLik_ki = cell(KI,1);
G_T_ki = cell(KI,1);
Beta_ki = cell(KI,1);
% OLS for initial values
Beta_ki{1} = (X'*X)^(-1) * X'*Y
tolerance = 1e-05;

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
    lambda = 1;
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
Beta_ki{i}

% Newton-Rapson alogrithm  
% It uses the close form solution of the Hessian instead of relying in the
% approximation by the outer product of gradients
for i = 2:KI
    %Gtheta_T{i-1} = -1/theta_ki{i-1} + 1/(theta^2)*mean(Y)% Tx1
    %Htheta_T{i-1} = 1/(theta^2) - 2/(theta^3)*mean(Y)
    %i = 2
    logLik_ki{i-1} = log_lik(Beta_ki{i-1}, Y, X);
    G_T_ki{i-1} = G_T(Beta_ki{i-1}, Y, X);
    H_T_ki{i-1} = H_T(Beta_ki{i-1}, Y);
    Beta_ki{i} = Beta_ki{i-1} - (H_T_ki{i-1})^(-1) * G_T_ki{i-1};
    
end

