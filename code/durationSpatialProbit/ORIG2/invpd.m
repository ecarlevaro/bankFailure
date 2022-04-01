function  xinv = invpd(x);
% PURPOSE: generalized inverse of non PD matrix 
%          (Moore-Penrose)
% ----------------------------------------------------------------
% USAGE: xinverse = invpd(x)
% where: x    = input matrix
%---------------------------------------------------
% RETURNS: xinv = Moore-Penrose psuedo matrix inverse
% ----------------------------------------------------------------
% NOTES:
% This function is intended to ensure PD 
% var-cov matrices returned by numerical hessians
% don't use it like invpd() in Gauss
% ----------------------------------------------------------------

% Written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com


[n,k] = size(x);
if n ~= k
error('invpd: must input a square matrix');
end;

xinv = pinv(x);

