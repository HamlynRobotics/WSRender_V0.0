% Input:
% Robot: The robot defined using ‘BuildRobot’ function
% 
% Output:
% Length_Sum: the total length of the robot
% Prismatic_Num: the number of prismatic joint
% Precision: the precision for workspace discretization
% 
% Function:
% Initial parameters for workspace visualization
% 
% Example:
% [N_DoF,Robot] = BuildRobot('Articulated');
% [Length_Sum,Prismatic_Num,Precision] = Initial_Precision(Robot);  

%%
function [length_sum,Prismatic_Num,Precision,Error] = Initial_Precision(Robot)
    %[N_DoF,~] = size(Robot.qlim);
    Q = Robot.qlim;
    length_sum = 0;

    
    [~,N_DoF] = size(Robot.config);
    Prismatic_Num = 0;
    for i = 1:1:N_DoF
        if Robot.config(i) ~= 'R'
            Prismatic_Num = Prismatic_Num + 1;
        end
    end

    if Prismatic_Num == 0
        for i = 1:1:N_DoF
            length_sum = length_sum + Robot.links(1,i).a + Robot.links(1,i).d ;
        end
    else
        
        for i = 1:1:N_DoF
            length_sum = length_sum + Robot.links(1,i).a + Robot.links(1,i).d ;
        end
        
        for i = 1:1:N_DoF
            if Robot.config(i) ~= 'R'
                P_I = i;
                length_sum =  Q(P_I,2);
            end
        end
    
    end
    Precision = length_sum/20;Error = length_sum/1000;
    
end

