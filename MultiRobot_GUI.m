function varargout = MultiRobot_GUI(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MultiRobot_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MultiRobot_GUI_OutputFcn, ...
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

% --- Executes just before MultiRobot_GUI is made visible.
function MultiRobot_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = MultiRobot_GUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)

%{
addpath(genpath(pwd));addpath('../');Folder = pwd;
filename = 'dan';path = fullfile(Folder,'User',[filename,'_Robot_Info','.mat']);
Robot_Info = load(path,'Robot_Info'); path = fullfile(Folder,'User',[filename,'_Initial_Config','.mat']);
Config_Info = load(path,'Initial_Config');
%}
global TransferAll;global TransferAll_B; global Volume_Overall;
addpath('../');Folder = pwd;
path = fullfile(Folder,'User','Transfer_A_Local_Indices.txt');TransferAll = dlmread(path); 
path = fullfile(Folder,'User','Transfer_B_Local_Indices.txt');TransferAll_B = dlmread(path); 
path = fullfile(Folder,'User',['Transfer','_Volume_Overall']);
A=load(path,'Volume_Overall');Volume_Overall=A.Volume_Overall;

%% Interaction
% Bimanual A
axes(handles.axes1);
plot3(TransferAll(:,1),TransferAll(:,2),TransferAll(:,3),'*b');
hold on;

axes(handles.axes2);
plot3(TransferAll_B(:,1),TransferAll_B(:,2),TransferAll_B(:,3),'*b');
hold on;
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

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
%set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});

function Results_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Results_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Analysis.
function Analysis_Callback(hObject, eventdata, handles)
global TransferAll;global TransferAll_B; global Volume_Overall;

Boundary = Volume_Overall.Boundary;
Volume_Size = Volume_Overall.Volume_Size;
Precision = Volume_Overall.Precision;

popup_sel_index = get(handles.Evaluation, 'Value')
% Bimanual A + B
axes(handles.axes4);
Transfer_Group{1} = TransferAll;Transfer_Group{2} = TransferAll_B;
[Volume_All,Volume_Interact] = Find_Interact_Bimanual(Transfer_Group,Boundary,Volume_Size,Precision,'Seperate');

axes(handles.axes3);
Volume_Interact = Boundary_WS(TransferAll,0.3,'b');
Volume_Interact = Boundary_WS(TransferAll_B,0.3,'g');

% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
cla(handles.axes4)

function Status_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Status_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Evaluation.
function Evaluation_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Evaluation_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

% --- Executes on button press in Creat.
function Creat_Callback(hObject, eventdata, handles)

%% Analysis Type: Multi robot
global TransferAll;global TransferAll_B; global Volume_Overall;

Type = 'Articulated';
[RightRobot1,LeftRobot1,~] = Multi_Bimanual_Construction(Type,1);

%% Initial Parameters
[Length_Sum,Prismatic_Num,Volume_Overall.Precision] = Initial_Precision(RightRobot1);

Type = 'Spherical';
[RightRobot2,LeftRobot2,Robot_Placement] = Multi_Bimanual_Construction(Type,2);

Num = 30;
[Global_Indices_Group{1},Dex_Group{1}] = Workspace_Analysis(RightRobot1,Num,Type);
Global_Indices_Group{2} = Global_Indices_Group{1};

[Global_Indices_Group{3},Dex_Group{3}] = Workspace_Analysis(RightRobot2,Num,Type);
Global_Indices_Group{4} = Global_Indices_Group{3};

Bimanual_Vector{1} = Robot_Placement{2}-Robot_Placement{1};
Dex_Group{2} = Dex_Group{1}; Dex_Group{2}(:,1:3) = Dex_Group{1}(:,1:3) + Bimanual_Vector{1}(1:3);
Bimanual_Vector{2} = Robot_Placement{4}-Robot_Placement{3};
Dex_Group{4} = Dex_Group{3}; Dex_Group{4}(:,1:3) = Dex_Group{3}(:,1:3) + Bimanual_Vector{2}(1:3);

Volume_Overall.Precision = 0.01;
[Volume_Overall.Boundary,Volume_Overall.Volume_Size] = Define_Volume(Dex_Group,Volume_Overall.Precision);
[V_All,V_Group] = Scatter_Volume_Convert(Dex_Group,Volume_Overall.Precision,Volume_Overall.Boundary,Volume_Overall.Volume_Size);

%% Visual All Robots
V_Bimanual{1} = V_Group{1}; V_Bimanual{2} = V_Group{2}; V_Bimanual_B{1} = V_Group{3}; V_Bimanual_B{2} = V_Group{4};
Index = 4;

%% Interaction
% Bimanual A
axes(handles.axes1);
[Transfer_Robot,TransferAll] = Visualize_VolumeData_All(Volume_Overall.Boundary,V_Bimanual,Volume_Overall.Volume_Size,Volume_Overall.Precision,Index,'Seperate');
axis off;  rotate3d on; 
[Volume_All_A,Volume_Interact_A] = Find_Interact_Bimanual(Dex_Group,Volume_Overall.Boundary,Volume_Overall.Volume_Size,Volume_Overall.Precision,'Off');

% Bimanual B
axes(handles.axes2);
[Transfer_Robot_B,TransferAll_B] = Visualize_VolumeData_All(Volume_Overall.Boundary,V_Bimanual_B,Volume_Overall.Volume_Size,Volume_Overall.Precision,Index,'Seperate');
axis off;  rotate3d on; 
[Volume_All_B,Volume_Interact_B] = Find_Interact_Bimanual(Dex_Group,Volume_Overall.Boundary,Volume_Overall.Volume_Size,Volume_Overall.Precision,'Off');

addpath('../');Folder = pwd; filename = 'Transfer';
path = fullfile(Folder,'User',[filename,'_A_Local_Indices.txt']);save(path,'TransferAll','-ascii');
path = fullfile(Folder,'User',[filename,'_B_Local_Indices.txt']);save(path,'TransferAll_B','-ascii');
path = fullfile(Folder,'User',[filename,'_Volume_Overall']);save(path,'Volume_Overall'); 

%set(handles.Status,'String','Finished Save Data');  
