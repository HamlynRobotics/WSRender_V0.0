function [N_Dof,Robot] = DefineRobot(Index)
    switch Index
        case 1
            l1 = 0; l2 = 65; l3 = 65; l4 = 25.5; l5 = 35;
             L1 = Link('theta', (pi)/2, 'a', 0, 'alpha', -(pi)/2);
             L2 = Link('theta', 0, 'a', 0, 'alpha', (pi)/2); 
             L3 = Revolute('d', 0, 'a', l4, 'alpha', -(pi)/2);
             L4 = Link('theta', 0, 'a', 0, 'alpha', 0); 

             Robot=SerialLink([L1 L2 L3 L4],'name','New_Microrobot');
             Robot.qlim = ([0 40; l3 l3+40; -(pi)/4+(pi)/2 (pi)/4+(pi)/2; l5 l5+40]);

             N_Dof = 4;

        case 2

            deg = pi/180;

            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0, ...
                'I', [0, 0.35, 0, 0, 0, 0], 'r', [0, 0, 0], ...
                'm', 0,    'Jm', 200e-6, 'G', -62.6111, ...
                'B', 1.48e-3, 'Tc', [0.395 -0.435],'modified');

            L2 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, ...
                'I', [0.13, 0.524, 0.539, 0, 0, 0], 'r', [-0.3638, 0.006, 0.2275], ...
                'm', 17.4, 'Jm', 200e-6, 'G', 107.815, ...
                'B', .817e-3,  'Tc', [0.126 -0.071],'modified' );

            L3 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,  ...
                'I', [0.066, 0.086, 0.0125, 0, 0, 0], 'r', [-0.0203, -0.0141, 0.070], ...
                'm', 4.8,'Jm', 200e-6, 'G', -53.7063, ...
                'B', 1.38e-3, 'Tc', [0.132, -0.105], 'modified');

            L4 = Link('theta', -pi/2, 'alpha', 0, 'a', 0 ,'modified');
            L4.sigma = 1;

            L5 = Revolute('d', 0, 'a', 0, 'alpha', 0, ...
                'I', [0, 0.35, 0, 0, 0, 0], 'r', [0, 0, 0], ...
                'm', 0, 'Jm', 200e-6, 'G', -62.6111, ...
                'B', 1.48e-3, 'Tc', [0.395 -0.435],'modified');

            L6 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, ...
                'I', [0.13, 0.524, 0.539, 0, 0, 0], 'r', [-0.3638, 0.006, 0.2275],...
                'm', 17.4, 'Jm', 200e-6, 'G', 107.815,...
                'B', .817e-3,'Tc', [0.126 -0.071],'modified' );

            L7 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,  ...
                'I', [0.066, 0.086, 0.0125, 0, 0, 0], 'r', [-0.0203, -0.0141, 0.070], ...
                'm', 4.8, 'Jm', 200e-6,'G', -53.7063, ...
                'B', 1.38e-3, 'Tc', [0.132, -0.105],'modified');


            Robot = SerialLink([L1 L2 L3 L4 L5 L6 L7],'name','MyRobot');

            Robot.qlim = degtorad([-70  70; 20  160; -180 180; 15/deg  20/deg;  -180 180
                                      20  160
                                     -70  70]);

             N_Dof = 7;
     
    end
    
end

