function [Volume_All,New_V,Transfer_New] = Optimized_Interaction_Analysis(Transfer_Group,Boundary,Volume_Size,Precision,Base,Mode)
New_Dex = Transform_WS(Transfer_Group{1},Base);
Transfer_Group{1}=New_Dex;
[Volume_All,New_V,Transfer_New] = HR_Interact_Bimanual(Transfer_Group,Boundary,Volume_Size,Precision,Mode,'None');
%[Volume_All,New_V,Transfer_New]

end

