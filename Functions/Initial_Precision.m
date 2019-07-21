function [length_sum,Prismatic_Num,Precision,Error] = Initial_Precision(Robot)
    %[N_DoF,~] = size(Robot.qlim);
    Q = Robot.qlim;
    length_sum = 0;

    
    [~,N_DoF] = size(Robot.config);
    Prismatic_Num = 0;
    for i = 1:1:N_DoF
        if Robot.config(i) ~= 'R'
            Prismatic_Num = Prismatic_Num + 1;
        end
    end

    if Prismatic_Num == 0
        for i = 1:1:N_DoF
            length_sum = length_sum + Robot.links(1,i).a + Robot.links(1,i).d ;
        end
    else
        
        for i = 1:1:N_DoF
            length_sum = length_sum + Robot.links(1,i).a + Robot.links(1,i).d ;
        end
        
        for i = 1:1:N_DoF
            if Robot.config(i) ~= 'R'
                P_I = i;
                length_sum =  Q(P_I,2);
            end
        end
    
    end
    Precision = length_sum/20;Error = length_sum/1000;
    
end

