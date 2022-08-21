%该文件用于生成data.txt，保存样本数据库的特征值
clc;clear;
SumData(1:60,1:25)=0;    %一共有60个样本

for LET = 'A' : 'F'    
    for item = 1 : 10
        str = '.\Sample\';
        str = strcat( str , num2str( LET ) );
        str = strcat( str , '\' );
        str = strcat( str , num2str( LET ) );
        str = strcat( str , '-' );
        str = strcat( str , num2str( item ) );
        str = strcat( str , '.bmp' );
        
        img = imread(str);               %读取照片
        imgGray = rgb2gray(img);         %转换为灰度图
        imgBinary = im2bw(imgGray,0.5);  %转换为二值图
        
        len = size(imgBinary);
        ySize = len(1);                %存储的是行数
        xSize = len(2);                %存储的是列数
        
        xLeft = 0 ;
        xRight = 0 ;
        yTop = 0;
        yButtom = 0 ;
        firstFlag = 0 ;                %用于标记检测到第一条边
        
        %找出ROI数字，检测左右边缘
        for i = 1 : xSize
            sum = 0;                   %清空计数
            for j = 1 : ySize
                sum = sum + imgBinary(j,i);%sum得到的是每一列累加的累加值
            end;
            if sum < ySize && firstFlag == 0 
                    xLeft = i;         %左边缘检测
                    firstFlag = 1;  
            end;
            if sum == ySize && firstFlag == 1
                xRight = i; %右边缘检测
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == xSize %找不到右边缘，默认最右边界为右边缘
                xRight = i;
                firstFlag = 0 ;
            end;    
        end;
       clear i;
       clear j;
       %上下边缘的检测也是同等道理
       firstFlag=0;
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
        
        clear i;
        clear j;
        %截取ROI区域
        imgROI = imcrop (imgBinary,[xLeft yTop (xRight -xLeft) (yButtom - yTop)]);
        [ylengthROI,xlengthROI] = size ( imgROI );
        %分为5等分
        xScale = floor( xlengthROI / 5 );
        yScale = floor( ylengthROI / 5 );
        counterTemp = 1;   %统计5*5的区域计算情况
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
                imgTemp = imcrop( imgROI , [ ((i-1) * xScale) ((j-1) * yScale)  xScaleTemp yScaleTemp]);
                [ylengthTemp,xlengthTemp] = size(imgTemp);
                sum = 0 ;
                for x = 1 : xlengthTemp
                    for y = 1: ylengthTemp
                        sum = sum + imgTemp(y,x);    %统计每一小块的像素和
                    end;
                end
                %分别计算全部样本，其黑色像素所占的比例
                SumData( (double(LET) - 65) * 10 + item ,counterTemp) = 1 - sum / (ylengthTemp * xlengthTemp);
                counterTemp = counterTemp + 1;                   
            end;
        end;
    end;
end;

f_data = fopen('G:\machine learning\Lab1_xsh\Sample\data.txt','wt');
[len1, len2] = size(SumData);
clear i;clear j;
for i = 1 : len1
    for j = 1 : len2
        fprintf(f_data,'%8.4f',SumData(i,j));  %将数据写入到文本文件中
    end;
    fprintf(f_data,'\n');
end;
fclose(f_data);
   

