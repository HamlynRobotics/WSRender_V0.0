%% Function for running the scaling GUI.
% The input is the configuration file.

function varargout = GUI(varargin)
%GUI MATLAB code file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('Property','Value',...) creates a new GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI('CALLBACK') and GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 17-May-2019 08:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)

%% read the config file

config_file = varargin{1};
fileID = fopen(config_file,'r');

f = 0;
r = 0;
i = 1;
T = eye(4);
while (~feof(fileID))
    tline = fgetl(fileID);
    if(tline == "#WS files")
        f = 1;
        tline = fgetl(fileID);
    end
    if(tline == "#Transformation Matrix")
        tline = fgetl(fileID);
        f = 0;
        r = 1;
        i = 1;
    end
    if (f ~= 0 && isempty(tline) == 0)
        WS_files{i} = tline;
        i = i+1;
    end
    % read R
    if (r ~= 0 && isempty(tline) == 0)
        row = str2num(tline);
        T(i,:) = row;
        i = i+1;
    end
    
end

% Initial transormation, offset, and scaling
R_s2m = T(1:3,1:3);
offset = T(1:3,4).';
scale = T(4,1:3);

%read WS data from files
cols = 4; %3+dexterity measures
handles.totalWSVals = cell(2,1);
for i = 1:2
fileID = fopen(WS_files{i},'r');

data = fscanf(fileID,[ '%f']);
fclose(fileID);

n = floor(length(data)/cols);
vals = reshape(data(1:cols*n),[cols n]);
handles.totalWSVals{i} = vals ;

P_ws{i} = vals(1:3,:);
end


% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Initialize values needed for GUI
handles.InitVals.Rot = R_s2m;
handles.InitVals.offset = offset;
handles.InitVals.scale = scale;

handles.Shapes_handles.h_shp = cell(2,1); % handle to alphashape WS
handles.Shapes_handles.h_shp_dext = cell(2,1); % handle to alphashape dext WS


start_button = handles.Start_button;
set(start_button,'BackgroundColor',[1 0 0]);

handles.dexterity{1} = "WS"; % choice of WS to plot for master
handles.dexterity{2} = "WS"; % choice of WS to plot for slave

handles.SlaveWSData = P_ws{2}'; % for plotting slave WS in its frame
handles.MasterWSData = P_ws{1}'; % for plotting slave WS in its frame

handles.DextSlaveWSData = []; % for plotting slave Dexterous WS in its frame
handles.DextMasterWSData = []; % for plotting slave Dexterous WS in its frame

handles.percentages = cell(2,1); % percentages of dext worksapces for master and slave
handles.percentages{1} = str2num(handles.WS1_perc.String); % [min, max] for master
handles.percentages{2} = str2num(handles.WS2_perc.String); % [min, max] for slave

handles.alpha = []; % [master,slave] for better WS resolution
handles.alpha_dext = []; % [master,slave] for better dext WS resolution

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Select the alpha factor for plottting WS
% handles.alpha = [master_alpha,slave_alpha]
function TotWS_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to TotWS_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotWS_alpha as text
%        str2double(get(hObject,'String')) returns contents of TotWS_alpha as a double
handles.alpha = str2num(eventdata.Source.String);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TotWS_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotWS_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Button for viusalizing mastr/slave WS independently
% --- Executes on button press in set_button.
function set_button_Callback(hObject, eventdata, handles)
% hObject    handle to set_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p1 = zeros(1,2); % min percs
p2 = zeros(1,2); % max percs

% not needed

% handles.dexterity{1} = handles.popup_WS1.String{handles.popup_WS1.Value};
% handles.dexterity{2} = handles.popup_WS2.String{handles.popup_WS2.Value};
% 
% handles.percentages{1} = str2num(handles.WS1_perc.String);
% handles.percentages{2} = str2num(handles.WS2_perc.String);
% 
% handles.alpha = str2num(handles.TotWS_alpha.String);
% handles.alpha_dext = str2num(handles.DextWS_alpha.String);


alpha = zeros(1,2);
alpha_high = zeros(1,2);
if (isempty(handles.alpha) == 0)
alpha = handles.alpha;
end
if (isempty(handles.alpha_dext)== 0)
alpha_high = handles.alpha_dext;
end
for i = 1:2
     
    perc = handles.percentages{i};
   p1(i) = perc(1); 
   p2(i) = perc(2); 
end

model{1} = handles.MasterWSData;
model{2} = handles.SlaveWSData;

model_high = cell(2,1);

ha(1) = handles.MasterWS; % master WS axis
ha(2) = handles.SlaveWS; % slave WS axis

handles.Start_button.BackgroundColor = [1 0 0];
pause(0.01);

% delete(h_shp_high);

for nw = 1:2
    
    vals = handles.totalWSVals{nw};
    P = vals(1:3,:);
    
    switch handles.dexterity{nw}
    case 'WS'
        disp("Whole WS considered");
        dext = [];
    case 'k1'
        disp("Kinematic Dexterity Measure considered");
        dext = vals(4,:);
        
    case 'k2'
        disp("Kinematic Condition Number considered");
        dext = vals(5,:);
        
    case 'k3'
        disp("Kinematic Minimum Eigenvalue considered");
        dext = vals(6,:);
        
    case 'd1'
        disp("Dynamic Dexterity Measure considered");
        dext = vals(7,:);
        
    case 'd2'
        disp("Dynamic Condition Number considered");
        dext = vals(8,:);
        
    case 'd3'
        disp("Dynamic Minimum Eigenvalue considered");
        dext = vals(9,:);
        
    end

    % plot total WS for each model8Master/slave)
    
curr_model = model{nw};

if (alpha(nw) ~= 0)
shp{nw,1} = alphaShape(curr_model(:,1),curr_model(:,2),curr_model(:,3),alpha(nw));

else
   shp{nw,1} = alphaShape(curr_model(:,1),curr_model(:,2),curr_model(:,3)); 
end
alpha(nw) = shp{nw}.Alpha;

set(gcf,'CurrentAxes',ha(nw))
cla;
hold on
handles.Shapes_handles.h_shp{nw} = plot(shp{nw},'FaceColor',[0.7 0.7 0.7],'EdgeColor','black','EdgeAlpha',0.3,'FaceAlpha',0.3);
xlabel ('x')
ylabel ('y')
zlabel ('z')

% if a dexterity measure has been chosen, get the percentage range

if (isempty(dext) == 0)
    
    dext = (dext-min(dext))/(max(dext)-min(dext));
    
    [N,~,bin] = histcounts(dext,min(dext):1e-05: max(dext));
    
    perc_min = 0;
    dp = 0.05; % percentage discretization
    n = 1/dp;
    for i = 1:n
        
        perc = i*dp;
        flag = find(bin <= perc*length(N) & bin > perc_min*length(N));
        dext_P{i,1} = P(:,flag);
        
        perc_min = perc;
    end
  
    n1 = floor(p1(nw)*(n-1)+1);
    n2 = floor(p2(nw)*(n-1)+1);
    
    P_high = [];
    for i = n1:n2
        P_high = [P_high dext_P{i,1}];
    end

    model_high{nw,1} = P_high.';
      
    % plot desired dexterius WS (within the percentages range)
    
    curr_model_high = model_high{nw,1};
    if alpha_high(nw) ~= 0

    shp_high{nw,1} = alphaShape(curr_model_high(:,1),curr_model_high(:,2),curr_model_high(:,3),alpha_high(nw)); 
    else
     shp_high{nw,1} = alphaShape(curr_model_high(:,1),curr_model_high(:,2),curr_model_high(:,3)); 
      
    end
    alpha_high(nw) = shp_high{nw}.Alpha;
    
    h_shp_high = plot(shp_high{nw},'FaceColor','red','EdgeColor','red','EdgeAlpha',0.3,'FaceAlpha',0.3);
xlabel ('x')
ylabel ('y')
zlabel ('z')
view(3)
hold off
   
end
end

% update master/slave Dext WS
handles.DextSlaveWSData = model_high{2};
handles.DextMasterWSData = model_high{1};

handles.alpha = alpha;
handles.alpha_dext = alpha_high;

 handles.Start_button.BackgroundColor = [0 1 0];
 handles.TotWS_alpha.String = num2str(alpha);
 handles.DextWS_alpha.String = num2str(alpha_high);
 
 guidata(hObject, handles);





%% gets alpha for dext WS alphashape
% handles.alpha_dext = [master,slave]
function DextWS_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to DextWS_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DextWS_alpha as text
%        str2double(get(hObject,'String')) returns contents of DextWS_alpha as a double
handles.alpha_dext = str2num(eventdata.Source.String);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DextWS_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DextWS_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Start button for starting the scaling of the desired WS
% --- Executes on button press in Start_button.
function Start_button_Callback(hObject, eventdata, handles)
% hObject    handle to Start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slave_WS = handles.SlaveWSData;
master_WS = handles.MasterWSData;
alpha_models = handles.alpha;

% If dext ws exists, plot it
    if (isempty(handles.DextSlaveWSData) == 0)
        slave_WS = handles.DextSlaveWSData;
        alpha_models(2) = handles.alpha_dext(2);
    end
    
    if (isempty(handles.DextMasterWSData) == 0)
        master_WS = handles.DextMasterWSData;
        alpha_models(1) = handles.alpha_dext(1);
    end

% transorm slave WS from its frame to master frame
slave_WS = slave_WS*handles.InitVals.Rot';

h_scaling = handles.Mapping;
offset = handles.InitVals.offset;
scaling = handles.InitVals.scale;

guidata(hObject, handles);

% shows the buttons for the scaling
 WS_scaling_GUI(h_scaling,offset,scaling,master_WS,slave_WS,alpha_models)


%% Popup menu for master deterous WS choice
% --- Executes on selection change in popup_WS1.
function popup_WS1_Callback(hObject, eventdata, handles)
% hObject    handle to popup_WS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_WS1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_WS1

handles.dexterity{1} = eventdata.Source.String{eventdata.Source.Value}; % which dexterity to plot for WS1
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popup_WS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_WS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Popup menu for slave deterous WS choice
% --- Executes on selection change in popup_WS2.
function popup_WS2_Callback(hObject, eventdata, handles)
% hObject    handle to popup_WS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_WS2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_WS2

handles.dexterity{2} = eventdata.Source.String{eventdata.Source.Value};% which dexterity to plot for WS2
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popup_WS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_WS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Get percentages of WS1 (master)
% if [0 1] same as choosing WS
% handles.percentages{1} = [min,max]
function WS1_perc_Callback(hObject, eventdata, handles)
% hObject    handle to WS1_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WS1_perc as text
%        str2double(get(hObject,'String')) returns contents of WS1_perc as a double

handles.percentages{1} = str2num(eventdata.Source.String);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function WS1_perc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WS1_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Get percentages of WS2 (slave)
%% if [0 1] same as choosing WS
% handles.percentages{2} = [min,max]
function WS2_perc_Callback(hObject, eventdata, handles)
% hObject    handle to WS2_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WS2_perc as text
%        str2double(get(hObject,'String')) returns contents of WS2_perc as a double
handles.percentages{2} = str2num(eventdata.Source.String);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function WS2_perc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WS2_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



