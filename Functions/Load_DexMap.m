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

