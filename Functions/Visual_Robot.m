function [deg] = Visual_Robot(RightRobot,LeftRobot,Size,varargin)
    deg = pi/180;
    opt.visual = {'Teach','On', 'Bimanual','Off','Human','HumanReal'};

    opt.Range = [];
    opt.range = {'Big', 'Small'};
    opt = tb_optparse(opt, varargin);
    Robot = RightRobot;
    
    if isempty(opt.Range)
        switch opt.range
            case 'Big'
                AxisMax = Size * 2 ;
                %AxisMax = 2;
                WS_Range = [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax];
            case 'Small'
                AxisMax = Size * 1.2;
                WS_Range = [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax];
        end
    else
        WS_Range = opt.Range;
    end
        
    switch opt.visual
        case 'HumanReal'
            RightRobot.plotopt = {'workspace', WS_Range};
            RightRobot.name = 'RightRobot';
            RightRobot.base = transl(BaseRight(1:3))* trotx(BaseRight(4))* troty(BaseRight(5))* trotz(BaseRight(6));
            
            LeftRobot.plotopt = {'workspace', WS_Range};
            LeftRobot.name = 'LeftRobot';
            LeftRobot.base = transl(BaseLeft(1:3))* trotx(BaseLeft(4))* troty(BaseLeft(5))* trotz(BaseLeft(6));   
            
        case 'Human'
            RightRobot.plotopt = {'workspace', WS_Range};
            RightRobot.name = 'RightRobot';
            RightRobot.base = transl(BaseRight(1:3))* trotx(BaseRight(4))* troty(BaseRight(5))* trotz(BaseRight(6));
            
            LeftRobot.plotopt = {'workspace', WS_Range};
            LeftRobot.name = 'LeftRobot';
            LeftRobot.base = transl(BaseLeft(1:3))* trotx(BaseLeft(4))* troty(BaseLeft(5))* trotz(BaseLeft(6));   

            qsL = [0*deg 0*deg 0 pi/2 0]; 
            LeftRobot.name = 'LeftArm';
            LeftRobot.plot(qsL,'shading','noshadow','nobase','jointcolor','g','tile1color',[1 1 1] ); % 'jointdiam',0.1,
            hold on

            qsR = [0*deg 0*deg 0 pi/2 0];
            RightRobot.name = 'RightArm';
            RightRobot.plot(qsR,'shading','noshadow','nobase','jointcolor','g','tile1color',[1 1 1] );
            hold on


        case 'Teach'
            Robot.plotopt = {'workspace', WS_Range};
            Robot.teach()   
            
            
                        
        case 'On'
            RightRobot.plotopt = {'workspace', WS_Range};
            %RightRobot.name = 'RightRobot';

            
                   
            LeftRobot.plotopt = {'workspace', WS_Range};
            %LeftRobot.name = 'LeftRobot';
 
            
            Q = RightRobot.qlim; 
            [N_DoF,~] = size(Q);

            for i = 1:1:N_DoF
                qs(1,i) = (Q(i,2) + Q(i,1))/2;
            end
            
            % RightRobot.plot(qs,'noname','shading','noshadow','nobase','jointdiam',1.6,'jointcolor','r'); % 'jointdiam',1.6,,'floorlevel',-60
            RightRobot.plot(qs);
            % RightRobot.plot(qs,'nobase','noshadow','jointcolor','r' ,'tile1color',[1 1 1],'scale',0.6,'nowrist','jointdiam',1,'noname','floorlevel',-60);
            hold on;

            
            
        case 'Bimanual'
            RightRobot.plotopt = {'workspace', WS_Range};
            %RightRobot.name = 'RightRobot';

            RightRobot.base
            LeftRobot.plotopt = {'workspace', WS_Range};
            %LeftRobot.name = 'LeftRobot';
 
            
            Q = RightRobot.qlim; 
            [N_DoF,~] = size(Q);

            for i = 1:1:N_DoF
                qs(1,i) = (Q(i,2) + Q(i,1))/2;
            end
            
            % RightRobot.plot(qs,'noname','shading','noshadow','nobase','jointdiam',1.6,'jointcolor','r'); % 'jointdiam',1.6,,'floorlevel',-60
            RightRobot.plot(qs);
            % RightRobot.plot(qs,'nobase','noshadow','jointcolor','r' ,'tile1color',[1 1 1],'scale',0.6,'nowrist','jointdiam',1,'noname','floorlevel',-60);
            hold on;

            
            Q = LeftRobot.qlim;
            [~,N_DoF] = size(Q);
            for i = 1:1:N_DoF
                qs(1,i) = (Q(i,2) + Q(i,1))/2;
            end
            hold on;
            LeftRobot.plot(qs);
            % LeftRobot.plot(qs,'noname','shading','noshadow','nobase','jointdiam',1.6,'jointcolor','r'); % 'jointdiam',1.6,'floorlevel',-60
            hold on;

        case 'Off'
            out = 'No visualization'
    end
    
end
