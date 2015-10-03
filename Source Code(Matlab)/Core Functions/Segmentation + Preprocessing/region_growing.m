function[segmentedImage, labelMatrix, boundaries, regionAvgImage, regionProp] = region_growing(im,Q)

% Input  :  im = input image (3-band remote sensing image) 
%           Q = scale parameter (small produces large segments, large Q produces small segments)
%
% Output :  SegmentedImage = input image marked with segment boundaries
%           labelMatrix  = 2-d matrix with each segment labelled with a unique numbers
%           regionAvgImage = each segment in the image is displayed with average value of pixels (i.e. each segment has a unique identifier)
%           regionProp -> regionProp(i, 1) = mean value of segment with identifier 'i' for the first band  
%						  regionProp(i, 2) = mean value of segment with identifier 'i' for the second band
%						  regionProp(i, 2) = mean value of segment with identifier 'i' for the second band

nPixels = size(im,1)*size(im,2);

% Watershed segmentation
[labelMatrix, regionProp,labelMatrix_]  = watershed_transform(im);

% Building graph
[edges]             = get_graph(labelMatrix_, regionProp);

% Region Growing using 'Statistical Region Merging' (Nock and Neilson, 2004)
[map]               = SRM(edges,regionProp,size(im,1)*size(im,2),Q);

% Don't try to understand what's happening here
T = zeros(size(labelMatrix));
for i = 1:size(im,1)
    for j =1:size(im,2)
        T(i,j)=map(labelMatrix(i,j));
    end
end

% Preparing resutls to be displayed
labelMatrix = T;
segmentedImage = im;
regionAvgImage = im;

% Preparing region average image
for i = 1 : nPixels
    regionAvgImage(i) = regionProp(labelMatrix(i), 1);
    regionAvgImage(i+nPixels) = regionProp(labelMatrix(i), 2);
    regionAvgImage(i+2*nPixels) = regionProp(labelMatrix(i), 3);
end
regionAvgImage = uint8(regionAvgImage);


boundaries = zeros(size(im(:,:,1)));
border = get_borders(labelMatrix);
boundaries(border) = 255;
pixels = size(im,1)*size(im,2);
segmentedImage(border) = 0;%237;
segmentedImage(border + pixels) = 0;%28;
segmentedImage(border + 2*pixels) = 0;%36;

regionAvgImage(border) = 0;%237;
regionAvgImage(border + pixels) = 0;%28;
regionAvgImage(border + 2*pixels) = 0;%36;

%figure, imshow(regionAvgImage, 'Border', 'Tight')
%set(gcf,'Name','Region Average Image');

figure, imshow(segmentedImage, 'Border', 'Tight')
set(gcf,'Name','Segmented Image');

%figure, imshow(boundaries, 'Border', 'Tight')
%set(gcf,'Name','Segment Boundaries');


end