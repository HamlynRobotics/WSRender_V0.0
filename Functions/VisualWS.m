% Input:
% Dex: local indices distribution map
% 
% Option:
%     opt.evaluate = {'Reachable','Local_Indices'};
%     opt.robotnum = {'SingleArm','Bimanual'};
%     opt.vector = [];
%     opt.Index = [];
%     opt.color = {'y','g','r','b'};
%     
% Output:
% Out: default 1
% 
% Function:
% Visualization and rendering of the workspace


function [out] = VisualWS(Dex,varargin)
    opt.evaluate = {'Reachable','Local_Indices'};
    opt.robotnum = {'SingleArm','Bimanual'};
    opt.color = {'y','g','r','b'};
    opt.vector = [];
    opt.Index = [];
    opt = tb_optparse(opt, varargin);
    out = 1;
    if isempty(opt.vector)
        Vector = zeros(1,6);
    else
        Vector = opt.vector;
    end

    if isempty(opt.Index)
        Num = 4;
    else
        Num = opt.Index;
    end

    switch opt.evaluate
        case 'Reachable'
            switch opt.robotnum
                case 'SingleArm'
                    plot3(Dex(:,1),Dex(:,2),Dex(:,3),opt.color); hold on;
                case 'Bimanual'
                    %plot3(Dex(:,1)+Vector(1),Dex(:,2)+Vector(2),Dex(:,3)+Vector(3),'*g'); hold on;  
                    %plot3(Dex(:,1)+Vector(4),Dex(:,2)+Vector(5),Dex(:,3)+Vector(6),'*y'); hold on;  

                    Dex_Right = [Dex(:,1)+Vector(1),Dex(:,2)+Vector(2),Dex(:,3)+Vector(3)];
                    Dex_Left  = [Dex(:,1)+Vector(4),Dex(:,2)+Vector(5),Dex(:,3)+Vector(6)];
                    shp = alphaShape(Dex_Right(:,1:3)); shp_left = alphaShape(Dex_Left(:,1:3));
                    plot(shp,'FaceColor','b','FaceAlpha',0.1,'EdgeColor','b','EdgeAlpha',0.1); hold on;
                    plot(shp_left,'FaceColor','b','FaceAlpha',0.1,'EdgeColor','b','EdgeAlpha',0.1); hold on;

            end
            
        case 'Local_Indices'
            
            switch opt.robotnum
                case 'SingleArm'
                    out = 1; 
                    caxis([0 1]); set(gcf,'color','w'); 
                    grid off;hold on; axis off;hold on;
                    scatter3(Dex(:,1),Dex(:,2),Dex(:,3),5,Dex(:,Num));
                    camlight('headlight','infinite')
                    hold on; colorbar; 
                case 'Bimanual'
                    out = 1; 
                    %colormap(jet); 
                    colorbar; caxis([0 1]); set(gcf,'color','w'); 
                    grid off;hold on; axis off;hold on;
                    scatter3(Dex(:,1)+Vector(1),Dex(:,2)+Vector(2),Dex(:,3)+Vector(3),5,Dex(:,Num));
                    hold on;
                    scatter3(Dex(:,1)+Vector(4),Dex(:,2)+Vector(5),Dex(:,3)+Vector(6),5,Dex(:,Num));
                    camlight('headlight','infinite')
            end
            

    end

end

