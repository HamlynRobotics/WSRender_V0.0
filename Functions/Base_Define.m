% Input:
% type : Type of the robot for evaluation
% 
% Output:
% BaseRight: the default base vector of the right robotic manipulator
% BaseLeft: the default base vector of the left robotic manipulator
% 
% Function:
% Generate the default base vector of a specific robot
% 
% Example:
% [BaseRight,BaseLeft] = Base_Define('Articulated');


function [BaseRight,BaseLeft] =Base_Define(type)

    switch type
        case 'Articulated'
            % for articulated robot
            BaseRight = [0.10  0 0.40 0 0 0];
            BaseLeft = [-0.10  0  0.40 0 0 0];
        case 'Spherical'
            BaseRight = [0.10  0.40  0 0 0 -pi/2];
            BaseLeft = [-0.10  0.40  0 0 0 -pi/2];  
        case 'dVRK'
            BaseRight = [0.10  0 0.20 0 pi pi/2];
            BaseLeft = [-0.10  0  0.20 0 0 pi/2];
        case 'Omni'
            BaseRight = [0.10  0 0.20 0 pi pi/2];
            BaseLeft = [-0.10  0  0.20 0 0 pi/2]; 
            
        case 'HamlynCRM'
            BaseRight = [0.10  0 0.30  0 0 -pi/2];
            BaseLeft = [-0.10  0  0.30  0 0 -pi/2];
            
        case 'SimHumanArm'
            BaseRight = [0.10 0.40 0  -pi/7 0 -pi/2];
            BaseLeft = [-0.10 0.40 0  -pi/7 0 -pi/2];
        case 'HumanArm'
            BaseRight = [0    0.40   0    0   pi/2 -pi/2];
            BaseLeft = [-0.40 0.40   0  0   pi/2 -pi/2]; 
        case 'Define'
            BaseRight = [0.10  0 0.40 0 0 -pi/2];
            BaseLeft = [-0.10  0  0.40 0 0 -pi/2];             
        otherwise
            BaseRight = [0.10  0 0.40 0 0 0];
            BaseLeft = [-0.10  0  0.40 0 0 0];   
    end
    
end