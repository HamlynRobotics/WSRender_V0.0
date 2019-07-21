%% Function for scaling the workspaces
% shows button for selection and winfdow for results

function  WS_scaling_GUI(ha,offset,scaling,master_WS,slave_WS,alpha)
% clear all
global scale;
global h_scale;
global h_scale_shp;
global iter;
global shp;
global shp_slave;
global off;
global vol_opt;
global scale_opt;
global off_opt;

global h_P0;


iter = 0;
vol_opt = 0;
off_opt = 0;

scale = scaling;
scale_opt = scale;

model_master = master_WS;
model_slave = slave_WS;

shp_slave = alphaShape(model_slave(:,1),model_slave(:,2),model_slave(:,3),alpha(2));
shp = alphaShape(model_master(:,1),model_master(:,2),model_master(:,3),alpha(1));

off = offset;
model_slave = model_slave.*repmat(scale,length(model_slave),1);
model_slave = model_slave+off ;

P0_slave= off;

global shp_slave_init;
shp_slave_init = alphaShape(model_slave(:,1),model_slave(:,2),model_slave(:,3),alpha(2));

% [~,P] = boundaryFacets(shp_slave_init);
P = shp_slave_init.Points;

bound_box_slave = P;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI
set(gcf,'CurrentAxes',ha)
%  ha = h_scaling;
% figure(f);
cla(ha);

%  ha = f.CurrentAxes;
ha.XLabel.String = 'x';
 ha.YLabel.String = 'y';
 ha.ZLabel.String = 'z';
 ha.XGrid = 'on';
 ha.YGrid = 'on';
 ha.ZGrid = 'on';
 view(3)
 
%% X
text(1,1)  = uicontrol('Style','text','String','X',...
    'Position',[780,600,35,25]);

p_control(1,1)    = uicontrol('Style','pushbutton',...
    'String','+','Position',[815,600,50,25],'Callback',{@button_Callback,ha},'tag','x');

m_control(1,1)    = uicontrol('Style','pushbutton',...
    'String','-','Position',[865,600,50,25],'Callback',{@button_Callback,ha},'tag','x');

%% Y
text(2,1)  = uicontrol('Style','text','String','Y',...
    'Position',[780,560,35,25]);

p_control(2,1)    = uicontrol('Style','pushbutton',...
    'String','+','Position',[815,560,50,25],'Callback',{@button_Callback,ha},'tag','y');

m_control(2,1)    = uicontrol('Style','pushbutton',...
    'String','-','Position',[865,560,50,25],'Callback',{@button_Callback,ha},'tag','y');

%% Z
text(3,1)  = uicontrol('Style','text','String','Z',...
    'Position',[780,520,35,25]);

p_control(3,1)    = uicontrol('Style','pushbutton',...
    'String','+','Position',[815,520,50,25],'Callback',{@button_Callback,ha},'tag','z');

m_control(3,1)    = uicontrol('Style','pushbutton',...
    'String','-','Position',[865,520,50,25],'Callback',{@button_Callback,ha},'tag','z');

%% offset
text_off  = uicontrol('Style','text','String','Offset',...
    'Position',[950,625,80,25]);

global input_offset;
input_offset = uicontrol('Style','edit',...
    'Position',[950,600,175,25]);

% input_offset.Max = 2;
input_offset.BackgroundColor =[1 1 1];
input_offset.String = num2str(off);

%% scaling 
 uicontrol('Style','text','String','Scaling',...
    'Position',[950,570,80,25]);

global input_scale;
input_scale = uicontrol('Style','edit',...
    'Position',[950,545,175,25]);

% input_offset.Max = 2;
input_scale.BackgroundColor =[1 1 1];
input_scale.String = num2str(scale);

%%

% Button for setting the desired offset and scaling
set_offset = uicontrol('Style','pushbutton',...
    'String','set','Position',[950,515,150,25],'Callback',{@button_Callback,ha},'tag','set_offScal');

%% Result

global text_res;
text_res = uicontrol('Style','edit',...
    'Position',[800,440,300,75]);

text_res.Max = 3;
text_res.BackgroundColor =[1 1 1];

global text_res_opt;
text_res_opt = uicontrol('Style','edit',...
    'Position',[800,370,300,75]);

text_res_opt.Max = 3;
text_res_opt.BackgroundColor =[1 1 1];

%%%%%%%%%%%%

hold on
h_scale = plot3(ha,bound_box_slave(:,1),bound_box_slave(:,2),bound_box_slave(:,3), '.y');
plot(shp,'FaceColor',[0.7 0.7 0.7],'EdgeColor','black','EdgeAlpha',0.3,'FaceAlpha',0.2)
h_scale_shp = plot(shp_slave_init,'FaceColor','yellow','EdgeColor','yellow','EdgeAlpha',0.3,'FaceAlpha',0.3);
h_P0 = plot3(ha,P0_slave(1),P0_slave(2),P0_slave(3),'.k','MarkerSize',20);
view(3)
hold off


end

%% CallBack for the push buttons

function button_Callback(source,eventdata,ha)
val = source.String;
dir = eventdata.Source.Tag;

global scale;
global h_scale;
global h_scale_shp;
global sol;
global iter;
global text_res;
global text_res_opt;
global vol_opt;
global scale_opt;
global input_offset;
global input_scale;

global off_opt;

global h_P0;
global off;

iter = iter+1;

ds = 0.01; % scaling discretization

delete(h_scale);
delete(h_scale_shp);
delete(h_P0);


if val == '+' % plus button
    
    n = 0;
    
elseif val == '-' % minus button
    
    n = 1;
end

switch dir % direction 
    case 'x'
        scale(1) = scale(1)+(-1)^n*ds;
    case 'y'
        scale(2) = scale(2)+(-1)^n*ds;
    case 'z'
        scale(3) = scale(3)+(-1)^n*ds;
end

if (dir == "set_offScal") % if set button pressed
    
    off = str2num(input_offset.String);
    scale = str2num(input_scale.String);
end

[check,Volume,bound_box_slave] = resize(); % recomputed scaled WS

% slave inside master
if check == 1
    
    % better volume obtained?
    if Volume >= vol_opt
        vol_opt = Volume;
        scale_opt = scale;
        off_opt = off;
    end
    
    text_res.BackgroundColor =[0 1 0];
    
    sol(iter,:) = [scale Volume];
    
    str1 = num2str(scale);
    str1 = strcat("scale = ",str1);
    str2 = num2str(Volume);
    str2 = strcat(" volume = ",str2);
    str = str1+newline+str2;
    
    set(text_res,'String',str);
    
    
    str_opt = num2str(scale_opt);
    str_opt = strcat("Optimal scale = ",str_opt);
    
    str_opt = str_opt+newline+strcat("Optimal Vol = ",num2str(vol_opt))+newline;
    str_opt = str_opt+strcat(" Optimal off = ",num2str(off_opt));
    set(text_res_opt,'String',str_opt);
    
    hold on
    h_scale = plot3(ha,bound_box_slave(:,1),bound_box_slave(:,2),bound_box_slave(:,3), '.g','LineWidth',4);
    h_P0 = plot3(off(1),off(2),off(3),'.k','MarkerSize',20);
    hold off
else
    
    % salve outside master
    
    text_res.BackgroundColor =[1 0 0];
    set(text_res,'String',"out of WS"+newline+"scale = "+ num2str(scale));
    
    hold on
    h_scale = plot3(ha,bound_box_slave(:,1),bound_box_slave(:,2),bound_box_slave(:,3), '.r','LineWidth',4);
        h_P0 = plot3(off(1),off(2),off(3),'.k','MarkerSize',20);
    hold off
end

end

% recompute WS with scaling and offset

function [check,V,bound_box_slave] = resize()
global scale;
global off;
global shp_slave;
global shp_slave_init;

% slave WS points

P = shp_slave.Points;

% scale shape
P = P.*repmat(scale,length(P),1);

% translate shape
 P = P+off;

 % new volume
shp_slave_init.Points = P;

 %V = shp_slave_init.volume; % more accurate bu slower
 
 [~,V] = boundary(P(:,1),P(:,2),P(:,3),1); % to speed up computation but
%  more approximtaed
 
 % checking condition
 check = check_in_WS(P);

 % new WS pointcloud (not reproduced as alphashape for speed issues)
bound_box_slave = P;

end

% slave in master WS checking
function check = check_in_WS(Pv)
global shp;

check = 1;


in_shape = inShape(shp,Pv);
        
        if any(in_shape == 0) %at least one point on each segment outside shape
            check = 0;
        end

end

