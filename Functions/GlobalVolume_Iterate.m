function [Volume,Pre] = GlobalVolume_Iterate(Dex,Index_Num,Error)
Precision = 0.01;
i = 0;
Volume  = 0;
    while i < 49
        i = i + 1; Pre = Precision - i * 0.0002;
            [V,Boundary,Volume_Size] = New_ScatterToVolume(Dex,Pre,Index_Num,'UnSave');
            [TransferRight,TransferLeft,TransferDual] = Visualize_New_VolumeData(Boundary,V,V,Volume_Size,Pre ,'Off');
            [Volume_Temp] = Boundary_WS(TransferRight,0.1,'off')
        if abs(Volume - Volume_Temp) < Error
            break;
        else
            Volume = Volume_Temp;
        end
    end
end

