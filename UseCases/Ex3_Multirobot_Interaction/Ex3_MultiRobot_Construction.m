currentFolder = pwd;
addpath(genpath(currentFolder));


%%  Analysis Type: Multi robot
% Load an existing robot data for evaluation
Flag = 1;

Parameters.Couple = 0;
Parameters.Joint_Limit = 0;
Parameters.Monte_Carlo = 0;
Parameters.Iteration = 0;
Parameters.Joint_Num  = 60;
Parameters.Precision  = 0.02;
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

%Dex_Group{1}(:,1:3) = Dex_Group{1}(:,1:3) + Robot_Placement{1}(1:3);
%Dex_Group{2}(:,1:3) = Dex_Group{1}(:,1:3) + Robot_Placement{2}(1:3);

Bimanual_Vector{2} = Robot_Placement{4}-Robot_Placement{3};
Dex_Group{4} = Dex_Group{3}; 
Dex_Group{4}(:,1:3) = Dex_Group{3}(:,1:3) + Bimanual_Vector{2}(1:3);

%Dex_Group{3}(:,1:3) = Dex_Group{3}(:,1:3) + Robot_Placement{3}(1:3);
%Dex_Group{4}(:,1:3) = Dex_Group{4}(:,1:3) + Robot_Placement{4}(1:3);

