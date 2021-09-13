x = 1:10;
n = length(x);
avg = mymean(x);
%med = mymedian(x,n);

function a = mymean(v)
% MYMEAN Local function that calculates mean of array.

    a = sum(v)/n;
end