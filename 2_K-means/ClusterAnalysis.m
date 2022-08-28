% 生成4组数据并显示，用k-means聚类算法进行聚类，将不同的聚类用不同颜色显示出来
clc;clear;close all;
%% 生成高斯分布的随机数据
%第一类数据
mu1=[1.0 1.0];              %均值
S1=[0.3 0;0 0.35];          %协方差/生成的数据的自相关矩阵
data1=mvnrnd(mu1,S1,250);   %产生高斯分布数据

%第二类数据
mu1=[3.0 1.0];
S1=[0.3 0;0 0.35];
data2=mvnrnd(mu1,S1,250);

%第三类数据
mu1=[1.0 -1.0];
S1=[0.3 0;0 0.35];
data3=mvnrnd(mu1,S1,250);

%第四类数据
mu1=[3.0 -1.0];
S1=[0.3 0;0 0.35];
data4=mvnrnd(mu1,S1,250);

%显示数据
figure(1);
plot(data1(:, 1), data1(:, 2), 'k.');
title('满足高斯随机分布的四组原始随机点');
hold on;
plot(data2(:,1),data2(:,2),'g+');
plot(data3(:,1),data3(:,2),'m*');
plot(data4(:,1),data4(:,2),'ys');
hold off;

%四组数据合并到一起
data = [data1(:, 1), data1(:, 2); data2(:, 1), data2(:, 2); data3(:, 1), data3(:, 2); data4(:, 1), data4(:, 2);];
%显示数据库
%figure(2);
%plot(data(:,1),data(:,2),'g+');
%title('原始随机点');

%% 生成随机的四个簇的中心位置
% 取随机四个点，作为中心，也是作为区分的簇，本实验取四个簇，分成四类
%产生在1~length（data(:,1)）范围内的伪随机整数
data1_center = randi([1, length(data(:, 1))]);
data2_center = randi([1, length(data(:, 1))]);
data3_center = randi([1, length(data(:, 1))]);
data4_center = randi([1, length(data(:, 1))]);

data1_center = data(data1_center, :);
data2_center = data(data2_center, :);
data3_center = data(data3_center, :);
data4_center = data(data4_center, :);

%显示取得的四个初始的随机点的位置
hold on;
plot(data1_center(:, 1), data1_center(:, 2),'ko');
plot(data2_center(:, 1), data2_center(:, 2),'ko');
plot(data3_center(:, 1), data3_center(:, 2),'ko');
plot(data4_center(:, 1), data4_center(:, 2),'ko');
title('原始随机点');

%% 开始聚类分析
TIMES = 10; %迭代计算10次

for j=1:1:TIMES
    ClustData1 = [];
    ClustData2 = [];
    ClustData3 = [];
    ClustData4 = [];
    for i = 1: 1: length(data(:, 1)) - 1
        % 每一个数据都对四个中心求欧氏距离
        dis_2_data1 = ( data(i, 1) - data1_center(1, 1) ) ^ 2 + ( data(i, 2) - data1_center(1, 2) ) ^ 2 ;
        dis_2_data2 = ( data(i, 1) - data2_center(1, 1) ) ^ 2 + ( data(i, 2) - data2_center(1, 2) ) ^ 2 ;
        dis_2_data3 = ( data(i, 1) - data3_center(1, 1) ) ^ 2 + ( data(i, 2) - data3_center(1, 2) ) ^ 2 ;
        dis_2_data4 = ( data(i, 1) - data4_center(1, 1) ) ^ 2 + ( data(i, 2) - data4_center(1, 2) ) ^ 2 ;
        
        % 利用sort函数对四个距离进行排序，取最小值
        [ dis_order, NUM] = sort([dis_2_data1 dis_2_data2 dis_2_data3 dis_2_data4], 'ascend');
        switch NUM(1, 1)
            case 1
                ClustData1 = [ ClustData1; data(i,:) ];
            case 2
                ClustData2 = [ ClustData2; data(i,:) ];
            case 3
                ClustData3 = [ ClustData3; data(i,:) ];
            case 4
                ClustData4 = [ ClustData4; data(i,:) ];
        end;
        
    end;
   % 重新计算四个簇的中心位置
   data1_center(1, 1) = sum( ClustData1(:, 1) ) / length(ClustData1(:, 1));
   data1_center(1, 2) = sum( ClustData1(:, 2) ) / length(ClustData1(:, 2));
   data2_center(1, 1) = sum( ClustData2(:, 1) ) / length(ClustData2(:, 1));
   data2_center(1, 2) = sum( ClustData2(:, 2) ) / length(ClustData2(:, 2));
   data3_center(1, 1) = sum( ClustData3(:, 1) ) / length(ClustData3(:, 1));
   data3_center(1, 2) = sum( ClustData3(:, 2) ) / length(ClustData3(:, 2));
   data4_center(1, 1) = sum( ClustData4(:, 1) ) / length(ClustData4(:, 1));
   data4_center(1, 2) = sum( ClustData4(:, 2) ) / length(ClustData4(:, 2));
    %% 显示聚类分析后的数据
    figure(3);
    plot(ClustData1(:, 1), ClustData1(:, 2), 'kx');
    title('聚类分析的结果');
    hold on;
    plot(ClustData2(:, 1), ClustData2(:, 2), 'gs');
    plot(ClustData3(:, 1), ClustData3(:, 2), 'b*');
    plot(ClustData4(:, 1), ClustData4(:, 2), 'y.');

    plot(data1_center(:, 1), data1_center(:, 2), 'ro');
    plot(data2_center(:, 1), data2_center(:, 2), 'ro');
    plot(data3_center(:, 1), data3_center(:, 2), 'ro');
    plot(data4_center(:, 1), data4_center(:, 2), 'ro');
    hold off;

    pause(0.5);
end;



