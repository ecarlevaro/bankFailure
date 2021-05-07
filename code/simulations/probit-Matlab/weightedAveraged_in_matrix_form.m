% N = 3, k=2
x1 = [1 2 3]'
x2 = [0.2 0.6 -1.4]'

X = [x1 x2]
% Weighted sum
% Weights = 0.4, 0.2, 0.4

% In CAMERON DAIS, p469, x_i is a Kx1 vector. Here X(1,:) is a 1xK vector.
% We transpose it to make it comparable

% In scalar from
0.4*X(1,:)'*X(1,:) + 0.2*X(2,:)'*X(2,:) + 0.4*X(3,:)'*X(3,:)
%ans =
%
%    4.8000   -1.3600
%   -1.3600    0.8720

% Matrix form
W = eye(3) .* [0.4 0.2 0.4]
X'*W*X
%ans =
%
%    4.8000   -1.3600
%   -1.3600    0.8720
