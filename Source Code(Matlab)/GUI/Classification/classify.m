function [classMap] = classify(trainingData, group, features, labelMatrix)

%----- Classification using SVM -----%
SVMStruct = svmtrain(group, trainingData, ['-t 1', '-s 1', '-d 7']);
Group = [1:size(features)]';
Group = svmpredict(Group, features, SVMStruct);
%------------------------------------------%

% house keeping
classMap = labelMatrix;
for i=1:max(max(classMap))
    idx = classMap == i;
    classMap(idx) = Group(i);
end
end