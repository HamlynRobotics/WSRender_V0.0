function [Num_Array] = Local_Indice_Map(Indice_Group)
[~,Num] = size(Indice_Group); Num_Array = zeros(1,Num);
[~,Index_Name] = ReadFiles('All_Indices');
[~,All_Num] = size(Index_Name); All_Index_Num = 4:1:(4+All_Num-1);
Map_LocalIndex = containers.Map(All_Index_Num,Index_Name);
Map_Inv_LocalIndex = containers.Map(Index_Name,All_Index_Num);
for i = 1:1: Num
    Num_Array(1,i) = Map_Inv_LocalIndex(Indice_Group{i});
end
end

