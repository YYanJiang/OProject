clear all;

bin=5;
disp(['When the number of bins in the histograms is ' num2str(bin) ':']);

trainData=zeros(29,bin*3);
testData=zeros(29,bin*3);

trainnum=1; %number of train image
for i=1:29
        % train image histogram
        train=imread(['ImClasss/' 'train' num2str(i) '.jpg']);
        trainR=histogram(train(:,:,1),bin);
        trainG=histogram(train(:,:,2),bin);
        trainB=histogram(train(:,:,3),bin);
        trainData(trainnum,:)=[trainR trainG trainB];
%         trainlabel(trainnum)=i;
        trainnum=trainnum+1;
end

testnum=1; %number of test image
for i=1:4

        % test image histogram
        test=imread(['ImClasss/' 'test' num2str(i) '.jpg']);
        testR=histogram(test(:,:,1),bin);
        testG=histogram(test(:,:,2),bin);
        testB=histogram(test(:,:,3),bin);
        testData(testnum,:)=[testR testG testB];
%         testlabel(testnum)=j;
      testnum=testnum+1;
end 

% referance:https://blog.csdn.net/hjimce
% mean shift cluster
radius=1500000;  %search window radius
threshold=1e-3*radius; % 1500 % threshold for stop judgment
trainIdx = MS(trainData,radius,threshold);
testIdx = MS(testData,radius,threshold);

%display the result
for i=1:29  
    disp(['Train image ' num2str(i) ' has been assigned to class ' num2str(trainIdx(i)) '.']);
end

for i=1:29  
    disp(['Test image ' num2str(i) ' has been assigned to class ' num2str(testIdx(i)) '.']);
end