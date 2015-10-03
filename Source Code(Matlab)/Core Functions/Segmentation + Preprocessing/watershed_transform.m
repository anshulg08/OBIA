function [labelMatrix, regionProp, labelMatWithBorder] = watershed_transform(img)

%---- Initialisations ----%
im = img;
%CAUTION : colorgrad works only for 3-channel images
gradmag = image_gradient(img);
nPixels = size(im,1)*size(im,2);

labelMatrix = watershed(gradmag);
labelMatWithBorder = labelMatrix;
labelMatrix = remove_boundry(labelMatrix,img);

numOfRegions = max(labelMatrix(:));
numOfChannels = 3;
regionProp = double(zeros(numOfRegions, numOfChannels + 1));
im = double(img);

for i = 1 : nPixels
    label = labelMatrix(i);
    regionProp(label, 1) = regionProp(label, 1) + im(i);
    regionProp(label, 2) = regionProp(label, 2) + im(i+nPixels);
    regionProp(label, 3) = regionProp(label, 3) + im(i+2*nPixels);
    regionProp(label, 4) = regionProp(label, 4) + 1;
end

regionProp(:, 1) = regionProp(:, 1)./regionProp(:, 4);
regionProp(:, 2) = regionProp(:, 2)./regionProp(:, 4);
regionProp(:, 3) = regionProp(:, 3)./regionProp(:, 4);

end
