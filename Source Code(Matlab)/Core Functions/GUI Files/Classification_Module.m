function varargout = Classification_Module(varargin)
% CLASSIFICATION_MODULE M-file for Classification_Module.fig
%      CLASSIFICATION_MODULE, by itself, creates a new CLASSIFICATION_MODULE or raises the existing
%      singleton*.
%
%      H = CLASSIFICATION_MODULE returns the handle to a new CLASSIFICATION_MODULE or the handle to
%      the existing singleton*.
%
%      CLASSIFICATION_MODULE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFICATION_MODULE.M with the given input arguments.
%
%      CLASSIFICATION_MODULE('Property','Value',...) creates a new CLASSIFICATION_MODULE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Classification_Module_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Classification_Module_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Classification_Module

% Last Modified by GUIDE v2.5 08-Jun-2013 12:36:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Classification_Module_OpeningFcn, ...
                   'gui_OutputFcn',  @Classification_Module_OutputFcn, ...
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


% --- Executes just before Classification_Module is made visible.
function Classification_Module_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Classification_Module (see VARARGIN)

% Choose default command line output for Classification_Module
handles.trainingData = 0;
handles.group = 0;

handles.im = varargin{1};
handles.segmentedImage = varargin{2};
handles.labelMatrix = varargin{3};
handles.im_filt = varargin{4};
handles.numclasses = 0;
handles.classMap = 0;
handles.numOfFeatures = 12;
% compute features
handles.im_filt = rgb2ycbcr(handles.im_filt);
s = regionprops(handles.labelMatrix, 'Area', 'ConvexArea', 'Eccentricity', 'EquivDiameter','Extent','MajorAxisLength','MinorAxisLength','Perimeter','Solidity');
s1 = regionprops(handles.labelMatrix, handles.im_filt(:,:,1), 'MaxIntensity', 'MinIntensity','MeanIntensity','PixelValues');
s2 = regionprops(handles.labelMatrix, handles.im_filt(:,:,2), 'MaxIntensity', 'MinIntensity','MeanIntensity','PixelValues');
s3 = regionprops(handles.labelMatrix, handles.im_filt(:,:,3), 'MaxIntensity', 'MinIntensity','MeanIntensity','PixelValues');
handles.features = getfeatures(s, s1, s2, s3);
handles.checkBox = [handles.feature1 handles.feature2 handles.feature3 handles.feature4 handles.feature5 handles.feature6 handles.feature7 handles.feature8 handles.feature9 handles.feature10 handles.feature11 handles.feature12];

for i = 1:handles.numOfFeatures
    set(handles.checkBox(i), 'Value', 1);
end

axes(handles.axes1);
image(handles.segmentedImage);
ratio = size(handles.segmentedImage,2)/size(handles.segmentedImage,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Classification_Module wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Classification_Module_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1 "Get Training Data "
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
image(handles.segmentedImage);
ratio = size(handles.segmentedImage,2)/size(handles.segmentedImage,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);

handles.group = 0;
for i=1:handles.numClasses
    if(handles.group == 0)
        [handles.trainingData, handles.group] = getTrainingData(handles.labelMatrix, handles.features, i, handles.axes1, handles.segmentedImage);
    else
        [tempTrainingData, tempGroup] = getTrainingData(handles.labelMatrix, handles.features, i, handles.axes1, handles.segmentedImage);
        handles.group = [handles.group ; tempGroup]; 
        handles.trainingData = [handles.trainingData; tempTrainingData];    
    end
end
guidata(hObject, handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 temp = handles.segmentedImage;
 classId = get(handles.text3,'Value');
 axes(handles.axes1);
 image(temp);

% --- Executes on selection change in text2.
function text2_Callback(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns text2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text2


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.numClasses = str2num(get(handles.edit1,'string'));
% set the value in text2 and text3
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selecFeaturesIdx = [];
k = 1;
for i = 1:handles.numOfFeatures
    if get(handles.checkBox(i), 'Value') == 1
        selecFeaturesIdx(k) = i; 
        k = k +1;
    end
end
     
if(size(selecFeaturesIdx) ~= 0)
    k = 1;
    for i = 1:size(selecFeaturesIdx, 2)
        New_features(:,k) = handles.features(:,selecFeaturesIdx(i));
        New_trainingData(:,k) = handles.trainingData(:,selecFeaturesIdx(i));
        k = k +1;   
    end

    handles.classMap = classify(New_trainingData, handles.group, New_features, handles.labelMatrix);
    
    axes(handles.axes1);
    image(label2rgb(handles.classMap));
    ratio = size(handles.classMap,2)/size(handles.classMap,1);
    set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);
    uiwait(msgbox('Classification Done'));
else
    uiwait(msgbox('No Feature Selected'));
end

guidata(hObject, handles);

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox2.
function listbox2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in feature1.
function feature1_Callback(hObject, eventdata, handles)
% hObject    handle to feature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature1


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selecFeaturesIdx  = CART(handles.trainingData, handles.group);

for i = 1:handles.numOfFeatures
    if(size(find(selecFeaturesIdx == i)) ~= 0)   
        set(handles.checkBox(i), 'Value', 1);  
    else
        set(handles.checkBox(i), 'Value', 0);  
    end
end

% --- Executes on button press in feature12.
function feature9_Callback(hObject, eventdata, handles)
% hObject    handle to feature12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature12


% --- Executes on button press in feature4.
function feature4_Callback(hObject, eventdata, handles)
% hObject    handle to feature4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature4


% --- Executes on button press in feature5.
function feature5_Callback(hObject, eventdata, handles)
% hObject    handle to feature5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature5


% --- Executes on button press in feature6.
function feature6_Callback(hObject, eventdata, handles)
% hObject    handle to feature6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature6


% --- Executes on button press in feature7.
function feature7_Callback(hObject, eventdata, handles)
% hObject    handle to feature7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature7


% --- Executes on button press in feature8.
function feature8_Callback(hObject, eventdata, handles)
% hObject    handle to feature8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature8


% --- Executes on button press in feature12.
function feature10_Callback(hObject, eventdata, handles)
% hObject    handle to feature12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature12


% --- Executes on button press in feature12.
function feature12_Callback(hObject, eventdata, handles)
% hObject    handle to feature12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature12


% --- Executes on button press in feature2.
function feature2_Callback(hObject, eventdata, handles)
% hObject    handle to feature2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature2


% --- Executes on button press in feature3.
function feature3_Callback(hObject, eventdata, handles)
% hObject    handle to feature3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature3


% --- Executes on button press in feature1.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to feature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feature1


% --- Executes on button press in pushbutton8 "Save Data"
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data{1} = handles.classMap;
data{2} = handles.labelMatrix;
data{3} = handles.features;
data{4} = handles.group ;
data{5} = handles.trainingData;

[FileName, PathName] = uiputfile('*.mat', 'Save As'); 
datafile = fullfile(PathName,FileName);
save(datafile,'data');




% --- Executes on button press in pushbutton9 " Load Data"
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[baseFileName, folder] = uigetfile('*.mat', 'Load File');
datafile = fullfile(folder, baseFileName);
load(datafile);
handles.classMap = data{1} ;
handles.labelMatrix = data{2} ;
handles.features = data{3} ;
handles.group  = data{4} ;
handles.trainingData = data{5} ;

image(label2rgb(handles.classMap));
ratio = size(handles.classMap,2)/size(handles.classMap,1);
set(handles.axes1,'PlotBoxAspectRatio', [ratio 1 1]);
guidata(hObject,handles);


% --- Executes on button press in pushbutton10 " View features for selected objects" 
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y] = getpts(handles.axes1);
objectId = handles.labelMatrix(ceil(y),ceil(x));     
objectFeatures = handles.features(objectId,:);
    
%{
uitable('PropertyName1', value1,'PropertyName2',value2,...)
uitable(parent,...)
handle = uitable(...)
    %}
f = figure('Position',[200 200 900 150]);
dat = objectFeatures; 
cnames = {'Mean1','Mean2','Mean3','Area','ConvexArea','Eccentricity','Perimeter','Solidity','Smoothness','Variance1','Variance2','Variance3'};
rnames = {'Object'};
t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 870 100]);
