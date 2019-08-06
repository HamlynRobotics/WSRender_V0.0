% Input:
% Type_Group: A list of types of robots in cell data structure
% Num: The total joint number
% Output:
% Dex_Group: The local indices distribution map of the target robots in
% Cell data structure
% Function: 
% Load existing data of the targeted robots for analysis
% Example: 
% Type_Group = {'Articulated','Spherical','Omni','HamlynCRM'};
% Count_Num = 216000;
% [Dex] =Load_DexMap(Type_Group,Count_Num);

%% 
function [Dex_Group] =Load_DexMap(Type_Group,Num)
[~,Num_Group] = size(Type_Group);
Dex_Group = cell(1,Num_Group);
    for i = 1:1:Num_Group
        filename = Type_Group{i};
        addpath('../');
        Folder = pwd;
        path = fullfile(Folder,'Data',[filename, num2str(Num)]);
        Dex = load(path,'Dex');  
        Dex_Group{i} = Dex.Dex;
    end
end

