% Test File
im2 = myequalize_12(im);
im = imread('pout.tif');

figure

subplot(1,2,1)
imshow(im)
title("Original Image")
subplot(1,2,2)
imshow(im2)
title("Equalized Image")

figure
imhist(im2)

