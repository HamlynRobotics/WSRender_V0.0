% Input:
% Option?
% opt.type = {'Environment','Placement','Parameters','Indices','All_Indices'};
% default?
% type = 'Environment';
% 
% Output:
% Config_file: List of robots
% Out: Struct, contents of config/environment txt files
% 
% Function:
% Read configurations
% 
% Example:
% [file_dir,Configs] = ReadFiles('Placement');

%%
function [Robots_Name,Out] = ReadFiles(varargin)
    opt.type = {'Environment','Placement','Parameters','Indices','All_Indices'};
    opt = tb_optparse(opt, varargin); 
    Robots_Name = {};
    addpath('../');
    Folder = pwd; 
    
    switch opt.type
        case 'Environment'
            File_Name = 'Env_config.txt';
            config_file = fullfile(Folder,'Config',File_Name);
            fileID = fopen(config_file,'r');

            while (~feof(fileID))
                tline = fgetl(fileID);
                if(tline == "#Desk")
                    tline = fgetl(fileID); Desk = str2num(tline);
                end
                if(tline == "#Frame")
                    tline = fgetl(fileID); Frame = str2num(tline);
                end
            end
            
            Out{1} = Desk; Out{2} = Frame;

        case 'Indices'
           
            p = 0;
            File_Name = 'Indices_config.txt';
            config_file = fullfile(Folder,'Config',File_Name);
            fileID = fopen(config_file,'r');
            while (~feof(fileID))
                    p = p + 1;
                    tline = fgetl(fileID);
                    Out{p} = tline;
            end
            
        case 'All_Indices' 
            p = 0;
            File_Name = 'All_Indices.txt';
            config_file = fullfile(Folder,'Config',File_Name);
            fileID = fopen(config_file,'r');
            while (~feof(fileID))
                    p = p + 1;
                    tline = fgetl(fileID);
                    Out{p} = tline;
            end
            
        case 'Parameters' 
            File_Name = 'Parameters_config.txt';
            config_file = fullfile(Folder,'Config',File_Name);
            fileID = fopen(config_file,'r');
            
             while (~feof(fileID))
                tline = fgetl(fileID);
                
                if(tline == "#Couple")
                    tline = fgetl(fileID); Out.Couple_Flag = str2num(tline);
                end
                if(tline == "#Joint Limit")
                    tline = fgetl(fileID); Out.Joint_Flag = str2num(tline);
                end
                if(tline == "#Mento Carlo")
                    tline = fgetl(fileID); Out.Mento_Flag = str2num(tline);
                end
                %{
                if(tline == "#Dynamic")
                    tline = fgetl(fileID); Out.Dynamic_Flag = str2num(tline);
                end
                %}
                if(tline == "#Iteration")
                    tline = fgetl(fileID); Out.Iteraction_Flag = str2num(tline);
                end    
               
                if(tline == "#Joint Num")
                    tline = fgetl(fileID); Out.Joint_Num = str2num(tline);
                end  
                
                if(tline == "#Precision")
                    tline = fgetl(fileID); Out.Precision = str2num(tline);
                end  
                
                if(tline == "#Error")
                    tline = fgetl(fileID); Out.Error = str2num(tline);
                end  
            
            end
            
            %Out{1} = Joint_Flag; Out{2} = Mento_Flag; Out{3} = Dynamic_Flag; Out{4} = Iteraction_Flag;
           % Out{5} = Couple_Flag; 
            
        case 'Placement'     
            File_Name = 'Rob_config.txt';
            config_file = fullfile(Folder,'Config',File_Name);
            fileID = fopen(config_file,'r');

            f = 0;r = 0;i = 1;T = eye(4);
            tline = fgetl(fileID);
                if(tline == "#Robot Number")
                    tline = fgetl(fileID);
                    robot_num = str2num(tline);
                    
                end
                
            tline = fgetl(fileID);            
            k = 1; 
            while (~feof(fileID))
                    tline = fgetl(fileID);
                    String = strcat("#Transformation Matrix",num2str(k));
                    if(tline == String)  
                        T = eye(4);
                        tline = fgetl(fileID);
                        f = 0;
                        r = 1;
                    end

                    if (r ~= 0 && isempty(tline) == 0)
                       
                        row = str2num(tline);
                        T(i,:) = row;
                        i = i+1;
                        if i == 5
                            Out{k} = T;              
                            r = 0;    k = k + 1;    i = 1; 
                         
                        end
                    end
            end
            Out{k} = robot_num;
            
            fileID = fopen(config_file,'r'); k = 1;
            while (~feof(fileID))
                       tline = fgetl(fileID);
                        String1 = strcat('#Robot Type',num2str(k));
                        Flag = strcmp(tline,String1);
                            if(Flag == 1)
                                tline = fgetl(fileID);
                                Robots_Name{k} = tline;
                                k = k + 1;
                            end
            end
            
            
    end
           
end

