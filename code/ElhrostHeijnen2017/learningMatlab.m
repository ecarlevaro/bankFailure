% N = 60
% y* := Pr[y=1|x] = F(x'beta)
% i = random binary vector
% y := round((y* * i))

% SIMULATION PROBIT DATA
% Bernoulli distribution is a binomial with 1 trial
% x = [capital liquidity shortFunding]
N = 10
capital = unifrnd(0.08, 0.30, [1 N])
liquidity = unifrnd(0.01, 0.35, [1 N])
shortFunding = unifrnd(0.01, 0.40, [1 N])
X = [capital 
    liquidity 
    shortFunding]
% The ratio between coefficients is equal to the ratio of the marginal
% effects
beta = [ -4 
         -2
         3]
y_p = normcdf(X' * beta)
y = binornd(1, y_p)
% end simulation

% ESTIMATION
lnLgra =  y_i

% Exponential distribution
J = average

function [G1] = gra1_t(theta, y_t)
    1/theta.alpha - (Y)^(theta.beta)
end
function [g2_t] = gra2_t(theta, y_t)
    1/theta.beta + ln(y_t) - theta.alpha *ln(y_t)*y_t^(theta.beta)
end

% theta_hat = theta + H^-1(theta) G_T(theta)
% In the optimum, G_T(theta) = 0

% Newton-Raphson method
% Requires gradient and Hessian (first & second derivative)
%

% Exponential case
N = 60
KI = 8
Theta = [0.5]
Y = exprnd(Theta(1), N, 1)
%f_y = 1/theta * exp[-(y_t/theta)]
%lnLik_T = -ln(theta) + 1/theta*mean(Y)

G_T_ki = cell(KI,1)
H_T_ki = cell(KI,1)
Theta_ki = cell(KI,1)
Theta_ki{1} = [0.3]
    
for i = 2:KI
    %Gtheta_T{i-1} = -1/theta_ki{i-1} + 1/(theta^2)*mean(Y)% Tx1
    %Htheta_T{i-1} = 1/(theta^2) - 2/(theta^3)*mean(Y)
    logLik_ki{i-1} = log_lik(Theta_ki{i-1}, Y)
    G_T_ki{i-1} = G_T(Theta_ki{i-1}, Y)
    H_T_ki{i-1} = H_T(Theta_ki{i-1}, Y)
    Theta_ki{i} = Theta_ki{i-1} - (H_T_ki{i-1})^(-1) * G_T_ki{i-1}
    
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 40
alpha = 0.7
beta = 2
Y = wblrnd(alpha, beta, N, 1)

KI = 20 % # of iterations
Theta_ki = cell(KI,1)
Theta_ki{1} = [1;    1]
Theta_ki{1}

Galpha_ki = cell(KI, 1)
Gbeta_ki = cell(KI, 1)
X_ki = cell(KI, 1)
% loop
for i = 2:KI
    % i = 2
    alpha_iM1 = Theta_ki{i-1}(1)
    beta_iM1 = Theta_ki{i-1}(2)
    Galpha_ki{i-1} = 1/alpha_iM1 - (Y).^(beta_iM1) %Tx1
    Gbeta_ki{i-1} = 1/beta_iM1 + log(Y) - alpha_iM1 * log(Y).*Y.^(beta_iM1) %Tx1
    X_ki{i-1} = [Galpha_ki{i-1} Gbeta_ki{i-1}] % TxK

    Theta_ki{i} = Theta_ki{i-1} + inv(X_ki{i-1}'*X_ki{i-1}) * X_ki{i-1}'*ones(N,1)
end

Theta_ki{KI}
alpha_hat = Theta_ki{KI}(1)
beta_hat = Theta_ki{KI}(2)
%alpha_hat = alpha
%beta_hat = beta
logLikWei = log(alpha_hat) + log(beta_hat) + (beta_hat-1)*mean(log(Y)) - alpha_hat*mean(Y.^beta_hat)
%W = [
a = [3, 4, 4, 7, 10]
tt = 4
% countries have switched
I=(a<tt);
%Which countries switch at time t?
J=(a==tt);
% all countries but the ones that had switched
y=J(I==0);
% select rows of W of countries that haven't switched and columns of those
% who switches now
%X=[sum(W(I==0,I==1),2) data(tt).X(I==0 | J==1,vars)]; %first column is effect of countries that have already switched
