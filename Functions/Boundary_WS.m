function [v] = Boundary_WS(Dex,Value,varargin)
    Data = [Dex(:,1),Dex(:,2),Dex(:,3)];
    opt.color = {'r','b','g','off'};
    opt = tb_optparse(opt, varargin);
    [k,v]  = boundary(Data,1);
    
    switch opt.color
        case 'r'
            trisurf(k,Dex(:,1),Dex(:,2),Dex(:,3),'EdgeAlpha',0.5,'LineWidth',0.2,'EdgeColor','r','Facecolor','r','FaceAlpha',Value)
            hold on;
        case 'b'
            trisurf(k,Dex(:,1),Dex(:,2),Dex(:,3),'EdgeAlpha',0.5,'LineWidth',0.2,'EdgeColor','b','Facecolor','b','FaceAlpha',Value)
            hold on;
        case 'g'
            trisurf(k,Dex(:,1),Dex(:,2),Dex(:,3),'EdgeAlpha',0.5,'LineWidth',0.2,'EdgeColor','g','Facecolor','g','FaceAlpha',Value)
            hold on;
    end
end
