clear; close all; clc;
mu1=[0 0];                      %��ֵ
S1=[1 0.9; 0.9 1];              %Э����
inputData=mvnrnd(mu1, S1, 50);  %������˹�ֲ�����  50��
x1 = inputData(:, 1);           %ѡȡ��һ��       
x2 = inputData(:, 2);           %ѡȡ�ڶ���
len = length(inputData);        %�������ݳ���
figure;
plot(x1, x2, 'bx');
hold on;
xlim([-4, 4]);
ylim([-4, 4]);
title('���������������');
%�����ݶ�
x1 = [ones(len, 1) x1];          %����һ��1 50��
w = zeros(size(x1(1, :)))';      %��ʼ�����Իع麯����ϵ��
iterations = 20;                 %��������
alpha = 1;                       %ѧϰ��
k = 0;                           %����������־
while(1)
    temp = w;
    w = w - alpha * (1 / len) * x1' * ((x1 * w) - x2);     %����w
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
%�����������
hold on;
plot(plot_x, plot_y, 'r-')
title('���Իع����')
legend('ѵ������','���Իع�')
hold off;