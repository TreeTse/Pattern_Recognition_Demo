%����BP�����磬ѵ������
clc; clear; close all;
temp = load('train_x.mat');
train_x = double(temp.train_x);
temp = load('train_y.mat');
train_y = double(temp.train_y);
%sampleNum: ��������  featureNum: ÿ������ά��
[sampleNum, featureNum] = size(train_x);
%��ȡ��������ά��
[~, outputNum] = size(train_y);
%�����м��Ľڵ����
Node = 80;
%����ѵ������
%�����뼶���м伶��Ȩ�غͳ�ʼֵ
input_center.W = rand(Node, featureNum) - 0.5;  %%80*25
input_center.C = zeros(Node, 1);   
input_center.C = repmat(input_center.C, 1, 100);
%���м伶���������Ȩ�غͳ�ʼֵ
center_output.W = rand(outputNum, Node) - 0.5;   %%10*80
center_output.C = zeros(outputNum, 1);    
center_output.C = repmat(center_output.C, 1, 100);
%ѧϰ����
learn_speed = 0.01;
%ѵ������
time = 0;
trainMax = 10000;
figure;
hold on;
xlabel('��������');
ylabel('������');
while(1)
%���򴫲��㷨ʵ��
 centerIn = train_x * (input_center.W)' + (input_center.C)';
 centerOut = sigmoid(centerIn); 
 outputIn = centerOut * (center_output.W)' + (center_output.C)';
 outputOut = sigmoid(outputIn);

%���򴫲��㷨ʵ��
%���������Ԫ�����
outputError = -(train_y - outputOut) .* outputOut .* (1-outputOut);
%�����м䵥Ԫ�����
centerError = centerOut .* (1-centerOut) .* (outputError * center_output.W);
%����ÿ�������Ȩ��
input_center.W = input_center.W - learn_speed * (centerError)' * train_x;
center_output.W = center_output.W - learn_speed * (outputError)' * centerOut;

%���������Ԫ���
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
%������input_center��center_output���mode.mat�ļ���
save('mode.mat', 'input_center', 'center_output');

%������ѵ����˼·:ʹ�������������磬���Ȼ�ȡ��������,������һ��100*25�ľ���
%����Ӧ100������ͼƬ����ÿ��25���ٷֱȵ����ݣ��������Ԫȡ��10������Ϊ��0-9��
%10�����֣����ز㵥Ԫȡ80��,Ȼ������Ȩ�أ����÷��򴫲��㷨��ͨ�����ϵ�����������
%�㵽���ز�����ز㵽������Ȩ��,����Ȩ��д��mode.mat�ļ�






