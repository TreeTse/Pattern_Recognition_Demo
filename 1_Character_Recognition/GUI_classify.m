function varargout = GUI_classify(varargin)
% GUI_CLASSIFY MATLAB code for GUI_classify.fig
%      GUI_CLASSIFY, by itself, creates a new GUI_CLASSIFY or raises the existing
%      singleton*.
%
%      H = GUI_CLASSIFY returns the handle to a new GUI_CLASSIFY or the handle to
%      the existing singleton*.
%
%      GUI_CLASSIFY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CLASSIFY.M with the given input arguments.
%
%      GUI_CLASSIFY('Property','Value',...) creates a new GUI_CLASSIFY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_classify_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_classify_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_classify

% Last Modified by GUIDE v2.5 24-Apr-2019 15:12:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_classify_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_classify_OutputFcn, ...
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


% --- Executes just before GUI_classify is made visible.
function GUI_classify_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_classify (see VARARGIN)

% Choose default command line output for GUI_classify
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_classify wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_classify_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
axis([0 500 0 500]);      %??????????????????????????500*500
clc;

% ????????????????6????????????????????????10??????
% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f,p] = uiputfile({'*.bmp'},'????????');
str = strcat(p,f);
px = getframe(handles.axes1);          %??????????????axes1
curImg = frame2im(px);
imwrite(curImg,str,'bmp');             %????????
disp('????????!')                      %????????????????????????


% --- Executes on button press in button_classify.
function button_classify_Callback(hObject, eventdata, handles)
% hObject    handle to button_classify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
px = getframe(handles.axes1);
img = frame2im(px);
imgGray = rgb2gray(img);               %????????rgb??????????????????
imgBinary = im2bw(imgGray,0.5);        %????????????????????????
        len = size(imgBinary);
        ySize = len(1);    %len(1)????????????
        xSize = len(2);    %len(2)????????????
        xLeft = 0 ;
        xRight = 0 ;
        yTop = 0;
        yButtom = 0 ;
        firstFlag = 0 ;     %??????????????????????
        %????ROI??????????????????
        for i = 1 : xSize
            sum = 0;    %????????
            for j = 1 : ySize
                sum = sum + imgBinary(j,i);  %sum??????????????????????????
            end;
            if sum < ySize && firstFlag == 0 
                    xLeft = i;               %??????????
                    firstFlag = 1;  
            end;
            if sum == ySize && firstFlag == 1
                xRight = i; %??????????
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == xSize  %??????????????????????????????????
                xRight = i;
                firstFlag = 0 ;
            end;    
        end;
       clear i;
       clear j;
       firstFlag = 0;
        %??????????????????????????
        for i = 1 : ySize
            sum = 0;   
            for j = 1 : xSize
                sum = sum + imgBinary(i,j);
            end;
            if sum < xSize && firstFlag == 0 
                    yTop = i;
                    firstFlag = 1;  
            end;
            if sum == xSize && firstFlag == 1
                yButtom = i; 
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == ySize 
                yButtom = i;
                firstFlag = 0 ;
            end;    
        end;    
%????????
imgROI = imcrop (imgBinary,[xLeft yTop (xRight -xLeft) (yButtom - yTop)]); 
[ylengthROI,xlengthROI] = size ( imgROI );
xScale = floor( xlengthROI / 5 );
yScale = floor( ylengthROI / 5 );
SumData(1:25) =0;
SampleData = cell(60,25);  %??????                     
%??????????????????????????
SampleData = load ('.\Sample\data.txt');
%??????????25??  ??????????????????????????????
counter = 1;          %????5*5??????????????
        for i = 1 : 5
            for j = 1 : 5
                 xScaleTemp = xScale;
                 yScaleTemp = yScale;
                if i == 5 
                    xScaleTemp = xlengthROI - 4 * xScale;
                end;
                if j == 5 
                    yScaleTemp = ylengthROI - 4 * yScale;
                end;
                imgTemp = imcrop( imgROI , [ ((i - 1) * xScale) ((j - 1) * yScale)  xScaleTemp yScaleTemp]);
                [ylengthTemp,xlengthTemp] = size(imgTemp);
                sum = 0 ;
                for x = 1 : xlengthTemp
                    for y = 1: ylengthTemp
                        sum = sum + imgTemp(y,x);
                    end;
                end;
                SumData(counter) = 1 - sum / (ylengthTemp * xlengthTemp);
                counter = counter + 1;                   
            end;
        end;
ComMin(1:25) = 0;
for i = 1:60
   temp = 0.0;
    for j = 1:25
       temp = temp + (SampleData(i,j) - SumData(j)) * (SampleData(i,j) - SumData(j));
    end
    ComMin(i) = sqrt(temp);          %??????????60????????????????????
end

[sortData,sortIndex] = sort(ComMin,'ascend');         %??????????????  ???????????? ????????
currentNum = floor((sortIndex(1) - 1) / 10 ) + 65;    %??????????????????????

s = sprintf('?????????????? %c',currentNum);
msgbox(s,'Classify','help');   %????msgbox????????????


% --- Executes on button press in button_clear.
function button_clear_Callback(hObject, eventdata, handles)
% hObject    handle to button_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;    %????????


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ButtonDown pos1;
if strcmp(get(gcf,'SelectionType'),'normal')            %????????????
    ButtonDown = 1;                                     %????flag
    pos1 = get(handles.axes1,'CurrentPoint');           %????????????       
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ButtonDown pos1;
if(ButtonDown == 1)                                     %????????????
    pos = get(handles.axes1,'CurrentPoint');            %????????????
    line([pos1(1,1) pos(1,1)],[pos1(1,2) pos(1,2)],'LineStyle','-','LineWidth',9,'Color','Black','Marker','.','MarkerSize',20);
    pos1 = pos;                                         %????????????????
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ButtonDown;
ButtonDown = 0;
