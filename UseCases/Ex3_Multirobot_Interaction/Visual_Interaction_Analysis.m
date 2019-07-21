% Load an existing robot data for evaluation
Flag = 1;

% New Robot
Flag = 0;
Parameters.Couple = 0;
Parameters.Joint_Limit = 0;
Parameters.Monte_Carlo = 0;
Parameters.Iteration = 0;
Parameters.Joint_Num  = 60;
Parameters.Precision  = 0.01;
Parameters.Error = 0.0001;
%[~,Indice_Group] = ReadFiles('Indices');
Indice_Group = {'Manipulability','Inverse Condition Number','Minimum Singular Value'};
Parameters.Indice = Indice_Group;

%% Initial Parameters
[Length_Sum,Prismatic_Num,Precision] = Initial_Precision(RightRobot1);

QS = {};

% Load data
if Flag == 1
    Type = 'Articulated';
    [RightRobot1,LeftRobot1,~] = Multi_Bimanual_Construction(Type,1);
    [Dex_Group{1},  V_Robot, Global_Indices_Group{1}] = Global_One_Robot(Flag,RightRobot1,Type,Parameters,'g');
    
    Type = 'Spherical';
    [RightRobot2,LeftRobot2,Robot_Placement] = Multi_Bimanual_Construction(Type,2);
    [Dex_Group{2},  V_Robot, Global_Indices_Group{2}] = Global_One_Robot(Flag,RightRobot2,Type,Parameters,'g');
end

if Flag == 0
        Type = 'Articulated';
    [RightRobot1,LeftRobot1,~] = Multi_Bimanual_Construction(Type,1);
    [Global_Indices_Group{1},Dex_Group{1}] = Workspace_Analysis(RightRobot1,Parameters,Type);
    Global_Indices_Group{2} = Global_Indices_Group{1}; 

        
    Type = 'Spherical';
    [RightRobot2,LeftRobot2,Robot_Placement] = Multi_Bimanual_Construction(Type,2);
    [Global_Indices_Group{3},Dex_Group{3}] = Workspace_Analysis(RightRobot2,Parameters,Type);
    Global_Indices_Group{4} = Global_Indices_Group{3};
end

Bimanual_Vector{1} = Robot_Placement{2}-Robot_Placement{1};
Dex_Group{2} = Dex_Group{1}; 
Dex_Group{2}(:,1:3) = Dex_Group{1}(:,1:3) + Bimanual_Vector{1}(1:3);

Bimanual_Vector{2} = Robot_Placement{4}-Robot_Placement{3};
Dex_Group{4} = Dex_Group{3}; 
Dex_Group{4}(:,1:3) = Dex_Group{3}(:,1:3) + Bimanual_Vector{2}(1:3);


% Visualize Interaction Workspace Quality
% [~,Index_Name] = ReadFiles('Indices');
% [Num_Array] = Local_Indice_Map(Index_Name);


Precision = 0.01;
Dex_Group_Temp = Dex_Group;
Dex_Group_Temp{3}(:,4) = 1; Dex_Group_Temp{4}(:,4) = 1;

[Boundary,Volume_Size] = Define_Volume(Dex_Group_Temp,Precision);
[V_All,V_Group] = Scatter_Volume_Convert(Dex_Group_Temp,Precision,Boundary,Volume_Size);

%% Visual All Robots
V_Bimanual{1} = V_Group{1}; V_Bimanual{2} = V_Group{2};
V_Bimanual_B{1} = V_Group{3}; V_Bimanual_B{2} = V_Group{4};
Index = 4;

%% Interaction
% Bimanual A
 figure
[Transfer_Robot,TransferAll] = Visualize_VolumeData_All(Boundary,V_Bimanual,Volume_Size,Precision,Index,'Scatter');
 axis off;
Dex_A = {};
Dex_A{1} = Dex_Group{1}; Dex_A{2} = Dex_Group{2};
[Volume_All_A,Volume_Interact_A] = Find_Interact_Bimanual(Dex_A,Boundary,Volume_Size,Precision,'Off');


% Bimanual B
[Transfer_Robot_B,TransferAll_B] = Visualize_VolumeData_All(Boundary,V_Bimanual_B,Volume_Size,Precision,Index,'Scatter');
 axis off;
Dex_B = {};
Dex_B{1} = Dex_Group_Temp{3}; 
Dex_B{2} = Dex_Group_Temp{4}; 
[Volume_All_B,Volume_Interact_B] = Find_Interact_Bimanual(Dex_B,Boundary,Volume_Size,Precision,'Off');

% Bimanual A + B
figure
Transfer_Group{1} = TransferAll;Transfer_Group{2} = TransferAll_B;
[Volume_All,Volume_Interact,Transfer_New] = Final_Interact(Transfer_Group,Boundary,Volume_Size,Precision,'Local_Indices','Scatter');
hold on;




