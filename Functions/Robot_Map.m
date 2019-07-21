function [RobotType,Env_Type] = Robot_Map(Num,varargin)
    opt.Type = {'Robot','Environment'};
    opt = tb_optparse(opt, varargin);
    RobotType = 'Articulated';
    Env_Type = 'off';

    switch opt.Type
        case 'Robot'
            Index_Name = {'Articulated','Spherical','Cylindrical','Catersian','SCARA','Underactuated','Redundant','dVRK','Omni','HamlynCRM','MIS'...
            'puma560akb','Puma','stanford','Kuka_KR5', 'irb140','ABB_Yumi','ABB_irb140','Defined'};
            [~,Total_Num] = size(Index_Name);
            Index_Num = ones(1,Total_Num);
            for i = 1:1:Total_Num
                Index_Num(1,i) = i;
            end
  
            Robot_Map = containers.Map(Index_Num,Index_Name);
            RobotType = Robot_Map(Num);
            
        case 'Environment'     
            Index_Name = {'off','Desk_On','Frame_On','Both_On'};        
            Index_Num = [1 2 3 4];
            Environment_Map = containers.Map(Index_Num,Index_Name);
            Env_Type = Environment_Map(Num);
    end

end



