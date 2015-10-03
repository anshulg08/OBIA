function [features] = getfeatures(s,s1,s2,s3)

for i = 1:size(s)

    if(s(i).Area == 0)
        continue;
    end
    
    %   Spectral Features
    features(i,1) = s1(i).MeanIntensity;
    features(i,2) = s2(i).MeanIntensity;
    features(i,3) = s3(i).MeanIntensity; 

    %   Shape Features
    features(i,4) = s(i).Area;
    features(i,5) = s(i).ConvexArea;
    features(i,6) = s(i).Eccentricity;
    features(i,7) = s(i).Perimeter;
    features(i,8) = s(i).Solidity;
    features(i,9) = s(i).Extent;
    % add two more features, perimeter/perimeter of convex polygon/
    % bounding box
    
    %   Texture Features
    features(i,10) = std(double(s1(i).PixelValues));
    features(i,11) = std(double(s2(i).PixelValues));
    features(i,12) = std(double(s3(i).PixelValues)); 
end