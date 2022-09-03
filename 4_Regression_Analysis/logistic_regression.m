clear; close all; clc;
%������������
s = rng(7, 'v5normal');
%��һ������ֲ�
ave1 = [0 0];                     %��ֵ
S1 = [1 0.9; 0.9 1];              %Э����
data1 = mvnrnd(ave1, S1, 50);     %������˹�ֲ�����  
labe1 = ones(50, 1);              %��һ�����ݵı�ǩ
%�ڶ�������ֲ�
ave2 = [2 0];                      %��ֵ
S2 = [1 0.9; 0.9 1];               %Э����
data2 = mvnrnd(ave2, S2, 50);      %������˹�ֲ�����  
labe2 = zeros(50, 1);              %�ڶ������ݵı�ǩ
figure;
plot(data1(:, 1), data1(:, 2), 'kx');
hold on;
plot(data2(:, 1), data2(:, 2), 'bo');
%����
Data  = [data1; data2];         %ѵ����������
label = [labe1; labe2];         %������ǩ
[row, col] = size(Data);        %��ȡ����������
Data = [ones(row, 1) Data];     %���ڼ���߽�
%���ۺ���
a = 100;                        %ѧϰ��
w = zeros(size(Data, 2), 1);    %��ʼ��Ȩ��ϵ�� size(Data,2)����Data������
k = 0;                          %��ʼ����������
while(1)
    temp = w;
    %w:thetaϵ��  x:�������  y:�����ǩ/�ֽ�  J:��ʧ����  gradient:�ݶ�
    len = length(label);
    H_w = sigmoid(Data * w);            %�����
    J = 1 / len * sum(-label .*log(H_w) - (1 - label) .* log(1 - H_w));  %��ʧ����
    gradient = (1 / len) * Data' * (H_w - label);  %�ݶ��½������ʧ������Сֵ
    w = w - a * gradient;  %����Ȩ��ֵ
    if(w == temp)      %�ݶ��½�����Сֵ�����ٽ����ݶ��½�
        break;
    else
        k = k + 1;     %�����ݶ��½�
    end;
end
disp(['k=', num2str(k)]);
plot_x = [min(Data(:, 2)) - 4, max(Data(:, 2))];
plot_y = (-1 ./ w(3)) .* (w(1) + w(2) .* plot_x) ;
hold on
plot(plot_x, plot_y, 'r')       %�����߼��ع���
axis([-3, 4, -3, 4])
title('�߼��ع����')
legend('y = 1', 'y = 0', '�߼��ع�', 'location', 'northwest')
hold off;