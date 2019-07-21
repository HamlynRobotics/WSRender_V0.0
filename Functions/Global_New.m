function [Indices,Global_Indices] = Global_New(Dex,varargin)
    opt.evaluate = {'General'};
    opt.Indice = [];
    opt = tb_optparse(opt, varargin);
    
    [N,Ind] = size(Dex);
    Indices = Ind - 3;
    if isempty(opt.Indice)
        Global_Indices = zeros(1,Indices);
        switch opt.evaluate
            case 'General'
                for i = 1:1: Indices
                    Global_Indices(i) = sum(Dex(:,(i+3)))/N;
                    Global_Indices(i)  = real(Global_Indices(i));
                end

                Global_Indices(i+1) = min(Dex(:,6))/max(Dex(:,9));

                if Dynamic_Flag == 1
                    Global_Indices(i+2) = min(Dex(:,15))/max(Dex(:,18));
                end
        end
    else
        Indice_Group = opt.Indice;
        [Num_Array] = Local_Indice_Map(Indice_Group);
        [~,Cal_Index] = size(Num_Array);
        Global_Indices = zeros(1,Cal_Index);
        for K = 1:1:Cal_Index
            Global_Indices(1,K) = sum(Dex(:,Num_Array(1,K)))/N;
        end
    end
    
        

end
