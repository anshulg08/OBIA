function [map] = Graph_srm(edges, regionProp, n_pixels, Q)

g=256;
logdelta=2*log(6*n_pixels);
minRegionSize = 50;
numEdges = size(edges,1);
numOfRegions = size(regionProp,1);
size_segments = regionProp(:,4);
image_seg = regionProp(:,1:3);
map = 1:numOfRegions;
treerank = zeros(1, numOfRegions);

for i = 1:numEdges
    
    C1 = edges(i,2);
    C2 = edges(i,3);
    
    %Union-Find structure, here are the finds, average complexity O(1)
    while (map(C1)~=C1 ); C1=map(C1); end
    while (map(C2)~=C2 ); C2=map(C2); end
     
    logreg1 = min(g,size_segments(C1))*log(1.0+size_segments(C1));
    logreg2 = min(g,size_segments(C2))*log(1.0+size_segments(C2));

     dev=(((g*g)/(2.0*Q*size_segments(C1)))*(logreg1 + logdelta))+(((g*g)/(2.0*Q*size_segments(C2)))*(logreg2 + logdelta));
         
    predicat=( (((image_seg(C1,1)-image_seg(C2,1))^2)<dev) && (((image_seg(C1,2)-image_seg(C2,2))^2)<dev) && (((image_seg(C1,3)-image_seg(C2,3))^2)<dev) );
    
    if ( ((C1~=C2) && predicat) || size_segments(C1) <= minRegionSize || size_segments(C2) <= minRegionSize)
        % Find the new root for both regions
        if treerank(C1) > treerank(C2)
            map(C2) = C1; reg=C1;
        elseif treerank(C1) < treerank(C2)
            map(C1) = C2; reg=C2;
        elseif C1 ~= C2
            map(C2) = C1; reg=C1;
            treerank(C1) = treerank(C1) + 1;
        end

        % Merge regions
        nreg = size_segments(C1) + size_segments(C2);

        image_seg(reg,1)=(size_segments(C1)*image_seg(C1,1)+size_segments(C2)*image_seg(C2,1))/nreg;
        image_seg(reg,2)=(size_segments(C1)*image_seg(C1,2)+size_segments(C2)*image_seg(C2,2))/nreg;
        image_seg(reg,3)=(size_segments(C1)*image_seg(C1,3)+size_segments(C2)*image_seg(C2,3))/nreg;
        
        size_segments(reg)=nreg;
    end
end

% building the segmentation map
while 1
    map_ = map(map) ;
    if isequal(map_,map) ; break ; end
    map = map_ ;
end
    
end
    