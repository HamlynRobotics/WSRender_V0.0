function [QS,Count] = GenerateJoint(Robot,varargin)

    opt.JointNum = [];
    opt.type = {'General','MentoCarlo'};
    opt = tb_optparse(opt, varargin);
   [N_DoF,~] = size(Robot.qlim);

    if isempty(opt.JointNum)
        N = 15;
    else
        N = opt.JointNum;
    end
    Count = N*N*N;
    QS = zeros(Count,N_DoF);
    Q = Robot.qlim;
    QUp = Q(:,2);  QDown = Q(:,1);
    
    QLength = zeros(1,N_DoF);
            
    switch opt.type
        case 'General'

            if N_DoF == 6
                for i = 1:1:N_DoF
                    QLength(1,i) = (QUp(i)-QDown(i))/N;
                end
                Count = 0;
                for i = QDown(1): QLength(1,1): QUp(1)
                    for j = QDown(2): QLength(1,2): QUp(2)
                        for k = QDown(3): QLength(1,3): QUp(3)
                            Count = Count + 1;
                            QS(Count,1) = i; QS(Count,2) = j; QS(Count,3) = k;
                        end
                    end
                end
                QS(1:Count,(N_DoF-2)) = 0;  QS(1:Count,(N_DoF-1)) = pi/2;   QS(1:Count,N_DoF) = 0;
            
            else
                Count = N*N*N*N;
                QS = zeros(Count,N_DoF);
                for i = QDown(1): QLength(1,1): QUp(1)
                    for j = QDown(2): QLength(1,2): QUp(2)
                        for k = QDown(3): QLength(1,3): QUp(3)
                            for w = QDown(4): QLength(1,4): QUp(4)
                            Count = Count + 1;
                            QS(Count,1) = i; QS(Count,2) = j; QS(Count,3) = k; QS(Count,4) = w;
                            end
                        end
                    end
                end
                QS(1:Count,(N_DoF-2)) = 0; QS(1:Count,(N_DoF-1)) = pi/2; QS(1:Count,N_DoF) = 0;
            end

        case 'MentoCarlo'

            for i = 1:1:N_DoF
                QS(:,i) = (QDown(i) + (QUp(i)-QDown(i)) * rand(1,Count));
            end
    end
end