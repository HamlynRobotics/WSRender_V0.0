function [R] = Joint_Limitation(qPtr,qUp,qDown,N)

Qjoint=get(qPtr,'value');
QLimUp=get(qUp,'value');
QLimDown=get(qDown,'value');

 p = 1;
 
for i = 1: 1: N
     t= ( QLimUp(i) - QLimDown(i)) * (QLimUp(i) - QLimDown(i));
     T1 =  (Qjoint(i)-QLimDown(i)) ;
     T2 = (QLimUp(i)-Qjoint(i));
     p = p * T1 * T2 / t * 5;
end

 R = 1 - exp(-p);
 
end

