function [Evaluation_Index] = Choose_Indices(pop)
    switch pop
        case 1
            Evaluation_Index = 'Manipulability';
        case 2
            Evaluation_Index = 'Inverse Condition Number';
        case 3
            Evaluation_Index = 'Singular Minimal Value';
        case 4 
            Evaluation_Index = 'Condition Number';
        case 5
            Evaluation_Index = 'Order-Independent Manipulability'; 
        case 6 
            Evaluation_Index = 'Dynamic Manipulability'; 
        case 7 
            Evaluation_Index = 'Dynamic Singular Value'; 
        case 8 
            Evaluation_Index = 'Workspace Volume'; 
        case 9
            Evaluation_Index = 'Structure Length Index'; 
    end
end


