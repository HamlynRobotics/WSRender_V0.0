function[V_All,V_Group] = Scatter_Volume_Convert(Dex_Group,Pre,Boundary,Volume_Size,varargin)
    opt.mode = {'General','Intuitive','Manipulability','ICN','MSV'};
    opt = tb_optparse(opt, varargin);
    [~,Robot_Num] = size(Dex_Group);

    V_All = zeros(Volume_Size);
    A = Volume_Size(1);B = Volume_Size(2);C = Volume_Size(3);
    xminH =  Boundary(1,1); yminH = Boundary(2,1); zminH = Boundary(3,1);
    
    for k = 1:1:Robot_Num
        Dex = Dex_Group{k};
        [Count,~] = size(Dex);
        V_Data = zeros(Volume_Size);
        for i = 1:1:Count
            aa(i)= round((Dex(i,1)-xminH)/Pre);
            bb(i)= round((Dex(i,2)-yminH)/Pre);
            cc(i)= round((Dex(i,3)-zminH)/Pre);

            if cc(i) == 0 || cc(i)<0
                cc(i)= 1;
            end

            if bb(i)==0 || bb(i)<0
                bb(i)= 1;
            end

            if aa(i)==0 || aa(i)<0
                aa(i)= 1;
            end

            if cc(i) > C
                cc(i)= C;
            end

            if bb(i) > A
                bb(i)= A;
            end


            if aa(i) > B
                aa(i)= B;
            end

            V_Data(bb(i),aa(i),cc(i)) = Dex(i,4);
        
        end
               
        V_Group{k} = V_Data;  

        V_All = V_All + V_Group{k} ;
    end


    
end
