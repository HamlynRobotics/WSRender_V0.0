function [Results] = Local_Evaluation(Index,N_DoF,Y,m,M,R)
    Results = 0;
    [U S V] = svd(Y); 
    hmmi = sqrt(1/trace(pinv(Y*transpose(Y))));
    SS = diag(S);    
    J = Y(1:3,:);
    Sum_Singular =  sqrt(det(J * J'));

    
    H = Y*M;    
    [U DS V] = svd(H);
    %Dynamic_SS = [DS(1,1),DS(2,2),DS(3,3),DS(4,4),DS(5,5),DS(6,6)]; 
    Dynamic_SS = diag(DS);
    Dynamic_Sum_Singular = sqrt( det(H*transpose(H)));
    Dynamic_hmmi = sqrt(1/trace(pinv(H*transpose(H))));
    
    switch Index
        case 'Manipulability' 
            Results = Sum_Singular * R;
        case 'Inverse Condition Number'
            Results = min(SS)/max(SS) * R;
        case 'Minimum Singular Value'
            Results = min(SS) * R;
        case 'Order-Independent Manipulability'
            Results = Sum_Singular.^(1/N_DoF);                    
        case 'Harmonic Mean Manipulability Index'
            Results = hmmi* R;   %                        
        case 'Isotropic Index'
            Results = Sum_Singular.^(1/N_DoF)/mean(SS)  * R; % 
        case 'Condition number'
            Results = max(SS)/min(SS) * R;   
        case 'Max Singular'
            Results = max(SS)* R;  

        case 'Dynamic Manipulability' 
            Results = m * R;
            Results = Dynamic_Sum_Singular * R;
            
        case 'Dynamic Inverse Condition Number'
            Results = min(Dynamic_SS)/max(Dynamic_SS) * R;
        case 'Dynamic Minimum Singular Value'
            Results = min(Dynamic_SS) * R;
        case 'Dynamic Order-Independent Manipulability'
            Results = Dynamic_Sum_Singular.^(1/N_DoF);                    
        case 'Dynamic Harmonic Mean Manipulability Index'
            Results = Dynamic_hmmi * R;                     
        case 'Dynamic Isotropic Index'
            Results = Dynamic_Sum_Singular.^(1/N_DoF)/mean(Dynamic_SS)  * R; % 
        case 'Dynamic Condition Number'
            Results = max(Dynamic_SS)/min(Dynamic_SS) * R;   
        case 'Dynamic Max Singular'
            Results = max(Dynamic_SS)* R;  
    end

end


