function [Flag] = Draw_Arrow(P1,P2,Mode)

if Mode == 1
    plot3([P1(1),P2(1)],[P1(2),P2(2)],[P1(3),P2(3)],'r','linewidth',10)
hold on

[x,y,z]=ellipsoid(0,0,0,5,5,5) ;
surf((P2(1)+x),(P2(2)+y),(P2(3)+z)) ;
grid off;
re=[1 0.5 0];
colormap(re);
hold on
end

if Mode == 2
    plot3([P1(1),P2(1)],[P1(2),P2(2)],[P1(3),P2(3)],'b','linewidth',1)
hold on

plot3(P2(1),P2(2),P2(3),'ro','MarkerSize',3)
hold on
Flag = 1;

end



%{
P1 = [0,0,0]; P2 = [0,0,2];
Flag = 1;
figure; hold on; axis equal;
for k = 1:13
    x(k)=0.05*cos(pi/180*k*30);
    y(k)=0.05*sin(pi/180*k*30);
    z(k)=1.8;
    plot3([P2(1),x(k)],[P2(2),y(k)],[P2(3),z(k)])
end
plot3([P1(1),P2(1)],[P1(2),P2(2)],[P1(3),P2(3)]);
plot3(x,y,z); view(3)
%}
end

