% clear all 
% clc

%%%% A) Optimal expected utility of profit of the farmer planting non-irrigated corn with insurance
%% no irrigation but with insurance 

%% Step I: Parameters Initialization
load('yieldfunc_noirrig_parms.mat') % loading this dataset will generate a matrix containing the random beta's

A = 180 % ha    % area in ha %  the average farm size in the US

% sale price 
mu_p_corn= 5.90/25.4 % $/kg  mean sale price 
sig_p_corn = 0.23/25.4 % $/kg mean sigma sale price
r_N= 1308/907.18 % $/kg nitrogen sale price 
pmax = 0.31
pmin = 0.1

V= transpose((0:100:1000));

% rainfall during growing time 
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

for k=1:4
    for j=1:fin
% production function 

y_func = @(N,W_g) matrix1(j,1) + matrix1(j,2).*W_g+ matrix1(j,3).*N + matrix1(j,4).*W_g.^2 + matrix1(j,5).*N.^2 + matrix1(j,6)*(N.*W_g)+ matrix1(j,7)*(T_g)+ matrix1(j,8)*(T_g.^2)+matrix1(j,9)*(T_g.*N)+ matrix1(j,10)*(T_g.*W_g)+ matrix1(j,11).*(T_p)+ matrix1(j,12)*(T_p.^2)+ matrix1(j,13)*(T_h) +matrix1(j,14)*(T_h.^2)+ matrix1(j,15)*(W_p) + matrix1(j,16)*(W_p.^2)+ matrix1(j,17)*(W_h)+ matrix1(j,18)*(W_h.^2) %production yield (kg/ha)

% price density 
G_p= @(p) exp(-(p-mu_p_corn).^2/(2*sig_p_corn.^2))*(1/(sig_p_corn*(2*pi()).^.5)) % density function of price 

% the guarantee yield 
y_func_g =@(c) 2768*exp(0.0151.*c) % the guarantee yield for the area 

%Premium rates are generated from crop insurance tool 

prem = @(c) 0.0139*exp(0.074.*c) % the premium rate

% profit for farmer having insurance and no irrigation

I=@(N,W_g,c) (y_func_g(c)> y_func(N,W_g)).*mu_p_corn.*(y_func_g(c)-y_func(N,W_g))   %indemnity calc

Pi_2= @(N,p,W_g,c) A.*(p.*y_func(N,W_g)- r_N.*N + ((100-ded(c))/100).*I(N,W_g,c)- prem(c)) %Profit % Wealth of farmer with no Insurance

U_2 = @(N,p,W_g,c) Pi_2(N,p,W_g,c) - v.* (Pi_2(N,p,W_g,c)).^2%

U_2= @(N,W_g,c) integral(@(p) U_2(N,p,W_g,c).*G_p(p),pmin,pmax,'ArrayValued',true)% Expected profit with insurance 

ppt_g = [mu_W_g-V(k)/100;mu_W_g+V(k)/100]

U_2_neg =@(x) - U_2(x(1),ppt_g,x(2))

%% Step 3 Optimization specification 
% Maximization of profit with insurance 

x0=[20;63];
lb=[10;50];
ub=[1500;90];
Ai = []; % No linear constraints
b = [];
Aeq = [];
beq = [];

[x_opt_2,U_2_opt_m,U_2_opt_val] = fminimax(U_2_neg,x0,Ai,b,Aeq,beq,lb,ub)

matrix_no_irrig_ins_uncertainty(j,18+k)= x_opt_2(1); 
matrix_no_irrig_ins_uncertainty(j,24+k)= x_opt_2(2); 
matrix_no_irrig_ins_uncertainty(j,30+k)= - U_2_opt_val;
   end
end

save matrix_no_irrig_ins_uncertainty.mat matrix_no_irrig_ins_uncertainty


