%Initial values
l1 = 0; l2 = 65; l3 = 65; l4 = 25.5; l5 = 35;
AxisMax = 150;
 WS_Range = [-AxisMax,AxisMax,-AxisMax,AxisMax,-AxisMax,AxisMax];
%L = (theta, d, a, alpha)
%L0 = Link('theta', 0, 'a', 0, 'alpha', 0);
%L1 = Link('theta', (pi)/2, 'a', 0, 'alpha', (pi)/2);
L2 = Link('theta', (pi)/2, 'a', 0, 'alpha', -(pi)/2);
L3 = Link('theta', 0, 'a', 0, 'alpha', (pi)/2); 
L4 = Revolute('d', 0, 'a', l4, 'alpha', -(pi)/2);
L5 = Link('theta', 0, 'a', 0, 'alpha', 0); 



r = SerialLink([L2 L3 L4 L5]);
r.qlim = ([0 40; l3 l3+40; -(pi)/4+(pi)/2 (pi)/4+(pi)/2; l5 l5+40]);
r.plotopt = {'workspace', WS_Range};
%r.teach

%% Robot Workspace Analysis
Couple_Flag = 1;
[QS,Count]=Generate_Joint(r,Couple_Flag,'JointNum',30);

% Reachable workspace + Lobal Evaluate
Flag = [0 0];
Dex = ReachableWS(r,Count,QS,Flag,'On','UnSave');

Dynamic_Flag = 0;
% General form for Global Evaluation
[Indices,Global_Indices] = GlobalEvaluate(Dex,Count,Dynamic_Flag);