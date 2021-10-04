function y = countGL_12(im, v)
    % Get size of vector
    N = length(v);
    
    % Preallocate y
    y = zeros(1, N-1);
    
    for i=1:N-1
        % Make Boolean mask of pixels satisfying criteria
        mask = im >= v(i) & im < v(i + 1);
        
        % Sum all trues in mask
        y(i) = sum(sum(mask));
    end