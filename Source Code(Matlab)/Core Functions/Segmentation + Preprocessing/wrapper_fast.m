function[labelMatrix] = wrapper_fast(im,labelMatrix,edges,regionProp, Q)

[map]   = Graph_srm(edges,regionProp,size(im,1)*size(im,2),Q);
labelMatrix = reshape(map(labelMatrix(:)),size(im(:,:,1)));
end