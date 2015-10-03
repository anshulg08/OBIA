function [features] = getfeatures(s,s1,s2,s3, s4,s5, s6)

for i = 1:size(s)

    if(s(i).Area == 0)
        continue;
    end
    
    %   Spectral Features
    features(i,1) = s1(i).MeanIntensity;
    features(i,2) = s2(i).MeanIntensity;
    features(i,3) = s3(i).MeanIntensity; 

    %   Shape Features
    %features(i,4) = s(i).Area;
    %features(i,5) = s(i).ConvexArea;
    %features(i,6) = s(i).Eccentricity;
    %features(i,7) = s(i).Perimeter;
    %features(i,4) = s(i).Solidity;
    %features(i,5) = s(i).Extent;
    
    
    %   Texture Features
    features(i,4) = std(double(s4(i).PixelValues));
    features(i,5) = std(double(s5(i).PixelValues));
    features(i,6) = std(double(s6(i).PixelValues)); 
end