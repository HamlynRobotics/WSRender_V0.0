function [I] = Global_Integral(Dex,Precision)
x = Dex(:,1);y = Dex(:,2);z = Dex(:,3);d = Dex(:,4);

%F = TriScatteredInterp(x,y,z,d);
F = scatteredInterpolant(x,y,z,d);
X = min(x):Precision:max(x);
Y = min(y):Precision:max(y);
Z = min(z):Precision:max(z);
[qx,qy,qz] = meshgrid(X,Y,Z);
qd = F(qx,qy,qz); %estimated value of d
%f = find(isnan(qd));
%qd(f) = 0;

 % summation
% this reduces to computing the average if all dV are equal 
dV = Precision*Precision*Precision; 
I = sum(sum(sum(qd)))*dV;

 
 % trapezoidal
I = trapz(Z,qd,3);
I = trapz(Y,I);
I = trapz(X,I);

end

