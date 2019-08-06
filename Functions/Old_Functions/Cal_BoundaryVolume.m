function [vol] = Cal_BoundaryVolume(Dex)
    Data = [Dex(:,1),Dex(:,2),Dex(:,3)];
    [~, vol] = boundary(Data);
end

