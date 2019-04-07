function color = pixelValue(image, x, y, method)
% pixel value at real coordinates
if inImage(size(image),x,y)
    % do the interpolation
    switch(method)
        case 'nearest'
            % Do nearest neighbour
            color = image(round(x), round(y));
            return;
        case 'linear'
            % Do bilinear interpolation
            fx = floor(x);
            fy = floor(y);
            a = x - fx;
            b = y - fy;
            % Get image values while dealing with border problem.
            [f1, f2, f3, f4] = getPixelValue(image, size(image), fx, fy);
            color = (1-a) * (1-b) * f1 + ...
                    a * (1-b) * f2 + ...
                    (1-a) * b * f3 + ...
                    a * b * f4;
    end %end switch
else
    % return a constant
    color = -1;
end