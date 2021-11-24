function [im2, a] = autolevel_12(fname)  
    % Load image
    im = imread(fname);
    
    % Get samples
    [x, y] = getSamples(im);
    
    % Convert (i, j) coordinates to linear indices
    linearidx = sub2ind(size(im), y, x);
    
    % Sample gray-levels at (i, j) coordinates
    I = double(im(linearidx));
    
    % Perform levelling operation
    [im2, a] = level(im, x, y, I);

    % Plot as per assignment requirements
    imshow(im);
    hold on;
    plot(x, y, 'y+');
end

% Private function to partition and sample image
function [x, y] = getSamples(im)
    % Get image size
    [szx, szy] = size(im);
    
    % Number of divisions to make in each direction
    %   Number of sub-areas is ndiv^2
    ndiv = 4;
    
    % Calculate M and N from number of divisions
    M = fix(szx/ndiv);
    N = fix(szy/ndiv);
    
    % Preallocate sample point coordinates
    x = zeros(1, ndiv^2);
    y = zeros(1, ndiv^2);
    
    for p = 1:ndiv
        for q = 1:ndiv   
            % Get submatrix
            lb = [M*(p - 1); N*(q - 1)] + 1;
            ub = [M*p; N*q];
            submat = im(lb(1):ub(1), lb(2):ub(2));

            % Find local coordinates of darkest pixel in submatrix
            [colmins, imin] = min(submat);
            [~, j] = min(colmins);
            i = imin(j);
            
            % Transform coordinates from submatrix frame to global frame
            i = i + lb(1) - 1;
            j = j + lb(2) - 1;
            
            % Record darkest pixel location for submatrix n
            n = (p - 1)*ndiv + q;
            y(n) = i;
            x(n) = j;
        end
    end
end

% Private function to level image with given landmarks
%   Adapted from Dr. Ladak's levelling function
function [im2, a] = level(im, x, y, I)
    % Fit data at selected points to background function
    %  Solve least-squares problem: [C]{a} = {k} using the
    %    \ operator, i.e., {a} = [C]\{k}
    %  First, compute elements of the matrix [C]
    N = length(x);
    Sx = sum(x);
    Sy = sum(y);
    Sxx = sum(x.*x);
    Syy = sum(y.*y);
    Sxy = sum(x.*y);
    Sxxx = sum(x.^3);
    Sxxy = sum(x.*x.*y);
    Sxyy = sum(x.*y.*y);
    Syyy = sum(y.^3);
    Sxxxx = sum(x.^4);
    Sxxxy = sum(y.*x.^3);
    Sxxyy = sum(x.*x.*y.*y);
    Sxyyy = sum(x.*y.^3);
    Syyyy = sum(y.^4);
    C = [N    Sx  Sy   Sxx   Syy   Sxy;
        Sx   Sxx Sxy  Sxxx  Sxyy  Sxxy;
        Sy   Sxy Syy  Sxxy  Syyy  Sxyy;
        Sxx Sxxx Sxxy Sxxxx Sxxyy Sxxxy;
        Syy Sxyy Syyy Sxxyy Syyyy Sxyyy;
        Sxy Sxxy Sxyy Sxxxy Sxyyy Sxxyy];
    % Construct {k} 
    SI = sum(I);
    SxI = sum(x.*I);
    SyI = sum(y.*I);
    SxxI = sum(x.*x.*I);
    SyyI = sum(y.*y.*I);
    SxyI = sum(x.*y.*I);
    k = [SI SxI SyI SxxI SyyI SxyI]';
    % Solve
    a = C\k;

    % Remove background
    % First compute background image
    [rows, cols] = size(im);
    [x, y] = meshgrid( 1:cols, 1:rows );
    back = a(1) + a(2)*x + a(3)*y + a(4)*x.*x + a(5)*y.*y +a(6)*x.*y;
    im2 = double(im) - back;
    im2 = mat2gray(im2); % Convert matrix of type double to image of type double
    im2 = im2uint8(im2); % Convert to uint8 image. Although you were not asked
                         % to do this, it is useful to make output same type as
                         % input image.
end