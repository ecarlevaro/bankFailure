function p=tnprob(mu,s,Sigma,seed)

%Let y be multivariate normal with mean mu and variance Sigma. Then the
%program calculates the probability that (y>0)==s using GHK

if nargin<4
    R=1000;
    seed=rand(R,length(mu));
end

Q=chol(Sigma)';
R=size(seed,2);
N=length(mu);
pest=ones(1,R);

for r=1:R
   xi=zeros(N,1); z=zeros(N,1);
   for i=1:N
       z(i)=(-mu(i)-Q(i,:)*xi)/Q(i,i);
       u=seed(i,r); q=normcdf(z(i));       
       if s(i)==1
           xi(i)=norminv(u*(1-q)+q);
           pest(r)=pest(r)*(1-q);
       else
           xi(i)=norminv((1-u)*q);
           pest(r)=pest(r)*q;
       end        
   end
end

p=mean(pest);

end

