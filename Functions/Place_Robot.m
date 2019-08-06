% Input:
% RightRobot: the right robotic manipulator for evaluation
% LeftRobot: the left robotic manipulator for evaluation. If single robot,
% then leftrobot and rightrobot are the same
% Size: the total link length of the robot
% Num : number of the bimanual robots
% Option:
%     opt.visual = {'Off','Teach','On','Bimanual'};
%     opt.base = [];    opt.Range = [];
%     opt.range = {'Big', 'Small'};
% 
% Output:
% out : default 1
% 
% Function:
% Place a robot in suitable place. Define base transform relationship to the world frame.
% 
% Example:


function [out] = Place_Robot(RightRobot,LeftRobot,Size,Num,varargin)
    deg = pi/180;
    [N_DoF,~] = size(RightRobot.qlim);
    opt.visual = {'Off','Teach','On','Bimanual'};
    opt.base = [];
    opt.baseleft = [];
    opt.Range = [];
    opt.range = {'Big', 'Small'};
    opt = tb_optparse(opt, varargin);
    
    Robot = RightRobot;
    if isempty(opt.base)
        Base = zeros(1,6);
    else
        Base = opt.base;
    end
    Robot.base=transl(Base(1:3))* trotx(Base(4))* troty(Base(5))* trotz(Base(6));
    
    if isempty(opt.baseleft)
        BaseLeft = zeros(1,6);
    else
        BaseLeft = opt.baseleft;
    end
    LeftRobot.base=transl(BaseLeft(1:3))* trotx(BaseLeft(4))* troty(BaseLeft(5))* trotz(BaseLeft(6));
    
    if isempty(opt.Range)
        switch opt.range
            case 'Big'
                AxisMax =  Size * 1.5 + (Base(1)+Base(2)+Base(3))/3;
                WS_Range = [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax];
            case 'Small'
                AxisMax = Size * 1.2;
                WS_Range = [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax];
        end
    else
        WS_Range = opt.Range;
    end
    
    Robot.plotopt = {'workspace', WS_Range};
    switch opt.visual
        case 'Bimanual'
            RightRobot.plotopt = {'workspace', WS_Range*2};
            RightRobot.name = strcat('RightRobot',num2str(Num));
            LeftRobot.plotopt = {'workspace', WS_Range*2};
            LeftRobot.name = strcat('LeftRobot',num2str(Num));
             
            Q = RightRobot.qlim; 
            [N_DoF,~] = size(Q);

            for i = 1:1:N_DoF
                qs(1,i) = (Q(i,2) + Q(i,1))/2;
            end
            RightRobot.plot(qs,'noname','noshadow','nobase','tile1color',[1 1 1]);
             %plot(RightRobot,qs);
            %RightRobot.plot(qs,'noname','noshadow','nobase','jointdiam',1.6,'jointcolor','r'); % ,'shading','jointdiam',1.6,,'floorlevel',-60,,'noname'
            % RightRobot.plot(qs);
            % RightRobot.plot(qs,'nobase','noshadow','jointcolor','r' ,'tile1color',[1 1 1],'scale',0.6,'nowrist','jointdiam',1,'noname','floorlevel',-60);
            hold on;

            Q = LeftRobot.qlim;
            [~,N_DoF] = size(Q);
            for i = 1:1:N_DoF
                qs(1,i) = (Q(i,2) + Q(i,1))/2;
            end
            hold on;
            LeftRobot.plot(qs,'noname','noshadow','nobase','tile1color',[1 1 1]);
            % LeftRobot.plot(qs,'noname','shading','noshadow','nobase','jointdiam',1.6,'jointcolor','r'); % 'jointdiam',1.6,'floorlevel',-60
            hold on;
            grid off;
        case 'Teach'
            Robot.teach()
            out = 'Teach';
        case 'On'
            Q = Robot.qlim;
            for i = 1:1:N_DoF
                qs(1,i) = (Q(i,2) + Q(i,1))/2;
            end
            
            Robot.plot(qs,'noshadow','jointcolor','r' ,'tile1color',[1 1 1],'nowrist');
            %Robot.plot(qs,'noshadow');
            %hold on;
            out = 'On';
            %'floorlevel',-60    % ,'nobase'    % ,'noname' %,'jointdiam',1
            % 'scale',0.6,'noname'
        case 'Off'
            out = 'No visualization';
    end
    
end
