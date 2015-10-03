function[segmentedImage, labelMatrix, boundaries, regionAvgImage, regionProp] = wrapper(im,Q)

segmentedImage = im;

nPixels = size(im,1)*size(im,2);

[labelMatrix, regionProp,labelMatrix_]  = segment(im);
[edges]             = getAdjMatrix(labelMatrix_, regionProp);
[map]               = Graph_srm(edges,regionProp,size(im,1)*size(im,2),Q);

T = zeros(size(labelMatrix));
for i = 1:size(im,1)
    for j =1:size(im,2)
        T(i,j)=map(labelMatrix(i,j));
    end
end

labelMatrix = T;
regionAvgImage = im;
for i = 1 : nPixels
    regionAvgImage(i) = regionProp(labelMatrix(i), 1);
    regionAvgImage(i+nPixels) = regionProp(labelMatrix(i), 2);
    regionAvgImage(i+2*nPixels) = regionProp(labelMatrix(i), 3);
end

regionAvgImage = uint8(regionAvgImage);

boundaries = zeros(size(im(:,:,1)));
border = srm_getborders(labelMatrix);
boundaries(border) = 255;
pixels = size(im,1)*size(im,2);
segmentedImage(border) = 0;%237;
segmentedImage(border + pixels) = 0;%28;
segmentedImage(border + 2*pixels) = 0;%36;

regionAvgImage(border) = 0;%237;
regionAvgImage(border + pixels) = 0;%28;
regionAvgImage(border + 2*pixels) = 0;%36;

figure, imshow(regionAvgImage, 'Border', 'Tight')

end