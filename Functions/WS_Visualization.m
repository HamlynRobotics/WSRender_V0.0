% Input:
% Pop: index mode for visualization in the GUI
% Dex: local indices distribution map
% Volume_Info: volume data information
% Flag_Info: flag information
% 
% Output:
% String_Out: the name of mode
% 
% Function:
% Visualize the workspace by rendering in different modes


function [String_Out] = WS_Visualization(pop,Dex,Volume_Info,Flag_Info)
    Slice_Flag = Flag_Info(1); Bimanual = Flag_Info(2); 
    
    Evaluation_Index = Flag_Info(3); Slice = Flag_Info(4); Index_Num = Flag_Info(5); Bimanual_Vector = Flag_Info(6);
    Slice_Flag = cell2mat(Slice_Flag);Bimanual= cell2mat(Bimanual);Evaluation_Index = cell2mat(Evaluation_Index);Slice=cell2mat(Slice);
    Index_Num=cell2mat(Index_Num); Bimanual_Vector=cell2mat(Bimanual_Vector);
  
    
    switch pop
        
        case 1
            String_Out = strcat(Evaluation_Index,'Scatter') ;
            if Bimanual == 0
                
                if Index_Num == 10
                    VisualWS(Dex);
                else
                    VisualWS(Dex,(Index_Num+3),'Local_Indices');
                end
            else
                if Index_Num == 10
                    VisualWS(Dex,'Bimanual','vector',Bimanual_Vector);
                else
                    VisualWS(Dex,(Index_Num+3),'Local_Indices','Bimanual','vector',Bimanual_Vector)
                end
            end
        case 2 
             String_Out = strcat(Evaluation_Index,'Volume Data') ;
             if Bimanual == 0    
                 [TransferSingle] = Visualize_SingleVolumeData(Volume_Info.Boundary_Robot,Volume_Info.V,Volume_Info.Volume_Size,Volume_Info.Precision);
             else
                % Visualize Interact Volume Data
                [TransferRight,TransferLeft,TransferDual] = Visualize_VolumeData(Volume_Info.Boundary_Robot,Volume_Info.VLeft_Robot,Volume_Info.VRight_Robot,Volume_Info.Volume_Size_Robot,Volume_Info.Precision,'Scatter');
             end
        case 3
            String_Out = strcat(Evaluation_Index,'Convhulln') ;
            [Volume_R,Volume_L] = Visual_Dex_Convhulln(Dex,Dex);
        case 4
            String_Out = strcat(Evaluation_Index,'Isosurface') ;
            [A] = Visual_Isosurface(Dex,Volume_Info.Boundary_Single,Volume_Info.Precision);
        case 5
            String_Out = strcat(Evaluation_Index,'Slice') ;
            if Slice_Flag(1) == 1
                [out] = Visual_Slice(Volume_Info.V,Volume_Info.Boundary_Robot,Volume_Info.Precision,'X',Slice(1));
            end
            if Slice_Flag(2) == 1
                [out] = Visual_Slice(Volume_Info.V,Volume_Info.Boundary_Robot,Volume_Info.Precision,'Y',Slice(2));
            end
            if Slice_Flag(3) == 1
                [out] = Visual_Slice(Volume_Info.V,Volume_Info.Boundary_Robot,Volume_Info.Precision,'Z',Slice(3));
            end
        case 6
            String_Out = strcat(Evaluation_Index,'Boundary') ;
            [OUT] = Boundary_WS(Dex,Slice(4));
        case 7
            String_Out = strcat(Evaluation_Index,'Alphashape') ;
            shp = alphaShape(Dex(:,1:3),Slice(5));
            plot(shp)
            axis equal
            %[Out] = AlphaShape_WS(Dex,Slice(5));
        case 8
            String_Out = strcat(Evaluation_Index,'Reachable') ;
            if Bimanual == 0
                VisualWS(Dex,'Reachable');
                %set(handles.Status,'String',Evaluation_Index);
            else
                Bimanual_Vector = [-10,0,40,10,0,40];
                VisualWS(Dex,'Reachable','Bimanual','vector',Bimanual_Vector);
            end
    end
end

