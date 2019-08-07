function [Volume_Points,Boundary,Volume_Size] = Def_Constraints()
    Pre = 1;
    Desk_Width = 10;Desk_Length=10;Desk_Height=10;
    
    X=-Desk_Width: Pre :Desk_Width; Y=-Desk_Length: Pre :Desk_Length;Z = -Desk_Height: Pre :Desk_Height;
    [x,y,z]=meshgrid(X,Y,Z); 
    Volume_Points = [x,y,z];
            
    xminH = -Desk_Width;    xmaxH = Desk_Width;
    yminH = -Desk_Length;   ymaxH = Desk_Length;
    zminH = -Desk_Height;   zmaxH = Desk_Height;

    Boundary(1,1) = xminH; Boundary(1,2) = xmaxH;
    Boundary(2,1) = yminH; Boundary(2,2) = ymaxH;
    Boundary(3,1) = zminH; Boundary(3,2) = zmaxH;
    
    [A,B,C] = size(x);
    Volume_Size = [A,B,C];

    P = Visualize_SingleVolumeData(Boundary,Volume_Points,Volume_Size, Pre);
    % DT = delaunayTriangulation(P(:,1:3));
    
    FV = scatteredInterpolant(P(:,1),P(:,2),P(:,3),P(:,4));
    
    InV = FV(x,y,z);
   
    iso_surf = isosurface(x,y,z,InV, 1);

points = [80 140 80; 40 60 20; 50 60 20; 50 60 20]; 


[distances,surface_points] = point2trimesh( iso_surf, 'QueryPoints', points);

patch(iso_surf,'FaceAlpha',.5); xlabel('x'); ylabel('y'); zlabel('z'); axis equal; hold on 
plot3M = @(XYZ,varargin) plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),varargin{:}); 
plot3M(points,'*r') 
plot3M(surface_points,'*k') 
plot3M(reshape([shiftdim(points,-1);shiftdim(surface_points,-1);shiftdim(points,-1)*NaN],[],3),'k')

% distance: x.
% C = 1-1/exp(x);
end

