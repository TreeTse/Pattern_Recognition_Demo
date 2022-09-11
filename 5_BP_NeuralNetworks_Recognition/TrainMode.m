%构建BP神经网络，训练参数
clc; clear; close all;
temp = load('train_x.mat');
train_x = double(temp.train_x);
temp = load('train_y.mat');
train_y = double(temp.train_y);
%sampleNum: 样本个数  featureNum: 每个样本维度
[sampleNum, featureNum] = size(train_x);
%获取输出结果的维度
[~, outputNum] = size(train_y);
%设置中间层的节点个数
Node = 80;
%设置训练参数
%从输入级到中间级的权重和初始值
input_center.W = rand(Node, featureNum) - 0.5;  %%80*25
input_center.C = zeros(Node, 1);   
input_center.C = repmat(input_center.C, 1, 100);
%从中间级到输出级的权重和初始值
center_output.W = rand(outputNum, Node) - 0.5;   %%10*80
center_output.C = zeros(outputNum, 1);    
center_output.C = repmat(center_output.C, 1, 100);
%学习速率
learn_speed = 0.01;
%训练次数
time = 0;
trainMax = 10000;
figure;
hold on;
xlabel('迭代次数');
ylabel('错误率');
while(1)
%正向传播算法实现
 centerIn = train_x * (input_center.W)' + (input_center.C)';
 centerOut = sigmoid(centerIn); 
 outputIn = centerOut * (center_output.W)' + (center_output.C)';
 outputOut = sigmoid(outputIn);

%反向传播算法实现
%计算输出单元误差项
outputError = -(train_y - outputOut) .* outputOut .* (1-outputOut);
%计算中间单元误差项
centerError = centerOut .* (1-centerOut) .* (outputError * center_output.W);
%更新每个网络的权重
input_center.W = input_center.W - learn_speed * (centerError)' * train_x;
center_output.W = center_output.W - learn_speed * (outputError)' * centerOut;

%计算输出单元误差
lost = sum(sum(((outputOut - train_y) .^ 2)')) / sampleNum; 
time = time + 1;
hold on;
plot(time, lost, 'b.');
disp(['lost = ' num2str(lost)]);
if(lost <= 0.05)
    break;
elseif(time == trainMax)
    break;
end
pause(0.0001);
end
hold off;
%将变量input_center、center_output存进mode.mat文件里
save('mode.mat', 'input_center', 'center_output');

%神经网络训练的思路:使用了两层神经网络，首先获取样本数据,输入是一个100*25的矩阵，
%即对应100张样本图片，其每张25个百分比的数据，输出层神经元取了10个，因为有0-9共
%10个数字，隐藏层单元取80个,然后设置权重，利用反向传播算法，通过不断迭代更新输入
%层到隐藏层和隐藏层到输出层的权重,最后把权重写入mode.mat文件






