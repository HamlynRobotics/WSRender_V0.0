function [Point_Right,Point_Left,Volume_R,Volume_L] = Visual_Dex_Convhulln(Right,Left,varargin)
    opt.visual = {'Single','Bimanual','Off'};
    opt = tb_optparse(opt, varargin);
 
    P = [Left(:,1),Left(:,2),Left(:,3)];
    [K,Volume_L] = convhulln(P);
    Point_Left = P;
   

        [k1,k2] = size(K);
        NewSurf = zeros(k1,3);

        for i = 1:1:k1
            NewSurf(i,1) = Left(K(i),1);
            NewSurf(i,2) = Left(K(i),2);
            NewSurf(i,3) = Left(K(i),3);
        end
        %%
        % Patch Convhulln Surface
        C = [0.667;1;0;];
        patch('vertices',P,'faces',K,'facecolor',C);
        alpha(0.3)                % set all patches transparency to 0.3

        colorbar
        view(3)   
        
        R = 0;
        P = [Right(:,1),Right(:,2),Right(:,3)];
        [K,Volume_R]= convhulln(P);

        [k1,k2] = size(K);
        NewSurf = zeros(k1,3);

        for i = 1:1:k1
            NewSurf(i,1) = Right(K(i),1);
            NewSurf(i,2) = Right(K(i),2);
            NewSurf(i,3) = Right(K(i),3);
        end

        % Patch Convhulln Surface
        C = [0;0.667;1];
        patch('vertices',P,'faces',K,'facecolor',C);
        colorbar
        view(3)
        alpha(0.3) 
        Point_Right = P;

    %%
    Flag_Determine = 0;

    if Flag_Determine == 1
        % Random Points Generation in Small Volume
        Length = 40;
        NX = 10000;
        Rx = Con_Xmin + (Con_Xmax - Con_Xmin) * rand(NX,1);
        Ry = Con_Ymin + (Con_Ymax - Con_Ymin) * rand(NX,1);
        Rz = Con_Zmin +(Con_Zmax - Con_Zmin)  * rand(NX,1);

        Count_Point = 0;

        for i = 1:1:NX
            inflag = inpolyhedron(P,[Rx(i),Ry(i),Rz(i)]);
            if inflag == 1
                Count_Point = Count_Point + 1;
            end
        end
    end

end
