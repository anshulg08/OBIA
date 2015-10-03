function [segmentedImage, boundaries] = getsegmentedImage(im, labelMatrix, colorIdx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pixels = size(im,1)*size(im,2);
% 1 = white, 2= black, 3 = blue, 4 = red, 5 = green
color = [0 0 0;255 255 255; 60 70 200; 230 30 30; 30 170 40];

%regionAvgImage = regionProp(labelMatrix(:), :);
%regionAvgImage = uint8(regionAvgImage(:,1:3));
%regionAvgImage = reshape(regionAvgImage, size(im));

boundaries = zeros(size(im(:,:,1)));
border = srm_getborders(labelMatrix);
boundaries(border) = 255;

border = srm_getborders(labelMatrix);

segmentedImage = im;
segmentedImage(border) = color(colorIdx,1);
segmentedImage(border + pixels) = color(colorIdx,2);
segmentedImage(border + 2*pixels) = color(colorIdx,3);

end

