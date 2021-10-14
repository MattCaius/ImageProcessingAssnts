clear all; close all;

thres = intermeans_12('rice.png');
disp(['Normalized threshold: ' num2str(thres)]);
disp(['Threshold: ' num2str(thres*255)]);