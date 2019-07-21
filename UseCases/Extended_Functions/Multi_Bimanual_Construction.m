function [RightRobot,LeftRobot,Robot_Placement] = Multi_Bimanual_Construction(Type,Number)
%% Analysis Type: Dual-Arm robot
if Number == 1
    %% Environment
    [out] = Draw_Invironment('off');
end


%% Config
[file_dir,Configs] = ReadFiles('Placement');
[~,n] = size(Configs);
Robot_Num = Configs{n};

for j = 1:1:Robot_Num
    T = Configs{j};
    Euler = rotm2eul( T(1:3,1:3),'XYZ');
    %  rotm = eul2rotm(eul)
    Robot_Placement{j} = [T(1,4),T(2,4), T(3,4),Euler(1),Euler(2),Euler(3)];
end


%% Dual-Arm Robot
[~,RightRobot] = BuildRobot(Type);
[~,LeftRobot] = BuildRobot(Type);

[RightRobot,LeftRobot] = PlaceTwoRobot(RightRobot,LeftRobot,Number,'Off','baseright',Robot_Placement{Number*2-1},'baseleft',Robot_Placement{Number*2});

end



