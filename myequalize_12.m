function im2 = myequalize_12(im)
% myequalize_12 implements a histogram equalization algorithm
%
% im2 = myequalize(im) where im is an input uint8 image, and im2 is the
% outputted equalized image

Dm = 255; % We require unit8 - so maximum gray level is 255

dims = size(im); % get dimensions to calculate A0
A0 = dims(1)*dims(2); % total number of pixels

[H, D] = imhist(im); % Obtain histogram

cumulative_sum = cumsum(H); % Calculate the cumulative distribution

f_Da = cumulative_sum * (Dm/A0); % Calculate f(Da) by scaling by Dm/A0

Db = uint8(round(f_Da)) % Round f(Da) to create Db

im2 = intlut(im, Db); % Use Db list as a lookup table for the original image

end