% Constructing an Optimal Portfolio using Scenario based Markowitz and Mean
% Absolute Deviation model and there by computing the Value at Risk and 
% Conditional Value at Risk both at 95% confidence levels.
%                                           (C)Pavan Narayn
% INPUT
% Raw Matrix loaded from 'Indices.Mat' File - Mandatory file for the
% program to produce results.

function [x] = t2risk(x)
% Loading Data and producing a returns matrix
load('indices.mat','raw');

% ret1 -- Returns matrix from 1990 - 2000 for computation of optimal
% allocation of portfolio
ret1 = raw(2:121,:)./raw(1:120,:);

% ret2 -- Returns matrix from 2000 - 2009 for VaR, CVaR calculation
ret2 = raw(121:241,:)./raw(120:240,:);

% Equally Weighted Scenario Input Vector
x1 = [1/3,1/3,1/3];
n=120;
Pi = ones(n, 1)/n;

% Convex Optimization for model with Mean Absolute Deviation Objective
cvx_begin
    cvx_quiet(true)
    variable x(3)
    variable W(120)
    variable E
subject to 
    sum(x) == 1;
    ret1*x == W;
    E>= 1.001;
    sum(Pi'*W) == E;
    x>=0;
    minimize(sum(Pi'*abs(W-E)));
cvx_end

% Convex Optimization for Scenario based Markowitz model
cvx_begin
    cvx_quiet(true)
    variable q(3)
    variable W(120)
    variable E
subject to 
    sum(x) == 1;
    ret1*q == W;
    E>= 1.001;
    sum(Pi'*W) == E;
    x>=0;
    minimize(sum(Pi'*(W-E).^2));
cvx_end

% Results to display
display('Scenario based Markowitz model Optimal Allocation')
display(q)
display('MAD (Mean Absolute Deviation) model Optimal Allocation')
display(x)
display('VaR and Conditional VaR with optimal weights of assets under Scenario based Markowitz')
opretq = ret2*q;
shortfallq = 1005-1000*opretq;
ssfq = sort(shortfallq);
VaRq = ssfq(6)
CVaRq = mean(ssfq(1:6))
display('VaR and Conditional VaR with optimal weights of assets under MAD')
% Returns matrix with optimal scenario of weights
opret = ret2*x;
shortfall = 1005-1000*opret;
ssf = sort(shortfall);
VaR = ssf(6)
CVaR = mean(ssf(1:12))
display('VaR and Conditional VaR with equal weights of assets')
% Equally weighted assets
opret1 = ret2*x1';
shortfall1 = 1005-1000*opret1;
ssf1 = sort(shortfall1);
VaR1 = ssf1(6)
CVaR1 = mean(ssf1(1:6))
display(E)
display(sum(Pi'*(W-E).^2))
end
