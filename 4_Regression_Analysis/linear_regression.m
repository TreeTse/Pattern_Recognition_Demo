clear; close all; clc;
mu1=[0 0];                      %均值
S1=[1 0.9; 0.9 1];              %协方差
inputData=mvnrnd(mu1, S1, 50);  %产生高斯分布数据  50个
x1 = inputData(:, 1);           %选取第一列       
x2 = inputData(:, 2);           %选取第二列
len = length(inputData);        %计算数据长度
figure;
plot(x1, x2, 'bx');
hold on;
xlim([-4, 4]);
ylim([-4, 4]);
title('随机生成线性数据');
%计算梯度
x1 = [ones(len, 1) x1];          %增加一列1 50行
w = zeros(size(x1(1, :)))';      %初始化线性回归函数的系数
iterations = 20;                 %迭代次数
alpha = 1;                       %学习率
k = 0;                           %迭代次数标志
while(1)
    temp = w;
    w = w - alpha * (1 / len) * x1' * ((x1 * w) - x2);     %更新w
    if(w == temp)
        break;
    elseif(k >= iterations)
        break;
    else
        k = k + 1;
    end;
    disp(['k=', num2str(k)]);
end;
plot_x = x1(:, 2);
plot_y = x1 * w;
%绘制拟合曲线
hold on;
plot(plot_x, plot_y, 'r-')
title('线性回归分析')
legend('训练样本','线性回归')
hold off;