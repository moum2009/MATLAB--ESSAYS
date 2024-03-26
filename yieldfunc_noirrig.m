clear all 
clc

%%%% A) Optimal expected utility of profit of the farmer planting non-irrigated corn without insurance

% matrix holding results 
     
matrix1 = zeros(1000,8);

% production function parameters % 
%                             Estimate Std. Error t value Pr(>|t|)    
% (Intercept)               -4.200e+04  2.449e+03 -17.151  < 2e-16 ***
% pptg                       4.223e+02  8.214e+01   5.142 2.78e-07 ***
% rate_N_county              1.661e+01  2.895e+00   5.739 9.84e-09 ***
% I(pptg^2)                 -2.154e+01  1.146e+00 -18.802  < 2e-16 ***
% I(rate_N_county^2)        -3.955e-03  5.280e-04  -7.490 7.56e-14 ***
% I(pptg * rate_N_county)   -1.929e-01  5.796e-02  -3.329 0.000875 ***
% tmeang                     3.422e+03  2.507e+02  13.652  < 2e-16 ***
% I(tmeang^2)               -6.498e+01  5.447e+00 -11.928  < 2e-16 ***
% I(tmeang * rate_N_county) -6.056e-01  1.195e-01  -5.068 4.10e-07 ***
% I(tmeang * pptg)           9.495e+00  3.193e+00   2.974 0.002952 ** 
% tmeanp                     1.876e+02  1.001e+02   1.874 0.060940 .  
% I(tmeanp^2)               -6.135e+00  3.627e+00  -1.691 0.090801 .  
% tmeanh                     2.373e+02  1.428e+02   1.662 0.096555 .  
% I(tmeanh^2)               -1.839e+01  4.540e+00  -4.049 5.18e-05 ***
% pptp                       3.570e+01  1.555e+01   2.296 0.021698 *  
% I(pptp^2)                 -2.613e+00  5.729e-01  -4.561 5.16e-06 ***
% ppth                      -1.313e+01  1.481e+01  -0.887 0.375080    

mu_b0= -4.200*10.^4; mu_b1= 4.223*10.^2; mu_b2= 1.661*10.^1; mu_b3= -2.154*10.^1; mu_b4= -3.955*10^-3;mu_b5=-1.929*10.^-1;mu_b6= 3.422*10.^3;
mu_b7=-6.498*10.^1;mu_b8=-6.056*10^-1;mu_b9= 9.495;mu_b10=1.876*10.^2; mu_b11= -6.135; mu_b12=  2.373*10.^2; mu_b13=  -1.839*10.^1; mu_b14= 3.57*10^1; 
mu_b15=-2.613; mu_b16=1.313*10.^1 ;mu_b17=-1.871;

sig_b0= 2.449*10^3; sig_b1= 8.214*10^1; sig_b2= 2.895; sig_b3= 1.146; sig_b4= 5.280*10^-4;sig_b5=5.796*10^-2;sig_b6= 2.507*10^2;
sig_b7=5.447;sig_b8=1.195*10^-1;sig_b9= 3.193 ;sig_b10=1.001*10^2; sig_b11= 3.627; sig_b12=  1.428*10^2 ; sig_b13=  4.540; sig_b14= 1.555*10^1 ; 
sig_b15=5.729*10^-1; sig_b16=1.481*10^1 ;sig_b17=6.595*10^-1;

rng(1234) 

for j=1:1000

b0 = normrnd(mu_b0,sig_b0);
b1 = normrnd(mu_b1,sig_b1);
b2 = normrnd(mu_b2,sig_b2);
b3 = normrnd(mu_b3,sig_b3);
b4 = normrnd(mu_b4,sig_b4);
b5 = normrnd(mu_b5,sig_b5);
b6 = normrnd(mu_b6,sig_b6);
b7 = normrnd(mu_b7,sig_b7);
b8 = normrnd(mu_b8,sig_b8);
b9 = normrnd(mu_b9,sig_b9);
b10 = normrnd(mu_b10,sig_b10);
b11 = normrnd(mu_b11,sig_b11);
b12= normrnd(mu_b12,sig_b12);
b13= normrnd(mu_b13,sig_b13);
b14= normrnd(mu_b14,sig_b14);
b15= normrnd(mu_b15,sig_b15);
b16= normrnd(mu_b16,sig_b16);
b17 = normrnd(mu_b17,sig_b17);

matrix1(j,1)= b0; matrix1(j,2)= b1; matrix1(j,3)= b2; matrix1(j,4)= b3; matrix1(j,5)= b4; matrix1(j,6)= b5; matrix1(j,7)= b6; matrix1(j,8)= b7; matrix1(j,9)= b8;
matrix1(j,10)= b9; matrix1(j,11)= b10; matrix1(j,12)= b11; matrix1(j,13)= b12;  matrix1(j,14)= b13; matrix1(j,15)= b14; matrix1(j,16)= b15; matrix1(j,17)= b16; matrix1(j,18)= b17; 
end 

%intercept

for i=1:1
    for j=1:1000
if matrix1(j,1) > 0;
   matrix1(j,1)=  - matrix1(j,1); 
end    
    end 
end 


%pptg


for i=1:1
    for j=1:1000
if matrix1(j,2) < 0;
   matrix1(j,2)=  - matrix1(j,2); 
end    
    end 
end 
% rate_N_county

for i=1:1
    for j=1:1000
if matrix1(j,3) < 0;
   matrix1(j,3)=  - matrix1(j,3); 
end    
    end 
end 

% pptg^2


for i=1:1
    for j=1:1000
if matrix1(j,4) > 0;
   matrix1(j,4)=  - matrix1(j,4); 
end    
    end 
end 

% rate_N_county^2
    for j=1:1000
if matrix1(j,5) > 0;
   matrix1(j,5)=  - matrix1(j,5); 
end    
    end 

%pptg*rate_N_county
    for j=1:1000
if matrix1(j,6) > 0;
   matrix1(j,6)=  - matrix1(j,6); 
end    
    end 



%tmeang
for j=1:1000
if matrix1(j,7) < 0;
   matrix1(j,7)=  - matrix1(j,7); 
end    
end 


%tmeang^2

    for j=1:1000
if matrix1(j,8) > 0;
   matrix1(j,8)=  - matrix1(j,8); 
end    
    end 

%tmeang * rate_N_county

    for j=1:1000
if matrix1(j,9) > 0;
   matrix1(j,9)=  - matrix1(j,9); 
end    
    end 


%tmeang * pptg

    for j=1:1000
if matrix1(j,10) < 0;
   matrix1(j,10)=  - matrix1(j,10); 
end    
    end 

%tmeanp

    for j=1:1000
if matrix1(j,11) < 0;
   matrix1(j,11)=  - matrix1(j,11); 
end    
    end 


%tmeanp^2


    for j=1:1000
if matrix1(j,12) > 0;
   matrix1(j,12)=  - matrix1(j,12); 
end    
    end 

%tmeanh

    for j=1:1000
if matrix1(j,13) < 0;
   matrix1(j,13)=  - matrix1(j,13); 
end    
    end 

%tmeanh^2


    for j=1:1000
if matrix1(j,14) > 0;
   matrix1(j,14)=  - matrix1(j,14); 
end    
    end 

%pptp
 for j=1:1000
if matrix1(j,15) < 0;
   matrix1(j,15)=  - matrix1(j,15); 
end    
 end 

%pptp^2

for j=1:1000
if matrix1(j,16) > 0;
   matrix1(j,16)=  - matrix1(j,16); 
end    
end 

%ppth


for j=1:1000
if matrix1(j,17) > 0;
   matrix1(j,17)=  - matrix1(j,17); 
end    
end 

%ppth^2


for j=1:1000
if matrix1(j,18) > 0;
   matrix1(j,18)=  - matrix1(j,18); 
end    
end

save('yieldfunc_noirrig_parms.mat','matrix1');  

