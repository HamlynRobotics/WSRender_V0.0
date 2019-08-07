% Input:
% opt.type
%
% Output:
% N_Dof: number of degrees of freedom
% Robot: the robot model built by the pre-defined DH Table
%
% Function:
% Build a targeted robot for workspace analysis
% Define a robot based on DH table; 
% Define joint limitation
% Basic type: 
% Articulated robot; Spherical robot; Cartesian robot; etc.
% Self-defined robot: 'Define'
%
% Example:
% [N_DoF,Robot] = BuildRobot('Articulated');

function [N_Dof,Robot] = BuildRobot(varargin)
    deg = pi/180;
    opt.type = {'Articulated', 'Spherical','Cylindrical','Catersian','SCARA','dVRK', 'Omni','HamlynCRM','ABB_Yumi','Puma560','Underactuated','MIS','Full_Human_Arm','Define'};
    opt = tb_optparse(opt, varargin);
    
    switch opt.type
        case 'Articulated'
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );
            L3 = Revolute('d', 0, 'a', 0.20, 'alpha', 0,'modified');
            L4 = Revolute('d', 0, 'a', 0.20, 'alpha',pi/2,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified');
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');

            Robot = SerialLink([L1 L2 L3 L4 L5 L6]);
            Robot.qlim = degtorad([45  135; -45  45; -120  0; -180 180; 20  160; -70  70]);
            %Robot.qlim = degtorad([40  140; -50  50; -130  0; -180 180; 20  160; -70  70]);
            Robot.name = 'Articualted';
            %Robot.qlim = degtorad([135  225; -45  45; -120  0; -180 180; 20  160; -70  70]);
            N_Dof = 6;
            
            %{
            L1 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );
            L3 = Revolute('d', 0, 'a', 0.20, 'alpha', -pi/2,'modified');
            L4 = Revolute('d', 0, 'a', 0.20, 'alpha',0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified');
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');

            Robot = SerialLink([L1 L2 L3 L4 L5 L6]);
            Robot.qlim = degtorad([45  135; -45  45; -120  0; -180 180; 20  160; -70  70]);
            %Robot.qlim = degtorad([40  140; -50  50; -130  0; -180 180; 20  160; -70  70]);
            Robot.name = 'Articualted';
            %Robot.qlim = degtorad([135  225; -45  45; -120  0; -180 180; 20  160; -70  70]);
            
            %}

        case 'Spherical'
          
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );L3.sigma = 1;
            L3 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); 
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');  
            
            N_Dof = 6;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6]);
            Robot.qlim = degtorad([-45  45;45  135; 0.20/deg   0.40/deg; -180 180; 20  160; -70  70]);
            %Robot.qlim = degtorad([-50  50;40  140; 0.10/deg   0.40/deg; -180 180; 20  160; -70  70]);
            Robot.name = 'Spherical';
            
           
            
              %{
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );L3.sigma = 1;
            L3 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); 
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');  
            
            Robot = SerialLink([L1 L2 L3 L4 L5 L6]);
            Robot.qlim = degtorad([-45  45;45  135; 0.20/deg   0.40/deg; -180 180; 20  160; -70  70]);
            %Robot.qlim = degtorad([-50  50;40  140; 0.10/deg   0.40/deg; -180 180; 20  160; -70  70]);
            Robot.name = 'Spherical';
             %}
                         
        case 'Cylindrical'
            L1 = Revolute('d', 0.20, 'a', 0, 'alpha', 0,'modified');L2.sigma = 1;
            L2 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); L3.sigma = 1;
            L3 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); 
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');  
            
            N_Dof = 6;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','Cylindrical');
            Robot.qlim = degtorad([-45  45; 0.0/deg   0.40/deg; 0.20/deg   0.40/deg; -180 180; 20  160; -70  70]);
            Robot.name = 'Cylindrical';
            
        case 'Catersian'
            L1.sigma = 1;
            L1 = Link('theta', pi/2, 'alpha', 0, 'a', 0 ,'modified');  L2.sigma = 1;
            L2 = Link('theta', pi/2, 'alpha', pi/2, 'a', 0 ,'modified');L3.sigma = 1;
            L3 = Link('theta', pi/2, 'alpha',pi/2, 'a', 0 ,'modified'); 
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');  
            
            N_Dof = 6;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','Catersian');
            Robot.qlim = degtorad([0.20/deg   0.40/deg; 0.20/deg   0.40/deg; 0.20/deg   0.40/deg; -180 180; 20  160; -70  70]); 
            Robot.name = 'Catersian';
            
        case 'SCARA'
            L1 = Revolute('d', 0, 'a', 0.2, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0.2, 'alpha', 0,'modified'); L3.sigma = 1;
            L3 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); 
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            
            N_Dof = 4;
            Robot = SerialLink([L1 L2 L3 L4],'name','SCARA');
            Robot.qlim = degtorad([-45  45;45  135; 0.20/deg   0.40/deg; -180 180;]);
            Robot.name = 'SCARA';

        case 'Underactuated'
            % Simplified Arm Model
            Length = 0.30;
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0, 'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            L3 = Revolute('d', 0, 'a', Length, 'alpha',0,'modified');
            L4 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');
            
            N_Dof = 5;
            Robot = SerialLink([L1 L2 L3 L4 L5],'name','SimpleArm');
            Robot.qlim = degtorad([-160 -20;-140 140; -140 140; 20 160;-90 90]);
             
         case 'Redandant'
            % Full_Human_Arm
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0, 'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, 'modified' );
            L3 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            L4 = Link('theta', -pi/2, 'alpha', 0, 'a', 0 ,'modified');  L4.sigma = 1;
            L5 = Revolute('d', 0, 'a', 0, 'alpha', 0, 'modified');
            L6 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L7 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            
            N_Dof = 7;
            Robot=SerialLink([L1 L2 L3 L4 L5 L6 L7],'name','Redandant');    
            
         case 'dVRK'
            Length1 = 0.2794; Length2 =  0.3048;
            L1 = Revolute('d', 0, 'a', 0, 'alpha',  0, 'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha',  -pi/2, 'modified');    
            L3 = Revolute('d', 0, 'a', Length1, 'alpha', 0, 'modified');  
            L4 = Revolute('d', 0.1506, 'a', Length2, 'alpha', pi/2, 'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, 'modified');
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            
            N_Dof = 6;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','dVRK');  
            Robot.qlim = degtorad([-40  65; -15  50; -50  35; -200 90; -90  180; -45  45]);
            
        case 'MIS'
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );L3.sigma = 1;
            L3 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); 
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');  
            
            N_Dof = 6;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','MIS');
            Robot.qlim = degtorad([-30  30;60  120; 0   0.10/deg; -180 180; 20  160; -70  70]);
                              

             
        case 'ABB_Yumi'
            L1 = Revolute('d', 0.11, 'a', 0.03, 'alpha', pi/2,'modified');
            L2 = Revolute('d', 0, 'a', 0.03, 'alpha', pi/2, 'modified' );
            L3 = Revolute('d', 0.2465, 'a', 0.0405 ,'alpha', -pi/2 , 'modified'); 
            L4 = Revolute('d', 0, 'a', 0.0405, 'alpha', -pi/2,'modified');
            L5 = Revolute('d', 0.265, 'a', 0.0135, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0.027, 'alpha', -pi/2,'modified');  
            L7 = Revolute('d', 0.032, 'a', 0, 'alpha', 0,'modified');  
            
            N_Dof = 7;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6 L7],'name','ABB_Yumi');
            Robot.qlim = degtorad([-168.5  168.5 ;-143.5  43.5; -123.5  80; -290 290; -88  138; -229  229;-168.5  168.5]);

        case 'HamlynCRM'
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );L3.sigma = 1;
            L3 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); 
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');  
            
            N_Dof = 6;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','HamlynCRM');
            Robot.qlim = degtorad([-45  45;45  135; 0.24/deg  0.40/deg; -180 180; 20  160; -70  70]);
            
         case 'Omni'
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );
            L3 = Revolute('d', 0, 'a', 0.127508, 'alpha', 0,'modified');
            L4 = Revolute('d', 0, 'a', 0.149352, 'alpha',pi/2,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified');
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');

            N_Dof = 6;
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','Omni');
            Robot.qlim = degtorad([-50  50; 0  105; -90  0; -180 180; 20  160; -70  70]);
            
         case 'Puma560'
            a2=0.4318; a3=0.0202; d3=0.1244; d4=0.4318;

            L1=Link([th(1), 0, 0 ,0],'modified');
            L2=Link([th(2), 0, 0 ,-pi/2],'modified');
            L3=Link([th(3),d3,a2 ,0],'modified');
            L4=Link([th(4),d4,a3 ,-pi/2],'modified');
            L5=Link([th(5), 0, 0 , pi/2],'modified');
            L6=Link([th(6), 0, 0 ,-pi/2],'modified');
            
            N_Dof = 6;
            Robot=SerialLink([L1 L2 L3 L4 L5 L6],'name','Puma560');
                        
         case 'Define'
            [N_Dof,Robot] = DefineRobot(1);
            

    end
end