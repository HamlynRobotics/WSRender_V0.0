function [V_Scale,Mapping_Efficiency] = Mapping(Master_Dex,Slave_Dex)
    Slave_Centre = mean(Slave_Dex);
    Precision = 0.001;
    Slave_Dex(:,1:3) = Slave_Dex(:,1:3) - Slave_Centre(1,1:3);
    
    [~,n] = size(Master_Dex);
     V_Scale = zeros(n,7);
    
    for i = 1:1:n
        Dex_temp = Master_Dex{i};
        Dex = Dex_temp(:,1:6);
        Master_Centre = mean(Dex);
        Dex(:,1:3) = Dex(:,1:3) - Master_Centre(1,1:3);
        Volume_Interact_Scale = zeros(1,7);
        for j = 1:1:7
               % Adjust Scaling Ratio
               Scale_Ratio = 0.1 + (j-1)*0.05;
               % Master
               Dex_Group{1} = Dex*Scale_Ratio;
               % Slave
               Dex_Group{2} = Slave_Dex;
               [Boundary,Volume_Size] = Define_Volume(Dex_Group,Precision);
               %[V_All,V_Group] = Scatter_Volume_Convert(Dex_Group,Precision,Boundary,Volume_Size);  
               % Index = 4;
               % [Transfer_Robot,TransferAll] = Visualize_VolumeData_All(Boundary,V_Group,Volume_Size,Precision,Index,'Off');
               [~,Volume_Interact_A] = Find_Interact_Bimanual(Dex_Group,Boundary,Volume_Size,Precision);
               Volume_Interact_Scale(1,j)=Volume_Interact_A;
        end
        V_Scale(i,:) = Volume_Interact_Scale;

    end
    V_Slave = Boundary_WS(Slave_Dex,0.1,'off');
    Mapping_Efficiency = V_Scale/V_Slave;
end