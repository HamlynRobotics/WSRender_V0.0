% Input:
% Dex_Group,
% Boundary,
% Volume_Size,
% Precision,
% opt.visual = {'Off','Bimanual','Seperate','Scatter'};
% opt.color = {'r','b'};
% 
% Output:
% Volume_All: the overall workspace volume of multi robots
% Volume_Interact: the intersection workspace volume of multi robots
% 
% Function:
% Calculate the overall/intersection workspace volume of multi robots

function [Volume_All,Volume_Interact] = Find_Interact_Bimanual(Dex_Group,Boundary,Volume_Size,Precision,varargin)
%% Interaction Analysis
    opt.visual = {'Off','Bimanual','Seperate','Scatter'};
    opt.color = {'r','b'};
    opt = tb_optparse(opt, varargin);

    for i = 1:1:2
        Reach = Dex_Group{i}(:,1:3); Reach(:,4) = 1;
        Reach_Group{i} = Reach;
    end
    
    [V_All_Reach,V_Group_Reach] = Scatter_Volume_Convert(Reach_Group,Precision,Boundary,Volume_Size);
    [TransferRight1,TransferLeft1,TransferDual] = Visualize_VolumeData(Boundary,V_Group_Reach{1},V_Group_Reach{2},Volume_Size,Precision);
    [NumC,~] = size(TransferDual);
    k = 0;
    for i = 1:1:NumC
        if TransferDual(i,4) == 2
            k = k + 1;
            Interact(k,:) = TransferDual(i,:);
        else
            continue
        end
        
    end
    Value = 0.1;
    Volume_All = Boundary_WS(TransferDual,Value,'off');
    if k == 0
        Volume_Interact = 0
    else
        Volume_Interact = Boundary_WS(Interact,Value,'off');

    end
    
    switch opt.visual
        case 'Seperate'
            plot3(Interact(:,1),Interact(:,2),Interact(:,3),'*r');
            hold on;
            Volume_Interact = Boundary_WS(Interact,Value,'r');

        case 'Scatter'
            
            colormap(viridis);
            colorbar; caxis([0 1]); set(gcf,'color','w'); 
            scatter3(Interact(:,1),Interact(:,2),Interact(:,3),5,Interact(:,4)); hold on;
    end
end

