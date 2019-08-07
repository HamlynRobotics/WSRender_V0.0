function [DoF,Arm] = HumanArm(varargin)
    deg = pi/180;
    opt.type = {'WholeArm', 'SimpleArm'};
    opt.axes = {'all','T', 'R'};
    opt.dof = [];
    
    opt = tb_optparse(opt, varargin);
    
    if isempty(opt.dof)
        switch opt.axes
            case 'all'
                dof = [1 1 1 1 1 1];
            case 'T'
                dof = [1 1 1 0 0 0];
            case 'R'
                dof = [0 0 0 1 1 1];

        end
    else
        dof = opt.dof;
    end
        
    opt.dof = logical(dof);
    N_Dof = sum(opt.dof);
    
    switch opt.type
        case 'WholeArm'
            L1.sigma = 1;
            L1 = Link('theta', 0, 'alpha', 0, 'a', 0 ,'modified'); 
            L2 = Revolute('d', 0, 'a', 0, 'alpha', -pi/2, 'modified');
            L3 = Revolute('d', 0, 'a', 0, 'alpha', pi/2,  'modified' );L4.sigma = 1;
            L4 = Link('theta', 0, 'alpha', pi/2, 'a', 0 ,'modified'); 
            L5 = Revolute('d', 0, 'a', 0, 'alpha',0,  'modified');
            L6 = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            L7= Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');
            DoF = 7;
            Arm = SerialLink([L1 L2 L3 L4 L5 L6 L7],'name','WholeArm');  
            Arm.qlim = degtorad([0/deg 0.20/deg; -70  70; 10  170; 0.10/deg 0.30/deg; -140   140; 20  160; -90  90]);
    
        case 'SimpleArm'
            ArmLength = 0.30;
            L(1) = Revolute('d', 0, 'a', 0, 'alpha', 0, 'modified');
            L(2) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            L(3) = Revolute('d', 0, 'a', ArmLength, 'alpha',0,'modified');
            L(4) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'modified');
            L(5) = Revolute('d', 0, 'a', 0, 'alpha', pi/2,'modified');
            DoF = 5;
            Arm = SerialLink(L,'name','SimpleArm');
            Arm.qlim = degtorad([-160 -20;-140 140; -140 140; 20 160;-90 90]);
    end
    
    
 
end
