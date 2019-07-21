function [out] = Draw_Invironment(varargin)
    
    opt.visual = {'off','Off','Desk_On','Frame_On','Both_On'};
    
    %{
    opt.desk = [];
    opt.frame = [];
    
    if isempty(opt.desk)
        desk = [60,40,50];
    else
        desk = opt.desk;
    end
    
    if isempty(opt.frame)
        frame = [40,40];
    else
        frame = opt.frame;
    end
    %}
    opt = tb_optparse(opt, varargin);

    [config_file,Out] = ReadFiles('Environment');
    desk = Out{1};
    frame =  Out{2};
    Desk_Length = desk(1); Desk_Width = desk(2); Desk_Height = desk(3); 
    Frame_Height = frame(1); Frame_Width = frame(2);
    delta = Desk_Length/10;
    out = 'no';
    switch opt.visual
        case 'Off'
            out = 'no environment';
            grid off;
            X=-Desk_Width:0.01:Desk_Width; Y=-Desk_Length:0.01:Desk_Length;
            [x,y]=meshgrid(Y,X); z1=x*0;
            s=surf(x,y,z1,'FaceColor','flat');
            s.EdgeColor = 'none';
            alpha(0.6);
            hold on;
            out = 'desk';
            
            
        case 'Desk_On'
            % Desk for placing robot
            plot3([Desk_Length/2,Desk_Length/2],[Desk_Width,Desk_Width],[-Desk_Height,0],'k','linewidth',3)
            hold on;
            plot3([-Desk_Length/2,-Desk_Length/2],[Desk_Width,Desk_Width],[-Desk_Height,0],'k','linewidth',3)
            hold on;
            plot3([-Desk_Length/2,-Desk_Length/2],[0,0],[-Desk_Height,0],'k','linewidth',3)
            hold on;
            plot3([Desk_Length/2,Desk_Length/2],[0,0],[-Desk_Height,0],'k','linewidth',3)
            hold on;

            X=0:0.01:Desk_Width; Y=-Desk_Length/2:0.01:Desk_Length/2;
            [x,y]=meshgrid(Y,X); z1=x*0;
            s=surf(x,y,z1,'FaceColor','flat');
            s.EdgeColor = 'none';
            alpha(0.6);
            hold on;
            out = 'desk';
            
        case 'Frame_On'
            % Framework for fixing robot
            plot3([-Frame_Width/2,Frame_Width/2],[0,0],[Frame_Height,Frame_Height],'r','linewidth',3);hold on;
            plot3([-Frame_Width/2,Frame_Width/2],[0,0],[0,0],'r','linewidth',3); hold on;
            plot3([-(Frame_Width/2-delta),-(Frame_Width/2-delta)],[0,0],[0,Frame_Height],'r','linewidth',3); hold on;
            plot3([(Frame_Width/2-delta),(Frame_Width/2-delta)],[0,0],[0,Frame_Height],'r','linewidth',3); hold on;
            out = 'frame';
            
        case 'Both_On'
            % Desk for placing robot            
            % Framework for fixing robot
            plot3([Desk_Length/2,Desk_Length/2],[Desk_Width,Desk_Width],[-Desk_Height,0],'k','linewidth',3); hold on;
            plot3([-Desk_Length/2,-Desk_Length/2],[Desk_Width,Desk_Width],[-Desk_Height,0],'k','linewidth',3); hold on;
            plot3([-Desk_Length/2,-Desk_Length/2],[0,0],[-Desk_Height,0],'k','linewidth',3); hold on;
            plot3([Desk_Length/2,Desk_Length/2],[0,0],[-Desk_Height,0],'k','linewidth',3);hold on;

            X=0:0.01:Desk_Width; Y=-Desk_Length/2:0.01:Desk_Length/2;
            [x,y]=meshgrid(Y,X); z1=x*0;
            s=surf(x,y,z1,'FaceColor','flat'); s.EdgeColor = 'none';
            alpha(0.6);  hold on;
            
            plot3([-Frame_Width/2,Frame_Width/2],[0,0],[Frame_Height,Frame_Height],'r','linewidth',3); hold on;
            plot3([-Frame_Width/2,Frame_Width/2],[0,0],[0,0],'r','linewidth',3); hold on;
            plot3([-(Frame_Width/2-delta),-(Frame_Width/2-delta)],[0,0],[0,Frame_Height],'r','linewidth',3); hold on;
            plot3([(Frame_Width/2-delta),(Frame_Width/2-delta)],[0,0],[0,Frame_Height],'r','linewidth',3); hold on;
            out = 'both';
    end

end