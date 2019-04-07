function [f1, f2, f3, f4] = getPixelValue(image, size, fx, fy)
% Deal with border problem and get right values.
f1 = image(fx, fy);
if size(1) == fx
    f2 = f1;
    f4 = image(fx, fy+1);
else
    f2 = image(fx+1, fy);
    f4 = image(fx+1, fy+1);
end
if size(2) == fy
    f3 = f1;
    f4 = image(fx+1, fy);
else
    f3 = image(fx, fy+1);
    f4 = image(fx+1, fy+1);
end
if size(1) == fx && size(2) == fy
    f4 = f1;
end
end