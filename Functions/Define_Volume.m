function [Boundary,Volume_Size] = Define_Volume(Dex_Group,Pre)
    [~,Robot_Num] = size(Dex_Group);
    Boundary = zeros(3,2);
    xmin = zeros(1,Robot_Num);xmax = zeros(1,Robot_Num);
    ymin = zeros(1,Robot_Num);ymax = zeros(1,Robot_Num);
    zmin = zeros(1,Robot_Num);zmax = zeros(1,Robot_Num);
    for i = 1:1:Robot_Num
        Dex = Dex_Group{i};
        xmin(i) = min(Dex(:,1)); xmax(i) = max(Dex(:,1));
        ymin(i) = min(Dex(:,2)); ymax(i) = max(Dex(:,2));
        zmin(i) = min(Dex(:,3)); zmax(i) = max(Dex(:,3));
    end

    X_min = min(xmin);Y_min = min(ymin);Z_min = min(zmin);
    X_max = max(xmax);Y_max = max(ymax);Z_max = max(zmax);

    Boundary(1,1) = X_min; Boundary(1,2) = X_max;
    Boundary(2,1) = Y_min; Boundary(2,2) = Y_max;
    Boundary(3,1) = Z_min; Boundary(3,2) = Z_max;

    [X_mesh,Y_mesh,Z_mesh] = meshgrid(X_min:Pre:X_max,Y_min:Pre:Y_max,Z_min:Pre:Z_max);
    [A, B, C] = size(X_mesh);
    Volume_Size = [A, B, C];
end

