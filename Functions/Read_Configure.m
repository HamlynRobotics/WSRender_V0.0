function [B] = Read_Configure(File_Name)
addpath('../');
Folder = pwd;
Target_file = fullfile(Folder,'Data',File_Name);         
fileID = fopen(Target_file,'r');
A = textscan(fileID, '%f %f %f \r\n');
fclose(fileID);
B = [cell2mat(A(1,1)),cell2mat(A(1,2)),cell2mat(A(1,3))];
end

