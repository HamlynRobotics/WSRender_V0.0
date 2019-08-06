% Input:
% Dex: local indices distribution map
% Pre: precision
% opt.evaluate = {'Manipulability','InverseCN','MSV','ConditionNumber','OI_Manipulability','Reachable'};
% 
% Output:
% V: the obtained volume data
% Boundary: the boundary of the volume data
% Volume_Size: the size of the volume data
% 
% Function:
% Convert single manipulator’s local indices distribution map to volume data mode. 


function [V,Boundary,Volume_Size] = SingleScatterToVolume(Dex,Pre,varargin)
    opt.evaluate = {'Manipulability','Inverse Condition Number','MSV','ConditionNumber','OI_Manipulability','Reachable'};
    opt.Path = [];
    opt = tb_optparse(opt, varargin);
    
    [Count,~] = size(Dex);
    Boundary = zeros(3,2);
    
    if isempty(opt.Path)
        filename = 'Volume_Data';   path = '.\\Data\\Volume_Data';           
    else
        filename = opt.Path; addpath('../'); Folder = pwd;
        path = fullfile(Folder,'Data',[filename, num2str(Count)]);
    end
    


    xminH = min(Dex(:,1));xmaxH = max(Dex(:,1));
    yminH = min(Dex(:,2));ymaxH = max(Dex(:,2));
    zminH = min(Dex(:,3));zmaxH = max(Dex(:,3));

    Boundary(1,1) = xminH; Boundary(1,2) = xmaxH;
    Boundary(2,1) = yminH; Boundary(2,2) = ymaxH;
    Boundary(3,1) = zminH; Boundary(3,2) = zmaxH;

    [xxH,yyH,zzH] = meshgrid(xminH:Pre:xmaxH,yminH:Pre:ymaxH,zminH:Pre:zmaxH);
    %% Make Grid 3D Volume Data

    [A,B,C] = size(xxH);
    
    
    Volume_Size = [A,B,C];
    V = zeros(Volume_Size);
    Flag = 1;
    switch opt.evaluate
        case 'Manipulability'
            Flag = 4;
        case 'InverseCN'
            Flag = 5;   
        case 'MSV'
            Flag = 6;  
        case 'ConditionNumber'
            Flag = 7; 
        case 'OI_Manipulability'
            Flag = 8; 
        case 'Reachable'
            Flag = 0;  
    end

    for i = 1:1:Count
        aa(i)= round((Dex(i,1)-xminH)/Pre);
        bb(i)= round((Dex(i,2)-yminH)/Pre);
        cc(i)= round((Dex(i,3)-zminH)/Pre);

        if cc(i) == 0 || cc(i)<0
            cc(i)= 1;
        end

        if bb(i)==0 || bb(i)<0
            bb(i)= 1;
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

        if aa(i) > B
            aa(i)= B;
        end
        
        if Flag == 0
            V(bb(i),aa(i),cc(i)) = 1;
        else
            V(bb(i),aa(i),cc(i)) =Dex(i,Flag);
        end
    end
    
    
     switch opt.save
        case 'Save'
            save(path,'V');
        case 'UnSave'
            path = 'N'; 
            out = 'UnSave';
    end

end

