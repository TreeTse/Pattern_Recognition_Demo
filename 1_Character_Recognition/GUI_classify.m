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
axis([0 500 0 500]);      %限定绘制图片区域的像素个数500*500
clc;

% 本样例中，建立了6个样本种类，每个种类包含10个样本
% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f,p] = uiputfile({'*.bmp'},'保存文件');
str = strcat(p,f);
px = getframe(handles.axes1);          %获取当前的图形axes1
curImg = frame2im(px);
imwrite(curImg,str,'bmp');             %保存图像
disp('成功保存!')                      %命令行提示：成功保存图片


% --- Executes on button press in button_classify.
function button_classify_Callback(hObject, eventdata, handles)
% hObject    handle to button_classify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
px = getframe(handles.axes1);
img = frame2im(px);
imgGray = rgb2gray(img);               %把三维的rgb图转成二维的灰度图
imgBinary = im2bw(imgGray,0.5);        %把灰度图像转换为二值图像
        len = size(imgBinary);
        ySize = len(1);    %len(1)存储的是行数
        xSize = len(2);    %len(2)存储的是列数
        xLeft = 0 ;
        xRight = 0 ;
        yTop = 0;
        yButtom = 0 ;
        firstFlag = 0 ;     %用于标记检测到第一条边
        %找出ROI数字，检测左右边缘
        for i = 1 : xSize
            sum = 0;    %清空计数
            for j = 1 : ySize
                sum = sum + imgBinary(j,i);  %sum得到的是每一列累加的累加值
            end;
            if sum < ySize && firstFlag == 0 
                    xLeft = i;               %左边缘检测
                    firstFlag = 1;  
            end;
            if sum == ySize && firstFlag == 1
                xRight = i; %右边缘检测
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == xSize  %找不到右边缘，默认最右边界为右边缘
                xRight = i;
                firstFlag = 0 ;
            end;    
        end;
       clear i;
       clear j;
       firstFlag = 0;
        %上下边缘的检测也是同等道理
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
%剪裁图像
imgROI = imcrop (imgBinary,[xLeft yTop (xRight -xLeft) (yButtom - yTop)]); 
[ylengthROI,xlengthROI] = size ( imgROI );
xScale = floor( xlengthROI / 5 );
yScale = floor( ylengthROI / 5 );
SumData(1:25) =0;
SampleData = cell(60,25);  %初始化                     
%加载已经存进文件的样本数据
SampleData = load ('.\Sample\data.txt');
%把图像分层25份  计算每一格黑色笔画所占的百分比
counter = 1;          %统计5*5的区域计算情况
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
    ComMin(i) = sqrt(temp);          %分别计算与60组样本数据的欧氏距离
end

[sortData,sortIndex] = sort(ComMin,'ascend');         %按从小到大排序  返回数据数组 下标数组
currentNum = floor((sortIndex(1) - 1) / 10 ) + 65;    %计算该下标属于哪个字母

s = sprintf('当前写的字母是 %c',currentNum);
msgbox(s,'Classify','help');   %调用msgbox函数进行提示


% --- Executes on button press in button_clear.
function button_clear_Callback(hObject, eventdata, handles)
% hObject    handle to button_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;    %直接清除


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ButtonDown pos1;
if strcmp(get(gcf,'SelectionType'),'normal')            %按下鼠标左键
    ButtonDown = 1;                                     %按下flag
    pos1 = get(handles.axes1,'CurrentPoint');           %取得按下坐标       
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ButtonDown pos1;
if(ButtonDown == 1)                                     %鼠标左键按下
    pos = get(handles.axes1,'CurrentPoint');            %获得移动坐标
    line([pos1(1,1) pos(1,1)],[pos1(1,2) pos(1,2)],'LineStyle','-','LineWidth',9,'Color','Black','Marker','.','MarkerSize',20);
    pos1 = pos;                                         %两点间画线后更新
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ButtonDown;
ButtonDown = 0;
