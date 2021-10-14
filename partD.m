clear all; close all;

% Load image
im = 'rice.png';
I = imread(im);

% Threshold the image
thres = intermeans_12(im);

% Convert to binary image
bw = im2bw(I, thres);

% Show result
imshow(bw);

%% Part D starts here

[L, num] = bwlabel(bw);
disp(['Number of grains: ' num2str(num)]);