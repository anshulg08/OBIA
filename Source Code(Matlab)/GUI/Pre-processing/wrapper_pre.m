function[im_filt,labelMatrix,edges,regionProp] = wrapper_pre(im)

[im_filt] = edison_wrapper(im, @Rgb2Luv, 'steps', 1);
im_filt = luv2rgb(im_filt);
im_filt = double(im_filt);
im_filt = im_filt*255;
im_filt = uint8(im_filt);

[labelMatrix, regionProp,labelMatrix_]  = segment(im_filt);
[edges]             = getAdjMatrix(labelMatrix_, regionProp);

end