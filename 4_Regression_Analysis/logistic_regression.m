clear; close all; clc;
%生成两类数据
s = rng(7, 'v5normal');
%第一类随机分布
ave1 = [0 0];                     %均值
S1 = [1 0.9; 0.9 1];              %协方差
data1 = mvnrnd(ave1, S1, 50);     %产生高斯分布数据  
labe1 = ones(50, 1);              %第一类数据的标签
%第二类随机分布
ave2 = [2 0];                      %均值
S2 = [1 0.9; 0.9 1];               %协方差
data2 = mvnrnd(ave2, S2, 50);      %产生高斯分布数据  
labe2 = zeros(50, 1);              %第二类数据的标签
figure;
plot(data1(:, 1), data1(:, 2), 'kx');
hold on;
plot(data2(:, 1), data2(:, 2), 'bo');
%整合
Data  = [data1; data2];         %训练样本数据
label = [labe1; labe2];         %样本标签
[row, col] = size(Data);        %获取样本的行列
Data = [ones(row, 1) Data];     %用于计算边界
%代价函数
a = 100;                        %学习率
w = zeros(size(Data, 2), 1);    %初始化权重系数 size(Data,2)返回Data的列数
k = 0;                          %初始化迭代次数
while(1)
    temp = w;
    %w:theta系数  x:输入参数  y:输出标签/分界  J:损失函数  gradient:梯度
    len = length(label);
    H_w = sigmoid(Data * w);            %激活函数
    J = 1 / len * sum(-label .*log(H_w) - (1 - label) .* log(1 - H_w));  %损失函数
    gradient = (1 / len) * Data' * (H_w - label);  %梯度下降求解损失函数最小值
    w = w - a * gradient;  %更新权重值
    if(w == temp)      %梯度下降到最小值，不再进行梯度下降
        break;
    else
        k = k + 1;     %继续梯度下降
    end;
end
disp(['k=', num2str(k)]);
plot_x = [min(Data(:, 2)) - 4, max(Data(:, 2))];
plot_y = (-1 ./ w(3)) .* (w(1) + w(2) .* plot_x) ;
hold on
plot(plot_x, plot_y, 'r')       %绘制逻辑回归线
axis([-3, 4, -3, 4])
title('逻辑回归分析')
legend('y = 1', 'y = 0', '逻辑回归', 'location', 'northwest')
hold off;