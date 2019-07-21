function [Volume_Info,Transfer_Group] = Interaction_Analysis(Base,Dex_Group,Precision,varargin)
    opt.visual = {'Off','Bimanual','Seperate','Scatter'};
    opt = tb_optparse(opt, varargin);
    Dex_Right = Dex_Group{1};
    Dex_Left = Dex_Group{2};

    Dex_Right(:,1:3) = Dex_Right(:,1:3) + Base(1,1:3) ;
    Dex_Left(:,1:3) = Dex_Left(:,1:3) + Base(1,1:3) ;

    Dex_Group{1} = Dex_Right;
    Dex_Group{2} = Dex_Left;

    [Boundary,Volume_Size] = Define_Volume(Dex_Group,Precision);

    [~,V_Group] = Scatter_Volume_Convert(Dex_Group,Precision,Boundary,Volume_Size);

    %% Visual All Robots
    V_Bimanual{1} = V_Group{1}; V_Bimanual{2} = V_Group{2};
    V_Bimanual_B{1} = V_Group{3}; V_Bimanual_B{2} = V_Group{4};

    % Bimanual A
    Index = 4;
    [Transfer_Robot_A,TransferAll_A] = Visualize_VolumeData_All(Boundary,V_Bimanual,Volume_Size,Precision,Index,opt.visual);
    [Volume_All_A,Volume_Interact_A] = Find_Interact_Bimanual(Dex_Group,Boundary,Volume_Size,Precision,opt.visual);

    % Bimanual B
    [Transfer_Robot_B,TransferAll_B] = Visualize_VolumeData_All(Boundary,V_Bimanual_B,Volume_Size,Precision,Index,opt.visual);
    [Volume_All_B,Volume_Interact_B] = Find_Interact_Bimanual(Dex_Group,Boundary,Volume_Size,Precision,opt.visual);

    % Bimanual A + B
    Transfer_Group{1} = TransferAll_A;
    Transfer_Group{2} = TransferAll_B;

    %{
        if HR_Flag == 1
            [Volume_All,Volume_Interact,Transfer_New] = HR_Interact_Bimanual(Transfer_Group,Boundary,Volume_Size,Precision,'on');
        else
            [Volume_All,Volume_Interact] = Find_Interact_Bimanual(Transfer_Group,Boundary,Volume_Size,Precision,'on');
        end

    %}

    Volume_Info = [Volume_All_A,Volume_Interact_A,Volume_All_B,Volume_Interact_B];
end

