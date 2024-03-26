clear all 
clc

%% no irrigation and no insurance 
%% Step I: Parameters Initialization
fin= 10

load('yieldfunc_noirrig_parms.mat') % loading this dataet will generate a matrix containing the random beta's

A = 180 % ha    % area in ha %  the average farm size in the US

% sale price 

mu_p_corn= 5.90/25.4 % $/kg  mean sale price 
sig_p_corn = 0.23/25.4 % $/kg mean sigma sale price
r_N= 1308/907.18 % $/kg nitrogen sale price 
pmax = 0.31
pmin = 0.1

% rainfall during growing time 
mu_W_g = 9.96; %cm mean precipitation 

sig_W_g_vec = 2.5:10

W_g_max = 27; %cm
W_g_min = 1.9; %cm

% other weather variables

T_p = 13.54
W_p = 10.59
T_g = 22.43
T_h = 15.05
W_h = 8.48

v= 0.005

%% Step 2:  production function specification 

for k=1:4
    for j=1:fin
% production function 

sig_W_g = sig_W_g_vec(k); %cm standard deviation precipitation 

y_func = @(N,W_g) matrix1(j,1) + matrix1(j,2).*W_g+ matrix1(j,3).*N + matrix1(j,4).*W_g.^2 + matrix1(j,5).*N.^2 + matrix1(j,6)*(N.*W_g)+ matrix1(j,7)*(T_g)+ matrix1(j,8)*(T_g.^2)+matrix1(j,9)*(T_g.*N)+ matrix1(j,10)*(T_g.*W_g)+ matrix1(j,11).*(T_p)+ matrix1(j,12)*(T_p.^2)+ matrix1(j,13)*(T_h) +matrix1(j,14)*(T_h.^2)+ matrix1(j,15)*(W_p) + matrix1(j,16)*(W_p.^2)+ matrix1(j,17)*(W_h)+ matrix1(j,18)*(W_h.^2) %production yield (kg/ha)

% rainfall density 
R_W_g= @(W_g) exp(-(W_g-mu_W_g).^2/(2*sig_W_g.^2))*(1/(sig_W_g*(2*pi()).^.5)) % density function of precipitation during growing time

% price density 
G_p= @(p) exp(-(p-mu_p_corn).^2/(2*sig_p_corn.^2))*(1/(sig_p_corn*(2*pi()).^.5)) % density function of price 


%% without insurance 

% profit for farmer having no insurance and no self-protection

Pi_1= @(N,p,W_g) A.*(p.*y_func(N,W_g)-r_N.*N) % Wealth of farmer with no Insurance
U_1 = @(N,p,W_g) Pi_1(N,p,W_g) - v .* (Pi_1(N,p,W_g)).^2%

EU_1 = @(N) integral2(@(p,W_g) U_1(N,p,W_g).*R_W_g(W_g).*G_p(p),pmin,pmax,W_g_min,W_g_max)% Expected utility of profit with no insurance 

EU_1_neg = @(N) - EU_1(N)
k=k
j=j 

%% Step 3 Optimization specification 
      
% Maximization of profit with no insurance 

opts = optimoptions(@fmincon,'Algorithm','interior-point');
problem = createOptimProblem('fmincon','objective',...
EU_1_neg,'x0',20,'lb',10,'ub',1500,'options',opts);
ms = MultiStart;
[N_opt,EU_1_neg_opt] = run(ms,problem,2);

EU_1_opt = -EU_1_neg_opt;
matrix_no_irrig_no_ins(j,18+k)=N_opt;
matrix_no_irrig_no_ins(j,24+k)= EU_1_opt;
    end
end

save matrix_no_irrig_no_ins.mat matrix_no_irrig_no_ins