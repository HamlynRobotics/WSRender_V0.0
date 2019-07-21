function [QS,Count] = Generate_Joint(Robot,Flag,varargin)

    opt.JointNum = [];
    opt.type = {'General','MentoCarlo'};
    opt.save = {'Save','UnSave'};
    opt.Path = [];
    opt = tb_optparse(opt, varargin);
    [N_DoF,~] = size(Robot.qlim);
    
    Q = Robot.qlim;
    QUp = Q(:,2);  QDown = Q(:,1);

    if isempty(opt.JointNum)
        N = 15;
    else
        N = opt.JointNum;
    end

    if isempty(opt.Path)
        filename = 'Joint_Map'; path_Joint = '.\\Data\\Joint_Map';           
    else
        filename = opt.Path; addpath('../'); Folder = pwd;
        path_Joint = fullfile(Folder,'Data',[filename, num2str(N)]);
    end

    if Flag == 0
        N_Joint = N_DoF - 3;
    else
        N_Joint = N_DoF;
    end  
    
    Count = N.^(N_Joint); QS = zeros(Count,N_DoF);
    if Flag == 0
        for k = 1:1:N_Joint
            I = (N_DoF + 1 - k);
            QS(:, I)= (Q(I,1)+Q(I,2))/2;
        end
    end
    % QLength = zeros(1,N_DoF);
    Joint_Table = zeros(N_Joint,N);

    switch opt.type
        case 'General'
            for i = 1:1:N_Joint
                Joint_Table(i,:) = linspace(QDown(i),QUp(i),N);
            end
            QS_P = Mycombvec(Joint_Table);QS_P = transpose(QS_P);
            QS(:,1:N_Joint) = QS_P;
       
        case 'MentoCarlo'
            for i = 1:1:N_Joint
                QS(:,i) = (QDown(i) + (QUp(i)-QDown(i)) * rand(1,Count));
            end
    end

    switch opt.save
        case 'Save'
            save(path_Joint,'QS');
        case 'UnSave'
            %path_Joint = 'N';
            out = 'UnSave';
    end
    
end