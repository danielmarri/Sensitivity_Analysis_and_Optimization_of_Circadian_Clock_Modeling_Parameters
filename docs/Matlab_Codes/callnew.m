%%CALLS THE CLOCK MODEL AND DISPLAY THE DYNAMICS OF THE MODEL
function [T,Y] = callnew()
%%
clc; clear all; close all;
%% 
tspan = [0  100];
    y1_0 = 1.7;  y2_0 = 1.304;  y3_0 = 0;  y4_0 = 0.5;  y5_0 = 1.134;  y6_0 = 1.414; y7_0 = 1.8311132;
   y8_0 =1.5232; y9_0 = 1.45; y10_0 = 1.73;  y11_0 = 1.603;  y12_0 = 1.504;  y13_0 = 1.301;  y14_0 = 1.1014;  
    y15_0=1.153; y16_0=1.153; y17_0=1.353; y18_0=1.0153;  y19_0=2.2153; y20_0=2.0153; y21_0=2.0353; y22_0=2.043; y23_0=2.0353;
    
  %%  
    [T,Y] = ode45(@new,tspan,[y1_0 y2_0 y3_0 y4_0 y5_0 y6_0 y7_0 y8_0 y9_0 y10_0 y11_0 y12_0 y13_0 y14_0 y15_0 y16_0 y17_0 y18_0 y19_0 y20_0 y21_0 y22_0 y23_0]);
    %plot(T,Y);grid on
   

    
%%
figure 
plot(T,Y(:,1),'LineWidth',3.0);
      xlabel('Time(h)');
    ylabel('Concentration (nM)');
     legend('Per mRNA') 
     
     
     

  figure 
      plot(T,Y(:,2),'LineWidth',3.0);
        xlabel('Time(h)');
   ylabel('Concentration (nM)');
       legend('Cry mRNA')
       
       figure 
       plot(T,Y(:,3), 'LineWidth',3.0);
         xlabel('Time(h)');
    ylabel('Concentration (nM)');
      legend('Bmal1 mRNA')
   
    figure
     plot(T,Y(:,4), 'LineWidth',3.0);
         xlabel('Time(h)');
   ylabel('Concentration (nM)');
      legend('Ror mRNA')
      
      figure 
       plot(T,Y(:,5), 'LineWidth',3.0);
         xlabel('Time(h)');
    ylabel('Concentration (nM)');
      legend('Rev-erb mRNA')
        

 
   
      
   figure
  plot(T,Y(:,1),'LineWidth',3)
   hold on
   plot(T,Y(:,2),'LineWidth',3)
  plot(T,Y(:,3),'LineWidth',3)
  legend('Per','Cry','Bmal1') 
   xlabel('Time(h)');
   ylabel('Concentration (nM)');      
      
      
      
      
      
     figure
  plot(T,Y(:,3),'LineWidth',3)
   hold on
   plot(T,Y(:,4),'LineWidth',3)
  plot(T,Y(:,5),'LineWidth',3)
  legend('Bmal1','Ror','Rev-erb') 
   xlabel('Time(h)');
   ylabel('Concentration (nM)'); 
   
    figure
  plot(T,Y(:,1),'LineWidth',3)
   hold on
   plot(T,Y(:,2),'LineWidth',3)
  plot(T,Y(:,3),'LineWidth',3)
   plot(T,Y(:,4),'LineWidth',3)
  plot(T,Y(:,5),'LineWidth',3)
  legend('Per','Cry','Bmal1','Ror','Rev-erb') 
   xlabel('Time(h)');
   ylabel('Concentration (nM)');  
   
   
   
   figure
  plot(T,Y(:,6)+ Y(:,11)+ Y(:,12)+ Y(:,17)+ Y(:,22) ,'LineWidth',3)
   hold on
   plot(T,Y(:,7)+ Y(:,11)+ Y(:,13)+ Y(:,17)+ Y(:,22) ,'LineWidth',3)
  plot(T,Y(:,8)+ Y(:,14)+ Y(:,18)+ Y(:,21),'LineWidth',3)
  plot(T,Y(:,9) + Y(:,15)+ Y(:,19),'LineWidth',3)
  plot(T,Y(:,10) + Y(:,16)+ Y(:,20),'LineWidth',3)
  legend('PER','CRY','BMAL1','ROR','REV-ERB') 
   xlabel('Time(h)');
   ylabel('Concentration (nM)');
    
     
     
end
 