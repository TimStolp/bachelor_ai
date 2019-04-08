function inImage = inImage(size, x, y)
x_i = cast(size(2), 'double');
y_i = cast(size(1), 'double');
if 1 <= x && x <= x_i && 1 <= y && y <= y_i
    inImage = true;
else
    inImage = false;
end