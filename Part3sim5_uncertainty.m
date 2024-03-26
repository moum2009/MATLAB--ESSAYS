%% Probability of crop insurance purchase 

%clear all 
%clc

load('matrix_irrig_no_ins.mat') % load the case with no insurance and irrigation
load('matrix_irrig_ins.mat') % load the case with insurance and irrigation

%% Probability of crop insurance purchase for a farmer without irrigation v = 0.0025
Uinsno = matrix_irrig_no_ins(1:fin,30:34)/10^7 % the third column of this matrix is max EU without ins
Uins= matrix_irrig_ins(1:fin,35:39)/10^7 % the 4th column is max EU with ins

% Getting the choice based on the on expected utility
prob_uncertainty_irrig= zeros(fin,4)
for k= 1:4
for j=1:fin
prob_uncertainty_irrig(j,k) = exp(Uins(j,k))/(exp(Uins(j,k))+exp(Uinsno(j,k)))
end
end 

for k=1:4
prob_uncertainty_irrig(fin+1,k)= mean(prob_uncertainty_irrig(1:fin,k))
end 

%%
% [ttesth1,ttestp1,ttestci1,tteststat1] = ttest(prob(1:fin,1),prob_no_irrig(1:fin,1))
% [kstesth1,kstestp1,ksteststat1] = kstest2(prob(1:fin,1),prob_no_irrig(1:fin,1))
% [signtestp1,signtesth1,signteststats1] = signrank(prob(1:fin,1),prob_no_irrig(1:fin,1))
% 
% [ttesth2,ttestp2,ttestci2,tteststat2] = ttest(prob(1:fin,2),prob_no_irrig(1:fin,2))
% [kstesth2,kstestp2,ksteststat2] = kstest2(prob(1:fin,2),prob_no_irrig(1:fin,2))
% [signtestp2,signtesth2,signteststats2] = signrank(prob(1:fin,2),prob_no_irrig(1:fin,2))
% 
% [ttesth3,ttestp3,ttestci3,tteststat3] = ttest(prob(1:fin,3),prob_no_irrig(1:fin,3))
% [kstesth3,kstestp3,ksteststat3] = kstest2(prob(1:fin,3),prob_no_irrig(1:fin,3))
% [signtestp3,signtesth3,signteststats3] = signrank(prob(1:fin,3),prob_no_irrig(1:fin,3))
% 
% [ttesth4,ttestp4,ttestci4,tteststat4] = ttest(prob(1:fin,4),prob_no_irrig(1:fin,4))
% [kstesth4,kstestp4,ksteststat4] = kstest2(prob(1:fin,4),prob_no_irrig(1:fin,4))
% [signtestp4,signtesth4,signteststats4] = signrank(prob(1:fin,4),prob_no_irrig(1:fin,4))
% 
% figure(5)
% plot(sig_pptg_vec(2:4),100*prob(fin+1,2:4))
% hold on 
% plot(sig_pptg_vec(2:4),100*prob_no_irrig(fin+1,2:4))
% xlabel('Standard Deviation of Precipitation') 
% ylabel('Probability of Participation (%)')
% legend('Irrigation','No Irrigation')
% 
% sig = [sprintf('sig = 3.5');sprintf('sig = 4.5');sprintf('sig = 5.5')];
% average_prob = 100*[prob(fin+1,2)-prob_no_irrig(fin+1,2);prob(fin+1,3)-prob_no_irrig(fin+1,3);prob(fin+1,4)-prob_no_irrig(fin+1,4)];
% t_test = [ttestp2;ttestp3;ttestp4];
% ks_test = [kstestp2;kstestp3;kstestp4];
% 
% T = table(sig,average_prob,t_test,ks_test)                               %
% table2latex(T);  
