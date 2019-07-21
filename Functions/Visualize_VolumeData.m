function [TransferRight,TransferLeft,TransferDual] = Visualize_VolumeData(Boundary,VLeft,VRight,Volume_Size,Precision,varargin)
    
    opt.visual = {'Off','Bimanual','Seperate','Scatter'};
    opt = tb_optparse(opt, varargin);

    %% Check Transfer to Volume Data, Left and Right respectly
    xminH = Boundary(1,1);yminH = Boundary(2,1);zminH = Boundary(3,1);
    VDualArm = VLeft+VRight;
    Pre = Precision;
    %%
    A = Volume_Size(1);B = Volume_Size(2);C = Volume_Size(3);
    % Check Left
    Total = A * B * C;
    % TransferLeft = zeros(Total,3);
    NumLC = 0;
    for i = 1:1:A
        for j = 1:1:B
            for k = 1:1:C
                if VLeft(i,j,k) ~=0
                    NumLC = NumLC+1;
                    TransferLeft(NumLC,1) = xminH + Pre*(j-1);
                    TransferLeft(NumLC,2) = yminH + Pre*(i-1);
                    TransferLeft(NumLC,3) = zminH + Pre*(k-1);
                    TransferLeft(NumLC,4) = VLeft(i,j,k);
                end
            end
        end
    end  
    %%
    % Check Right
    Total = A * B * C;
    % TransferRight = zeros(Total,3);
    NumRC = 0;
    for i = 1:1:A
        for j = 1:1:B
            for k = 1:1:C
                if VRight(i,j,k) ~=0
                    NumRC = NumRC+1;
                    TransferRight(NumRC,1) = xminH + Pre*(j-1);
                    TransferRight(NumRC,2) = yminH + Pre*(i-1);
                    TransferRight(NumRC,3) = zminH + Pre*(k-1);
                    TransferRight(NumRC,4) = VRight(i,j,k);
                end
            end
        end
    end  
    %%
    % Check Dual
    Total = A * B * C;
    % TransferDual = zeros(Total,3);
    NumC = 0;
    for i = 1:1:A
        for j = 1:1:B
            for k = 1:1:C
                if VDualArm(i,j,k) ~=0
                    NumC = NumC+1;
                    TransferDual(NumC,1) = xminH + Pre*(j-1);
                    TransferDual(NumC,2) = yminH + Pre*(i-1);
                    TransferDual(NumC,3) = zminH + Pre*(k-1);
                    TransferDual(NumC,4) = VDualArm(i,j,k);
                end
            end
        end
    end

    %% Check Transfer to Volume Data, Dual Arm
    switch opt.visual
        case 'Seperate'
            plot3(TransferLeft(1:NumLC,1),TransferLeft(1:NumLC,2),TransferLeft(1:NumLC,3),'*b');
            hold on;
            plot3(TransferRight(1:NumRC,1),TransferRight(1:NumRC,2),TransferRight(1:NumRC,3),'*r');
            hold on;
        case 'Bimanual'
            plot3(TransferDual(1:NumC,1),TransferDual(1:NumC,2),TransferDual(1:NumC,3),'*g');
            Dex = TransferDual;
            [v] = Boundary_WS(Dex,0.1,'g');
            hold on;
        case 'Scatter' 
            scatter3(TransferLeft(:,1),TransferLeft(:,2),TransferLeft(:,3),5,TransferLeft(:,4));
            hold on;
            scatter3(TransferRight(:,1),TransferRight(:,2),TransferRight(:,3),5,TransferRight(:,4));
            hold on;
    end
end
