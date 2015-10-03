function [L_out] = remove_boundry(L, rgb)

rgb = double(rgb);
rgb = rgb(:,:,1)+rgb(:,:,2)+rgb(:,:,3);
nPixels = size(rgb,1)*size(rgb,2);
L_out = L;
dim = size(rgb);
MASK = [1 -1 dim(1) -dim(1) 1+dim(1) 1-dim(1) -1-dim(1) -1+dim(1)];

idx = find( L == 0);
for i = 1:size(idx)
    nbr = MASK + idx(i);
    nbr = nbr((nbr>0) & (nbr<=nPixels));
    nbr = nbr(L(nbr) ~= 0);
    
    t1 = rgb(nbr);
    t2 = L(nbr);
    [cc,min_index] = min(t1);
    L_out(idx(i)) = t2(min_index);
end

end
            