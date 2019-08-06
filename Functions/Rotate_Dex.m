% Input:
% Dex: local indices distribution map
% Angle: rotation degree
% 
% Output:
% New_Dex: the new local indices distribution map after rotation
% 
% Function:
% Rotate the local indices distribution map

%%
function [New_Dex] = Rotate_Dex(Dex,Angle,varargin)
    New_Dex = Dex; [Count,~] = size(Dex);
    opt.axis = {'z','x','y'};
    opt.vector = [];
    opt = tb_optparse(opt, varargin);
    switch opt.axis
        case 'z'
            for i = 1:1:Count
                New_Dex(i,1:3) = Dex(i,1:3) * rotz(Angle);
            end
        case 'x'
            for i = 1:1:Count
                New_Dex(i,1:3) = Dex(i,1:3) * rotx(Angle);
            end            
        case 'y'
            for i = 1:1:Count
                New_Dex(i,1:3) = Dex(i,1:3) * roty(Angle);
            end            
    end                     
end

