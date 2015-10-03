function [trainingData, group] = getTrainingData(map, features, classId, axes1, im)

[x,y] = getpts(axes1);
npixels = size(im,1)*size(im, 2);
k = 1;
for j=1:size(x)
    label = map(ceil(y(j)),ceil(x(j)));     
    trainingData(k,:) = features(label,:);
    group(k) = classId; 
    k = k + 1;
    im(find(map == label)) = 0;
    im(find(map == label)+npixels) = 0;
    im(find(map == label)+2*npixels) = 0;
    axes(axes1);
    image(im);
    ratio = size(im,2)/size(im,1);
    set(axes1,'PlotBoxAspectRatio', [ratio 1 1]);
end

group = group';

end