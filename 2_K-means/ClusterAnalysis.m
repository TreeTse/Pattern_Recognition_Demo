% ����4�����ݲ���ʾ����k-means�����㷨���о��࣬����ͬ�ľ����ò�ͬ��ɫ��ʾ����
clc;clear;close all;
%% ���ɸ�˹�ֲ����������
%��һ������
mu1=[1.0 1.0];              %��ֵ
S1=[0.3 0;0 0.35];          %Э����/���ɵ����ݵ�����ؾ���
data1=mvnrnd(mu1,S1,250);   %������˹�ֲ�����

%�ڶ�������
mu1=[3.0 1.0];
S1=[0.3 0;0 0.35];
data2=mvnrnd(mu1,S1,250);

%����������
mu1=[1.0 -1.0];
S1=[0.3 0;0 0.35];
data3=mvnrnd(mu1,S1,250);

%����������
mu1=[3.0 -1.0];
S1=[0.3 0;0 0.35];
data4=mvnrnd(mu1,S1,250);

%��ʾ����
figure(1);
plot(data1(:, 1), data1(:, 2), 'k.');
title('�����˹����ֲ�������ԭʼ�����');
hold on;
plot(data2(:,1),data2(:,2),'g+');
plot(data3(:,1),data3(:,2),'m*');
plot(data4(:,1),data4(:,2),'ys');
hold off;

%�������ݺϲ���һ��
data = [data1(:, 1), data1(:, 2); data2(:, 1), data2(:, 2); data3(:, 1), data3(:, 2); data4(:, 1), data4(:, 2);];
%��ʾ���ݿ�
%figure(2);
%plot(data(:,1),data(:,2),'g+');
%title('ԭʼ�����');

%% ����������ĸ��ص�����λ��
% ȡ����ĸ��㣬��Ϊ���ģ�Ҳ����Ϊ���ֵĴأ���ʵ��ȡ�ĸ��أ��ֳ�����
%������1~length��data(:,1)����Χ�ڵ�α�������
data1_center = randi([1, length(data(:, 1))]);
data2_center = randi([1, length(data(:, 1))]);
data3_center = randi([1, length(data(:, 1))]);
data4_center = randi([1, length(data(:, 1))]);

data1_center = data(data1_center, :);
data2_center = data(data2_center, :);
data3_center = data(data3_center, :);
data4_center = data(data4_center, :);

%��ʾȡ�õ��ĸ���ʼ��������λ��
hold on;
plot(data1_center(:, 1), data1_center(:, 2),'ko');
plot(data2_center(:, 1), data2_center(:, 2),'ko');
plot(data3_center(:, 1), data3_center(:, 2),'ko');
plot(data4_center(:, 1), data4_center(:, 2),'ko');
title('ԭʼ�����');

%% ��ʼ�������
TIMES = 10; %��������10��

for j=1:1:TIMES
    ClustData1 = [];
    ClustData2 = [];
    ClustData3 = [];
    ClustData4 = [];
    for i = 1: 1: length(data(:, 1)) - 1
        % ÿһ�����ݶ����ĸ�������ŷ�Ͼ���
        dis_2_data1 = ( data(i, 1) - data1_center(1, 1) ) ^ 2 + ( data(i, 2) - data1_center(1, 2) ) ^ 2 ;
        dis_2_data2 = ( data(i, 1) - data2_center(1, 1) ) ^ 2 + ( data(i, 2) - data2_center(1, 2) ) ^ 2 ;
        dis_2_data3 = ( data(i, 1) - data3_center(1, 1) ) ^ 2 + ( data(i, 2) - data3_center(1, 2) ) ^ 2 ;
        dis_2_data4 = ( data(i, 1) - data4_center(1, 1) ) ^ 2 + ( data(i, 2) - data4_center(1, 2) ) ^ 2 ;
        
        % ����sort�������ĸ������������ȡ��Сֵ
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
   % ���¼����ĸ��ص�����λ��
   data1_center(1, 1) = sum( ClustData1(:, 1) ) / length(ClustData1(:, 1));
   data1_center(1, 2) = sum( ClustData1(:, 2) ) / length(ClustData1(:, 2));
   data2_center(1, 1) = sum( ClustData2(:, 1) ) / length(ClustData2(:, 1));
   data2_center(1, 2) = sum( ClustData2(:, 2) ) / length(ClustData2(:, 2));
   data3_center(1, 1) = sum( ClustData3(:, 1) ) / length(ClustData3(:, 1));
   data3_center(1, 2) = sum( ClustData3(:, 2) ) / length(ClustData3(:, 2));
   data4_center(1, 1) = sum( ClustData4(:, 1) ) / length(ClustData4(:, 1));
   data4_center(1, 2) = sum( ClustData4(:, 2) ) / length(ClustData4(:, 2));
    %% ��ʾ��������������
    figure(3);
    plot(ClustData1(:, 1), ClustData1(:, 2), 'kx');
    title('��������Ľ��');
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



