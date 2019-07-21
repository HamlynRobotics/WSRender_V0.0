function [TransferDual,Volume] = Visualize_SingleVolumeData(Boundary,V,Volume_Size,Precision,varargin)
    opt.evaluate = {'Reachable'};
    opt.visual = {'Bimanual','Seperate','Scatter'};
  
    opt = tb_optparse(opt, varargin);


    
    xminH = Boundary(1,1);yminH = Boundary(2,1);zminH = Boundary(3,1);
    VDualArm = V;
    Pre = Precision;
    A = Volume_Size(1);B = Volume_Size(2);C = Volume_Size(3);
    Total = A * B * C;
    %TransferDual = zeros(Total,3);
    NumC = 0;
    for i = 1:1:A
        for j = 1:1:B
            for k = 1:1:C
                if VDualArm(i,j,k) ~=0
                    NumC = NumC+1;
                    TransferDual(NumC,1) = xminH + Pre*(j-1);
                    TransferDual(NumC,2) = yminH + Pre*(i-1);
                    TransferDual(NumC,3) = zminH + Pre*(k-1);
                    TransferDual(NumC,4) = VDualArm(i,j,k);
                end
            end
        end
    end
[Volume] = Boundary_WS(TransferDual,0.1,'g');
    switch opt.evaluate
        case 'Reachable'
            TransferDual(:,4) = 1;
            plot3(TransferDual(:,1),TransferDual(:,2),TransferDual(:,3),'*y');
            hold on;
        otherwise
            colormap(jet);
            colorbar;
            caxis([0 1]);
            set(gcf,'color','w'); 
            grid off;hold on;
            axis off;hold on;
            scatter3(TransferDual(:,1),TransferDual(:,2),TransferDual(:,3),5,TransferDual(:,4));
            camlight('headlight','infinite')
            hold on;
    end

 
end
