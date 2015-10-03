function [idx] = selectFeatures(trainingData, group)

trainingData = [trainingData; trainingData];
group = [group; group];
CART = 	classregtree(trainingData,group,'method','classification');
[temp, idx] = cutvar(CART);
idx = unique(idx);
idx = idx(find(idx~= 0))
figure,view(CART);
end

