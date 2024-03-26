% clear all 
% clc

%% irrigation with insurance 
%%%% A) Optimal expected utility of profit of the farmer planting non-irrigated corn with insurance

%% Step I: Parameters Initialization
load('yieldfunc_noirrig_parms.mat') % loading this dataet will generate a matrix containing the 1000 random beta's
matrix_irrig_ins= matrix_irrig_no_ins
fin=10

A = 180 % ha    % area in ha %  the average farm size in the US

% sale price 
mu_p_corn= 5.90/25.4 % $/kg  mean sale price 
sig_p_corn = 0.23/25.4 % $/kg mean sigma sale price
r_N= 1308/907.18 % $/kg nitrogen sale price 
pmax = 0.31
pmin = 0.1

% rainfall during growing time 
mu_W_g = 9.96; %cm mean precipitation 
sig_W_g_vec = 2.5:10;
W_g_max = 27; %cm
W_g_min = 1.9; %cm

% other weather variables

T_p = 13.54
W_p = 10.59
T_g = 22.43
T_h = 15.05
W_h = 8.48


% insurance 
v =0.005
ded= @(c) 100 - c % deductible

%% Irrigation 
%reference levels 
sig_W_g_0 = 2.5
mu_W_g_0 = 13
%total water
theta_ir = 2000 % impact 
W_tot = @(W_g,W_ir) W_g + W_ir

for k=1:4
    for j=1:fin
% production function 

sig_W_g = sig_W_g_vec(k); %cm standard deviation precipitation 
sig_W_tot =@(W_ir) sig_W_g - W_ir*theta_ir/1000
mu_W_tot =@(W_ir) mu_W_g + W_ir*theta_ir/1000

y_func = @(N,W_g,W_ir) theta_ir + matrix1(j,1) + matrix1(j,2).*W_tot(W_g,W_ir)+ matrix1(j,3).*N + matrix1(j,4).*W_tot(W_g,W_ir).^2 + matrix1(j,5).*N.^2 + matrix1(j,6)*(N.*W_tot(W_g,W_ir))+ matrix1(j,7)*(T_g)+ matrix1(j,8)*(T_g.^2)+matrix1(j,9)*(T_g.*N)+ matrix1(j,10)*(T_g.*W_tot(W_g,W_ir))+ matrix1(j,11).*(T_p)+ matrix1(j,12)*(T_p.^2)+ matrix1(j,13)*(T_h) +matrix1(j,14)*(T_h.^2)+ matrix1(j,15)*(W_p) + matrix1(j,16)*(W_p.^2)+ matrix1(j,17)*(W_h)+ matrix1(j,18)*(W_h.^2) %production yield (kg/ha)

% rainfall density 
R_W_g= @(W_g,W_ir) exp(-(W_tot(W_g,W_ir)-mu_W_tot(W_ir)).^2/(2*sig_W_tot(W_ir).^2))*(1/(sig_W_tot(W_ir)*(2*pi()).^.5)) % density function of precipitation during growing time

% price density 
G_p= @(p) exp(-(p-mu_p_corn).^2/(2*sig_p_corn.^2))*(1/(sig_p_corn*(2*pi()).^.5)) % density function of price 


% the guarantee yield 
y_func_g =@(c) 2768*exp(0.0151.*c) % the guarantee yield for the area 

%Premium rates are generated from crop insurance tool 

prem = @(c) 0.0139*exp(0.074.*c) % the premium rate

% profit for farmer having insurance 

I=@(N,W_g,W_ir,c) (y_func_g(c)> y_func(N,W_g,W_ir)).*mu_p_corn.*(y_func_g(c)-y_func(N,W_g,W_ir))   %indemnity calc

Pi_2= @(N,p,W_g,W_ir,c) A.*(p.*y_func(N,W_g,W_ir)- r_N.*N -r_W*W_ir + ((100-ded(c))/100).*I(N,W_g,W_ir,c)- prem(c)) %Profit % Wealth of farmer with no Insurance

U_2 = @(N,p,W_g,W_ir,c) Pi_2(N,p,W_g,W_ir,c) - v.* (Pi_2(N,p,W_g,W_ir,c)).^2%

EU_2= @(N,W_ir,c) integral2(@(p,W_g) U_2(N,p,W_g,W_ir,c).*R_W_g(W_g,W_ir).*G_p(p),pmin,pmax,W_g_min,W_g_max)% Expected profit with no insurance 

EU_2_neg =@(x) - EU_2(x(1),x(2),x(3))

k=k
j=j 

% boundaries of W_ir
% boundaries of W_ir
lbw = max((0.9*mu_W_g_0 - mu_W_g - 1.1*sig_W_g_0 + sig_W_g)/(2*theta_ir*0.0001),0)
ubw =((1.1*mu_W_g_0 - mu_W_g -0.9*sig_W_g_0 + sig_W_g))/(2*theta_ir*0.0001)


%% Step 3 Optimization specification 
% Maximization of profit with insurance 

% Maximization of profit with no insurance 
x0=[20;(lbw+ubw)/2;63];
lb=[10;lbw;50];
ub=[1500;ubw;90];

opts = optimoptions(@fmincon,'Algorithm','interior-point');
problem = createOptimProblem('fmincon','objective',EU_2_neg,'x0',x0,'lb',lb,'ub',ub,'options',opts);  %set limits on x to 0

ms = MultiStart;
[x_opt_2,EU_2_neg_opt] = run(ms,problem,2);

EU_2_opt = - EU_2_neg_opt

matrix_irrig_ins(j,18+k)= x_opt_2(1); matrix_irrig_ins(j,24+k)= x_opt_2(2); matrix_irrig_ins(j,30+k)= x_opt_2(3); matrix_irrig_ins(j,35+k)= EU_2_opt;
   end
end

save matrix_irrig_ins.mat matrix_irrig_ins
