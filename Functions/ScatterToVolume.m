function[VDualArm,VLeft,VRight,Boundary,Volume_Size] = ScatterToVolume(Dex,Pre,BaseRight,BaseLeft,varargin)
    opt.evaluate = {'Manipulability','InverseCN','MSV'};
    opt.visual = {'Visual_Off','Visual_On'};
    opt.bimanual={'Single','BimanualRobot','BimanualArm'};
    opt = tb_optparse(opt, varargin);

    switch opt.evaluate
        case 'Manipulability'
    end
    
    switch opt.bimanual
        case 'BimanualArm'
            Left=[Dex(:,1)-20,Dex(:,2),Dex(:,3),Dex(:,4)];
            Right=[Dex(:,1),Dex(:,2),Dex(:,3),Dex(:,4)];
        case 'BimanualRobot'
            Left=[Dex(:,1) + BaseLeft(1) ,Dex(:,2) + BaseLeft(2),Dex(:,3) + BaseLeft(3) ,Dex(:,4)];
            Right=[Dex(:,1)+ BaseRight(1) ,Dex(:,2) + BaseRight(2),Dex(:,3) + BaseRight(3) ,Dex(:,4)];
    end
    
            [Count,~] = size(Right);
            Boundary = zeros(3,2);

            xminH = min(Left(:,1));xmaxH = max(Right(:,1));
            yminH = min(Left(:,2));ymaxH = max(Left(:,2));
            zminH = min(Left(:,3));zmaxH = max(Left(:,3));

            Boundary(1,1) = xminH; Boundary(1,2) = xmaxH;
            Boundary(2,1) = yminH; Boundary(2,2) = ymaxH;
            Boundary(3,1) = zminH; Boundary(3,2) = zmaxH;

            [xxH,yyH,zzH] = meshgrid(xminH:Pre:xmaxH,yminH:Pre:ymaxH,zminH:Pre:zmaxH);
            %% Make Grid 3D Volume Data
            [A, B, C] = size(xxH);
            Volume_Size = [A, B, C];

            VLeft = zeros(size(xxH)); VRight = zeros(size(xxH));
            %%
            for i = 1:1:Count
                aa(i)= round((Left(i,1)-xminH)/Pre);
                aaR(i)= round((Right(i,1)-xminH)/Pre);
                bb(i)= round((Left(i,2)-yminH)/Pre);
                cc(i)= round((Left(i,3)-zminH)/Pre);

                if cc(i) == 0 || cc(i)<0
                    cc(i)= 1;
                end

                if bb(i)==0 || bb(i)<0
                    bb(i)= 1;
                end
                if aaR(i)==0 || aaR(i)<0
                    aaR(i)= 1;
                end

                if aa(i)==0 || aa(i)<0
                    aa(i)= 1;
                end

                if cc(i) > C
                    cc(i)= C;
                end

                if bb(i) > A
                    bb(i)= A;
                end
                if aaR(i) > B
                    aaR(i)= B;
                end

                if aa(i) > B
                    aa(i)= B;
                end

                %V_Z = Zmin + c * Precision;

                VLeft(bb(i),aa(i),cc(i)) =Left(i,4);
                VRight(bb(i),aaR(i),cc(i)) =Right(i,4);
            end
                VDualArm = VLeft+VRight;

   

    switch opt.visual
        case 'Visual_Off'
            out = 'Visual Off'
        case 'Visual_On'
            
            iso_val = 0.5;
            iso_surfD = isosurface(xxH,yyH,zzH,VLeft,iso_val);
            pD = patch(iso_surfD,'FaceAlpha',0.3);
            isonormals(xxH,yyH,zzH,VLeft,pD)
            pD.FaceColor = 'green';
            pD.EdgeColor = 'none';
            hold on;
            
        
    end
    
end
