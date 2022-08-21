%���ļ���������data.txt�������������ݿ������ֵ
clc;clear;
SumData(1:60,1:25)=0;    %һ����60������

for LET = 'A' : 'F'    
    for item = 1 : 10
        str = '.\Sample\';
        str = strcat( str , num2str( LET ) );
        str = strcat( str , '\' );
        str = strcat( str , num2str( LET ) );
        str = strcat( str , '-' );
        str = strcat( str , num2str( item ) );
        str = strcat( str , '.bmp' );
        
        img = imread(str);               %��ȡ��Ƭ
        imgGray = rgb2gray(img);         %ת��Ϊ�Ҷ�ͼ
        imgBinary = im2bw(imgGray,0.5);  %ת��Ϊ��ֵͼ
        
        len = size(imgBinary);
        ySize = len(1);                %�洢��������
        xSize = len(2);                %�洢��������
        
        xLeft = 0 ;
        xRight = 0 ;
        yTop = 0;
        yButtom = 0 ;
        firstFlag = 0 ;                %���ڱ�Ǽ�⵽��һ����
        
        %�ҳ�ROI���֣�������ұ�Ե
        for i = 1 : xSize
            sum = 0;                   %��ռ���
            for j = 1 : ySize
                sum = sum + imgBinary(j,i);%sum�õ�����ÿһ���ۼӵ��ۼ�ֵ
            end;
            if sum < ySize && firstFlag == 0 
                    xLeft = i;         %���Ե���
                    firstFlag = 1;  
            end;
            if sum == ySize && firstFlag == 1
                xRight = i; %�ұ�Ե���
                firstFlag = 0;
            end;
            if firstFlag == 1 && i == xSize %�Ҳ����ұ�Ե��Ĭ�����ұ߽�Ϊ�ұ�Ե
                xRight = i;
                firstFlag = 0 ;
            end;    
        end;
       clear i;
       clear j;
       %���±�Ե�ļ��Ҳ��ͬ�ȵ���
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
        %��ȡROI����
        imgROI = imcrop (imgBinary,[xLeft yTop (xRight -xLeft) (yButtom - yTop)]);
        [ylengthROI,xlengthROI] = size ( imgROI );
        %��Ϊ5�ȷ�
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
                imgTemp = imcrop( imgROI , [ ((i-1) * xScale) ((j-1) * yScale)  xScaleTemp yScaleTemp]);
                [ylengthTemp,xlengthTemp] = size(imgTemp);
                sum = 0 ;
                for x = 1 : xlengthTemp
                    for y = 1: ylengthTemp
                        sum = sum + imgTemp(y,x);    %ͳ��ÿһС������غ�
                    end;
                end
                %�ֱ����ȫ�����������ɫ������ռ�ı���
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
        fprintf(f_data,'%8.4f',SumData(i,j));  %������д�뵽�ı��ļ���
    end;
    fprintf(f_data,'\n');
end;
fclose(f_data);
   

