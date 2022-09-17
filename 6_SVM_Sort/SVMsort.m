% 使用SVM(支持向量机)分割两类点并画出图形
XY1 = 2 + rand(100, 2); % 随机产生100行2列在2-3之间的点
XY2 = 3 + rand(100, 2); % 随机产生100行2列在3-4之间的点
XY = [XY1;XY2];         % 合并两点
Classify =[zeros(100, 1); ones(100, 1)]; % 第一类点用0表示，第二类点用1表示
Sample = 2 + 2 * rand(100, 2); % 测试点
%figure(1);
%plot(XY1(:,1),XY1(:,2),'r*'); % 第一类点用红色表示
%hold on;
%plot(XY2(:,1),XY2(:,2),'b*'); % 第二类点用蓝色表示
% 训练SVM
SVM = svmtrain(XY, Classify, 'showplot', true);
% 给测试点分类，并作出最大间隔超平面(一条直线)
svmclassify(SVM, Sample, 'showplot', true); 