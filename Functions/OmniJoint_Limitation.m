function [R] = Joint_Limitation(qPtr,qUp,qDown,N)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Qjoint=get(qPtr,'value');
QLimUp=get(qUp,'value');
QLimDown=get(qDown,'value');



 p = 1;
 
for i = 1: 1: N
    if i == 3
        
        [ QLimDown(i),QLimUp(i)] = Vary_Joint_Limits(Qjoint(2));
    end
     t= ( QLimUp(i) - QLimDown(i)) * (QLimUp(i) - QLimDown(i));
     p = p * (Qjoint(i)-QLimDown(i)) * (QLimUp(i)-Qjoint(i)) / t * 10;
end

 R = 1 - exp(-p);
 
end



