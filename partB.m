clear all; close all;

% Find the threshold
thres = intermeans_12('rice.png');

% Display the results
disp(['Normalized threshold: ' num2str(thres)]);
disp(['Threshold: ' num2str(thres*255)]);