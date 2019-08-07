

function [Robot,RobotType] = Robot_Library(pop)
        switch pop 
            case 12
                mdl_puma560akb
                Robot = p560m;
                RobotType = 'puma560akb';
            case 13
                mdl_puma560
                Robot = p560;
                RobotType = 'Puma';
            case 14
                mdl_KR5
                Robot = KR5; 
                RobotType = 'Kuka_KR5';
            case 15
                mdl_irb140
                Robot = irb140;
                RobotType = 'ABB_irb140';
            case 16
                mdl_stanford
                Robot = stanf;
                RobotType = 'stanford';  
        end
end

