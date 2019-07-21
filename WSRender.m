
% Construct a new robot within the embedded libray for evaluation
Flag = 0;
% Use Parameters in script mode; 

Parameters.Couple = 0; % Accelerate Calculation
Parameters.Joint_Limit = 0;
Parameters.Monte_Carlo = 0;
Parameters.Iteration = 0;
Parameters.Joint_Num  = 15;
Parameters.Precision  = 0.02;
Parameters.Error = 0.0001;
[~,Indice_Group] = ReadFiles('Indices');
Indice_Group = {'Manipulability','Inverse Condition Number','Minimum Singular Value'};
Parameters.Indice = Indice_Group;

RobotType = 'Spherical';
[~,Robot] = BuildRobot(RobotType);
figure(2)
[Dex,  V_Robot, Global_Indices] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'b');
%{
%% Slave Robot

%% Voxel Data Generation
% Change the Robot Data Visualization Form
Vector = [-20,0,0];
BaseRLeft = [-10, 0 ,0];
BaseRight = [10, 0 ,0];
[VDual_Robot,VLeft_Robot,VRight_Robot,Boundary_Robot,Volume_Size_Robot] = ScatterToVolume(Dex,2,BaseRight,BaseRLeft,'BimanualRobot','Visual_On');



[V,Boundary_Single,Volume_Size] = SingleScatterToVolume(Dex_Arm,Precision);
Dex_Arm2=[Dex_Arm(:,1)-20,Dex_Arm(:,2),Dex_Arm(:,3),Dex_Arm(:,4)];
[V2,Boundary_Single2,Volume_Size2] = SingleScatterToVolume(Dex_Arm2,Precision);

%% Interaction Analysis
[MapRobotR,MapRobotL,Boundary,CP] = FindInteract(Dex_Arm,VDual_Arm,Dex,Precision);

%% Intuitive Analysis
[Gripper] = Workspace_Arrow(QS_Arm,Right_RealArm,Left_RealArm);

%% Visualization

Fig = 2;

% Visualize robot volume data
Precision = 2;
[TransferRight,TransferLeft,TransferDual] = Visualize_VolumeData(Boundary_Robot,VLeft_Robot,VRight_Robot,Volume_Size_Robot,Precision,'Scatter');



VisualWS(Dex_Arm,Fig,'Reachable');
[TransferSingle] = Visualize_SingleVolumeData(Boundary_Single,V,Volume_Size,Precision);
[TransferSingle2] = Visualize_SingleVolumeData(Boundary_Single2,V2,Volume_Size2,Precision);

% Visualize Interact Volume Data
[Right_Arm,Left_Arm,Dual_Arm] = Visualize_VolumeData(Boundary_Arm,VLeft_Arm,VRight_Arm,Volume_Size_Arm,Precision,'Seperate');



% Visualize Human Robot Shared Workspace
[InteractionPosition,MapHumanRobot] = Visual_InteractVolumn(MapRobotR,MapRobotL,VDualArm,Boundary,Precision,Fig,'Visual_On');
VisualWS(InteractionPosition,Fig,'Reachable','Bimanual','vector',Bimanual_Vector);
% save('E:/Dan.mat','InteractionPosition');

[VolumeSum,Percentage] = AddVolume(VDual_Arm);
[HumanRobotSum]= AddVolume(MapHumanRobot);
Ratio = HumanRobotSum/VolumeSum;

PlaceTwoRobot(RightArm,LeftArm,N_DoF,'Human','baseright',BaseRightArm,'baseleft',BaseLeftArm);
PlaceTwoRobot(RightRobot,LeftRobot,N_DoF,'Bimanual','baseright',BaseRight,'baseleft',BaseLeft);

% Visual Ergonomic Directions
[Flag] = Visualize_Arrow(Arm,QS_Arm,Fig);
%Slave_Reference()

% Visual Intuitive Workspace
Intuitive_Workspace(Dex_Arm,Gripper);

%}