function line = profile(image, x0, y0, x1, y1, n, method)
% profile of an image along straight line in n points
x = linspace(x0, x1, n); y = linspace(y0, y1, n);
for i = 1:length(x)
    line(i) = pixelValue(image, x(i), y(i), method);
end
