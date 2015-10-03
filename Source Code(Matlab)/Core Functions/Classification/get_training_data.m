function [trainingData, group] = getTrainingData(image, map, features)

numOfClasses = input('Number of Classes : ');
k = 1;
color = 1;
npixels = size(image,1)*size(image,2);

map_ = zeros(size(map));
im = image;

border = get_borders(map);
image(border) = 0;
image(border+npixels) = 0;
image(border+2*npixels) = 0;
figure, imshow(image,'Border','Tight')
set(gcf,'Name','Input Training Data');
Tlabel = [255 255 255; 0 255 0 ; 255 0 0; 0 0 255];

for i=1:numOfClasses

    [x,y] = getpts();
    
    for j=1:size(x)
        class(i,j)  = map(ceil(y(j)),ceil(x(j)));     
    
        label = class(i,j);
        idx = map == label;
        map_(idx) = color;
    
        
        trainingData(k,:) = features(class(i,j),:);
        group(k) = i; 
        k = k+1;
    end
    
    idx = find(map_ == color);
    im(idx) = Tlabel(i,1);
    im(idx+npixels) = Tlabel(i,2);
    im(idx+2*npixels) = Tlabel(i,3);
    
    color = color+1;
end

figure, imshow(im,'Border','Tight')
set(gcf,'Name','Class 1: Training Data');

group = group';
end