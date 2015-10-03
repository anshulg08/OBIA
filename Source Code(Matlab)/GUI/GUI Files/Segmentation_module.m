function varargout = Segmentation_module(varargin)
% SEGMENTATION_MODULE M-file for Segmentation_module.fig
%      Segmentation_module, by itself, creates a Segmentation_module Segmentation_module or raises the existing
%      singleton*.
%
%      H = Segmentation_module returns the handle to a Segmentation_module Segmentation_module or the handle to
%      the existing singleton*.
%
%      Segmentation_module('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Segmentation_module.M with the given input arguments.
%
%      Segmentation_module('Property','Value',...) creates a Segmentation_module Segmentation_module or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Segmentation_module_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Segmentation_module_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Segmentation_module

% Last Modified by GUIDE v2.5 08-Jun-2013 20:04:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Segmentation_module_OpeningFcn, ...
                   'gui_OutputFcn',  @Segmentation_module_OutputFcn, ...
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


% --- Executes just before Segmentation_module is made visible.
function Segmentation_module_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Segmentation_module (see VARARGIN)

% Choose default command line output for Segmentation_module

% global variables
handles.preLabelMatrix = 0;
handles.labelMatrix = 0;
handles.segmentedImage = 0;
handles.edges = 0;
handles.regionProp = 0;
handles.first = 1;
handles.scale = 100;
% loading image from previous module and set default value for scale parameter
global curr;
global imFilt;
global imageArray;
global originalHandle;
global im;
imageArray = varargin{1};
originalHandle = varargin{2};
handles.inputImage = imageArray;
handles.orig_im = imageArray;
im = imageArray;
curr = imageArray;
imFilt = imageArray;
handles.output = hObject;
set(handles.edit2,'String','200');

% displaying image according to the aspect ratio
axes(handles.axes1);
image(im);
ratio = size(im,2)/size(im,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Segmentation_module wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Segmentation_module_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.segmentedImage;
% varargout{2} = handles.labelMatrix;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2 " Segment ".
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global curr; 
global imFilt;
A=get(handles.edit2,'String');
if isempty(str2num(char(A)))
    h = warndlg('Input must be numerical');
    uiwait(h);
    set(handles.edit2,'string','200');
    uicontrol(handles.edit2);
    fprintf('exit');
else 
    if (str2num(char(A))) > 1000
    h = warndlg('Scale should be less than 1000');
    uiwait(h);
    set(handles.edit2,'string','1000');
    fprintf('exit');
    end
end

handles.scale = str2num(char(A));
if handles.first == 1
    [imFilt, handles.preLabelMatrix,handles.edges,handles.regionProp] = wrapper_pre(im);    
    handles.first = 0;
end    

[handles.labelMatrix] = wrapper_fast(imFilt, handles.preLabelMatrix, handles.edges,handles.regionProp,handles.scale);     

% call this after loading the image
[handles.segmentedImage, handles.boundaries] = getsegmentedImage(im, handles.labelMatrix, 1);
curr = handles.segmentedImage;
axes(handles.axes1);
image(curr);
ratio = size(handles.segmentedImage,2)/size(handles.segmentedImage,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);
uiwait(msgbox('Segmentation Done'));

guidata(hObject, handles);



% --- Executes on button press in pushbutton3 "Save data ".
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr;
global imFilt;
global im;
data{1} = handles.preLabelMatrix;
data{2} = handles.labelMatrix;
data{3} = handles.segmentedImage;
data{4} = handles.edges ;
data{5} = handles.regionProp;
data{6} = handles.first;
data{7} = handles.scale;
data{8} = imFilt;
data{9} = im;
[FileName, PathName] = uiputfile('*.mat', 'Save As'); 
datafile = fullfile(PathName,FileName);
save(datafile,'data');

% --- Executes on button press in pushbutton5 "load data".
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global curr;
global imFilt;
global im;
[baseFileName, folder] = uigetfile('*.mat', 'Load File');
datafile = fullfile(folder, baseFileName);
load(datafile);
handles.preLabelMatrix = data{1} ;
handles.labelMatrix = data{2} ;
handles.segmentedImage = data{3} ;
handles.edges  = data{4} ;
handles.regionProp = data{5} ;
handles.first = data{6} ;
handles.scale = data{7} ;
imFilt = data{8} ;
im = data{9} ;
curr =  handles.segmentedImage;

image(curr);
ratio = size(curr,2)/size(curr,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);
guidata(hObject,handles)
set(handles.edit2, 'String', num2str(handles.scale));

guidata(hObject,handles)


% --- Executes on button press in pushbutton8 " Zoom in ".
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr;
rect = getrect();
curr = curr(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
axes(handles.axes1);
image(curr);
ratio = size(curr,2)/size(curr,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);
guidata(hObject,handles)



% --- Executes on button press in pushbutton9 "Zoom out ".
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr;
if (handles.first == 1)
    curr = handles.orig_im;
else
    curr = handles.segmentedImage;
end
    axes(handles.axes1);
image(curr);
ratio = size(curr,2)/size(curr,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);
guidata(hObject,handles)


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.segmentedImage;
varargout{2} = handles.labelMatrix;
aa = 'This is when control returns!'
% Hint: delete(hObject) closes the figure
delete(hObject);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns edit1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit1
% Determine the selected data set.
global im;
str = get(hObject,'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
case 'Red' 
    color = 4;
case 'Green' 
   color = 5;
case 'Blue' 
   color = 3;
case 'Black' 
   color = 1;
case 'White' 
   color = 2;
end
% Save the handles structure.
[handles.segmentedImage, handles.boundaries] = getsegmentedImage(im, handles.labelMatrix, color);
axes(handles.axes1);
image(handles.segmentedImage);
ratio = size(handles.segmentedImage,2)/size(handles.segmentedImage,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);

guidata(hObject,handles)



function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imFilt;
global im;
Classification_Module(im, handles.segmentedImage, handles.labelMatrix, imFilt);
