function thres = intermeans_12(im)
    I = imread(im);

    % Guess thres as mean of image gray level
    thres = round(mean2(I));
    
    % Get image histogram
    [h, D] = imhist(I);
    
    % Iteratively refine thres
    thres_prev = -1;
    while thres ~= thres_prev
        thres_prev = thres;
        % Section histogram using thres
        idx = D <= thres;

        % Calculate weighted mean of histogram sections 
        meanLow = sum(D(idx).*h(idx))/sum(h(idx));
        meanHi = sum(D(~idx).*h(~idx))/sum(h(~idx));
        
        % Recalculate thres
        thres = round(mean([meanLow meanHi]));
    end
    
    thres = thres/max(D);
end