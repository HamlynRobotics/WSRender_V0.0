function [RightRobot,LeftRobot,BaseRight,BaseLeft,Global_Indices,Dex] = Single_Bimanual_Construction(Type,Joint_Num)
[RightRobot,LeftRobot,~] = Multi_Bimanual_Construction(Type,1);
% Initial Parameters
[Length_Sum,Prismatic_Num,Precision] = Initial_Precision(RightRobot);
[Global_Indices,Dex,O_Volume] = Workspace_Analysis(RightRobot,Joint_Num,Type);


[BaseRight,BaseLeft] = Base_Define(Type);
end



