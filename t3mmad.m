% Markowitz model using Mean Absolute Deviation to minimize the risk

function [x] = t3mmad(x)
load('indices.mat','raw');
ret1 = raw(2:121,:)./raw(1:120,:);
mu = 1.001;
L = 1005;
m = [mean(ret1(1:120,1)), mean(ret1(1:120,2)), mean(ret1(1:120,3))];
beta = 0.95;
S=120;


% Portfolio Optimization for optimal weights 
cvx_begin
    cvx_quiet(true)
    variable x(3)
    variable z(120)
    variable a
    subject to
    U = ret1*x;
    E=1/120*sum(U);
    %for s=1:120
    %    y(s) = L-(ret1(s,:)*x)-alpha;
    %end
    z>= L-1000*U-a;
    %for s=1:120
    %    z(s) >= y(s);
    %end
    sum(x) == 1;
    E>=1.001;
    x*m>=mu;
    x>=0;
    z>=0;
    minimize(a+((1/(1/S*(1-beta))))*(sum(z)));



display(x)
display('VaR and Conditional VaR with optimal weights of assets')

opret = x*ret1;
ssf = sort(opret);
VaR = ssf(114)
CVaR = mean(ssf(115:120))

display('VaR and Conditional VaR with equal weights of assets')
opret1 = y1*ret1;
ssf1 = sort(opret1);
VaR = ssf1(114)
CVaR = mean(ssf1(115:120))


