function [Data] = Read_Table(File_Name)
Folder = pwd;

filename = fullfile(Folder,'Data',File_Name);
           
fileID   = fopen(filename,'r');
data     = textscan(fileID, '%f %f %f %f\n');
Data = [data{1},data{2},data{3},data{4}];
end

