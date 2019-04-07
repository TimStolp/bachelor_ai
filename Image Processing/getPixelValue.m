function [f1, f2, f3, f4] = getPixelValue(image, size, fx, fy)
% Deal with border problem and get right values.
f1 = image(fy, fx);
if size(2) == fx
    f2 = f1;
else
    f2 = image(fy, fx+1);
end
if size(1) == fy
    f3 = f1;
else
    f3 = image(fy+1, fx);
end
if size(2) == fx && size(1) == fy
    f4 = f1;
elseif size(2) == fx
    f4 = image(fy+1, fx);
elseif size(1) == fy
    f4 = image(fy, fx+1);
else
    f4 = image(fy+1, fx+1);
end
end