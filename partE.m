clear all; close all;

% Load image
im = 'rice.png';
I = imread(im);

% Threshold the image
thres = intermeans_12(im);

% Convert to binary image
bw = im2bw(I, thres);

figure;
subplot(1, 2, 1);
imshow(bw);

% Clean up noise
bw2 = bwareaopen(bw, 5);

subplot(1, 2, 2);
imshow(bw2);

% Count grains
[L, num] = bwlabel(bw2);
disp(['Number of grains: ' num2str(num)]);