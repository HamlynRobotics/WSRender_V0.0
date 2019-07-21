function [Dex,path,O_Volume,Volume] = ReachableWS_Indices(Robot,QS,Joint_Flag ,varargin)
    [Count,~] = size(QS);  Mid_Point = zeros(Count,3);
    % Transfer Indice Name to Array Number
    % Joint penalty
    R = zeros(Count,1); 

    opt.save = {'Save','UnSave'};
    opt.evaluate = {'On','Off'};
    %opt.volume = {'Common','Operating'};
    opt.Indice = {}; opt.Path = [];  opt = tb_optparse(opt, varargin);
    
    if isempty(opt.Path)
        filename = 'LocalIndice_Map';   path = '.\\Data\\LocalIndice_Map';           
    else
        filename = opt.Path; addpath('../'); Folder = pwd;
        path = fullfile(Folder,'Data',[filename, num2str(Count)]);
    end
    
    if isempty(opt.Indice)
        Num_Array = linspace(4,6,3); Cal_Index = 3;
    else
        Indice_Group = opt.Indice ;
        [Num_Array] = Local_Indice_Map(Indice_Group);
        [~,Cal_Index] = size(Num_Array);
        Dex = zeros(Count,Cal_Index);   
    end
    m = 0; M = 0;
    
    % Joint Limitation Information
    Q = Robot.qlim; [N_DoF,~] = size(Q); QUpL = Q(:,2); QDownL = Q(:,1);
    qUp = libpointer('doublePtr',QUpL); qDown = libpointer('doublePtr',QDownL);
    
    switch opt.evaluate
        case 'Off'
            for i = 1:1:Count
                TQS= Robot.fkine(QS(i,:)); TQS = TQS.T; Dex(i,1) = TQS(1,4); Dex(i,2) = TQS(2,4); Dex(i,3) = TQS(3,4);
                
            end
        case 'On'
            for i = 1:1:Count
                [TQS,T] = Robot.fkine(QS(i,:)); All_T = T(3).T;  
                Mid_Point(i,1) = All_T(1,4);  Mid_Point(i,2) = All_T(2,4);  Mid_Point(i,3) = All_T(3,4);  
                qPtr=libpointer('doublePtr',QS(i,:));          
                if Joint_Flag  == 1
                    % R(i,1) = OmniJoint_Limitation(qPtr,qUp,qDown,Nq);
                    R(i,1) = Joint_Limitation(qPtr,qUp,qDown,N_DoF);
                else
                    R(i,1) = 1;
                end
                TQS = TQS.T; Dex(i,1) = TQS(1,4); Dex(i,2) = TQS(2,4); Dex(i,3) = TQS(3,4);
                
                Y = jacob0(Robot,QS(i,:)); 
                for K = 1:1:Cal_Index
                    Evaluation = Indice_Group{K};
                    if strfind(Evaluation, 'Dynamic') == 1
                         M = Robot.inertia(QS(i,:));
                       [m] = Dynamic_M(Robot, QS(i,:));
                    end
                       Dex(i,Num_Array(K)) = Local_Evaluation(Indice_Group{K},N_DoF,Y,m,M,R(i,1));
                end
            end
    end

    % Norminization
    [~,Dex_Indice_Num] = size(Dex);
    for i = 4:1:Dex_Indice_Num
        Max_Value = max(Dex(:,i)); Dex(:,i)=Dex(:,i)/Max_Value;
    end
    
    switch opt.save
        case 'Save'
            save(path,'Dex');
        case 'UnSave'
            path = 'N'; out = 'UnSave';
    end
    
    Overall_Point = Dex(:,1:3); 
    Data = cat(1, Overall_Point,Mid_Point); 
    [~, O_Volume] = boundary(Data); 
    [~, Volume] = boundary(Overall_Point); 
end
