clear all; close all;

% Test image
row = uint8(0:255);
im = repmat(row, 100, 1);

% Generate histogram plot
stem(0:255, countGL_12(im, 0:256));
set(gca, 'xlim', [0 255], 'ylim', [0 150]);
title('Assignment 1', 'fontsize', 16);
xlabel('Gray level');
ylabel('No. pixels');

% Answer to part (c)
disp(['Number of pixels: ' num2str(sum(countGL_12(im, 0:256)))]);