currentFolder = pwd;
addpath(genpath(currentFolder));

% 1) Load Existing local indices distribution map and visualze
% 2) Example for WSRender Use Case 2 in paper: Articulated Bimanual
% Manipulator distribution map visualization
% 3) Example for WSRender Use Case 2 in paper: Spherical Bimanual
% Manipulator distribution map visualization
% 4) Load Self-defined robot local indices distribution map and visualize
% 5) Change visualization modes and parameters

%% 1) Load Existing Local indices distribution map and visualze

% for bimanual articualated robot
FileName = 'E:\12-WSRender\Data\Articulated216000.mat';
File=load(FileName);
Dex = File.Dex;
Dex_Left = Dex;
Dex_Left(:,2) = Dex_Left(:,2) + 0.2;

figure(1)
colormap(viridis);
caxis([0 1]); set(gcf,'color','w'); 
grid off;hold on; axis off;hold on;
scatter3(Dex(:,1),Dex(:,2),Dex(:,3),5,Dex(:,4));
hold on; 
scatter3(Dex_Left(:,1),Dex_Left(:,2),Dex_Left(:,3),5,Dex_Left(:,4));  
hold on;
colorbar; 

% for bimanual spherical robot
FileName = 'E:\12-WSRender\Data\Spherical216000.mat';
File=load(FileName);
Dex = File.Dex;
Dex_Left = Dex;
Dex_Left(:,2) = Dex_Left(:,2) + 0.2;

figure(2)
colormap(viridis);
caxis([0 1]); set(gcf,'color','w'); 
grid off;hold on; axis off;hold on;
scatter3(Dex(:,1),Dex(:,2),Dex(:,3),5,Dex(:,4));
hold on; 
scatter3(Dex_Left(:,1),Dex_Left(:,2),Dex_Left(:,3),5,Dex_Left(:,4));  
hold on;
colorbar; 
     

%% 
% 2) Example for WSRender Use Case 2 in paper: Articulated Bimanual
% Manipulator distribution map visualization

% Load an existing robot data for evaluation
Flag = 1;

if Flag == 1
     Type = 'Articulated';
    [RightRobot1,LeftRobot1,~] = Multi_Bimanual_Construction(Type,1);
    [Dex_A,  V_Robot, Global_Indices_Group{1}] = Global_One_Robot(Flag,RightRobot1,Type,Parameters,'g');
end

% Build a new robot
if Flag == 0
    % Use Default Parameters in script mode;
    Parameters.Couple = 0;
    Parameters.Joint_Limit = 0;
    Parameters.Monte_Carlo = 0;
    Parameters.Iteration = 0;
    Parameters.Joint_Num  = 15;
    Parameters.Precision  = 0.02;
    Parameters.Error = 0.0001;

    [~,Indice_Group] = ReadFiles('Indices');
    Indice_Group = {'Manipulability','Inverse Condition Number','Minimum Singular Value'};
    Parameters.Indice = Indice_Group;

    %
    RobotType = 'Articulated';
    Number = 1;
    [RightRobot,LeftRobot,Robot_Placement] = Multi_Bimanual_Construction(RobotType,Number);

    figure
    [Dex_A,  V_Robot, Global_Indices] = Global_One_Robot(Flag,RightRobot,RobotType,Parameters,'g');
    
    
end
figure
Bimanual_Vector{1} = Robot_Placement{2}-Robot_Placement{1};
[out] = VisualWS(Dex_A,'Reachable','Bimanual','vector',Bimanual_Vector{1});

%% 3) Example for WSRender Use Case 2 in paper: Spherical Bimanual
% Manipulator distribution map visualization

% Load an existing robot data for evaluation
Flag = 1;

if Flag == 1
     Type = 'Spherical';
    [RightRobot2,LeftRobot2,Robot_Placement] = Multi_Bimanual_Construction(Type,2);
    [Dex_B,  V_Robot, Global_Indices_Group{2}] = Global_One_Robot(Flag,RightRobot2,Type,Parameters,'g');
end


% Build a new robot
if Flag == 0
    % Use Default Parameters in script mode;
    Parameters.Couple = 0;
    Parameters.Joint_Limit = 0;
    Parameters.Monte_Carlo = 0;
    Parameters.Iteration = 0;
    Parameters.Joint_Num  = 15;
    Parameters.Precision  = 0.01;
    Parameters.Error = 0.0001;

    [~,Indice_Group] = ReadFiles('Indices');
    Indice_Group = {'Manipulability','Inverse Condition Number','Minimum Singular Value'};
    Parameters.Indice = Indice_Group;

    RobotType = 'Spherical';
    [RightRobot,LeftRobot,Robot_Placement] = Multi_Bimanual_Construction(RobotType,Number);
    figure
    [Dex_B,  V_Robot, Global_Indices] = Global_One_Robot(Flag,RightRobot,RobotType,Parameters,'g');
end

figure
Bimanual_Vector{2} = Robot_Placement{4}-Robot_Placement{3};
[out] = VisualWS(Dex_B,'Local_Indices','Bimanual','vector',Bimanual_Vector{2});



%% 4) Load Self-defined robot local indices distribution map and visualize
addpath('../');Folder = pwd;
File_Name = 'ws_data.txt';
path = fullfile(Folder,'Data',File_Name);

Define_Dex = dlmread(path); 
rotate3d on;
Index =  4;
if Index == 1
    plot3(Define_Dex(:,1)*100,Define_Dex(:,2)*100,Define_Dex(:,3)*100,'b');
else
    Define_Dex(:,1:3) =  Define_Dex(:,1:3)*100;

    VisualWS(Define_Dex,Index,'Local_Indices');
end
%% 5) Change visualization modes and parameters

[VDual_Robot,VLeft_Robot,VRight_Robot,Boundary_Robot,Volume_Size_Robot] = ScatterToVolume(Dex_B,Parameters.Precision, Robot_Placement{1}, Robot_Placement{2},'BimanualRobot','Visual_On');
Volume_Info.V = VDual_Robot;
Volume_Info.VDual_Robot = VDual_Robot;Volume_Info.VLeft_Robot=VLeft_Robot; Volume_Info.VRight_Robot=VRight_Robot;
Volume_Info.Boundary_Robot=Boundary_Robot; 
Volume_Info.Volume_Size_Robot=Volume_Size_Robot;

Volume_Info.Precision = Precision; 

Slice_Flag = [1,0,0,0.1,0.3]; Bimanual = 1; Evaluation_Index = 'Inverse Condition Number';
Index_Num = 5;  Slice =  [0,0,0,0.1,0.3];
Flag_Info = {Slice_Flag,Bimanual,Evaluation_Index,Slice,Index_Num,Bimanual_Vector{2}};
rotate3d on; 


pop= 2; % Volume mode
grid off;
[String_Out] = WS_Visualization(pop,Dex_B,Volume_Info,Flag_Info);

pop= 3; % 'Convhulln'
figure
[String_Out] = WS_Visualization(pop,Dex_B,Volume_Info,Flag_Info);

pop= 5; % 'Slice'
figure
[String_Out] = WS_Visualization(pop,Dex_B,Volume_Info,Flag_Info);

pop= 6; % 'Boundary',0.1
figure
[String_Out] = WS_Visualization(pop,Dex_B,Volume_Info,Flag_Info);


