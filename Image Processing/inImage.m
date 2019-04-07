function inImage = inImage(size, x, y)
x_i = size(2);
y_i = size(1);
if 1 <= x && x <= x_i && 1 <= y && y <= y_i
    inImage = true;
else
    inImage = false;
end