function [N_Dof,Robot] = ExampleRobot(varargin)
    deg = pi/180;
    opt.type = {'dVRK', 'Omni','HamlynCRM','Puma560'};
    opt.axes = {'T', 'all', 'R'};
    opt.visual = {'On', 'Off'};
    opt.dof = [];
    
    opt = tb_optparse(opt, varargin);
    
    if isempty(opt.dof)
        switch opt.axes
            case 'T'
                dof = [1 1 1 0 0 0];
            case 'R'
                dof = [0 0 0 1 1 1];
            case 'all'
                dof = [1 1 1 1 1 1];
        end
    else
        dof = opt.dof;
    end
        
    opt.dof = logical(dof);
    N_Dof = sum(opt.dof);
    
    
    switch opt.type
        case 'dVRK'
            L1 = Revolute('d', 0, 'a', 0, 'alpha',  0, 'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha',  -pi/2, 'modified');    
            L3 = Revolute('d', 0, 'a', Length1, 'alpha', 0, 'modified');  
            L4 = Revolute('d', 15.06, 'a', Length2, 'alpha', pi/2, 'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, 'modified');
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','dVRK');  
            Robot.qlim = degtorad([-40  65; -15  50; -50  35; -200 90; -90  180; -45  45]);
             
        case 'HamlynCRM'
            L1 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L2 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );
            L3 = Link('theta', 0, 'alpha', -pi/2 , 'a', 0 ,'modified'); L3.sigma = 1;
            L4 = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L5 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified' );
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');  
            
            Robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','HamlynCRM');
            Robot.qlim = degtorad([-45  45;45  135; 24/deg  40/deg; -180 180; 20  160; -70  70]);
            
         case 'Omni'
            L(1) = Revolute('d', 0, 'a', 0, 'alpha', 0,'modified');
            L(2) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified' );
            L(3) = Revolute('d', 0, 'a', 12.7508, 'alpha', 0,'modified');
            L(4) = Revolute('d', 0, 'a', 14.9352, 'alpha',pi/2,'modified');
            L(5) = Revolute('d', 0, 'a', 0, 'alpha', -pi/2,'modified');
            L(6) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');

            Robot = SerialLink(L,'name','Omni');
            Robot.qlim = degtorad([-50  50; 0  105; -90  0; -180 180; 20  160; -70  70]);
       
            
         case 'Puma560'
            a2=0.4318; a3=0.0202; d3=0.1244; d4=0.4318;

            L1=Link([th(1), 0, 0 ,0],'modified');
            L2=Link([th(2), 0, 0 ,-pi/2],'modified');
            L3=Link([th(3),d3,a2 ,0],'modified');
            L4=Link([th(4),d4,a3 ,-pi/2],'modified');
            L5=Link([th(5), 0, 0 , pi/2],'modified');
            L6=Link([th(6), 0, 0 ,-pi/2],'modified');
            
            Robot=SerialLink([L1 L2 L3 L4 L5 L6],'name','Puma560');
    end
    
    switch opt.visual
        case 'On'
            AxisMax = 50;            
            Robot.plotopt = {'workspace', [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax]};
            Robot.teach()
        case 'Off'
            AxisMax = 50;            
            Robot.plotopt = {'workspace', [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax]};
    end
    
 
end

