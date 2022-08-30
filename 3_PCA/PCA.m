clear;clc;
mu1=[0 0]; 
S1=[1 0.8;0.8 1];  
inputData = mvnrnd(mu1, S1, 1000);     %������˹�ֲ�����  1000����ά����
K = 1;                               %K����ǰK������ֵ
[row,col] = size(inputData);         %%��ȡ�������ݵ�����������
%���ֵ
Aver = mean(inputData);
%������ֵ����
AverData = repmat(Aver, row, 1);    
%��ÿ������ȥ��ֵ
MeanValue = inputData - AverData; 
%����Э����
CovData = MeanValue' * MeanValue / row;
%������������FVector������ֵFData
[FVector, FData] = eig(CovData);
%��������������������
FeaData = diag(FData)                 %�Խ������ݣ���Ϊ����ֵ
[~, order] = sort(FeaData, 'descend');%������ֵ���н�������
FVector = FVector(:, order)           %������������������ֵ���н�������
%ȡǰK����������ֵ����Ӧ��������������ͶӰ���� 
Projection_matrix = FVector(:, 1:K);
%��������ĸ�ά���ݣ����ĵ�γ�ȱ�ʾ����
NewData =  inputData * Projection_matrix;
%Fv_k = Projection_matrix(2,:)-Projection_matrix(1,:);
figure(1);
plot(inputData(:,1),inputData(:,2),'g.');
hold on;
compass(FVector(1, :), FVector(2, :), 'black')
result = FVector(1, :) * FVector(2, :)'
xlim([-4, 4]);
ylim([-4, 4]);
title('����Բ��2ά�������');
hold on;
Data = NewData * (Projection_matrix');
plot(Data(:, 1), Data(:, 2), 'r.');
title('���ɷַ���') ; 

%�����ͨ��PCA���н�ά������Ķ�ά����ת��Ϊһά�����ݣ�����ͶӰ����ֱ���ϣ���ά��������������ú�ɫ��ͷ��������