function [classMap] = classify(im, Q)

% Input : im = input image, Q = scale parameter
% Output : classMap = each class markes with a unique number
warning off all

im_copy = im;

% filter the image
[im_filt] = edison_wrapper(im, @Rgb2Luv, 'steps', 1);
im_filt = luv2rgb(im_filt);
im_filt = double(im_filt);
im_filt = im_filt*255;
im_filt = uint8(im_filt);

% segment the image
[temp, map] = region_growing(im, Q);

im_filt = rgb2ycbcr(im_filt);
imt = im;
imt = rgb2ycbcr(imt);

s = regionprops(map, 'Area', 'ConvexArea', 'Eccentricity', 'EquivDiameter','Extent','MajorAxisLength','MinorAxisLength','Perimeter','Solidity');
s1 = regionprops(map, im_filt(:,:,1), 'MaxIntensity', 'MinIntensity','MeanIntensity','PixelValues');
s2 = regionprops(map, im_filt(:,:,2), 'MaxIntensity', 'MinIntensity','MeanIntensity','PixelValues');
s3 = regionprops(map, im_filt(:,:,3), 'MaxIntensity', 'MinIntensity','MeanIntensity','PixelValues');
s4 = regionprops(map, imt(:,:,1), 'PixelValues');
s5 = regionprops(map, imt(:,:,2), 'PixelValues');
s6 = regionprops(map, imt(:,:,3), 'PixelValues');

features = get_features(s,s1,s2,s3, s4, s5, s6);

[trainingData, group] = get_training_data(im,map, features);


%----- Classification using SVM -----%

SVMStruct = svmtrain(group, trainingData, ['-t 1', '-s 1', '-d 7']);
Group = [1:size(features)]';
Group = svmpredict(Group, features, SVMStruct);

Group = knnclassify(features, trainingData, group, 1);

%------------------------------------------%

classMap = map;
for i=1:max(max(classMap))
    idx = classMap == i;
    classMap(idx) = Group(i);
end

figure,imshow(label2rgb(classMap), 'Border','Tight')
set(gcf,'Name','Classified Image');

bw = ones(size(im(:,:,1)));
bw = bw*255;
border = get_borders(classMap);
bw(border) = 0;

figure,imshow(bw, 'Border','Tight')


end