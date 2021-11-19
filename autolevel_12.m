function [im2, a] = autolevel_12(fname)  
    plotlevel = false;

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

    % Plot results with landmarks
    if plotlevel
        subplot(121);
        imshow(im);
        hold on;
        plot(x, y, 'y+');
        title('Original');

        subplot(122);
        imshow(im2);
        title('Levelled');
    % Plot as per assignment requirements
    else
        imshow(im);
        hold on;
        plot(x, y, 'y+');
    end
end

% Private function to partition and sample image
function [x, y] = getSamples(im)
    % Show image partitioning diagnostics (for development purposes)
    diagnostics = false;

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
    
    if diagnostics
        imshow(im);
        hold on;
    end
    for p = 1:ndiv
        % Plot vertical division lines
        if diagnostics
            plot([1 szy], [M*(p - 1) M*(p - 1)], 'r');
        end
        for q = 1:ndiv
            % Plot horizontal division lines
            if diagnostics
                plot([N*(q - 1) N*(q - 1)], [1 szx], 'r');
            end
            
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
    % Plot sample points on diagnostic image
    if diagnostics
        plot(x, y, 'y+');
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