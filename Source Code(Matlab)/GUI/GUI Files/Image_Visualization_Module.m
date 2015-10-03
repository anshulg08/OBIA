function varargout = Image_Visualization_Module(varargin)
% Image_Visualization_Module M-file for Image_Visualization_Module.fig
%      Image_Visualization_Module, by itself, creates a new Image_Visualization_Module or raises the existing
%      singleton*.
%
%      H = Image_Visualization_Module returns the handle to a new Image_Visualization_Module or the handle to
%      the existing singleton*.
%
%      Image_Visualization_Module('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Image_Visualization_Module.M with the given input arguments.
%
%      Image_Visualization_Module('Property','Value',...) creates a new Image_Visualization_Module or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the Image_Visualization_Module before Image_Visualization_Module_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Image_Visualization_Module_OpeningFcn via varargin.
%   
%      *See Image_Visualization_Module Options on GUIDE's Tools menu.  Choose "Image_Visualization_Module allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Image_Visualization_Module

% Last Modified by GUIDE v2.5 08-Jun-2013 20:03:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Image_Visualization_Module_OpeningFcn, ...
                   'gui_OutputFcn',  @Image_Visualization_Module_OutputFcn, ...
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


% --- Executes just before Image_Visualization_Module is made visible.
function Image_Visualization_Module_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
 % hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Image_Visualization_Module (see VARARGIN)

% Choose default command line output for Image_Visualization_Module
handles.output = hObject;
cla reset;

% ---------------------
global labelMatrix;
global segmentedImage;
global edges;
global regionProp;
global im;

labelMatrix = 0;
edges = 0;
regionProp = 0;
im = 0;
segmentedImage = 0;
% ---------------------

% Update handles structure
guidata(hObject, handles);
%[filename, pathname] =uigetfile({'*.tif';'*.jpg';'*.*'},'Choose file to open');
 


% UIWAIT makes Image_Visualization_Module wait for user response (see UIRESUME)
% uiwait(handles.OBIA);


% --- Outputs from this function are returned to the command line.
function varargout = Image_Visualization_Module_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Seg_Callback(hObject, eventdata, handles)
% hObject    handle to Seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
 [baseFileName, folder] = uigetfile({'*.tif';'*.jpg';'*.*'}, 'Specify an image file');
 fullImageFileName = fullfile(folder, baseFileName);
 im_original=imread(fullImageFileName );
 global im;
 im = im_original;
 handles.orig_im = im_original;
 ratio = size(im,2)/size(im,1);
 set(handles.axes1,'PlotBoxAspectRatio', [1 ratio 1]);
 axes(handles.axes1);
 image(im);
 guidata(hObject,handles);
 

% --------------------------------------------------------------------
function Classification_Callback(hObject, eventdata, handles)
% hObject    handle to Classification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 


% --------------------------------------------------------------------
function Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RG_Callback(hObject, eventdata, handles)
% hObject    handle to RG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global labelMatrix;
global segmentedImage;
global edges;
global regionProp;
global im;

Segmentation_module(im, handles);
guidata(hObject,handles);


% --------------------------------------------------------------------
function AccuracyS_Callback(hObject, eventdata, handles)
% hObject    handle to AccuracyS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OBIA_CloseRequestFcn();


% --------------------------------------------------------------------
function SVM2_Callback(hObject, eventdata, handles)
% hObject    handle to SVM2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DT2_Callback(hObject, eventdata, handles)
% hObject    handle to DT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SVM1_Callback(hObject, eventdata, handles)
% hObject    handle to SVM1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function DT1_Callback(hObject, eventdata, handles)
% hObject    handle to DT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BI_Callback(hObject, eventdata, handles)
% hObject    handle to BI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Beta_Index();



% --------------------------------------------------------------------


% --- Executes on button press in pushbutton2 " Select layer to view "
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global im;
 band = get(handles.edit7, 'value');
 axes(handles.axes1);

 if(band == 5)
     image(im);
 else
     if(band == 4)
         if(size(im,3) == 4)
             image(im(:,:,band));
             colormap(gray)
         else
             image(im);
         end
     else
         image(im(:,:,band));
         colormap(gray)
     end
 end
 ratio = size(im,2)/size(im,1);
 set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);

 % --- Executes on button press in pushbutton3 " Enhancing Contrast "
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global segmentedImage;
if(segmentedImage ~= 0)
figure, imshow(segmentedImage);
end

% --- Executes on button press in pushbutton4 " Select Subset "
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
rect = getrect();
im = im(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
axes(handles.axes1);
image(im);
ratio = size(im,2)/size(im,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);

% --- Executes on button press in pushbutton5 " View Original image "
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
im = handles.orig_im;
axes(handles.axes1);
image(im);
ratio = size(im,2)/size(im,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



function AFI_Callback(hObject, eventdata, handles)
% hObject    handle to AFI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close OBIA.
function OBIA_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to OBIA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on selection change in edit7.
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns edit7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit7


% --- Executes on selection change in edit7.

function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in edit7.
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns edit7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit7
