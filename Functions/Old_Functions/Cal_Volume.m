function [VolumeSum,Percentage] = Cal_Volume(VDualArm)

[a,b,c] = size(VDualArm);
s = a*b*c;
D = reshape(VDualArm,[1,s]);
VolumeSum = sum(D);
Percentage = VolumeSum/s;
end

