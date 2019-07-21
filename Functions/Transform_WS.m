function [Out_Dex] = Transform_WS(Dex,Base)
    Out_Dex = Dex;
    
    Rx = Base(1,4); Ry = Base(1,5); Rz = Base(1,6);
    [Count,~] = size(Dex);
    for i = 1:1:Count
        Out_Dex(i,1:3) = Out_Dex(i,1:3)* rotx(Rx)* roty(Ry)* rotz(Rz);
    end
    Out_Dex(:,1:3) = Out_Dex(:,1:3) + Base(1,1:3);
end

