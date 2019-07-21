function [Dex, V_Robot, Global_Indices] = Global_One_Robot(Flag,Robot,RobotType,Parameters,varargin)
    opt.evaluate = {'r','b','g','Off'};
    opt = tb_optparse(opt, varargin);
    % Flag == 0: First time calculation
    % Flag == 1: Load Data
    
    Num = Parameters.Joint_Num;
    Couple_Flag = Parameters.Couple; 
    Indice_Group = Parameters.Indice;
    
    if Flag == 0
        %[Length_Sum,Prismatic_Num,Precision] = Initial_Precision(Robot);  
        %Visual_Robot(Robot{2},Robot{2},Length_Sum,'On');
        [QS,Count]=Generate_Joint(Robot,Couple_Flag,'JointNum',Num,'Path',RobotType);
              
        %% Robot Workspace Analysis
        % Reachable workspace + Lobal Evaluate
        [Dex,path,O_Volume,Volume] = ReachableWS_Indices(Robot,QS,Flag,'Indice',Indice_Group,'On','Path',RobotType);
        % General form for Global Evaluation
    end
    
    if Flag == 1
        % Load QS data
        filename = RobotType; addpath('../'); Folder = pwd;
        path_Joint = fullfile(Folder,'Data',[filename, num2str(Num)]);
        QS = load(path_Joint,'QS');  QS = QS.QS;  [Count,~] = size(QS);
                
        % Load Master Dex Data
        filename = RobotType;  addpath('../'); Folder = pwd;
        path = fullfile(Folder,'Data',[filename, num2str(Count)]);
        Dex = load(path,'Dex');  Dex = Dex.Dex;
    end 
    
    % General form for Global Evaluation
    [Indices,Global_Indices] = GlobalEvaluate(Dex);        

                
    switch opt.evaluate
        case 'r'
            [V_Robot] = Boundary_WS(Dex,0.1,'r');
        case 'b'
            [V_Robot] = Boundary_WS(Dex,0.1,'b');
        case 'g'
            [V_Robot] = Boundary_WS(Dex,0.1,'g');
        case 'Off'
            [V_Robot] = Boundary_WS(Dex,0.1,'off');
    end
    
  

end

