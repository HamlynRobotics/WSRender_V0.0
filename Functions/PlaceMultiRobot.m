function [out] = PlaceMultiRobot(Robot_Group,Base_Group,varargin)
    Num = size(Robot_Group);
    deg = pi/180;
    opt.visual = {'On','Off'};
    opt = tb_optparse(opt, varargin);
    AxisMax = 10;
    WS_Range = [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax]; 
    for k = 1:1:Num
        Robot.plotopt = {'workspace', WS_Range};  
        Robot = Robot_Group{k};
        [N_DoF,~] = size(Robot.qlim);
        Base = Base_Group{k};
        Robot.base=transl(Base(1:3))* trotx(Base(4))* troty(Base(5))* trotz(Base(6));
        Q = Robot.qlim;
        for i = 1:1:N_DoF
            qs(1,i) = (Q(i,2) + Q(i,1))/2;
        end

        Robot.plot(qs,'noshadow','jointcolor','r' ,'tile1color',[1 1 1],'scale',0.6,'nowrist');
        hold on;
                
    end
    switch opt.visual
        case 'On'


            out = 'On';
            %'floorlevel',-60    % ,'nobase'    % ,'noname' %,'jointdiam',1   
        case 'Off'
            out = 'No visualization';
    end
    
end

