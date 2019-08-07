function [Dex] = ReachableWS(Robot,Count,QS,Flag,varargin)
    % Flag(1): Joint_Flag
    % Flag(2): Dynamic_Flag
    Dex = zeros(Count,9);R = zeros(Count,1);
    opt.save = {'Save','UnSave'};
    opt.evaluate = {'Off','On'};
    opt = tb_optparse(opt, varargin);
    
            Q = Robot.qlim; 
            [N_DoF,~] = size(Q);
            
    QUpL = Q(:,2); QDownL = Q(:,1);
    
    qUp = libpointer('doublePtr',QUpL); qDown = libpointer('doublePtr',QDownL);
    

    switch opt.evaluate
        case 'Off'
            for i = 1:1:Count
                TQS= Robot.fkine(QS(i,:));
                Dex(i,1) = TQS(1,4); Dex(i,2) = TQS(2,4); Dex(i,3) = TQS(3,4);
            end

        case 'On'
            for i = 1:1:Count
                TQS= Robot.fkine(QS(i,:));
                qPtr=libpointer('doublePtr',QS(i,:));
                if Flag(2) == 1
                    [m] = Dynamic_M(Robot, QS(i,:));
                    M = Robot.inertia(QS(i,:));
                    Y = jacob0(Robot,QS(i,:)); 
                    H = Y*M;[U DS V] = svd(H);
                    Dynamic_SS = [DS(1,1),DS(2,2),DS(3,3),DS(4,4),DS(5,5),DS(6,6)]; 
                    %Dynamic_Sum_Singular = DS(1,1)*DS(2,2)*DS(3,3)*DS(4,4)*DS(5,5)*DS(6,6);
                    Dynamic_Sum_Singular = sqrt( det(Y*transpose(Y)));
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
                Dex(i,4) = Sum_Singular * R(i,1);
                Dex(i,5) = min(SS)/max(SS) * R(i,1);
                Dex(i,6) = min(SS) * R(i,1); % min singular
                Dex(i,7) = max(SS)/min(SS) * R(i,1);
                Dex(i,8) = Sum_Singular.^(1/N_DoF) * R(i,1); % order-independent manipulability
                Dex(i,9) = max(SS)* R(i,1); % max singular
                Dex(i,10) = hmmi* R(i,1);
                Dex(i,11) = Dex(i,8)/mean(SS)  * R(i,1) ;
                
                if Flag(2) == 1
                    Dex(i,12) = m * R(i,1);
                    Dex(i,13) = Dynamic_Sum_Singular * R(i,1);
                    Dex(i,14) = min(Dynamic_SS)/max(Dynamic_SS) * R(i,1);
                    Dex(i,15) = min(Dynamic_SS) * R(i,1); % min dynamic singular
                    Dex(i,16) = max(Dynamic_SS)/min(Dynamic_SS) * R(i,1);
                    Dex(i,17) = Dynamic_Sum_Singular.^(1/N_DoF) * R(i,1);  % order-independent dynamic manipulability
                    Dex(i,18) = max(Dynamic_SS) * R(i,1); % max dynamic singular
                    Dex(i,19) = Dynamic_hmmi * R(i,1);
                    Dex(i,20) = Dex(i,17)/mean(Dynamic_SS) * R(i,1);
           
                end
                
            end
            % Norminization
            Max = max(Dex(:,4));
            Dex(:,4) = Dex(:,4)/Max;
            
            Max = max(Dex(:,5));
            Dex(:,5) = Dex(:,5)/Max;
            
            Max = max(Dex(:,7));
            Dex(:,7) = Dex(:,7)/Max;
            
            Max = max(Dex(:,8));
            Dex(:,8) = Dex(:,8)/Max;
            
            Max = max(Dex(:,10));
            Dex(:,10) = Dex(:,10)/Max;
            
            Max = max(Dex(:,11));
            Dex(:,11) = Dex(:,11)/Max;   
            
            if Flag(2) == 1
                Max = max(Dex(:,12));
                Dex(:,12) = Dex(:,12)/Max;
                
                Max = max(Dex(:,13));
                Dex(:,13) = Dex(:,13)/Max;
                
                Max = max(Dex(:,14));
                Dex(:,14) = Dex(:,14)/Max;
                
                Max = max(Dex(:,16));
                Dex(:,16) = Dex(:,16)/Max;
                
                Max = max(Dex(:,17));
                Dex(:,17) = Dex(:,17)/Max;
                 
                Max = max(Dex(:,19));
                Dex(:,19) = Dex(:,19)/Max;
                                
                Max = max(Dex(:,20));
                Dex(:,20) = Dex(:,20)/Max;
            end
    end
   
    switch opt.save
        case 'Save'
            save('.\\Data\\LocalIndice_Map','Dex');
        case 'UnSave'
            out = 'UnSave'
    end
    

    
    
end

