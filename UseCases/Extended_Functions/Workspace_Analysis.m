function [Global_Indices,Dex,O_Volume] = Workspace_Analysis(Robot,Joint_Num,Type)
%% Robot Workspace Analysis
Couple_Flag = 0; Dynamic_Flag = 0;
Flag = [Couple_Flag,Dynamic_Flag];
Flag = [0 0];
[QS,Count]=Generate_Joint(Robot,Flag,'JointNum',Joint_Num,'Path',Type);

% Reachable workspace + Lobal Evaluate

%Dex = ReachableWS(Robot,Count,QS,Flag,'On','UnSave');

A = strcmp(Type,'HumanArm_Sim');
if A
    out='None'
    Indice_Group={};
else
    Indice_Group={'Manipulability','Inverse Condition Number','Minimum Singular Value'};
end

[Dex,path,O_Volume] = ReachableWS_New(Robot,QS,Flag,'Indice',Indice_Group,'On','Path',Type);

if A
    Dex(:,4) = 1;
end


Dynamic_Flag = 0;
% General form for Global Evaluation
[Indices,Global_Indices] = GlobalEvaluate(Dex,Count,Dynamic_Flag,'Indice',Indice_Group);


end

