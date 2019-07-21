function [A] = Visual_Isosurface(Dex,Boundary,Precision)
    xmin = Boundary(1,1); xmax = Boundary(1,2);
    ymin = Boundary(2,1); ymax = Boundary(2,2);
    zmin = Boundary(3,1); zmax = Boundary(3,2);


    [xx,yy,zz] = meshgrid(xmin:Precision:xmax,ymin:Precision:ymax,zmin:Precision:zmax);
    x = libpointer('doublePtr',xx);

    A = 1;

    F = scatteredInterpolant(Dex(:,1),Dex(:,2),Dex(:,3),Dex(:,4));
    InV = F(xx,yy,zz);
    iso_surf3 = isosurface(xx,yy,zz,InV, 0.5);
    pppp =  patch(iso_surf3);
    isonormals(xx,yy,zz,InV,pppp)
    pppp.FaceColor = 'black';
    pppp.EdgeColor = 'none';
    hold on;
    view(3)


end
