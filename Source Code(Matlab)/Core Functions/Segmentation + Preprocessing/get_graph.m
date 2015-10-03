function [edges] = get_graph(labelMatrix, regionProp)

%----- Initialisations -----%

% convert to double, to avoid repetitive type cast
labelMatrix= double(labelMatrix);
% size of image
dim = size(labelMatrix);
% initialize array
edges = [];


%---- Main processing ----%

% compute matrix of absolute differences in the first direction
diff1 = abs(diff(labelMatrix, 1, 1));

% find non zero values (region changes)
[i1 i2] = find(diff1);

% delete values close to border
i2 = i2(i1<dim(1)-1);
i1 = i1(i1<dim(1)-1);

% get values of consecutive changes
val1 = diff1(sub2ind(size(diff1), i1, i2));
val2 = diff1(sub2ind(size(diff1), i1+1, i2));

% find changes separated with 2 pixels
ind = find(val2 & val1~=val2);
edges = [edges;unique([val1(ind) val2(ind)], 'rows')];	


% compute matrix of absolute differences in the second direction
diff2 = abs(diff(labelMatrix, 1, 2));

% find non zero values (region changes)
[i1 i2] = find(diff2);

% delete values close to border
i1 = i1(i2<dim(2)-1);
i2 = i2(i2<dim(2)-1);

% get values of consecutive changes
val1 = diff2(sub2ind(size(diff2), i1, i2));
val2 = diff2(sub2ind(size(diff2), i1, i2+1));

% find changes separated with 2 pixels
ind = find(val2 & val1~=val2);
edges = [edges ; unique([val1(ind) val2(ind)], 'rows')];

% the edges the symmetric
edges_(:,1) = edges(:,2);
edges_(:,2) = edges(:,1);
edges = [edges ; edges_ ];

% remove eventual double edges
edges = unique(edges, 'rows');

edges(:,3) = edges(:,2);
edges(:,2) = edges(:,1);

for i = 1:size(edges)
    C1 = edges(i,2);
    C2 = edges(i,3);
    dR=(regionProp(C1,1)-regionProp(C2,1))^2;
    dG=(regionProp(C1,2)-regionProp(C2,2))^2;
    dB=(regionProp(C1,3)-regionProp(C2,3))^2;
    edges(i,1) = sqrt(dG+dB+dR);
end
edges = sortrows(edges);

end
