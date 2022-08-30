clear;clc;
mu1=[0 0]; 
S1=[1 0.8;0.8 1];  
inputData = mvnrnd(mu1, S1, 1000);     %产生高斯分布数据  1000个二维样本
K = 1;                               %K代表前K个特征值
[row,col] = size(inputData);         %%获取输入数据的行数和列数
%求均值
Aver = mean(inputData);
%构建均值向量
AverData = repmat(Aver, row, 1);    
%对每个向量去均值
MeanValue = inputData - AverData; 
%计算协方差
CovData = MeanValue' * MeanValue / row;
%计算特征向量FVector，特征值FData
[FVector, FData] = eig(CovData);
%将特征向量按降序排序
FeaData = diag(FData)                 %对角线数据，即为特征值
[~, order] = sort(FeaData, 'descend');%将特征值进行降序排列
FVector = FVector(:, order)           %将特征向量按照特征值进行降序排列
%取前K个最大的特征值所对应的特征向量构成投影矩阵 
Projection_matrix = FVector(:, 1:K);
%任意给定的高维数据，它的低纬度表示如下
NewData =  inputData * Projection_matrix;
%Fv_k = Projection_matrix(2,:)-Projection_matrix(1,:);
figure(1);
plot(inputData(:,1),inputData(:,2),'g.');
hold on;
compass(FVector(1, :), FVector(2, :), 'black')
result = FVector(1, :) * FVector(2, :)'
xlim([-4, 4]);
ylim([-4, 4]);
title('类椭圆形2维随机数据');
hold on;
Data = NewData * (Projection_matrix');
plot(Data(:, 1), Data(:, 2), 'r.');
title('主成分分析') ; 

%结果：通过PCA进行降维后，输入的二维数据转换为一维的数据，并且投影到了直线上，降维后的特征向量采用黑色箭头画出来了