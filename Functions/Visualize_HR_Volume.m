function[TransferRight,Oringin_Interact] = Visualize_HR_Volume(Boundary,V_New,Volume_Size,Precision, varargin)
    opt.visual = {'Off','Scatter','Seperate'};

    opt = tb_optparse(opt, varargin);

    %% Check Transfer to Volume Data, Left and Right respectly
    xminH = Boundary(1,1);yminH = Boundary(2,1);zminH = Boundary(3,1);
    
    Pre = Precision;
    %%
    A = Volume_Size(1);B = Volume_Size(2);C = Volume_Size(3);

    %%
    % Check Right
    Total = A * B * C;
    % TransferRight = zeros(Total,3);
    NumRC = 0;
    for i = 1:1:A
        for j = 1:1:B
            for k = 1:1:C
                if V_New(i,j,k) ~=0
                    NumRC = NumRC+1;
                    TransferRight(NumRC,1) = xminH + Pre*(j-1);
                    TransferRight(NumRC,2) = yminH + Pre*(i-1);
                    TransferRight(NumRC,3) = zminH + Pre*(k-1);
                    TransferRight(NumRC,4) = V_New(i,j,k);
                end
            end
        end
    end  
    
if NumRC ~= 0
    Oringin_Interact = TransferRight;
    Max_V = max(TransferRight(:,4));
    TransferRight(:,4) = TransferRight(:,4)/Max_V;
else
    out = 'error'
    TransferRight = zeros(1,4);Oringin_Interact=zeros(1,4);
end
    %% Check Transfer to Volume Data, Dual Arm
    switch opt.visual
        case 'Seperate'

            plot3(TransferRight(1:NumRC,1),TransferRight(1:NumRC,2),TransferRight(1:NumRC,3),'*r');
            hold on;

        case 'Scatter' 
            out = 1;
            
            scatter3(TransferRight(:,1),TransferRight(:,2),TransferRight(:,3),5,TransferRight(:,4));grid off;
            colormap(jet); colorbar; caxis([0 1]); set(gcf,'color','w'); 
            
            hold on;
    end
end
