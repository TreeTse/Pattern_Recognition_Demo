%����ѵ����
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
        imgBinary = im2bw(imgGray,0.5);   %ͼ���ֵ��      
        [ySize, xSize] = size(imgBinary); %��ȡͼƬ�ĳ��ȺͿ����Ϣ
        %��ʼ������
        xLeft = 0 ;
        xRight = 0 ;
        yTop = 0;
        yButtom = 0 ;
        firstFlag = 0 ;    %���ڱ�Ǽ�⵽��һ����
        %�ҳ�ROI ����
        %������ұ�Ե
        for i = 1 : xSize
            sum = 0;    %��ռ���
            for j = 1 : ySize
                sum = sum + imgBinary(j, i);   %ÿһ���ۼ�
            end;
            if sum < ySize && firstFlag == 0 
                    xLeft = i;                 %���Ե���
                    firstFlag = 1;  
            end;
            if sum == ySize && firstFlag == 1
                xRight = i;                    %�ұ�Ե���
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == xSize   %�Ҳ����ұ�Ե��Ĭ�����ұ߽�Ϊ�ұ�Ե
                xRight = i;
                firstFlag = 0 ;
            end;    
        end;
       firstFlag = 0;
        %������±�Ե
        for i = 1 : ySize
            sum = 0;    %��ռ���
            for j = 1 : xSize
                sum = sum + imgBinary(i, j);   %ÿһ���ۼ�
            end;
            if sum < xSize && firstFlag == 0 
                    yTop = i; %�ϱ�Ե���
                    firstFlag = 1;  
            end;
            if sum == xSize && firstFlag == 1
                yButtom = i;  %�±�Ե���
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == ySize %�Ҳ����ұ�Ե��Ĭ�����ұ߽�Ϊ�ұ�Ե
                yButtom = i;
                firstFlag = 0 ;
            end;    
        end;
        %��ȡROI����         
        imgROI = imcrop(imgBinary, [xLeft yTop (xRight -xLeft) (yButtom - yTop)]);
        %��ȡ��������
        [ylengthROI, xlengthROI] = size (imgROI);
        xScale = floor( xlengthROI / 5 );
        yScale = floor( ylengthROI / 5 );
        counterTemp = 1;   %ͳ��5*5������������
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
save('train_x.mat', 'train_x');   %������train_x���浽train_x.mat�ļ���
save('train_y.mat', 'train_y');







