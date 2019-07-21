function [Transfer_Robot,TransferAll] = Visualize_VolumeData_All(Boundary,V_Group,Volume_Size,Precision,Index,varargin)
    [~,Robot_Num] = size(V_Group);
    opt.visual = {'Off','Bimanual','Seperate','Scatter'};
    opt = tb_optparse(opt, varargin);
    xminH = Boundary(1,1);yminH = Boundary(2,1);zminH = Boundary(3,1);
    A = Volume_Size(1);B = Volume_Size(2);C = Volume_Size(3); Total = A * B * C; 
    
    Transfer = zeros(1,3);
  
    VDualArm = zeros(Volume_Size);
    for P = 1:1:Robot_Num
        NumLC = 0; VLeft = V_Group{P};
        for i = 1:1:A
            for j = 1:1:B
                for k = 1:1:C
                    if VLeft(i,j,k) ~=0
                        NumLC = NumLC+1;
                        Transfer(NumLC,1) = xminH + Precision*(j-1);
                        Transfer(NumLC,2) = yminH + Precision*(i-1);
                        Transfer(NumLC,3) = zminH + Precision*(k-1);
                        Transfer(NumLC,4) = VLeft(i,j,k);
                    end
                end
            end
        end  
        VDualArm = VDualArm + V_Group{P};
        Transfer_Robot{P} = Transfer;
    end
    
    % Check All
    Total = A * B * C;
    
    TransferAll = zeros(1,3);
    
    NumC = 0;
    for i = 1:1:A
        for j = 1:1:B
            for k = 1:1:C
                if VDualArm(i,j,k) ~=0
                    NumC = NumC+1;
                    TransferAll(NumC,1) = xminH + Precision*(j-1);
                    TransferAll(NumC,2) = yminH + Precision*(i-1);
                    TransferAll(NumC,3) = zminH + Precision*(k-1);
                    TransferAll(NumC,4) = VDualArm(i,j,k);
                end
            end
        end
    end

    %% Check Transfer to Volume Data, Dual Arm
    switch opt.visual
        case 'Seperate'
            for i = 1:1:Robot_Num
                Transfer = Transfer_Robot{i};
                plot3(Transfer(1:NumLC,1),Transfer(1:NumLC,2),Transfer(1:NumLC,3),'*b');
                hold on;
            end
        case 'Bimanual'
                plot3(TransferAll(1:NumC,1),TransferAll(1:NumC,2),TransferAll(1:NumC,3),'*k');
                hold on;
        case 'Scatter' 
            for i = 1:1:Robot_Num
                Transfer = Transfer_Robot{i};
                %colormap(jet); 
                colormap(viridis);
                colorbar; 
                caxis([0 1]); 
                set(gcf,'color','w'); hold on;
                scatter3(Transfer(:,1),Transfer(:,2),Transfer(:,3),5,Transfer(:,Index));
                hold on;
            end

    end
end
