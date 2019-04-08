function inImage = inImage(size, x, y)
inImage = 1 <= x && x <= size(2) && 1 <= y && y <= size(1);
end