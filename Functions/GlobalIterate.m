% Input:
% Parameters : the parameters for global indices calculation
% Robot : the targeted robot for analysis
% 
% Output:
% Dex : Local Indices distribution map
% Global_Indices: The final modified global indices
% i: number of joint that can lead to convergence
% Function:
% User Iterate Methods to generate evaluation value, until converge.


function [Dex,Global_Indices,i] = GlobalIterate(Robot,Parameters)
    Q = Robot.qlim;
    Error = Parameters.Error;
    
    Finish_Flag = 0;
    QUp = Q(:,2);  QDown = Q(:,1); 

    i = 5; k = 0;
    %[QS,Count]=GenerateJoint(Robot,'General','JointNum',5);
    
    [QS,Count] = Generate_Joint(Robot,Parameters.Couple,'General','JointNum',Parameters.Joint_Num);
    
    [Dex,path,O_Volume,Volume] = ReachableWS_Indices(Robot,QS,Parameters.Joint_Limit,'Indice',Parameters.Indice,'Off','UnSave');
    %Dex = ReachableWS(Robot,Count,QS,'On','UnSave');

    [N_Joint,~] = size(QS);
    %N_DoF = N_Joint;

    fileID = fopen('E:\\12-WSRender\\Data\\Global_M.txt','w');
    
    Volume = 0; 
    while(i<20)
        i = i + 1;
        %[QS,Count]=GenerateJoint(Robot,'General','JointNum',i);
        
        [QS,Count] = Generate_Joint(Robot,Parameters.Couple,'General','JointNum',i);
        
        %Dex = ReachableWS(Robot,Count,QS,'On','UnSave');
        
        [Dex,~,~,Temp_Volume] = ReachableWS_Indices(Robot,QS,Parameters.Joint_Limit,'Indice',Parameters.Indice,'Off','UnSave');

            if abs(Temp_Volume - Volume)<Error
                Out = 'Finish'
                [~,Global_Indices] = GlobalEvaluate(Dex);
                save(['E:\\12-WSRender\\Data\\Temp',num2str(i),'.mat',],'Dex');
                [Dex,~,~,Temp_Volume] = ReachableWS_Indices(Robot,QS,Parameters.Joint_Limit,'Indice',Parameters.Indice);
            [Indices,Global_Indices] = GlobalEvaluate(Dex);
                break
            else
                Volume = Temp_Volume;
            end


        %{
        fileID = fopen('E:\\12-WSRender\\Data\\Global_M.txt','a');
        nbytes = fprintf(fileID,'%d\r\n',i);

        Name = 'Global Manipulability:';
        nbytes = fprintf(fileID,'%s',Name);
        nbytes = fprintf(fileID,'%8f\r\n',Global_Indices(1));

        Name = 'Global Inverse Condition Number:';
        nbytes = fprintf(fileID,'%s',Name);
        nbytes = fprintf(fileID,'%8f\r\n',Global_Indices(2));

        Name = 'Global Minimal Singular Value:';
        nbytes = fprintf(fileID,'%s',Name);
        nbytes = fprintf(fileID,'%8f\r\n',Global_Indices(3));
     
        Name = 'Global Condition Number:';
        nbytes = fprintf(fileID,'%s',Name);
        nbytes = fprintf(fileID,'%8f\r\n',Global_Indices(4));
        %}
    end

end




