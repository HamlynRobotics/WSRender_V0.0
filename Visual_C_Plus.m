function varargout = Visual_C_Plus(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Visual_C_Plus_OpeningFcn, ...
                   'gui_OutputFcn',  @Visual_C_Plus_OutputFcn, ...
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


% --- Executes just before Visual_C_Plus is made visible.
function Visual_C_Plus_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Visual_C_Plus_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% cla;
global Master_Dex; global Slave_Dex; global Dex;
Type = get(handles.SystemType, 'Value');
addpath('../');Folder = pwd;path = fullfile(Folder,'Data','ws_data.txt');


switch Type
    case 1
        axes(handles.axes1);
        File_Name = 'Master_Manip_ws_51.txt';
        Dex = Read_Table(File_Name);  
        rotate3d on;
        plot3(Dex(:,1)*100,Dex(:,2)*100,Dex(:,3)*100,'r');
        %set(handles.Status,'String','Finished Load Data');  
        
    case 2
        axes(handles.axes2);
        File_Name = 'slave_ws_test.txt';
        Slave_Dex = Read_Table(File_Name);  rotate3d on;
        plot3(Slave_Dex(:,1)*100,Slave_Dex(:,2)*100,Slave_Dex(:,3)*100,'b');
        
    case 3
        axes(handles.axes3);
        File_Name = 'slave_ws_test.txt';
        Slave_Dex = Read_Table(File_Name);  
        %plot3(Slave_Dex(:,1)*100,Slave_Dex(:,2)*100,Slave_Dex(:,3)*100,'b');hold on;
        
        
         File_Name = 'Master_Manip_ws_51.txt';
        Master_Dex = Read_Table(File_Name);  
        %plot3(Master_Dex(:,1),Master_Dex(:,2),Master_Dex(:,3),'*y'); hold on; 
        %VisualWS(Master_Dex,'Reachable');hold on;
        
        [v] = Boundary_WS(Master_Dex,0.4,'r'); [v] = Boundary_WS(Slave_Dex,0.4,'b');
        rotate3d on;
        
    case 4
        axes(handles.axes4);
        File_Name = 'ws_data.txt';
        Define_Dex = dlmread(path); 
        rotate3d on;
        Index =  get(handles.Local, 'Value');
        if Index == 1
            plot3(Define_Dex(:,1)*100,Define_Dex(:,2)*100,Define_Dex(:,3)*100,'b');
        else
            Define_Dex(:,1:3) =  Define_Dex(:,1:3)*100;
           
            VisualWS(Define_Dex,(Index+2),'Local_Indices');
        end
end


% --- Executes on selection change in SystemType.
function SystemType_Callback(hObject, eventdata, handles)


function SystemType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
cla(handles.axes1);cla(handles.axes2);cla(handles.axes3)


% --- Executes on selection change in Local.
function Local_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Local_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
