%clear all 
%clc


%% irrigation, without insurance

%% Step I: Parameters Initialization

load('yieldfunc_noirrig_parms.mat') % loading this dataet will generate a matrix containing the 1000 random beta's

A = 180 % ha    % area in ha %  the average farm size in the US

% sale price 

mu_p_corn= 5.90/25.4 % $/kg  mean sale price 
sig_p_corn = 0.23/25.4 % $/kg mean sigma sale price
r_N= 1308/907.18 % $/kg nitrogen sale price 
r_W= 1.1 % $/kg nitrogen sale price 
pmax = 0.31
pmin = 0.1

% rainfall during growing time 
mu_W_g = 9.96; %cm mean precipitation 

sig_W_g_vec = 2.5:10

W_g_max = 27; %cm
W_g_min = 1.9; %cm
V= transpose((0:100:1000));

% other weather variables

T_p = 13.54
W_p = 10.59
T_g = 22.43
T_h = 15.05
W_h = 8.48

v= 0.005

%% Irrigation 
%total water
theta_ir = 2 % impact 
W_tot = @(W_g,W_ir) W_g + W_ir.*theta_ir

%% Step 2:  production function specification 

for k=1:4
    for j=1:fin
    
% production function 

y_func = @(N,W_g,W_ir) matrix1(j,1) + matrix1(j,2).*W_tot(W_g,W_ir)+ matrix1(j,3).*N + matrix1(j,4).*W_tot(W_g,W_ir).^2 + matrix1(j,5).*N.^2 + matrix1(j,6)*(N.*W_tot(W_g,W_ir))+ matrix1(j,7)*(T_g)+ matrix1(j,8)*(T_g.^2)+matrix1(j,9)*(T_g.*N)+ matrix1(j,10)*(T_g.*W_tot(W_g,W_ir))+ matrix1(j,11).*(T_p)+ matrix1(j,12)*(T_p.^2)+ matrix1(j,13)*(T_h) +matrix1(j,14)*(T_h.^2)+ matrix1(j,15)*(W_p) + matrix1(j,16)*(W_p.^2)+ matrix1(j,17)*(W_h)+ matrix1(j,18)*(W_h.^2) %production yield (kg/ha)

% price density 
G_p= @(p) exp(-(p-mu_p_corn).^2/(2*sig_p_corn.^2))*(1/(sig_p_corn*(2*pi()).^.5)) % density function of price 


%% without insurance 

% profit for farmer having no insurance 
ppt_g = [mu_W_g-V(k)/100;mu_W_g+V(k)/100]

Pi_1= @(N,p,W_g,W_ir) A.*(p.*y_func(N,W_g,W_ir)-r_N.*N-r_W.*W_ir) % Wealth of farmer with no Insurance
U_1 = @(N,p,W_g,W_ir) Pi_1(N,p,W_g,W_ir) - v .* (Pi_1(N,p,W_g,W_ir)).^2%

U_1 = @(N,W_g,W_ir) integral(@(p) U_1(N,p,W_g,W_ir).*G_p(p),pmin,pmax,'ArrayValued',true)% Expected utility of profit with no insurance 

U_1_neg = @(x) - U_1(x(1),ppt_g,x(2))

% boundaries of W_ir

% the boundaries for W over time
lbw = max((10*(0.9*W_g_min - W_g_min + 10^-2.*V(k,1)) - 10*(1.1*W_g_max - W_g_max - 10^-2.*V(k,1)))/(2*theta_ir),0)
ubw = (10*(1.1*W_g_min - W_g_min + 10^-2.*V(k,1)) - 10*(0.9*W_g_max - W_g_max - 10^-2.*V(k,1)))/(2*theta_ir)


%% Step 3 Optimization specification 
      
% Maximization of profit with no insurance 
x0=[20;(lbw+ubw)/2];
lb=[10;lbw];
ub=[1500;ubw];

Ai = []; % No linear constraints
b = [];
Aeq = [];
beq = [];

[x_opt_1,U_1_opt_m,U_1_opt_val] = fminimax(U_1_neg,x0,Ai,b,Aeq,beq,lb,ub)

matrix_irrig_no_ins_uncertainty(j,18+k)=x_opt_1(1);
matrix_irrig_no_ins_uncertainty(j,24+k)=x_opt_1(2);
matrix_irrig_no_ins_uncertainty(j,30+k)= -U_1_opt_val;
    end
end
save matrix_irrig_no_ins_uncertainty.mat matrix_irrig_no_ins_uncertainty
