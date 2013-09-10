% Portfolio Optimizaion using Mean Absolute Deviation model and calculation
% of Value at Risk and Conditional Value at Risk at 95% confidence Interval
% based on the optimal weights of portfolio from MAD model
%                                             Author: Pavan Kumar Narayanan
function [x] = t1mad(x)

% INPUT: Matrix of columns taken from main returns matrix
rs = [1.0547,1.0396,1.0088;
    0.9045,0.9516,1.0320;
    1.0079,0.9728,0.9912];

% Forming returns matrix from the raw data given in the file indices.mat
load('indices.mat','raw');
ret1 = raw(2:241,:)./raw(1:240,:);
s=3;
Pi = [1/3,1/3,1/3];
% Convex Optimization begins
cvx_begin
    cvx_quiet(true)
    variable x(3)
    variable W(3)
    variable E
    variable xa(3)
subject to 
    sum(x) == 1;
    rs*x == W;
    E>= 1.001;
    sum(Pi*W) == E;
    x>=0;
    % Portfolio MAD Objective
    minimize(sum(Pi*abs(W-E)));
cvx_end
display(x)
display('VaR and Conditional VaR with optimal weights of assets')
opret = ret1*x;
shortfall = 1005-1000*opret;
ssf = sort(shortfall);
VaR = ssf(12)
CVaR = mean(ssf(1:12))
display('VaR and Conditional VaR with equal weights of assets')
opret1 = ret1*Pi';
shortfall1 = 1005-1000*opret1;
ssf1 = sort(shortfall1);
VaR = ssf1(12)
CVaR = mean(ssf1(1:12))

end
