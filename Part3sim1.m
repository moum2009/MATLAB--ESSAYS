%% Probability of crop insurance purchase 

%clear all 
%clc
load('matrix_no_irrig_no_ins.mat') % load the case with no insurance
load('matrix_no_irrig_ins.mat') % load the case with insurance

%% probability of crop insurance purchase for a farmer without irrigation v = 0.0025

EUinsno = matrix_no_irrig_no_ins(1:fin,25:28)/10^7 % the third column of this matrix is max EU without ins
EUins= matrix_irrig_no_ins(1:fin,31:34)/10^7 % the 4th column is max EU with ins

% Getting the choice based on the proberence on expected utility
prob= zeros(fin,4)
for k= 1:4
for j=1:fin
prob(j,k) = exp(EUins(j,k))/(exp(EUins(j,k))+exp(EUinsno(j,k)))
end
end 

for k=1:4
prob(fin+1,k)= mean(prob(1:fin,k))
end 

% prob between insurance vs no insurance
[ttesth1,ttestp1,ttestci1,tteststat1] = ttest(prob(1:fin,2),prob(1:fin,1))
[kstesth1,kstestp1,ksteststat1] = kstest2(prob(1:fin,2),prob(1:fin,1))
[signtestp1,signtesth1,signteststats1] = signrank(prob(1:fin,2),prob(1:fin,1))

[ttesth2,ttestp2,ttestci2,tteststat2] = ttest(prob(1:fin,3),prob(1:fin,1))
[kstesth2,kstestp2,ksteststat2] = kstest2(prob(1:fin,3),prob(1:fin,1))
[signtestp2,signtesth2,signteststats2] = signrank(prob(1:fin,3),prob(1:fin,1))

[ttesth3,ttestp3,ttestci3,tteststat3] = ttest(prob(1:fin,4),prob(1:fin,1))
[kstesth3,kstestp3,ksteststat3] = kstest2(prob(1:fin,4),prob(1:fin,1))
[signtestp3,signtesth3,signteststats3] = signrank(prob(1:fin,4),prob(1:fin,1))


figure(1)
plot(sig_W_g_vec(1:4),100*prob(fin+1,1:4))
xlabel('Precipitation Standard Deviation (cm)') 
ylabel('Probability of Participation (%)')

std_prob = [sprintf('sig = 2.5 vs sig = 3.5');sprintf('sig = 2.5 vs sig = 4.5');sprintf('sig = 2.5 vs sig = 5.5')];
average_prob = fin*[prob(fin+1,2)-prob(fin+1,1);prob(fin+1,3)-prob(fin+1,1);prob(fin+1,4)-prob(fin+1,1)];
t_test = [ttestp1;ttestp2;ttestp3];
ks_test = [kstestp1;kstestp2;kstestp3];

T = table(std_prob,average_prob,t_test,ks_test)                               %
table2latex(T);              
