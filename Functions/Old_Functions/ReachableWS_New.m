function [Dex,path,O_Volume,Volume] = ReachableWS_New(Robot,QS,Flag,varargin)
    % Flag(1): Joint_Flag
    % Flag(2): Dynamic_Flag
    [Count,~] = size(QS);
    Dex = zeros(Count,20);
    Mid_Point = zeros(Count,3);
    % Transfer Indice Name to Array Number
    % Joint penalty
    R = zeros(Count,1); 

    opt.save = {'Save','UnSave'};
    opt.evaluate = {'On','Off'};
    opt.Indice = [];
    opt.Path = [];
    opt = tb_optparse(opt, varargin);
   
    
    opt.Indice
    
    
    if isempty(opt.Path)
        filename = 'LocalIndice_Map';
        path = '.\\Data\\LocalIndice_Map';           
    else
        filename = opt.Path;
        addpath('../');
        Folder = pwd;
        path = fullfile(Folder,'Data',[filename, num2str(Count)]);
    end
    
    if isempty(opt.Indice)
        Num_Array = linspace(4,11,8);
        Cal_Index = 8;
    else
        Indice_Group = opt.Indice;
       
        [Num_Array] = Local_Indice_Map(Indice_Group);
        [~,Cal_Index] = size(Num_Array);
    end
    
    % Joint Limitation Information
    Q = Robot.qlim; 
    [N_DoF,~] = size(Q);
    QUpL = Q(:,2); QDownL = Q(:,1);
    qUp = libpointer('doublePtr',QUpL);
    qDown = libpointer('doublePtr',QDownL);
    
    switch opt.evaluate
        case 'Off'
            for i = 1:1:Count
                TQS= Robot.fkine(QS(i,:));
                TQS = TQS.T;
                Dex(i,1) = TQS(1,4); Dex(i,2) = TQS(2,4); Dex(i,3) = TQS(3,4);
            end

        case 'On'
            for i = 1:1:Count
                [TQS,T] = Robot.fkine(QS(i,:));
                 All_T = T(3).T;
                 Mid_Point(i,1) = All_T(1,4);  Mid_Point(i,2) = All_T(2,4);  Mid_Point(i,3) = All_T(3,4);  
        
                qPtr=libpointer('doublePtr',QS(i,:));
                if Flag(2) == 1
                    [m] = Dynamic_M(Robot, QS(i,:));
                    M = Robot.inertia(QS(i,:));
                    Y = jacob0(Robot,QS(i,:)); 
                    H = Y*M;[U DS V] = svd(H);
                    Dynamic_SS = [DS(1,1),DS(2,2),DS(3,3),DS(4,4),DS(5,5),DS(6,6)]; 
                    %Dynamic_Sum_Singular = DS(1,1)*DS(2,2)*DS(3,3)*DS(4,4)*DS(5,5)*DS(6,6);
                    Dynamic_Sum_Singular = sqrt( det(Y*transpose(Y)));
                    Dynamic_Sum_Singular = sqrt( det(H*transpose(H)));
                    
                    Dynamic_hmmi = sqrt(1/trace(pinv(H*transpose(H))));
                end
                
                if Flag(1) == 1
                    % R(i,1) = OmniJoint_Limitation(qPtr,qUp,qDown,Nq);
                    R(i,1) = Joint_Limitation(qPtr,qUp,qDown,N_DoF);
                   
                else
                    R(i,1) = 1;
                end
                
                TQS = TQS.T;
                Dex(i,1) = TQS(1,4); Dex(i,2) = TQS(2,4); Dex(i,3) = TQS(3,4);
                Y = jacob0(Robot,QS(i,:)); 
                [U S V] = svd(Y); hmmi = sqrt(1/trace(pinv(Y*transpose(Y))));
                SS = diag(S);
                %SS = [S(1,1),S(2,2),S(3,3),S(4,4)]; 
                %Sum_Singular = S(1,1)*S(2,2)*S(3,3)*S(4,4)*S(5,5)*S(6,6);
                %Sum_Singular = det(Y*Y');
                
        J = Y(1:3,:);
        Sum_Singular =  sqrt(det(J * J'));

        for K = 1:1:Cal_Index
            switch Num_Array(K)
                case 4 
                    Dex(i,4) = Sum_Singular * R(i,1); % Manipulability
                case 5
                    Dex(i,5) = min(SS)/max(SS) * R(i,1); % Inverse condition number
                case 6
                       Dex(i,6) = min(SS) * R(i,1); % min singular value
                case 7
                     Dex(i,7) = max(SS)/min(SS) * R(i,1);   % condition number
                case 8
                     Dex(i,8) = Sum_Singular.^(1/N_DoF) * R(i,1); % order-independent manipulability           
                case 9
                     Dex(i,9) = max(SS)* R(i,1); % max singular                   
                case 10
                     Dex(i,10) = hmmi* R(i,1);   % Harmonic Mean Manipulability Index                        
                case 11
                     Dex(i,11) = Dex(i,8)/mean(SS)  * R(i,1) ; % Isotropic Index
                otherwise
                   out = 'error'
            end
        end

        %{
                Dex(i,4) = Sum_Singular * R(i,1);
                Dex(i,5) = min(SS)/max(SS) * R(i,1);
                Dex(i,6) = min(SS) * R(i,1); % min singular
                Dex(i,7) = max(SS)/min(SS) * R(i,1);
                Dex(i,8) = Sum_Singular.^(1/N_DoF) * R(i,1); % order-independent manipulability
                Dex(i,9) = max(SS)* R(i,1); % max singular
                Dex(i,10) = hmmi* R(i,1);
                Dex(i,11) = Dex(i,8)/mean(SS)  * R(i,1) ;
         %}
        
                if Flag(2) == 1
                    Dex(i,12) = m * R(i,1);
                    Dex(i,13) = Dynamic_Sum_Singular * R(i,1);
                    Dex(i,14) = min(Dynamic_SS)/max(Dynamic_SS) * R(i,1);
                    Dex(i,15) = min(Dynamic_SS) * R(i,1); % min dynamic singular
                    Dex(i,16) = max(Dynamic_SS)/min(Dynamic_SS) * R(i,1);
                    Dex(i,17) = Dynamic_Sum_Singular.^(1/N_DoF) * R(i,1);  % dynamic order-independent  manipulability
                    Dex(i,18) = max(Dynamic_SS) * R(i,1); % max dynamic singular
                    Dex(i,19) = Dynamic_hmmi * R(i,1);  % Harmonic Mean Manipulability Index     
                    Dex(i,20) = Dex(i,17)/mean(Dynamic_SS) * R(i,1); % Dynamic Isotropic Index
                end
            end
            % Norminization
            Max = max(Dex(:,4));      
            if Max ~= 0
                Dex(:,4) = Dex(:,4)/Max;
            end
            
            Max = max(Dex(:,5));      
            if Max ~= 0
                Dex(:,5) = Dex(:,5)/Max;
            end
            
            Max = max(Dex(:,7));      Dex(:,7) = Dex(:,7)/Max;
            Max = max(Dex(:,8));      Dex(:,8) = Dex(:,8)/Max;
            Max = max(Dex(:,10));     Dex(:,10) = Dex(:,10)/Max;
            Max = max(Dex(:,11));     Dex(:,11) = Dex(:,11)/Max;   

            if Flag(2) == 1
                Max = max(Dex(:,12)); Dex(:,12) = Dex(:,12)/Max;
                Max = max(Dex(:,13)); Dex(:,13) = Dex(:,13)/Max;
                Max = max(Dex(:,14)); Dex(:,14) = Dex(:,14)/Max;
                Max = max(Dex(:,16)); Dex(:,16) = Dex(:,16)/Max;
                Max = max(Dex(:,17)); Dex(:,17) = Dex(:,17)/Max;
                Max = max(Dex(:,19)); Dex(:,19) = Dex(:,19)/Max;
                Max = max(Dex(:,20)); Dex(:,20) = Dex(:,20)/Max;
            end
    end
   
    switch opt.save
        case 'Save'
            save(path,'Dex');
        case 'UnSave'
            path = 'N';
            out = 'UnSave'
    end
    
    Overall_Point = Dex(:,1:3);
    Data = cat(1, Overall_Point,Mid_Point) ;
   [~, O_Volume] = boundary(Data);  [~, Volume] = boundary(Overall_Point); 
    
end


