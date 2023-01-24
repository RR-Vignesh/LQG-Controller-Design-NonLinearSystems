%clearing all the previous outputs
clc
clear
% Declaring the variables
syms M m1 m2 l1 l2 g;
% Creating a linearized state space equation using A and B matrices
A=[0 1 0 0 0 0; 
    0 0 -(m1*g)/M 0 -(m2*g)/M 0;
    0 0 0 1 0 0;
    0 0 -((M+m1)*g)/(M*l1) 0 -(m2*g)/(M*l1) 0;
    0 0 0 0 0 1;
    0 0 -(m1*g)/(M*l2) 0 -(g*(M+m2))/(M*l2) 0];
B=[0; 1/M; 0; 1/(M*l1); 0; 1/(M*l2)];         %Declaring and initializing the B matrix which was obtained in the question
C1 = [1 0 0 0 0 0];                           %Initializing the C Matrix for the x component
C2 = [0 0 1 0 0 0; 0 0 0 0 1 0];              %Initializing the C Matrix for theta1 and theta2
C3 = [1 0 0 0 0 0; 0 0 0 0 1 0];              %Initializing the C Matrix for x and theta2
C4 = [1 0 0 0 0 0; 0 0 1 0 0 0; 0 0 0 0 1 0]; %Initializing the C Matrix for x, theta1 and theta2
%Matrix to check the Observability Condition
Observability1_mat = [C1' A'*C1' A'*A'*C1' A'*A'*A'*C1' A'*A'*A'*A'*C1' A'*A'*A'*A'*A'*C1'];
Observability2_mat = [C2' A'*C2' A'*A'*C2' A'*A'*A'*C2' A'*A'*A'*A'*C2' A'*A'*A'*A'*A'*C2'];
Observability3_mat = [C3' A'*C3' A'*A'*C3' A'*A'*A'*C3' A'*A'*A'*A'*C3' A'*A'*A'*A'*A'*C3'];
Observability4_mat = [C4' A'*C4' A'*A'*C4' A'*A'*A'*C4' A'*A'*A'*A'*C4' A'*A'*A'*A'*A'*C4'];
rank_Array = [rank(Observability1_mat),rank(Observability2_mat),rank(Observability3_mat),rank(Observability4_mat)];

% Iterating Over rankArray
for i = 1:4
  switch(i)
      case 1
          if rank_Array(i)==6 %Checking for full rank i.e. rank = 6
              disp('The system is observable when only x(t) is requested..')
            else
              disp('The system is not observable when only x(t) is requested..')
          end
      case 2
           if rank_Array(i)==6 %Checking for full rank i.e. rank = 6
              disp('The system is observable when only theta1(t) and theta2(t) are requested..')
           else
              disp('The system is not observable when only theta1(t) and theta2(t) are requested..')
           end
      case 3
           if rank_Array(i)==6 %Checking for full rank i.e. rank = 6
                   disp('The system is observable when only x(t) and theta2(t) are requested..')
            else
                disp('The system is not observable when only x(t) and theta2(t) are requested..')
           end

      case 4
           if rank_Array(i)==6 %Checking for full rank i.e. rank = 6
                disp('The system is observable when x(t), theta1(t) and theta2(t) are requested..')
            else
                disp('The system is not observable when x(t), theta1(t) and theta2(t) are requested..')
            end
      
  end
end