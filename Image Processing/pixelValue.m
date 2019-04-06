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
            color = (1-a)*(1-b)*image(fx,fy)+ ...
                    a*(1-b)*image(fx+1,fy)+ ...
                    (1-a)*b*image(fx,fy+1)+ ...
                    a*b*image(fx+1,fy+1);
    end %end switch
else
    % return a constant
    color = -1;
end