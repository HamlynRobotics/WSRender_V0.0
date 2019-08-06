% Input:
% RightRobot: the robot for evaluation
% Size: the total link length of the robot
% Option:
%     opt.visual = {'Off','Teach','On'};
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


function [out] = PlaceRobot(RightRobot,Size,varargin)
    deg = pi/180;
    [N_DoF,~] = size(RightRobot.qlim);
    opt.visual = {'Off','Teach','On'};
    opt.base = [];
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

