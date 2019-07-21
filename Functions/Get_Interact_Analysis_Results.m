function [Max_Results,Results,Results_Map] = Get_Interact_Analysis_Results(Boundary,Volume_Size,Precision,Transfer_Group,Mode)

    Dimention = 11;

    Results = zeros(3,3);
    p = 0;
    Results_Map=zeros( Dimention, Dimention);

    ny = 0; nz = 0;
    for y = -0.1:0.02:0.1
        for z = -0.1:0.02:0.1
            nz = nz + 1;
            Vary_Base = [0,y,z,0,0,0];
            p = p+1;
            Results(p,1) = y; Results(p,2) = z; 
            [Volume_All,~,~] = Optimized_Interaction_Analysis(Transfer_Group,Boundary,Volume_Size,Precision,Vary_Base,Mode);
            Results(p,3) = Volume_All;
        end
    end

    p = 0;
    for i = 1:1: Dimention
        for j = 1:1: Dimention
            p = p + 1;
            Results_Map(i,j) = Results(p,3);
        end
    end

    [M,I]=max(Results(:,3));
    Y_Max = Results(I,1);    Z_Max = Results(I,2);
    Max_Results=[Y_Max,Z_Max,M];

end

