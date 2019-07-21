function [Volume_All,New_V,Transfer_New] = Final_Interact(Dex_Group,Boundary,Volume_Size,Precision,varargin)
%% Interaction Analysis
    opt.mode = {'General','Local_Indices'};
    opt.visual = {'Show','Scatter','None'};
    opt = tb_optparse(opt, varargin);
    
    Reach_Group = Dex_Group;
    [~,V_Group_Reach] = Scatter_Volume_Convert(Reach_Group,Precision,Boundary,Volume_Size);
    New_V = V_Group_Reach{1}.*V_Group_Reach{2};
     
    [Transfer_New,Oringin_Interact] = Visualize_HR_Volume(Boundary,New_V,Volume_Size,Precision);
   
    Value = 0.1;
    
    switch opt.mode
        case 'General'
            Volume_All = Boundary_WS(Transfer_New,Value,'off');
        case 'Local_Indices'
            Volume_All = mean(Transfer_New(:,4));
    end

    switch opt.visual
        case 'Scatter'
            scatter3(Transfer_New(:,1),Transfer_New(:,2),Transfer_New(:,3),5,Transfer_New(:,4));  
            hold on;
            colorbar; 
        case 'Show'
            figure
            Boundary_WS(Transfer_New,Value,'g');
    end
end
