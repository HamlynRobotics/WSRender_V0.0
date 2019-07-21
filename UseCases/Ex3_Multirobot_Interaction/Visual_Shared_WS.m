% Visualize Shared Workspace

Precision = 0.01;
[Boundary,Volume_Size] = Define_Volume(Dex_Group,Precision);
[V_All,V_Group] = Scatter_Volume_Convert(Dex_Group,Precision,Boundary,Volume_Size);

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
Dex_B{1} = Dex_Group{3}; Dex_B{2} = Dex_Group{4};
[Volume_All_B,Volume_Interact_B] = Find_Interact_Bimanual(Dex_B,Boundary,Volume_Size,Precision,'Off');


% Bimanual A + B
figure
Transfer_Group{1} = TransferAll;Transfer_Group{2} = TransferAll_B;

Volume_All_A = Boundary_WS(TransferAll,0.3,'b');[Volume_All,Volume_Interact] = Find_Interact_Bimanual(Transfer_Group,Boundary,Volume_Size,Precision,'Seperate');


hold on;
Volume_All_B = Boundary_WS(TransferAll_B,0.3,'g');

%% Joint == 50
% Volume all = 0.1085; V_Share = 0.0163
% Articulated_V = 0.0600; A_Shared_V = 0.0137; 
% Spherical_V = 0.0623; S_Shared_V = 0.0197; 

%% Joint = 55
% Volume all = 0.1069; V_Share = 0.0166
% Articulated_V = 0.0569; A_Shared_V = 0.0138; 
% Spherical_V = 0.0640; S_Shared_V = 0.0201; 

%% Joint = 60
% Volume all = 0.1096; V_Share = 0.0167
% Articulated_V = 0.0606; A_Shared_V = 0.0139; 
% Spherical_V = 0.0646; S_Shared_V = 0.0204; 