function [Out] = AlphaShape_WS(Dex,alpha)
    Out = 1;
    shp = alphaShape(Dex(:,1),Dex(:,2),Dex(:,3),alpha);
    plot(shp)
    axis equal
end

