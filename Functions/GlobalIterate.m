
function [Dex] = GlobalIterate(Robot,Error)
    Q = Robot.qlim;
    Finish_Flag = 0;
    QUp = Q(:,2);  QDown = Q(:,1); 

    i = 15; k = 0;
    [QS,Count]=GenerateJoint(Robot,'General','JointNum',5);
    Dex = ReachableWS(Robot,Count,QS,'On','UnSave');
    [N_Joint,~] = size(QS);
    %N_DoF = N_Joint;

    fileID = fopen('E:\\12-WSRender\\Data\\Global_M.txt','w');
    
    Buffer_Indices=[0 0 0];
    while(i<20)
        i = i + 1;
        [QS,Count]=GenerateJoint(Robot,'General','JointNum',i);
        Dex = ReachableWS(Robot,Count,QS,'On','UnSave');
        [Global_Indices] = GlobalEvaluate(Dex,Count);
        save(['E:\\12-WSRender\\Data\\Dan',num2str(i),'.mat',],'Dex');
        [~,n] = size(Global_Indices);
        for I = 1:1:n
            if(Buffer_Indices(I) - Global_Indices(I))<Error
                Finish_Flag = Finish_Flag + 1;
            end
        end
            
        if Finish_Flag ==  n
                Out = 'Finish'
                break
        end
        
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
    end

end







%{

function [Dex] = GlobalIterate(N_DoF,Robot)
    Q = Robot.qlim;
    QUp = Q(:,2);  QDown = Q(:,1); 

    i = 1; k = 0;
    [QS,Count]=GenerateJoint(N_DoF,Robot,'General','JointNum',5);
    Dex = ReachableWS(Robot,Count,QS,'On','UnSave');
    [N_Joint,~] = size(QS);
    max_k = 100000
    fileID = fopen('E:\\20_Temp\\Global_M.txt','w');

    while(k<10000)
        i = i + 1
        k = 0;
        % N_Joint = 2 * N_Joint - 1;
        for j = 1:1:(N_Joint-1)
            k = k + 1;
            New_QS(k,:) = QS(j,:);
            New_Dex(k,:) = Dex(j,:);
            
            k = k + 1;
            New_QS(k,:) = (QS(j,:)+ QS((j+1),:))/2;
            TQS= Robot.fkine(New_QS(k,:));
            New_Dex(k,1) = TQS(1,4); New_Dex(k,2) = TQS(2,4); New_Dex(k,3) = TQS(3,4);
            Y = jacob0(Robot,New_QS(k,:));
            [U S V] = svd(Y);
            SS = [S(1,1),S(2,2),S(3,3),S(4,4),S(5,5),S(6,6)]; 
            New_Dex(k,4) = S(1,1)*S(2,2)*S(3,3)*S(4,4)*S(5,5)*S(6,6);
            New_Dex(k,5) = min(SS)/max(SS);
            New_Dex(k,6) = min(SS);

           
            k = k + 1;
            New_QS(k,:) = QS((j+1),:);   
            New_Dex(k,:) = Dex((j+1),:);
        end
        
        save(['E:\\20_Temp\\DanSmall',num2str(i),'.mat',],'New_Dex');
        QS = New_QS;
        Dex = New_Dex;
        [N_Joint,~] = size(QS);

        Dex(:,4) = Dex(:,4)/max(Dex(:,4));
        Dex(:,5) = Dex(:,5)/max(Dex(:,5));
        Dex(:,6) = Dex(:,6)/max(Dex(:,6));

        Global_Manipulability = sum(Dex(:,4))/N_Joint;
        Global_Condition = sum(Dex(:,5))/N_Joint;
        Global_MSV = sum(Dex(:,6))/N_Joint;


        fileID = fopen('E:\\20_Temp\\Global_M.txt','a');
        nbytes = fprintf(fileID,'%d\r\n',i);

        Name = 'Global Manipulability:';
        nbytes = fprintf(fileID,'%s',Name);
        nbytes = fprintf(fileID,'%8f\r\n',Global_Manipulability);

        Name = 'Global Condition Number:';
        nbytes = fprintf(fileID,'%s',Name);
        nbytes = fprintf(fileID,'%8f\r\n',Global_Condition);

        Name = 'Global Minimal Singular Value:';
        nbytes = fprintf(fileID,'%s',Name);
        nbytes = fprintf(fileID,'%8f\r\n',Global_MSV);

    end
end

%}