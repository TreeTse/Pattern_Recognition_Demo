%生成训练集
clc;clear;
for num = 0 : 9
    for item = 1 : 10
        str = '.\train\';
        str = strcat( str, num2str(num) );
        str = strcat( str, '\' );
        str = strcat( str, num2str(num) );
        str = strcat( str, '-' );
        str = strcat( str, num2str(item) );
        str = strcat( str, '.bmp' );
        img = imread(str);
        imgGray = img;
        imgBinary = im2bw(imgGray,0.5);   %图像二值化      
        [ySize, xSize] = size(imgBinary); %获取图片的长度和宽度信息
        %初始化参数
        xLeft = 0 ;
        xRight = 0 ;
        yTop = 0;
        yButtom = 0 ;
        firstFlag = 0 ;    %用于标记检测到第一条边
        %找出ROI 数字
        %检测左右边缘
        for i = 1 : xSize
            sum = 0;    %清空计数
            for j = 1 : ySize
                sum = sum + imgBinary(j, i);   %每一列累加
            end;
            if sum < ySize && firstFlag == 0 
                    xLeft = i;                 %左边缘检测
                    firstFlag = 1;  
            end;
            if sum == ySize && firstFlag == 1
                xRight = i;                    %右边缘检测
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == xSize   %找不到右边缘，默认最右边界为右边缘
                xRight = i;
                firstFlag = 0 ;
            end;    
        end;
       firstFlag = 0;
        %检测上下边缘
        for i = 1 : ySize
            sum = 0;    %清空计数
            for j = 1 : xSize
                sum = sum + imgBinary(i, j);   %每一列累加
            end;
            if sum < xSize && firstFlag == 0 
                    yTop = i; %上边缘检测
                    firstFlag = 1;  
            end;
            if sum == xSize && firstFlag == 1
                yButtom = i;  %下边缘检测
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == ySize %找不到右边缘，默认最右边界为右边缘
                yButtom = i;
                firstFlag = 0 ;
            end;    
        end;
        %截取ROI区域         
        imgROI = imcrop(imgBinary, [xLeft yTop (xRight -xLeft) (yButtom - yTop)]);
        %获取数字特征
        [ylengthROI, xlengthROI] = size (imgROI);
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
                imgTemp = imcrop(imgROI, [((i - 1) * xScale) ((j - 1) * yScale)  xScaleTemp yScaleTemp]);
                [ylengthTemp, xlengthTemp] = size(imgTemp);
                sum = 0 ;
                for x = 1 : xlengthTemp
                    for y = 1: ylengthTemp
                        sum = sum + imgTemp(y, x);
                    end;
                end;
                train_x(num * 10 + item, counterTemp) = 1 - sum / (ylengthTemp * xlengthTemp);
                counterTemp = counterTemp + 1;                   
            end;
        end;
        train_y(num * 10 + item, num + 1) = 1;
    end; 
end;
save('train_x.mat', 'train_x');   %将变量train_x保存到train_x.mat文件中
save('train_y.mat', 'train_y');







