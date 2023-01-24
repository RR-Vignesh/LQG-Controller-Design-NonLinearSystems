%clearing the previous outputs
clc
clear
%initialzing the values for the constants M, m1, m2, l1 and l2
M=1000; %Mass of the cart
m_1=100; %mass of the Pendulum 1
m_2=100; %mass of the Pendulum 2
l_1=20; %length of the string attached with Pendulum 1 from the cart
l_2=10; %length of the string attached with Pendulum 2 from the cart
g=9.81; %accelertaion due to gravity in m/s^2 is a constant
%declaring the state space matrices
A=[0 1 0 0 0 0;
 0 0 -(m_1*g)/M 0 -(m_2*g)/M 0;
 0 0 0 1 0 0;
 0 0 -((M+m_1)*g)/(M*l_1) 0 -(m_2*g)/(M*l_1) 0;
 0 0 0 0 0 1;
 0 0 -(m_1*g)/(M*l_2) 0 -(g*(M+m_2))/(M*l_2) 0];
B=[0; 1/M; 0; 1/(M*l_1); 0; 1/(M*l_2)];
% We have previously found out only C1, C3 and C4 are observable.
% Hence we will only use C1, C3 and C4.

C_1_matrix = [1 0 0 0 0 0]; %output measurement for the x component
C_3_matrix = [1 0 0 0 0 0; 0 0 0 0 1 0]; %output measurement for the components x and theat2
C_4_matrix = [1 0 0 0 0 0; 0 0 1 0 0 0; 0 0 0 0 1 0]; %output measurement for the components x, theta1 and theat2
D_matrix = 0;%Initiazling the D matrix with zeroes


% declaring the same Q and R matrices
Q=[100 0 0 0 0 0;
 0 100 0 0 0 0;
 0 0 100 0 0 0;
 0 0 0 100 0 0;
 0 0 0 0 100 0;
 0 0 0 0 0 100];
R=0.01; %%these are the variables used in cost function from LQR

% The initial conditions for Leunberger observer consists of 12 state variables are as follows,
% where we are considering 6 actual and 6 estimates
x0=[0,0,30,0,60,0,0,0,0,0,0,0];
% The order of state variables is as follows = [x,dx,theta_1,dtheta_1,theta_2,dtheta_2, 
% estimated_x,estimated_dx,estimated_theta_1,estimated_dtheta_1,estimated_theta_2,estimated_dtheta_2]
% For pole placement, we will choose eigen values with negative real part for stability
poles=[-1;-2;-3;-4;-5;-6];
% Calling LQR function to obtain K matrix
K=lqr(A,B,Q,R);

% Framing the Luenberger equation for all three cases where output is observable
% Using the pole placement funciton built into MATLAB
L_1 = place(A',C_1_matrix',poles)'; %L1 should be a 6x1 matrix
L_3 = place(A',C_3_matrix',poles)'; %L3 should be a 6x2 matrix
L_4 = place(A',C_4_matrix',poles)'; %L4 should be a 6x3 matrix
A_c1 = [(A-B*K) B*K; zeros(size(A)) (A-L_1*C_1_matrix)];% Luenberger A matrix    
B_c = [B;zeros(size(B))];% Luenberger B matrix
C_c1 = [C_1_matrix zeros(size(C_1_matrix))];% Luenberger C matrix
A_c3 = [(A-B*K) B*K; zeros(size(A)) (A-L_3*C_3_matrix)];% Luenberger A matrix
 
C_c3 = [C_3_matrix zeros(size(C_3_matrix))];% Luenberger C matrix
A_c4 = [(A-B*K) B*K; zeros(size(A)) (A-L_4*C_4_matrix)];% Luenberger A matrix 
C_c4 = [C_4_matrix zeros(size(C_4_matrix))];% Luenberger C matrix

system_1 = ss(A_c1, B_c, C_c1,D_matrix);%Inbuilt MATLAB function to output the state space equations
figure % launching a new figure WINDOW in Matlab
initial(system_1,x0)%Inbuilt MATLAB function to verify the initial response  of the system

figure
step(system_1)%Provides the step output response of the system

system_3 = ss(A_c3, B_c, C_c3,D_matrix);%inbult MATLAB function to output the state space equations
figure
initial(system_3,x0)%inbuilt MATLAB function to verify the initial response of the system

figure
step(system_3)%Provides the step output response of the system

system_4 = ss(A_c4, B_c, C_c4, D_matrix);%inbult MATLAB function to output the state space equations
figure
initial(system_4,x0)%inuilt MATLAB function to verify the initial response of the system

figure
step(system_4)%Provides the step output response of the system
grid on