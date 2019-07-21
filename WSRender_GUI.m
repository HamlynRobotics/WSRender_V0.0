function varargout = WSRender_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WSRender_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @WSRender_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before WSRender_GUI is made visible.
function WSRender_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
currentFolder = pwd;
addpath(genpath(currentFolder));

handles.output = hObject;
guidata(hObject, handles);

if strcmp(get(hObject,'Visible'),'off')
    axes(handles.axes2);
    axes(handles.axes1);
    plot(rand(5));
    cla;
    set(handles.axes1,'Visible', 'on');
    set(handles.axes2,'Visible', 'on');
end

% UIWAIT makes WSRender_GUI wait for user response (see UIRESUME)
 %uiwait(handles.figure1);
 %uiwait(handles.figure2);

% --- Outputs from this function are returned to the command line.
function varargout = WSRender_GUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)
delete(handles.figure2)


%% Clear Figure
function ClearFigure_Callback(hObject, eventdata, handles)
cla(handles.axes1)
cla(handles.axes2)


%% Button?System Type
% Analysis Type
% Single Robot Analysis
% Dual-Arm Robot Analysis
% Master-Slave Mapping
% Multi-Robots Interaction

function SystemType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in SystemType.
function SystemType_Callback(hObject, eventdata, handles)



%% Select Robot
function SelectRobot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SelectRobot_Callback(hObject, eventdata, handles)

%% Select Environment
% floor
% table
% frame
% define

function Environment_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Environment_Callback(hObject, eventdata, handles)



%% Configure
% Wrap up important parameters
function Configure_Callback(hObject, eventdata, handles)

% Load Robot Local Indice Map
global Dex;
global RobotType;
addpath('../');
File=load('.\\Data\\LocalIndice_Map.mat'); 
Dex = File.Dex;
File=load('.\\Data\\Joint_Map.mat');
Dex = File.QS;
% Template

%dlmwrite('myFile.txt', File, 'delimiter','\t');


global Initial_Config; global Indice_Group; global All_Indice;
Initial_Config.Environment= get(handles.Environment, 'Value');
Initial_Config.RobotType = get(handles.SelectRobot, 'Value');
Initial_Config.Analysis_Type = get(handles.SystemType, 'Value');

if Initial_Config.RobotType > 11
    [~,RobotType] = Robot_Library(Initial_Config.RobotType);
else
    [RobotType,~] = Robot_Map(Initial_Config.RobotType); 
end
    
set(handles.RobotType,'String',RobotType);

switch Initial_Config.Analysis_Type
    case 3
      runWSGUI()
      % GUI
    case 4
      MultiRobot_GUI
end


% Load Robot Placement Information
global Robot_Placement;
[Robots_Name,Configs] = ReadFiles('Placement');
[~,n] = size(Configs); 
Robot_Num = Configs{n};

[~,Parameters] = ReadFiles('Parameters');
Initial_Config.Couple_Flag = Parameters.Couple_Flag;
Initial_Config.MentoCarlo = Parameters.Mento_Flag; 
Initial_Config.Iteration = Parameters.Iteraction_Flag; 
Initial_Config.Joint_Flag = Parameters.Joint_Flag;

[~,Indice_Group] = ReadFiles('Indices');
[~,All_Indice] = ReadFiles('All_Indices');


for j = 1:1:Robot_Num
    T = Configs{j};    Euler = rotm2eul( T(1:3,1:3));
    %  rotm = eul2rotm(eul)
    Robot_Placement{j} = [T(1,4),T(2,4), T(3,4),Euler(1),Euler(2),Euler(3)];
end

% Draw Environment
axes(handles.axes1);[~,Env_Type] = Robot_Map(Initial_Config.Environment,'Environment'); 
Draw_Invironment(Env_Type);
set(handles.Status,'String','Finished Configure.');


%% --- Executes on button press in IterationMethod.
function IterationMethod_Callback(hObject, eventdata, handles)
global Initial_Config; Initial_Config.Iteration = get(hObject,'Value');

%% --- Executes on button press in MentoCarlo.
function MentoCarlo_Callback(hObject, eventdata, handles)
global Initial_Config; Initial_Config.MentoCarlo = get(hObject,'Value');

%% --- Executes on button press in JointLimit.
function JointLimit_Callback(hObject, eventdata, handles)
global Initial_Config; Initial_Config.Joint_Flag = get(hObject,'Value');

%% --- Executes on button press in Couple.
function Couple_Callback(hObject, eventdata, handles)
global Initial_Config;Initial_Config.Couple_Flag = get(hObject,'Value');



%% Robot Construction
function BuildRobot_Callback(hObject, eventdata, handles)
    global Initial_Config;global LeftRobot;global Robot;global N_DoF; 
    global Robot_Placement; global BaseRight; global BaseLeft; global Bimanual_Vector;
    
    
    Bimanual = Initial_Config.Analysis_Type - 1;
    
    if Initial_Config.RobotType > 11
        [Robot,RobotType] = Robot_Library(Initial_Config.RobotType);
    else
        [RobotType,~] = Robot_Map(Initial_Config.RobotType); 
       [N_DoF,Robot] = BuildRobot(RobotType);
    end
            
    [Length_Sum,Prismatic_Num,Precision,Error] = Initial_Precision(Robot); 
    Initial_Config.Precision = Precision; Initial_Config.Error = Error;
    
    set(handles.InputJoint,'String','15'); % Joint Sampling Number
    
    set(handles.ErrorInput,'String',num2str(Error)); % Error
    set(handles.PrecisionInput,'String',num2str(Precision)); % Precision
    
    switch Bimanual
        case 0
            set(handles.Status,'String','Single Robot');
            axes(handles.axes1);  
            Base = Robot_Placement{1};        
            PlaceRobot(Robot,Length_Sum,'On','base',Base);                
        case 1
            axes(handles.axes1);
            [~,Robot] = BuildRobot(RobotType); [~,LeftRobot] = BuildRobot(RobotType);
            [BaseRight,BaseLeft] = Base_Define(RobotType);
            [Length_Sum,Prismatic_Num,Precision] = Initial_Precision(Robot); 
            for j = 1:1:2      
                Configure_Info = Robot_Placement{j};
                X = Configure_Info(1);Y = Configure_Info(2);Z = Configure_Info(3);
                RX = Configure_Info(4);RY = Configure_Info(5);RZ = Configure_Info(6);
                if j == 1
                    BaseRight = [X Y Z RX RY RZ] ;
                else
                    BaseLeft = [X Y Z RX RY RZ];
                end
            end

            Bimanual_Vector=[BaseRight(1:3),BaseLeft(1:3)];

            PlaceTwoRobot(Robot,LeftRobot,Length_Sum,'On','Bimanual','baseright',BaseRight,'baseleft',BaseLeft);
            set(handles.Status,'String','Bimanual Robot');
    end
set(handles.Status,'String','Finished Robot Construction.');
%[deg] = Visual_Robot(RightRobot,LeftRobot,Size,varargin);


%% Workspace Generation
% --- Executes on button press in JointValueSampling.
function JointValueSampling_Callback(hObject, eventdata, handles)
    global QS;global Count;global Robot;
    global Initial_Config;
    Couple_Flag = Initial_Config.Couple_Flag;
    if Initial_Config.MentoCarlo == 1
        Joint_Type = 'MentoCarlo';
    else
        Joint_Type = 'General';
    end

    Num = str2num(get(handles.InputJoint,'String'));
    [QS,Count]= Generate_Joint(Robot,Couple_Flag,Joint_Type,'JointNum',Num);

    save('./Data/JointValue.mat','QS');
    set(handles.Status,'String','Finished Workspace Generation.');
    

%% Workspace Analysis
% --- Executes on button press in ReachableWS.
function ReachableWS_Callback(hObject, eventdata, handles)
global Count;global BaseRight; global BaseLeft; global Robot; global QS; global Dex; global Indice_Group;
global Initial_Config;  

 Bimanual = Initial_Config.Analysis_Type - 1; Precision = Initial_Config.Precision;
[RobotType,~] = Robot_Map(Initial_Config.RobotType); 

%Index_Num = [4 5 6 7 8 10 11]; Index_Name = {'Manipulability'Indice_Group = [,'Minimum Singular Value','Condition Number',...
   % 'Order-Independent Manipulability', 'Harmonic Mean Manipulability Index','Isotropic Index'};
%Map_LocalIndex = containers.Map(Index_Num,Index_Name); Map_Inv_LocalIndex = containers.Map(Index_Name,Index_Num);

[~,Index_Name] = ReadFiles('All_Indices');
[~,All_Num] = size(Index_Name); All_Index_Num = 4:1:(4+All_Num-1);
Map_LocalIndex = containers.Map(All_Index_Num,Index_Name);
Map_Inv_LocalIndex = containers.Map(Index_Name,All_Index_Num);

Flag = [Initial_Config.Joint_Flag,Initial_Config.Couple_Flag];

switch Initial_Config.Iteration
    case 0
        if Bimanual == 1
            %Dex = ReachableWS(RightRobot,Count,QS,Flag,'On');
            %[Dex,path,O_Volume,Volume] = ReachableWS_New(Robot,QS,Flag);
            
             [Dex,path,O_Volume,Volume] = ReachableWS_Indices(Robot,QS,Flag,'Indice',Indice_Group,'On','Path',RobotType);
        else
           % Dex = ReachableWS(Robot,Count,QS,Flag,'On');
          % [Dex,path,O_Volume,Volume] = ReachableWS_New(Robot,QS,Flag,'Indice',Indice_Group,'On','Path',RobotType);
             
         % [Dex,path,O_Volume] = ReachableWS_New(Robot,QS,Flag,'Indice',Indice_Group,'On','Path',RobotType);
        
           [Dex,path,O_Volume,Volume] = ReachableWS_Indices(Robot,QS,Flag,'Indice',Indice_Group,'On','Path',RobotType);
           
        end
    case 1
        %ErrorInput
        Error = str2num(get(handles.ErrorInput,'String'));
        [Dex] = GlobalIterate(Robot,Error); 
end

save('myFile.txt','Dex','-ascii');
%type('myFile.txt');

global Robot_Info;
Robot_Info.Robot = Robot; Robot_Info.QS = QS; Robot_Info.Dex = Dex; 
Robot_Info.Map_LocalIndex = Map_LocalIndex; Robot_Info.Map_Inv_LocalIndex = Map_Inv_LocalIndex;

set(handles.Status,'String','Finished Workspace Evaluation.');
%% Convert to Volume Data
global Evaluation_Index; global Boundary_Robot;global Volume_Size_Robot;
global Volume_Info; Initial_Config.Precision = str2num(get(handles.PrecisionInput,'String'));
Evaluation_Index = 'Manipulability';

if Bimanual == 0
    [V,Boundary_Robot,Volume_Size] = SingleScatterToVolume(Dex,Precision,Evaluation_Index);
    Volume_Info.V = V; 
else
    [VDual_Robot,VLeft_Robot,VRight_Robot,Boundary_Robot,Volume_Size] = ScatterToVolume(Dex,Initial_Config.Precision,BaseRight,BaseLeft,'BimanualRobot','Visual_On');
    out = 'Bimanual';
    Volume_Info.VDual_Robot = VDual_Robot;
    Volume_Info.VLeft_Robot = VLeft_Robot; Volume_Info.VRight_Robot = VRight_Robot;
end
Volume_Info.Boundary_Robot = Boundary_Robot;
Volume_Info.Precision = Precision; Volume_Info.Volume_Size=Volume_Size;
set(handles.Status,'String','Finished Generate Volume Data.'); set(handles.Status,'String','Finished Workspace Analysis.');


%% Global Evaluation
function Calculate_Callback(hObject, eventdata, handles)
global Dex; global Initial_Config;global Robot; global Robot_Info;
%[~,Global_Indices] = Global_New(Dex,Dynamic_Flag);

[Indices,Global_Indices] = GlobalEvaluate(Dex);
Robot_Info.Global_Indices = Global_Indices;
set(handles.globalresults,'String','Global OK');


%% Evaluation Indices
function Kinematic_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Kinematic_Callback(hObject, eventdata, handles)
global Robot_Info; Global_Indices = Robot_Info.Global_Indices; Robot = Robot_Info.Robot;
global Evaluation_Index; global Dex; global Index_Num; Evaluation_Index = 'Reachable';
Index_Num = get(handles.Kinematic, 'Value');

if(isempty(Index_Num))
    Index_Num = 4;
else
    Index_Num = Index_Num;
end

switch Index_Num
    case 10 
        V = Cal_BoundaryVolume(Dex);
        [length_sum,Prismatic_Num,Precision] = Initial_Precision(Robot);
        SLI = ((V).^(1/3))/length_sum;
        set(handles.globalresults,'String',num2str(SLI));
        set(handles.Status,'String','Structure Length Index');
    case 11
        [vol] = Cal_BoundaryVolume(Dex);
        set(handles.globalresults,'String',num2str(vol));
        set(handles.Status,'String','Workspace Volume');
    otherwise
        [Evaluation_Index] = Choose_Indices(Index_Num);
        set(handles.globalresults,'String',num2str(Global_Indices(Index_Num)));
        set(handles.Status,'String',Evaluation_Index);  
end

%% Workspace Visualization
function Plot_Callback(hObject, eventdata, handles)
%axes(handles.axes2); %cla;
global Volume_Info;global Initial_Config; 
global Dex;global Slice;  global Evaluation_Index;global Index_Num; global Slice_Flag
 Bimanual = Initial_Config.Analysis_Type - 1; 
global Bimanual_Vector;
Flag_Info = {Slice_Flag,Bimanual,Evaluation_Index,Slice,Index_Num,Bimanual_Vector};
rotate3d on; 
pop= get(handles.Visual, 'Value');
axes(handles.axes2);
grid off;
[String_Out] = WS_Visualization(pop,Dex,Volume_Info,Flag_Info);
set(handles.Status,'String',String_Out);
set(handles.Status,'String','Finished Generate Volume Data.');

%% --- Executes on slider movement.
%XSlice
%YSlice
%ZSlice
%Isovalue
%Alphavalue

function Slice_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Slice_Callback(hObject, eventdata, handles)
global Slice; Slice = [0,0,0,0,0];
global Slice_Flag; 
global Volume_Info;
Boundary_Single = Volume_Info.Boundary_Single; Slice_Flag = [0,0,0,0,0];
xminH = Boundary_Single(1,1); xmaxH = Boundary_Single(1,2);
yminH = Boundary_Single(2,1); ymaxH = Boundary_Single(2,2);
zminH = Boundary_Single(3,1); zmaxH = Boundary_Single(3,2);

pop= get(handles.Parameter, 'Value');

switch pop
    case 1
        Slice(1) = xminH + (xmaxH - xminH) * get(hObject,'Value'); Slice_Flag(1) = 1;
    case 2
        Slice(2) = yminH + (ymaxH - yminH) * get(hObject,'Value'); Slice_Flag(2) = 1;
    case 3
        Slice(3) = zminH + (zmaxH - zminH) * get(hObject,'Value'); Slice_Flag(3) = 1;
    case 4
        Slice(4) = get(hObject,'Value'); Slice_Flag(4) = 1;
    case 5
        Slice(5) = get(hObject,'Value'); Slice_Flag(5) = 1;
end

% --- Executes on button press in LoadFile.
function LoadFile_Callback(hObject, eventdata, handles)
global Dex;
FileName = get(handles.ReadFile,'String');File=load(FileName);Dex = File.Dex;

% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)

% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
cla;% clear global Robot;clear global Dex;clear global QS;
set(handles.InputJoint, 'String', '');set(handles.PreciseInput, 'String', '');set(handles.ErrorInput, 'String', '');

% --- Executes on selection change in VisualizeType.
function VisualizeType_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function VisualizeType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

%set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in AddRobot.
function AddRobot_Callback(hObject, eventdata, handles)

% --- Executes on selection change in RobotList.
function RobotList_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function RobotList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Indices.
function Indices_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Indices_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function InputJoint_Callback(hObject, eventdata, handles)

function InputJoint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EqualInterval_Callback(hObject, eventdata, handles)


function InputEqualJoint_Callback(hObject, eventdata, handles)
global Joint_Type
Joint_Type = 'General';

function InputEqualJoint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu6_Callback(hObject, eventdata, handles)

function popupmenu6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)

% --- Executes on button press in Teach.
function Teach_Callback(hObject, eventdata, handles)
global Robot; Enable_Teach = get(hObject,'Value');

if Enable_Teach == 1
    figure(1)
   Robot.teach()   
end
function ReadFile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ReadFile_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton7

function ErrorInput_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ErrorInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function PrecisionInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PrecisionInput_Callback(hObject, eventdata, handles)

% --- Executes on button press in TransferToVolume.
function TransferToVolume_Callback(hObject, eventdata, handles)

% --- Executes on button press in BuildBimanual.
function BuildBimanual_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)

% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PlaceBimanual.
function PlaceBimanual_Callback(hObject, eventdata, handles)
% Define and Visualize bimanual robot

function edit24_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit25_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit26_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit28_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit29_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit27_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)

% --- Executes on button press in PlotRobot.
function PlotRobot_Callback(hObject, eventdata, handles)


function edit30_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in VisualRobotSize.
function VisualRobotSize_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function VisualRobotSize_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function globalresults_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function globalresults_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Visual.
function Visual_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Visual_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Status_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Status_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Parameter.
function Parameter_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Parameter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in SaveFiles.
function SaveFiles_Callback(~, eventdata, handles)
global Robot_Info; global Initial_Config;global Dex;
addpath('../');Folder = pwd;
filename = get(handles.savename,'String');
path = fullfile(Folder,'User',[filename,'_Robot_Info']);save(path,'Robot_Info'); 
path = fullfile(Folder,'User',[filename,'_Initial_Config']);save(path,'Initial_Config');
path = fullfile(Folder,'User',[filename,'_Local_Indices.txt']);
save(path,'Dex','-ascii');
set(handles.Status,'String','Finished Save Data');  



function savename_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function savename_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function Customized_Callback(hObject, eventdata, handles)
Visual_C_Plus

% --- Executes on selection change in CalType.
function CalType_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function CalType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Dynamic.
function Dynamic_Callback(hObject, eventdata, handles)

function RobotType_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function RobotType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
