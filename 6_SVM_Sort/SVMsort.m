% ʹ��SVM(֧��������)�ָ�����㲢����ͼ��
XY1 = 2 + rand(100, 2); % �������100��2����2-3֮��ĵ�
XY2 = 3 + rand(100, 2); % �������100��2����3-4֮��ĵ�
XY = [XY1;XY2];         % �ϲ�����
Classify =[zeros(100, 1); ones(100, 1)]; % ��һ�����0��ʾ���ڶ������1��ʾ
Sample = 2 + 2 * rand(100, 2); % ���Ե�
%figure(1);
%plot(XY1(:,1),XY1(:,2),'r*'); % ��һ����ú�ɫ��ʾ
%hold on;
%plot(XY2(:,1),XY2(:,2),'b*'); % �ڶ��������ɫ��ʾ
% ѵ��SVM
SVM = svmtrain(XY, Classify, 'showplot', true);
% �����Ե���࣬�������������ƽ��(һ��ֱ��)
svmclassify(SVM, Sample, 'showplot', true); 