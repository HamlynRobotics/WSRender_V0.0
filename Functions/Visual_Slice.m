function [out] = Visual_Slice(V,Boundary_Single,Precision,varargin)
    opt.X = [];
    opt.Y = [];
    opt.Z = [];
    opt = tb_optparse(opt, varargin);
    
    if isempty(opt.X)
        xslice = 0;   
    else
        xslice = opt.X;
    end

    if isempty(opt.Y)
        yslice = [];   
    else
        yslice = opt.Y;
    end
    
    if isempty(opt.Z)
        zslice = []; 
    else
        zslice = opt.Z;
    end
    
    xminH = Boundary_Single(1,1); xmaxH = Boundary_Single(1,2);
    yminH =  Boundary_Single(2,1); ymaxH = Boundary_Single(2,2);
    zminH = Boundary_Single(3,1); zmaxH = Boundary_Single(3,2);

    [X,Y,Z] = meshgrid(xminH:Precision:xmaxH,yminH:Precision:ymaxH,zminH:Precision:zmaxH);

    out = 1;
    slice(X,Y,Z,V,xslice,yslice,zslice,'nearest')
end

