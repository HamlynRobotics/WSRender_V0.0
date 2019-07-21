currentFolder = pwd; addpath(genpath(currentFolder));

% 1) Example for loading an existing robot data for evaluation
% 2) Example for robot evaluation within the embedded library
% 3) Example for robot evaluation using user-defined robot
% 4) Example for WSRender Use Case 1 in paper: Single Manipulator Evaluation
% 5) Example for changing other parameters


%% 1) Example for loading an existing robot data for evaluation

% Load an existing robot data for evaluation
Flag = 1;

% Use Default Parameters in script mode;
Parameters.Couple = 1;
Parameters.Joint_Limit = 0;
Parameters.Monte_Carlo = 0;
Parameters.Iteration = 0;
Parameters.Joint_Num  = 15;
Parameters.Precision  = 0.02;
Parameters.Error = 0.0001;

[~,Indice_Group] = ReadFiles('Indices');
Parameters.Indice = Indice_Group;

RobotType = 'SCARA';
[~,Robot] = BuildRobot(RobotType);
figure(1)
[Dex,  V_Robot, Global_Indices] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'g');


%% 2) Example for robot evaluation within the embedded library

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

RobotType = 'Cylindrical';
[~,Robot] = BuildRobot(RobotType);
figure(2)
[Dex,  V_Robot, Global_Indices] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'b');


%% 3) Example for robot evaluation using user-defined robot

% Construct a user-defined new robot for evaluation
Flag = 1;

% Use Parameters in script mode; 
Parameters.Couple = 1;
Parameters.Joint_Limit = 0;
Parameters.Monte_Carlo = 1; % Use Monte Carlo mode for Joing Sampling
Parameters.Iteration = 0;
Parameters.Joint_Num  = 15;
Parameters.Precision  = 0.02;
Parameters.Error = 0.0001;
[~,Indice_Group] = ReadFiles('Indices');
Parameters.Indice = Indice_Group;

RobotType = 'Define';
[~,Robot] = BuildRobot(RobotType);
figure(3)
[Dex,  V_Robot, Global_Indices] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'r');


%% 4) Example for WSRender Use Case 1: Single Manipulator Evaluation
% Load an existing robot data for evaluation
% Focus on Global Kinematic Indices Evaluation
Flag = 0;

% Use Default Parameters in script mode;
Parameters.Couple = 0;
Parameters.Joint_Limit = 0;
Parameters.Monte_Carlo = 0;
Parameters.Iteration = 0;
Parameters.Joint_Num  = 60; % More Joint Sampling Number, more accurate calculation
Parameters.Precision  = 0.02;
Parameters.Error = 0.0001;

[~,Indice_Group] = ReadFiles('Indices');
Parameters.Indice = Indice_Group;

RobotType = 'dVRK';
[~,Robot] = BuildRobot(RobotType);
figure(1)
[dVRK_Dex, dVRK_V,dVRK_Global] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'b');

RobotType = 'Omni';
[~,Robot] = BuildRobot(RobotType);
figure(2)
[Omni_Dex, Omni_V,Omni_Global] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'r');

% dVRK: 0.5583    0.4660    0.4758    0.8680    0.5238    0.8596
% Omni: 0.5534    0.5240    0.5250    0.8550    0.2733    0.8604

%% 5) Example for WSRender Use Case 1: Single Manipulator Evaluation (other parameters)
% Load an existing robot data for evaluation
% Focus on Global Dynamic Indices Evaluation
Flag = 0;

% Use Default Parameters in script mode;

 
Parameters.Couple = 0;
Parameters.Joint_Limit = 0;
Parameters.Monte_Carlo = 0;
Parameters.Iteration = 0;
Parameters.Joint_Num  = 40; % More Joint Sampling Number, more accurate calculation
Parameters.Precision  = 0.02;
Parameters.Error = 0.0001;

% [0.0614408855420398,0.0406080511977673,0.0466885874027945,0.626879346452926,0.645343595910493,0.667953659990584]
[~,Indice_Group] = ReadFiles('Indices');
Parameters.Indice = Indice_Group;

mdl_puma560akb
Robot = p560m;
RobotType = 'puma560akb';
    
figure(1)
[puma560_Dex, puma560_V,puma560_Global] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'r');

mdl_stanford
Robot = stanf;
RobotType = 'stanford';

figure(2)
[stanford_Dex, stanford_V,stanford_Global] = Global_One_Robot(Flag,Robot,RobotType,Parameters,'b');

% puma560: [0.0527878825329903,0.0289504172077885,0.0361803927683084,0.604602820468743,0.634255176322526,0.655213778423893]
% stanford: [0.0614400708784671,0.0697103885766886,0.0719156799750894,0.618690731171898,0.591835489504051,0.722303248557853]